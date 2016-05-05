/* warning:
 * 1, every time you change structures in this file, you have to re-compile cmd/cell.c
   and re-format 400m.img.
 */

#ifndef CELL_COMMON_H
#define CELL_COMMON_H

#define ROOTCELL_DEFAULT 4096
#define CELL_SIZE (128 * 1024)
#define CELL_HEADER_SIZE (unsigned)(((struct cell *)0)->data)
#define CELL_DATA_MAX (CELL_SIZE - CELL_HEADER_SIZE)
struct cell_dentry{
	int len;
	int cellid;		/* point to which cell */
	char name[0];
};
struct cell{
	unsigned mktime;
	unsigned chgtime;
	unsigned size;
	unsigned type;

	struct cell_dentry ents[0];
	char data[0];
};
/*cell 文件系统的super block磁盘映像*/
struct cell_superblock{
	union{
		struct {
			char flags[4];
			int cellsize;
			int cellnum;
			int rootcell;		/*单位是字节，rootcell相对分区最起始的字节偏移*/
			char bitmap[0];

		};
		char room[1024];
	};
};
/*
struct cell_super_block{
	union{
		char room[1024];
		struct{
			char flags[4];
			int block_size;
			int block_num;
			struct cell_dentry root;
			char block_bmp[FILE_MAX];
		};
	};
}sb;
*/
#endif
