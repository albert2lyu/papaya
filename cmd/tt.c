#include<stdio.h>

int foobar(void){
	int a ;
	int c = getchar();
	for( ; ((a=getchar()) || 1) && c; c++){
		printf("hello %d", a);
	}
	return 0x234;
}
int main(void){
	foobar();	
}




