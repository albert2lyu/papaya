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
