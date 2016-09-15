#ifndef PRINTF_H
#define PRINTF_H
#include<valType.h>

int __sprintf(char *buf, char *format, u32 *args);
int sprintf(char *buf, char *format, ...);
int printf(char *format, ...);
void write_bar(int x, int y, char *title, char *content);

#endif
