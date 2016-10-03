#ifndef PAPAYA_SYSCALL_H
#define PAPAYA_SYSCALL_H
#include "../src/include/linux/NR_syscall.h"
#include "../src/include/linux/resource.h"

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
#define int80_carry_stack_args_6(name)									\
({																		\
	int ret;															\
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
						 "mov %%eax, %0\n\t"								\
																		\
						 "pop %%ebp\n\t"								\
						 "pop %%edi\n\t"								\
						 "pop %%esi\n\t"								\
						 "pop %%edx\n\t"								\
						 "pop %%ebx\n\t"								\
						 :"=r"(ret)										\
						 :"a"(NR_##name)								\
						 );												\
		ret;															\
})

#define int80_carry_stack_args_4(name)									\
({																		\
	__asm__ __volatile__("push %%ebx\n\t"								\
						 "push %%edx\n\t"								\
						 "push %%esi\n\t"								\
																		\
						 "mov 8(%%ebp),  %%ebx\n\t"						\
						 "mov 12(%%ebp), %%ecx\n\t"						\
						 "mov 16(%%ebp), %%edx\n\t"						\
						 "mov 20(%%ebp), %%esi\n\t"						\
																		\
						 "int $0x80\n\t"								\
																		\
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

#define int80_carry_stack_args_1(name)									\
({																		\
	__asm__ __volatile__("push %%ebx\n\t"								\
																		\
						 "mov 8(%%ebp),  %%ebx\n\t"						\
						 "int $0x80\n\t"								\
						 												\
						 "pop %%ebx\n\t"								\
						 :												\
						 :"a"(NR_##name)								\
						 );												\
})

#define int80_carry_stack_args_2(name)									\
({																		\
	__asm__ __volatile__("push %%ebx\n\t"								\
																		\
						 "mov 8(%%ebp),  %%ebx\n\t"						\
						 "mov 12(%%ebp),  %%ecx\n\t"					\
						 "int $0x80\n\t"								\
																		\
						 "pop %%ebx\n\t"								\
						 :												\
						 :"a"(NR_##name),								\
						 );												\
})

#define int80_carry_stack_args_3(name)									\
({																		\
	int ret;															\
	__asm__ __volatile__("push %%ebx\n\t"								\
						 "push %%edx\n\t"								\
																		\
						 "mov 8(%%ebp),  %%ebx\n\t"					\
						 "mov 12(%%ebp),  %%ecx\n\t"					\
						 "mov 16(%%ebp),  %%edx\n\t"					\
						 "int $0x80\n\t"								\
						 "mov %%eax, %0\n\t"							\
																		\
						 "pop %%edx\n\t"								\
						 "pop %%ebx\n\t"								\
						 :"=m"(ret)										\
						 :"a"(NR_##name)								\
						 );												\
				ret;													\
})

static inline int execve(char *filename, char *argv[], char *envp[]){
	return int80_carry_stack_args_3(execve);
}

static inline int printf(char *format, ...){
	return int80_carry_stack_args_6(printf);
}


static inline int fork(void){
	int80_carry_stack_args_0(fork);
	return 0x8899;
}

static inline void exit(int status){
	int80_carry_stack_args_1(exit);	
}

static inline int wait4(int pid, int *status, int option, struct rusage *ru){
	int80_carry_stack_args_4(wait4);
	return 0x8899;
}

static inline void * mmap2(void *addr, int length, int prot, 
						int flags, int fd, int pgoffset){
	return (void *)int80_carry_stack_args_6(mmap2);
}

static inline int open(char *filepath, int flags, int mode){
	return int80_carry_stack_args_3(open);
}




#endif
