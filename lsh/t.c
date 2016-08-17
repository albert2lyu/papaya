#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#define mkstr(s1, s2) s1 ## s2
#define strit(s) #s

int main(){
	int child_B, child_A;
	int pipefds[2];
	char *args1[] = {"/bin/wc", 0};
	char *args2[] =  {"/usr/bin/ls", 0};
	pipe(pipefds);

	if(!(child_B = fork())){
		close(pipefds[1]);
		close(0);
		dup2(pipefds[0], 0);
		close(pipefds[0]);
		execve("/usr/bin/wc", args1, 0);
		printf("pid %d: I am back, something is wrong\n", getpid());
	}

	close(pipefds[0]);

	if(!(child_A = fork())){
		close(1);
		dup2(pipefds[1], 1);
		close(pipefds[1]);
		execve("/bin/ls", args2, 0);
		printf("pid %d: I am back, something is wrong\n", getpid());
	}
	close(pipefds[1]);	
	while( wait4(-1, 0, 0, 0) != -1) ;
	printf("Done\n");

	return 0;
}





