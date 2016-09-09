#ifndef LINUX_SCHED_H
#define LINUX_SCHED_H
#include<valType.h>
#include<asm/page.h>

struct mm{
	union cr3 cr3;
};

int kernel_thread(int (*fn)(void *), void *arg, unsigned flags);

int 
do_execve(char *filepath, char *argv[], char *envp[], struct stack_frame *regs);
	

#endif
