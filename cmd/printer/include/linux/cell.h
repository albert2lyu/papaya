#ifndef CELL_H
#define CELL_H
#include<linux/cell_common.h>
/*用来解读super_block 尾部common块儿*/
struct cell_sb_info{
	int rootcell;
	int cellsize;
	int cellnum;
	char *bitmap;

};

struct cell_inode_info{
	
};
int cell_read_super(struct super_block *sb);
#endif
