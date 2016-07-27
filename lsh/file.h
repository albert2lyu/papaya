#ifndef FILE_H
#define FILE_H

int fdsize(int fd);
int filesize(char *name);
char *get_dirfile(char *dir, char *filename, char *fullpath);
#endif
