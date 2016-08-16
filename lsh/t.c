#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
int main(){
	pid_t pid = fork();
	if(pid == 0)
		while(1)
			printf("son:%d\n",getpid());
	else
		exit(0);
	return 0;
}
