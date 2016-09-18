#include "syscall.h"

static char g_array[10] = {1, 2, 3, 4, 5, 6};
int static_array[1024];
void doado(void){
	int x;
	for(int i = 0; i < 10; i++) printf("%u\n", g_array[i]);
	while(2){
		static_array[1023] = 3;
	}
}
