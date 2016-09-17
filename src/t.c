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
int main(int argc, char *argv[], char *envp[]){
	
	for(int i = 0; i < sizeof(g_array) / 4; i++) printf("%u\n", g_array[i]);
	//printf("a:%x, %x, %x", func_table[2], func_table[4], func_table[9]);
	struct flower red_rose;
	struct flower blue_rose;
	struct flower *red = &red_rose;
	struct flower *blue = &blue_rose;
	//printf("argc:%d, argv:%p, envc:%x, envp:%p", argc, argv, envc, envp);
	//printf("%p", (unsigned *)0x1 + 4);
	//int a = insert(red, blue);
	//printf("%d", a);
	return 0;
}








