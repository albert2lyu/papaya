/* cell 文件系统和ramdisk的初步代码都在这里*/
#include"ramdisk.h"
#include"fs_cell.h"
#include"mm.h"
void ramdisk_init(unsigned addr){
	cellmbr = (char *)(RAMDISK_BASE + PAGE_OFFSET);
}

int cell_read(char *file, char *buf){
	int cellid = search_file(file);
	if(cellid == -1) return 0;	
	oprintf("cellmbr:%x, cellid:%u\n", cellmbr, cellid);
	char *src = cellmbr + (cellid*CELL_SECTORS + 1) * 512;
	memcp(buf, src, CELL_SECTORS * 512);
}

