#include "syscall.h"

char *__argv[] = {
	"this is arg1",
	"and arg2",
	"arg3",
	0
};

char * __envp[] = {
	"HOME=/wws",
	"PATH=/wws/lab/yanqi/cmd:/wws/software",
	0
};

#define __argc (sizeof(__argv) / sizeof(char *))

static char g_array[10] = {1, 2, 3, 4, 5, 6};
int static_array[1024];
void doado(int argc, char *argv[], char *envp[]){
	int x;
	for(int i = 0; i < 10; i++) printf("%u\n", g_array[i]);
	int ret = fork();
	printf("I am back ! %u\n", ret);
	if(ret == 12345){
		execve("/home/cat", __argv, __envp);	
	}
	while(1){
		static_array[1023] = 3;
		char c = ret == 12345 ? '+' : '-';
		printf("%c ", c);
	}
}









