#ifndef LINUX_STRING_H
#define LINUX_STRING_H

//this header file is also used by user program
#include<valType.h>

int strlen(char*str);
unsigned long strnlen(char*str, ulong n);
char*strcpy(char*dest,char*src);
char*strncpy(char*dest, const char*src, int n);
int strcmp(const char *str1, const char *str2);
int strncmp(const char *str1, const char *str2, int n);
bool strmatch(char*seg,char*whole);

#endif
