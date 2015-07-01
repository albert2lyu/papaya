#include<elf.h>
#include<mmzone.h>
#include<sys_call.h>
#include<fs.h>
#include<unistd.h>
#define register_cmd(func) __register_cmd(#func, func)
#define CHAR_INT(c) ((c) == '0'? 0 : (c) - '0')
static void time(void);
static void kfreee(void);
static void kmallocc(void);
static void detect_pci(void);

static int cmd_asciis_nextword(void);
static int read_cmos(int addr);
static void init(void);
//tty运行在ring1,是内核进程,因为是从ring3移过来的，所以保留了较多的系统调用
#include<struinfo.h>
#include<ku_utils.h>
#include<sys_call.h>
#include<tty.h>
#include<ku_proc.h>
#include<disp.h>
#include<proc.h>
#include<mm.h>
#include<utils.h>
#include<video_drv.h>
char tmp[64];
char*buff;
extern unsigned p0_addr;
#define SIZE_LOAD_BUF (64*1024)
static char*loadbuf;
#define CMD_MAX_LEN 128
static char cmd_asciis[CMD_MAX_LEN];
static int cmd_len=0;
static char* pt_cmd=0;
static char arg0[16];

#define CMD_MAX_NR 100
static char*cmd_arr[CMD_MAX_NR];
static void (*func_arr[CMD_MAX_NR])();
int cmd_count = 0;

/**variables used for debug*/
static int g_zid = 2;
static int g_free_list_len;
static void set_zid(char *zid){g_zid = CHAR_INT(*zid);}
static void set_free_list_len(char *len){g_free_list_len = CHAR_INT(*len);}
static void alloc_pages_(char *order){__rmquene(__zones[g_zid], CHAR_INT(*order));}
/**
 * 1,目前tty调用了一些其它模块的函数,好在这些内核函数不含current指针.
 * 2,13年ring1进程之所以能调用任何内核函数,是因为那时还没有current指针,
 * 或者忘了给ring1进程调整指向3G的esp.
 */
void tty(void){
	oprintf("try to mount device1:partation:1:%s\n",mount("/mnt/",1,1)?"success":"failed");
	init();
	int crt_start;
//	__asm__("cli");
	loadbuf=kmalloc(SIZE_LOAD_BUF);
	oprintf("tty running..welcome^.^\n");
	while(1){
new_prompt:
		reset_cmd_asciis();
		memsetw((u16*)loadbuf,SIZE_LOAD_BUF/2,0);
		oprintf("#   ");
wait_input:
		while(1){
			unsigned ascii=getchar();
			switch(ascii){
				case 128://ctrl+l
					k_screen_reset();
					goto new_prompt;
				case 129://ctrl+c
					//kill(front_pid);
					oprintf("^C\n");
					goto new_prompt;
				case 130://ctrl+u
					crt_start=get_start();
					set_start(crt_start>=80?crt_start-80:crt_start);
					goto wait_input;
				case 131://ctrl+d
					crt_start=get_start();
					set_start(crt_start<(80*24*4-1)?crt_start+80:crt_start);
					goto wait_input;
			}
			oprintf("%c",ascii);//oprintf函数有能力打印控制字符，但更多的ctrl，shift组合还要跟进
			if(ascii=='\n'){//回车符执行命令
				parse_cmd_asciis();
				break;
			}
			//执行到这儿，说明是普通输入,写入cmd_asciis
			write_cmd_asciis(ascii);
		}
	}
}

static void info_free_area(void){
	int zid = g_zid;
	free_area_t *free_area = __zones[zid]->free_area;
	for(int i = 0; i <= MAX_ORDER; i++){
		oprintf("[%u]:%x ", 1<<i, free_area[i].nr_free);
		struct list_head *free_list = &free_area[i].free_list;
		struct list_head *node = free_list;
		int j =g_free_list_len;
		while(node->next != free_list && j-- > 0){
			node = node->next;
			page_t *page = (page_t *)((unsigned)node - MEMBER_OFFSET(page_t, lru));
			int page_id = page_idx(page);
			oprintf("%x(%x) --> ",(page-__zones[zid]->zone_mem_map)>>i, page_id);
		}	
		oprintf("\n");
	}
}

static void disk(void){
	oprintf("%10s%10s%8s%8s%10s%10s\n","device","boot","start","count","sys_id","sys_string");	
	int gmkb_start_lba[4];
	int gmkb_size[4];
	for(int i=1;i<MAX_PARTATION;i++){
		DP*dp=g_dp[1]+i;
		if(dp->start_lba==0) continue;//empty dp
		int c=dp->count/2;//x kb
		int s=dp->start_lba/2;//s kb
		/**
		int x_scale_count=0;
		int s_scale_count=0;
		while(x>=1024){
			x/=1024;
			x_scale_count++;	
		}
		while(s>=1024){
			s/=1024;
			s_scale_count++;
		}
		*/
		human_memsize_into(gmkb_start_lba,s,1);	
		human_memsize_into(gmkb_size,c,1);	
		int max0=0;
		int max1=0;
		while(gmkb_start_lba[max0]==0) max0++;
		while(gmkb_size[max1]==0) max1++;
//		oprintf("max0:%u,max1:%u\n",max0,max1);
		oprintf("%10u%10u%4u%4c%4u%4c%10u%10s\n",i,dp->boot,gmkb_start_lba[max0],mem_entity[max0],gmkb_size[max1],mem_entity[max1],dp->sys_id,sys_string[dp->sys_id]);
	}
}
static void kfreee(void){
	char*hex_str=arg0;	
	int addr;
	eat_hex(hex_str,addr);
	if(addr==-1){
		oprintf("bad size format\n");
		return;
	}
	kfree((void*)addr);
	info_heap();
}
static void kmallocc(void){
	char*hex_str=arg0;	
	int byte;
	eat_hex(hex_str,byte);
	if(byte==-1){
		oprintf("bad size format\n");
		return;
	}
	else if(byte+4<sizeof(EMPTY_BLOCK)){//申请byte太少
		oprintf("you are timid,can you ask for more?\n");
	}
	else {//正常申请
		kmalloc(byte);
	}
	info_heap();
}

#define MK_BDF(bus,dev,func) ((u32)(bus<<8|dev<<3|func))
#define MK_PCIADDR(bus,dev,func,reg) ((u32)(1<<31|MK_BDF(bus,dev,func)<<8|reg<<2))
#define PCI_BUS_MAX 0xff
#define PCI_DEV_MAX 0x1f
#define PCI_FUNC_MAX 0x7
#define PCI_CONFIG_ADDR 0XCF8
#define PCI_CONFIG_DATA 0xCFC
static void detect_pci(void){
	for(int bus=0;bus<=PCI_BUS_MAX;bus++){
		for(int dev=0;dev<=PCI_DEV_MAX;dev++){
			for(int func=0;func<=PCI_FUNC_MAX;func++){
				u32 addr=MK_PCIADDR(bus,dev,func,0);
				out_dw(PCI_CONFIG_ADDR,addr);

				u32 t=in_dw(PCI_CONFIG_ADDR);
//				oprintf("out_dw:%u,in_dw:%u\n",addr,t);
				u32 device_vender=in_dw(PCI_CONFIG_DATA);
				u16 device=device_vender>>16;
				u16 vender=device_vender&0xffff;
				if(vender!=0xffff){
					oprintf("bus:%u,dev:%u,func:%u,vender:%u,device:%u\n",bus,dev,func,vender,device);
				}
			}
		}
	}
}
static void time(void){
	int y=read_cmos(9);
	int m=read_cmos(8);
	int d=read_cmos(7);
	int h=read_cmos(4);
	int mi=read_cmos(2);
	int s=read_cmos(0);
	oprintf("20%u-%u-%u %u:%u:%u\n",y,m,d,h,mi,s);
}
static int read_cmos(int addr){
	out_byte(0x70,addr);
	int x=in_byte(0x71);
	return (x&0xf)+(x>>4)*10;
}

//return  value in two approach,very intersting
void reset_cmd_asciis(){
	cmd_len=0;
	memsetw((u16*)cmd_asciis,CMD_MAX_LEN/2,0);
	pt_cmd=cmd_asciis;
}

void parse_cmd_asciis(){//一个粗略的命令解析函数
	for(int cmd_id=0;cmd_id<cmd_count;cmd_id++){
		if(charscmp(cmd_arr[cmd_id],cmd_asciis,1)==1){
			if(cmd_asciis_nextword()){
				chars_to_str((char*)arg0,(char*)pt_cmd);
			}
			func_arr[cmd_id](arg0);
			return;
		}
	}
	oprintf("invalid command '%s'\n",cmd_asciis);
}

//void cmd_asciis_
void write_cmd_asciis(unsigned ascii){
	//先判别是否为控制字符
	if(ascii=='\b'){//处理退格鍵，删除缓冲区一个字符
		if(cmd_len>0){
			cmd_len--;
			cmd_asciis[cmd_len]=0;
		}
	}
	//若ascii是可打印字符，写入缓冲区
	else{
		cmd_asciis[cmd_len]=ascii;
		cmd_len++;
	}
}


static int cmd_asciis_nextword(void){//aim:adjust pt_cmd
	assert(*pt_cmd!=' '&&*pt_cmd!=0)
	while(*pt_cmd!=' '&&*pt_cmd!=0){
		pt_cmd++;
	}
	//now point to a empty seg,jump it
	if(*pt_cmd==0) return 0;//check if meet cmd end
	//to here,the empty is a space,safe
	while((*pt_cmd)==' '||(*pt_cmd)==0){
		pt_cmd++;
	}
	if(*pt_cmd==0) return 0;//whether space-serials followed by a \-
	return 1;
	//now point to a new word's head
}

static void __register_cmd(char *cmd, void (*func)(void)){
	func_arr[cmd_count] = func;
	cmd_arr[cmd_count] = cmd;
	cmd_count++;	
}

static void cat(char*path){
	int fd=open(path,0);
	if(fd==-1) return;
	int size=lseek(fd,0,2)+1;
	oprintf("i want to read %u bytes\n",size);
	spin("spin");
	lseek(fd,900,0);
	int r_bytes=read(fd,loadbuf,20);
	close(fd);
	oprintf("%s\n",loadbuf);
}

static void init(void){
	register_cmd(time);
	register_cmd(kfreee);
	register_cmd(kmallocc);	
	register_cmd(detect_pci);	
	register_cmd(info_free_area);
	register_cmd(set_zid);
	register_cmd(set_free_list_len);
	register_cmd(alloc_pages_);
	register_cmd(disk);
	register_cmd(cat);
}
