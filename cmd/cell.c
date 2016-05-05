/*warning: 
  1, struct cell和struct cell_dentry都是非固定体积的structure，不要在堆栈上分配内存.用malloc!
  2, 全局变量p_id从0数起，choose_partation也是基于这个习惯。 但交互时遵从习惯上的模式，即分区从1开始。
  3, TODO 把choose partation的branch挪到check flags前面。 check flags是为了阻止对非cell分区的大部分操作。
 */

/* 1, functions like 'alloc_free_block' and 'alloc_free_entry' write back to 
 * disk if they succeed, this is not good design, but simplifies the code.
 *
 */
#include<stdio.h>
#include<unistd.h>
#include<assert.h>
#include<string.h>
#include<stdlib.h>
#include<fcntl.h>
#include "../src/include/linux/cell_common.h"

#define bool int

#define F_REG 1
#define F_DIR 2
struct dp{
	unsigned char boot;
	unsigned char start_head;
	unsigned char start_sector;
	unsigned char start_cylender;

	unsigned char sys_id;//means the fs type ID.
	unsigned char end_head;
	unsigned char end_sector;
	unsigned char end_cylender;

	unsigned start_lba;
	unsigned count;
}*g_dps;
int g_dpnum;
char mbrbuf[1024];	/*512 is not enough, we collect all ebr and put after gdp*/
struct cell_superblock sb;
char cmd[16];
char arg1[64];
int mainfd;
struct cell *_pwd_block;
struct cell *_tmp_block;
struct cell_dentry *_entpwd;		/* dentry which points to the block of 'pwd'*/
#define pwd_block (*_pwd_block)
#define tmp_block (*_tmp_block)
#define entpwd (*_entpwd)
int p_start;		/* current partation start sector id*/
int p_count;		/* current partation's sector count */
int p_id;			/*current partation id, start from 0*/
int p_ext_id;		/* extened partation id */
#define go_on(msg, arg) {\
	printf(msg , arg);\
	continue;\
}

#define fail_say(msg, arg){\
	printf(msg, arg);\
	exit(1);\
}

#define return_say(value, msg){\
	printf(msg);\
	return value;\
}

#define SECTOR2BLOCK(sector_num) ((sector_num * 512 - sb.rootcell) / sb.cellsize)
void locate_cell(int cellid){
	lseek(mainfd,  p_start * 512 + + sb.rootcell + cellid * sb.cellsize, SEEK_SET);
}
bool main_read_cell(char *buf, int cellid){
	locate_cell(cellid);
	read(mainfd, buf, sb.cellsize);	
	return 1;
}

bool main_write_cell(char *buf, int cellid){
	locate_cell(cellid);
	write(mainfd, buf, sb.cellsize);
	return 1;
}

void write_sb(void){
	assert( lseek(mainfd, p_start*512+1024, SEEK_SET) != -1);
	assert( write(mainfd, (char *)&sb, 1024) == 1024);
}

/*TODO 可再“优雅”一些*/
struct cell_dentry *cell_find_entry(struct cell *cell, char *name){
	struct cell_dentry *cell_ent = cell->ents;
	int remain;
	for(remain = cell->size; remain > 0;){
		int entsize = sizeof(struct cell_dentry) + cell_ent->len;
		int len = cell_ent->len;
		if(len != 0){
			if(strlen(name) == len && strncmp(name, cell_ent->name, len) == 0) break;
			remain -= entsize;
		}
		cell_ent = (void *)((unsigned)cell_ent + entsize);	/*next*/
	}
	if(remain > 0) return cell_ent;
	return 0;
}
int get_filesize(int fd){
	int oldpos = lseek(fd, 0, SEEK_CUR);
	assert(oldpos != -1);
	int size = lseek(fd, 0, SEEK_END);	
	lseek(fd, oldpos, SEEK_SET);	
	return size;
}

bool check_cell_flags(struct cell_superblock *_sb){
	if(_sb->flags[0] != 'c' || _sb->flags[1] != 'e'  ||\
	   _sb->flags[2] != 'l'|| _sb->flags[3] != 'l') 
			return_say(0, "cell flags check failed\n")
	if(_sb->cellnum != SECTOR2BLOCK(p_count))
		return_say(0, "block count information not sychronised")
//	printf("check.. OK!\n");
	return 1;	
}

/* 1, 从0开始，0 表示分区1
 * 2, 交互时接受的命令却是从1开始的。
 */
bool choose_partation(int pid){
	int foo_pid = pid + 1;	/*foo_pid是用户习惯的partation id, count from 1*/
	if(pid == p_ext_id) return_say(0, "failed, 4 is extended partation\n");
	if(foo_pid <1 || foo_pid > g_dpnum) return_say(0, "failed, invalid partation id\n")
	struct dp *dp = g_dps + pid;
	p_id = pid;
	p_start = dp->start_lba;
	p_count = dp->count;
//	printf("start, count: %d %d\n", p_start, p_count);	
	int ret = lseek(mainfd, p_start*512+1024, SEEK_SET);
	if(ret == -1) fail_say("choose partation: lseek failed", 0);
	ret = read(mainfd, (char *)&sb, 1024);	
	if(ret == -1) fail_say("choose partation: read sb failed", 0);
	entpwd.cellid=0;
	main_read_cell((char*)&pwd_block, entpwd.cellid);
	return 1;
}


/*
 * WRITE DISK
 *@cellid 就是@cell对应的cellid光知道cell内存地址还不够，回写的时候，需要知道cell的id。
 *@DESC cell是一个目录类型的cell，其cellid为@cellid。在尾部增添一个名为name的dentry，
 * 指向的cellid为tocell。 warning:因删除而出现的碎片形式的dentry不能被回收利用,see log。
 * 只能通过碎片整理，挪到尾部才能用。
 */
struct cell_dentry *add_entry(struct cell *cell, int cellid, char *name, int tocell){
	struct cell_dentry *new =  (void *)((unsigned)cell->ents + cell->size);
	cell->size += sizeof(struct cell_dentry) + strlen(name);		/* alloc done */

	strncpy(new->name, name, strlen(name));
	new->len = strlen(name);	
	new->cellid = tocell;
	main_write_cell((void *)cell, cellid);	
	return new;
}


/* WRITE DISK */
int alloc_free_block(struct cell_superblock *sb){
	for(int i = 0; i < sb->cellnum; i++){
		if(sb->bitmap[i] == 0){
			sb->bitmap[i] = 1;
			write_sb();
			return i;
		}
	}
	return 0;
}

static void main_read_sector(char *buf, unsigned lba){
	assert( lseek(mainfd, lba*512, SEEK_SET) != -1 );	
	assert( read(mainfd, buf, 512) == 512 );
}

static char* sys_string[256];
static void print_dp(struct dp *dp, int p_id)
{
	printf("%10u%10u%10u%10u%10uM%10x%10s\n",p_id,dp->boot,dp->start_lba,\
	dp->count, dp->count * 512 / 0x100000, dp->sys_id,sys_string[dp->sys_id]);
}
/**here is why fs_ext should run ahead of fs_fat32/ntfs*/
static void init_dp(void){
	g_dps = (void *)(mbrbuf + 446);

	for(int i=0;i<256;i++) sys_string[i]="unknown";
	sys_string[0]="empty";
	sys_string[0x5]="extend";
	sys_string[0x83]="linux";
	sys_string[0x6]="fat16";
	sys_string[0x7]="hpfs/ntfs";

	printf("\n%10s%10s%10s%10s%10s%10s%10s\n","device","boot","start","count",\
			"size", "sys_id","fstype");	
	unsigned ebr_lba = 0;
	int i;
	for(i=0;i<4;i++){
		if(g_dps[i].start_lba==0) continue;
		print_dp(&g_dps[i], i + 1);	
		if(g_dps[i].sys_id == 5) {
			ebr_lba = g_dps[i].start_lba;	/* extended */
			p_ext_id = i;
		}
	}
	char ebr[512];
	struct dp *dp = (void *)(ebr + 446);
	next_ebr:
	if(ebr_lba == 0)  goto done;
	main_read_sector(ebr, ebr_lba);
	assert(dp->start_sector != 0 && "extended partation totally empty? ");
	g_dps[i] = *dp;
	g_dps[i].start_lba += ebr_lba;	/*修正成绝对偏移*/
	

	print_dp(dp, i + 1);
	if(dp[1].start_lba) ebr_lba += dp[1].start_lba;
	else ebr_lba = 0;
	i++;
	goto next_ebr;

	done:
	g_dpnum = i;
}

void print_cell(struct cell *cell, int depth){
	depth++;
	if(cell->type != F_DIR) return;
	struct cell_dentry *ent = cell->ents;
	for(int remain = cell->size, entsize; remain > 0;  ent = (void *)((unsigned)ent + entsize)){
		
		int len = ent->len;
		entsize = sizeof(struct cell_dentry) + len;
		if(len != 0){
			remain -= entsize;
			printf("%*s|__%.*s\n",depth, " ", len, ent->name);
			if(ent->len == 1 && strncmp(ent->name, ".", 1) == 0) continue;
			if(ent->len == 2 && strncmp(ent->name, "..", 2) == 0) continue;
			char cell[sb.cellsize];
			main_read_cell(cell, ent->cellid);
			print_cell((struct cell*)cell, depth);
		}
	}
}

/*load a file in current directory */
bool loadfile(char *name, char *buf){
	struct cell_dentry *ent = cell_find_entry(&pwd_block, name);
	if( !ent ) return_say(0, "can not find file");
	main_read_cell(buf, ent->cellid);
	return 1;
}
int main(int argc, char *argv[]){
	_tmp_block = malloc(0x100000);
	_pwd_block = malloc(0x100000);
	_entpwd = malloc(64);
	mainfd = open(argv[1], O_RDWR);
	if(!mainfd) fail_say("open failed: %s", argv[1]); 
	read(mainfd, mbrbuf, 1024);
	
	init_dp();
	if(!choose_partation(0)) return_say(1, "auto choose partation failed")

	//if(!check_cell_flags(&sb)) printf("cell filesystem undetected !");
	while(printf("$") && scanf("%s%s", cmd, arg1) != EOF){
		//printf("%s > %s", cmd, arg1);
		if(strcmp(cmd, "exit") == 0) return 0;
		else if(strcmp(cmd, "pwd") == 0 ||
				strcmp(cmd, "where") == 0) 
				printf("now in partation: %d\n", p_id + 1);
		else if(strcmp(cmd , "format") == 0){
			strncpy(sb.flags, "cell", 4);
			sb.cellsize = CELL_SIZE;	
			sb.rootcell = ROOTCELL_DEFAULT; /*STRONG ORDER:1 */
			sb.cellnum = SECTOR2BLOCK(p_count);	/*STRONG ORDER: 2
												*BUG 考虑分区sector total*/
			memset(sb.bitmap, 0, sb.cellnum);
			sb.bitmap[0] = 1;	/*block 0: used as root directory */
			write_sb();
			main_read_cell((void *)&tmp_block, 0);	/*0号cell就是root cell*/
			tmp_block.size = 0;
			tmp_block.type = F_DIR;
			add_entry(&tmp_block, 0, ".", 0);
			add_entry(&tmp_block, 0, "..", 0);
			choose_partation(p_id);	/* load pwd_block, at least*/
			printf("done.\n");
		}
		else if(!check_cell_flags(&sb))
			go_on("we are trapped in a un-cell partation, you have to run 'format'\n", 0)
		else if(cmd[0] > '0' && cmd[0] < '9'){
			int ok = choose_partation(cmd[0] - '0' - 1);
			if(ok) printf("partation %c now\n", cmd[0]);
			else printf("failed\n");
		}
		else if(strcmp(cmd, "cd") == 0){
			if(strlen(arg1) <= 0) go_on("second arg missing", 0)
			struct cell_dentry *ent = cell_find_entry(&pwd_block, arg1);
			if(!ent) go_on("can not find %s", arg1)
			main_read_cell((char *)&tmp_block, ent->cellid);
			if(tmp_block.type == F_DIR){
				entpwd = *ent;		//first step
				strncpy(entpwd.name, ent->name, ent->len);
				memcpy((char *)_pwd_block, (char *)_tmp_block, sb.cellsize);
				printf("ok\n");
			}
			else go_on("not a directory:%s", arg1)
				
		}
		else if(strcmp(cmd, "cat") == 0){
			if(loadfile(arg1, (void *)&tmp_block)){
				if(tmp_block.type != F_REG) 
					go_on("not regular file\n", 0)
				tmp_block.data[tmp_block.size] = 0;
				printf("%s\n", tmp_block.data);	
			}
		}
		else if(strcmp(cmd, "cp") == 0){
			char newname[64];
			scanf("%s", newname);
			int fd = open(arg1, O_RDWR);
			if(fd == -1) go_on("open failed: %s\n", arg1 )
			int size = read(fd, tmp_block.data, CELL_DATA_MAX);
			tmp_block.size = size;
			tmp_block.type = F_REG;
			/*ok, we loaded the source file and prepare for writing*/
			/*firstly, find a new dentry and block if no same-name file exsits*/
			struct cell_dentry *ent = cell_find_entry(&pwd_block, newname);	
			if(ent)	;/*we are lucky*/
			else{
				int newcell = alloc_free_block(&sb);
				ent = add_entry(&pwd_block, entpwd.cellid, newname, newcell);
			}
			main_write_cell((char *)&tmp_block, ent->cellid);
			main_write_cell((char *)&pwd_block, entpwd.cellid);
			write_sb();
		}
		else if(strcmp(cmd, "mkdir") == 0){
			int bid = alloc_free_block(&sb);
			struct cell_dentry *newent = add_entry(&pwd_block, entpwd.cellid, arg1, bid);
			assert(newent);
			tmp_block.type = F_DIR;
			tmp_block.size = 0;
			add_entry(&tmp_block, bid, ".", bid);
			add_entry(&tmp_block, bid, "..", entpwd.cellid);
			
		}
		else if(strcmp(cmd, "ls") == 0){
			//printf("ls now\n");
			print_cell(&pwd_block, 1);	
		}
		else go_on("unspecified command %s\n", cmd)
	}
	close(mainfd);
	return 0;
}















