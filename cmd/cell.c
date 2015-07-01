#include<stdlib.h>
#include<stdio.h>
#include<unistd.h>
#include<assert.h>
#include<errno.h>
#include"../include/fs_cell.h"
#define DISK_PATH "./cell.img"
char block[1024];
char cmd[64];
int main(int argc, char *argv[]){
	assert(argc == 3);
	cellmbr = malloc(512);
	assert(cellmbr);

	char *file = argv[2];
	if(open(file, 0) == -1){
		printf("%s not exist\n", file);
		return 1;
	}
	int fd = open(DISK_PATH, 2);
	if(fd == -1){
		printf("can not open %s\n", DISK_PATH);
		return 1;
	}
	read(fd, cellmbr, 512);

	if(strcmp(argv[1], "set") == 0){
		int i;	
		for(i = 0; i < CELL_MAX; i++){
			if(cellmbr[i*NAME_LEN] != 0) continue;
			/**got a empty name entry*/
			strcpy(cellmbr + i*NAME_LEN, file);
			lseek(fd, 0, 0);
			write(fd, cellmbr, 512);

			sprintf(cmd, "dd if=/dev/zero of=%s bs=512 conv=notrunc seek=%d count=%d",  DISK_PATH, 1+CELL_SECTORS*i, CELL_SECTORS);	
			system(cmd);
			sprintf(cmd, "dd if=%s of=%s bs=512 conv=notrunc seek=%d count=%d", file, DISK_PATH, 1+CELL_SECTORS*i, CELL_SECTORS);	
			system(cmd);
			break;
		}	
		if(i == CELL_MAX) printf("error:disk has no space\n");
	}
	else if(strcmp(argv[1], "info") == 0){
	
		if(strcmp(file, "cell") == 0){
			printf("file list:\n");
			int i = 0;
			while(i < CELL_MAX){
				if(cellmbr[i*NAME_LEN] != 0){
					printf("%d:%s   ", i, cellmbr + i*NAME_LEN);
				}
				i++;
			}
		}
		else{
			printf("%s:\n", file);
			int cell_id = search_file(file);
			if(cell_id == -1){
				printf("file %s not exist\n", file);
				return 1;
			}
			lseek(fd, 512*(1+CELL_SECTORS*cell_id), 0);
			read(fd, block, 512);
			printf("%s", block);
		}
	}

	else if(strcmp(argv[1], "del") == 0){
		printf("try delete %s\n", file);
		int cell_id = search_file(file);
		if(cell_id == -1){
			printf("file %s not exist\n", file);
			return 1;
		}
		cellmbr[cell_id*NAME_LEN] = 0;
		lseek(fd, 0, 0);
		write(fd, cellmbr, 512);
		printf("done\n");
	}
	else;

	return 0;
}
