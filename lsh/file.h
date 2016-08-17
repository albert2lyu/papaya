#ifndef FILE_H
#define FILE_H

#define bool int
#define true 1
#define false 0

#include<sys/types.h>
#include<fcntl.h>
#include<unistd.h>

int fdsize(int fd);
int filesize(char *name);
char *get_dirfile(char *dir, char *filename, char *fullpath);

static inline bool file_exists(char *filepath){
	int fd = open(filepath, 0);
	if(fd != -1){
		close(fd);
		return true;
	}
	return false;
}
#endif
