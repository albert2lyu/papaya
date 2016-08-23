#include<stdio.h>
#include"tochar.h"
int main(void){
	char *endptr = 0;
	int a = strtol("sdfabc", &endptr, 10);
	printf("%d, %s\n", a, endptr);
	//printf("%x", SEQ(s, d));
	//printf("%c", tochar($));
}
