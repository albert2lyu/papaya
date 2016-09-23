#include"../debug/debug.h"
#include<assert.h>
#include<stdio.h>
struct flower{
	struct flower *prev, *next;
	struct flower *_prev, *_next;
	int age;
};

int insert(struct flower *root, struct flower*new){
}


static char g_array[10] = {1, 2, 3, 4, 5, 6};
void foobar(void){
	goto aaa;
	for(int i =0; i < 10; i++){
		int a = 0x123;
		int b;
		if (a > b)
		aaa: printf("hellor :%d\n", a);
	}
}
void erase(int v[]){
	for(int i = 0; i < 10; i++){
		v[i] = 0;
	}
}
int main(int argc, char *argv[], char *envp[]){
	#if 1
	int x = 2;
	goto aaa;
		
	
	for(int j = 0x11; j < 100; j++){
		int a = 0x456;
		sleep(1);
		aaa: 
			printf("hellor :%d\n", j);
	}
	#endif
	return 0;
}








