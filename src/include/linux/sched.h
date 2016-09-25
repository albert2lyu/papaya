#ifndef LINUX_SCHED_H
#define LINUX_SCHED_H
struct pt_regs;
#include<valType.h>
#include<asm/page.h>

/* cloning flags:
 * 低8位用作信号遮罩。
 */
#define CSIGNAL 		0xff		/* signal mask to be sent at exit */
#define  CLONE_VM 		0x100		/* note! opposite to linux! 1 means copy */
#define  CLONE_FS 		0x200		
#define  CLONE_FD 	0x400


struct mm{
	union cr3 cr3;
	struct vm_area *vma;
	//start_data/code, end_data/code不需要4K对齐,但start_brk和brk是需要的
	unsigned long start_code, end_code;
	unsigned long start_data, end_data;
	unsigned long start_brk, brk;
	/* int count; */				//暂时不想支持active_mm
	int users;						//被多少个进程(线程)共享
};

int kernel_thread(int (*fn)(void *), void *arg, unsigned flags);

int 
do_execve(char *filepath, char *argv[], char *envp[], struct pt_regs *regs);
int schedule_timeout(unsigned msec);
void do_timer(struct pt_regs *pregs);

int do_fork(unsigned long clone_flags, unsigned long stack_start,
			struct pt_regs *regs, unsigned long stack_size);



#endif
