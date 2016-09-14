#include<old/proc.h>
#include<linux/sched.h>

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
						:"a"(1), "r"(fn), "r"(arg)
						);
	return 0;	
}


int sys_execve(struct pt_regs regs){
	int error;
	char *filename = (char *)regs.ebx;
	error = do_execve(filename, (char **)regs.ecx, (char **)regs.edx, &regs);
	return error;
}






