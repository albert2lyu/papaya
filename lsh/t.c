#include<stdio.h>
#include"tochar.h"
int main(void){
	char *endptr = 0;
	int a = strtol("sdfabc", &endptr, 10);
	printf("%s\n", getenv("HOME"));
	//printf("%x", SEQ(s, d));
	//printf("%c", tochar($));
}
