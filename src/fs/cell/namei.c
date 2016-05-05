/* 1, inode number就是cell number。 每个cell都是一个文件。
 * 2, root-cell 永远在第一个。
 */
#include<linux/fs.h>
#include<linux/cell.h>
#include<utils.h>
#include<linux/blkdev.h>
#define SB_COMMON(superblock) ((struct cell_sb_info *)(superblock->common))
#define I_COMMON(inode) ( (struct cell_inode_info *)(inode->common) )
/*@CELL_BLOCKS() & @CELL_START()
 *这两个宏是为了方便调用ll_rw_blocks()时的一些转换
 */
/* blocks per cell. blocksize = 1K */
#define CELL_BLOCKS(sb) (SB_COMMON(sb)->cellsize >> 10)
/* start block of a cell.*/
#define CELL_START(cellid, sb) ((SB_COMMON(sb)->rootcell >> 10) + CELL_BLOCKS(sb) * cellid)
static int cell_lookup(struct inode *dir, struct dentry *dentry);
static int read_inode(struct inode *inode);
static struct inode_operations cell_inode_operations= {
	lookup:	cell_lookup,
};

static struct super_operations cell_sb_operations = {
	read_inode: read_inode,	
};

static int read(struct file *file, char *buf, unsigned size, unsigned *ppos);
static int onclose(struct file *file);
static struct file_operations cell_f_ops = {
	open: 0,
	lseek: 0,
	read:read,
	onclose:onclose,
};
static int read_cell(struct super_block *sb, int cellid, struct cell *buf){
	int err = ll_rw_block2(sb->dev, READ, CELL_START(cellid, sb), CELL_BLOCKS(sb), (char *)buf);
	if(err){
		return err;
		spin("read cell failed");
	}
	return 0;	
}

static struct cell * cache_cell_header(struct super_block *sb, int cellid){
	//struct cell * cell = kmalloc( SB_COMMON(sb)->cellsize );	/* don't use sizeof(struct cell) */
	struct cell * cell = kmalloc(1024);	
	int err = ll_rw_block2(sb->dev, READ, CELL_START(cellid, sb), 1, (char *)cell);
	if(err){
		kfree(cell);
		spin("read cell header failed");
	}
	return cell;	
}
static int read_inode(struct inode *inode){
	struct super_block *sb = inode->sb;
	struct cell * cell = cache_cell_header(sb, inode->ino);
	if(!cell){
		return 1;
	}
	inode->mktime = cell->mktime;
	inode->chgtime = cell->chgtime;
	inode->size = cell->size;
	inode->operations = &cell_inode_operations;
	inode->file_ops = &cell_f_ops;
	kfree(cell);
	return 0;
}

/*TODO some code within should be moved to upper class function --- real_lookup */
static int cell_lookup(struct inode *dir, struct dentry *dentry){
	/* cell_find_entry把inode number放在struct inode字段*/
	//struct dentry *result = cell_find_entry(parent, dentry);	/* main job done */
	int err;
	struct super_block *sb = dir->sb;
	struct qstr *name = &dentry->name;
	struct cell *cell = kmalloc(SB_COMMON(sb)->cellsize);
	err = read_cell(sb, dir->ino, cell);
	if(err) {
		kfree(cell);
		return err;
	}
	struct cell_dentry *cell_ent = cell->ents;
	int remain;
	for(remain = cell->size; remain > 0;){
		int entsize = sizeof(struct cell_dentry) + cell_ent->len;
		//cell_ent = (void *)((u32)cell_ent + entsize);
		int len = cell_ent->len;
		if(len != 0){
			if(len == name->len && strncmp(name->name, cell_ent->name, len) == 0) break;
			remain -= entsize;
		}
		cell_ent = (void *)((u32)cell_ent + entsize);	/*next*/
	}
	if(remain <= 0){
		kfree(cell);
		return 1;	/*找不到*/	
	}
	dentry->inode = (void *)cell_ent->cellid;	/*把cell_dentry的信息搬到dentry里*/
	kfree(cell);

	return 0;
}

/* cell文件系统的superbock在1k位置，占一个block
 * 这个函数就是在挂载的时候被调用的。 所以创建sb->root这个dentry时，参数@parent总是
 * 传的是0.
 * 对任何一个挂载点，其->small_root这个dentry，或者说sb->root这个dentry总是捏造出来的。
 * 因为从情理上本来就不该有。 没有name。但好歹让sb指向挂载的设备的sb。当然了，sb->
 * root这个dentry的parent是没有的.
 */
int cell_read_super(struct super_block *sb){
	/*do safety check */
	assert(sizeof(struct cell_inode_info) <= sizeof(INODE_COMMON_SIZE));
	assert( CELL_HEADER_SIZE < 1024 );

	struct cell_superblock *cell_sb = kmalloc(1024);	/*BUG on sb_size > 1024 */
	int err = ll_rw_block2(sb->dev, READ, 1, 1, (char *)cell_sb);
	if(err) {
		kfree(cell_sb);
		return err;
	}
	/*初始化super block*/
	sb->operations = &cell_sb_operations;
	SB_COMMON(sb)->rootcell = cell_sb->rootcell;
	SB_COMMON(sb)->cellsize = cell_sb->cellsize;
	SB_COMMON(sb)->cellnum = cell_sb->cellnum;
	SB_COMMON(sb)->bitmap = cell_sb->bitmap;	/* so..不要释放cell_sb */

	/*要在内存里构建root dentry及它的inode */
	struct dentry *local_root = d_create(0, &(struct qstr){"/", 1, 0});
	local_root->inode = iget(sb, 0);	/*root inode 永远是0号inode */
	sb->root = local_root;
	local_root->sb = sb;	/*这种琐碎的关系就放在最后做*/
	return 0;
}


struct buf2{
	char *firstbuf, *lastbuf;
};
static int read(struct file *file, char *buf, unsigned size, unsigned *ppos){
	//struct dentry *dentry = file->dentry;
	struct inode *inode = file->dentry->inode;
	if(!file->data) file->data = kmalloc0( sizeof(struct buf2) );
	struct buf2 *buf2 = file->data;
	if(!buf2->firstbuf) buf2->firstbuf = kmalloc0( 1024 );
	if(!buf2->lastbuf) buf2->lastbuf = kmalloc0( 1024 );
	char *firstbuf = buf2->firstbuf;
	char *lastbuf = buf2->lastbuf;	/* if we have a on_open, this piece of code can be 
									* moved to on_open, that's better */

	int cell_addr  = CELL_START(inode->ino, inode->sb) * 1024;	
	unsigned pos  = cell_addr + CELL_HEADER_SIZE + file->pos ;
	unsigned end  = pos + size - 1;

	int first = pos / 1024;
	int last =  end / 1024;
	ll_rw_block2(inode->dev, READ, first, 1, firstbuf);
	if(last != first) ll_rw_block2(inode->dev, READ, last, 1, lastbuf);

	int first_left = pos % 1024;
	int first_right = 1024 - first_left;
	char *addr = buf + first_right;
	for(int i = first + 1; i <= last - 1; i++){
		ll_rw_block2(inode->dev, READ, i, 1, addr);
		addr += 1024;
	}
	
	memcpy(buf, firstbuf + first_left, first_right);
	if(last != first) memcpy(addr, lastbuf, end % 1024 + 1);

	return size;
}

static int onclose(struct file *file){
	if(file->data){
		struct buf2 *buf2 = file->data;
		kfree(buf2->firstbuf);
		kfree(buf2->lastbuf);
		kfree(buf2);
	}
	return 0;
}










