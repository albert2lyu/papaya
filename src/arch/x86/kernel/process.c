#include<old/proc.h>
#include<linux/sched.h>
#include<asm/errno.h>
#include<linux/NR_syscall.h>

int kernel_thread(int (*fn)(void *), void *arg, unsigned flags){
	__asm__ __volatile__(".intel_syntax noprefix\n\t"
						"mov ebx, esp\n\t"
						"int 0x80\n\t"
						"cmp esp, ebx\n\t"
						"je out\n\t"
						"push %2\n\t"
						"call %1\n\t"
						"out:"
						".att_syntax prefix\n\t"
						:
						:"a"(NR_fork), "r"(fn), "r"(arg)
						);
	return 0;	
}


int sys_execve(struct pt_regs regs){
	int error;
	char *filename = (char *)regs.ebx;
	char **argv = (void *)regs.ecx;	
													if(!argv)	return -EINVAL;
	error = do_execve(filename, argv, (char **)regs.edx, &regs);
	return error;
}

int sys_printf(struct pt_regs regs){
	__asm__ __volatile__ ("push %0\n\t"
						  "push %1\n\t"
						  "call oprintf\n\t"
						  "add 8, %%esp\n\t"
						  :
						  :"c"(regs.ecx), "b"(regs.ebx)
						  );	
	return 0;
}




