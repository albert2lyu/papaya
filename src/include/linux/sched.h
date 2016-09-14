#ifndef LINUX_SCHED_H
#define LINUX_SCHED_H
struct pt_regs;
#include<valType.h>
#include<asm/page.h>

struct mm{
	union cr3 cr3;
	struct vm_area *vma;
};

int kernel_thread(int (*fn)(void *), void *arg, unsigned flags);

int 
do_execve(char *filepath, char *argv[], char *envp[], struct pt_regs *regs);
	

#endif
