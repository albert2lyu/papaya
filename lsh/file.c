#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
#include<stdio.h>
#include<unistd.h>
#include<assert.h>
#include<errno.h>
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
