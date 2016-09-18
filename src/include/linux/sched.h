#ifndef LINUX_SCHED_H
#define LINUX_SCHED_H
struct pt_regs;
#include<valType.h>
#include<asm/page.h>

struct mm{
	union cr3 cr3;
	struct vm_area *vma;
	//start_data/code, end_data/code不需要4K对齐,但start_brk和brk是需要的
	unsigned long start_code, end_code;
	unsigned long start_data, end_data;
	unsigned long start_brk, brk;
};

int kernel_thread(int (*fn)(void *), void *arg, unsigned flags);

int 
do_execve(char *filepath, char *argv[], char *envp[], struct pt_regs *regs);
int schedule_timeout(unsigned msec);

void do_timer(void);
#endif
