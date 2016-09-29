#include "syscall.h"
int cat(int argc, char *arg0){
	char **argv = &arg0;
	char **envp = argv + argc + 1;
	int i = 0;
	repeat:
	for( i = 0; i < argc; i++){
		printf("%s\n", argv[i]);
	}
	i = 0;
	while(envp[i]){
		printf("%s\n", envp[i++]);
	}
	exit(3);
	goto repeat;
	while(1){
		//printf("? ");
	}
}
