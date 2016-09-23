#ifndef PAPAYA_SYSCALL_H
#define PAPAYA_SYSCALL_H
#include "../src/include/linux/NR_syscall.h"

/*
        +------------+
        |            |
        |            |
        |            |
        |            |
        |            |
        +------------+  <==  ebp reigster
        |  ebp       |
        +------------+  
        |  eip       |
        +------------+  +8
        |  arg1      |
        +------------+  +12
        |  arg2      |
        +------------+
        |  arg3      |
        +------------+
*/

/*
 * >强制传入6个参数，这有点儿丑，但很节省编程的时间
 * >至于危害，性能低一些，但不存在内存越界的可能。
 */
#define int80_carry_stack_args_6(name)												\
({																		\
	__asm__ __volatile__("push %%ebx\n\t"								\
						 "push %%edx\n\t"								\
						 "push %%esi\n\t"								\
						 "push %%edi\n\t"								\
						 "push %%ebp\n\t"								\
																		\
						 "mov 8(%%ebp),  %%ebx\n\t"						\
						 "mov 12(%%ebp), %%ecx\n\t"						\
						 "mov 16(%%ebp), %%edx\n\t"						\
						 "mov 20(%%ebp), %%esi\n\t"						\
						 "mov 24(%%ebp), %%edi\n\t"						\
						 "mov 28(%%ebp), %%ebp\n\t"						\
																		\
						 "int $0x80\n\t"								\
																		\
						 "pop %%ebp\n\t"								\
						 "pop %%edi\n\t"								\
						 "pop %%esi\n\t"								\
						 "pop %%edx\n\t"								\
						 "pop %%ebx\n\t"								\
						 :												\
						 :"a"(NR_##name)								\
						 );												\
})

#define int80_carry_stack_args_0(name)									\
({																		\
	__asm__ __volatile__(												\
						 "int $0x80\n\t"								\
						 :												\
						 :"a"(NR_##name)								\
						 );												\
})

#define int80_carry_stack_args_2(name)												\
({																		\
	__asm__ __volatile__("push %%ebx\n\t"								\
																		\
						 "mov 8(%%ebp),  %%ebx\n\t"						\
						 "mov 12(%%ebp),  %%ecx\n\t"						\
						 "int $0x80\n\t"								\
																		\
						 "pop %%ebx\n\t"								\
						 :												\
						 :"a"(NR_##name),								\
						 );												\
})

#define int80_carry_stack_args_3(name)												\
({																		\
	__asm__ __volatile__("push %%ebx\n\t"								\
						 "push %%edx\n\t"								\
																		\
						 "mov 8(%%ebp),  %%ebx\n\t"					\
						 "mov 12(%%ebp),  %%ecx\n\t"					\
						 "mov 16(%%ebp),  %%edx\n\t"					\
						 "int $0x80\n\t"								\
																		\
						 "pop %%edx\n\t"								\
						 "pop %%ebx\n\t"								\
						 :												\
						 :"a"(NR_##name)								\
						 );												\
})

static inline int execve(char *filename, char *argv[], char *envp[]){
	int80_carry_stack_args_3(execve);
}

static inline int printf(char *format, ...){
	int80_carry_stack_args_6(printf);
}


static inline int fork(void){
	int80_carry_stack_args_0(fork);
}










#endif
