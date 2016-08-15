#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
#include<stdio.h>
#include<unistd.h>
#include<assert.h>
#include<errno.h>
#include<string.h>
int fdsize(int fd){
	int pos = lseek(fd, 0, SEEK_CUR);	
	int size = lseek(fd, 0, SEEK_END);
	lseek(fd, pos, SEEK_SET);
	return size;
}

int filesize(char *name){
	int fd = open(name, 1+1, 0);
	if(fd == -1) return -1;
	int size = fdsize(fd);
	close(fd);
	return size;
}

char *get_dirfile(char *dir, char *filename, char *fullpath){
	//assert(dir[strlen(dir)-1] == '/');
	strcpy(fullpath, dir);
	if(dir[strlen(dir) - 1] != '/'){
		fullpath[strlen(dir)] = '/';
		fullpath[strlen(dir) + 1] = 0;
	}
	strcat(fullpath, filename);
	return fullpath;
}
