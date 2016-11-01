#include"fs_cell.h"

int search_file(char *name){
	int i = 0;
	while(i < CELL_MAX){
		if(strcmp(cellmbr + i*NAME_LEN, name) == 0) return i;
		i++;
	}
	return -1;
}
