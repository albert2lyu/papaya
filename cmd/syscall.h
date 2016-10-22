#ifndef PAPAYA_SYSCALL_H
#define PAPAYA_SYSCALL_H
#include "../src/include/linux/NR_syscall.h"
#include "../src/include/linux/resource.h"

#define PROT_READ	0x1		/* page can be read */
#define PROT_WRITE	0x2		/* page can be written */
#define PROT_EXEC	0x4		/* page can be executed */
#define PROT_SEM	0x8		/* page may be used for atomic ops */
#define PROT_NONE	0x0		/* page can not be accessed */
#define PROT_GROWSDOWN	0x01000000	/* mprotect flag: extend change to start of growsdown vma */
#define PROT_GROWSUP	0x02000000	/* mprotect flag: extend change to end of growsup vma */

#define MAP_SHARED	0x01		/* Share changes */
#define MAP_PRIVATE	0x02		/* Changes are private */
#define MAP_TYPE	0x0f		/* Mask for type of mapping (OSF/1 is _wrong_) */
#define MAP_FIXED	0x100		/* Interpret addr exactly */
#define MAP_ANONYMOUS	0x10		/* don't use a file */

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
	int ret;															\
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
						 "mov %%eax, %0\n\t"							\
																		\
						 "pop %%esi\n\t"								\
						 "pop %%edx\n\t"								\
						 "pop %%ebx\n\t"								\
						 :"=r"(ret)										\
						 :"a"(NR_##name)								\
						 );												\
	ret;																\
})

#define int80_carry_stack_args_0(name)									\
({																		\
	int ret;															\
	__asm__ __volatile__(												\
						 "int $0x80\n\t"								\
						 "mov %%eax, %0\n\t"							\
						 :"=r"(ret)										\
						 :"a"(NR_##name)								\
						 );												\
	ret;																\
})

#define int80_carry_stack_args_1(name)									\
({																		\
	int ret;															\
	__asm__ __volatile__("push %%ebx\n\t"								\
																		\
						 "mov 8(%%ebp),  %%ebx\n\t"						\
						 "int $0x80\n\t"								\
						 "mov %%eax, %0\n\t"							\
						 												\
						 "pop %%ebx\n\t"								\
						 :"=m"(ret)										\
						 :"a"(NR_##name)								\
						 );												\
	ret;																\
})

#define int80_carry_stack_args_2(name)									\
({																		\
	int ret;															\
	__asm__ __volatile__("push %%ebx\n\t"								\
																		\
						 "mov 8(%%ebp),  %%ebx\n\t"						\
						 "mov 12(%%ebp),  %%ecx\n\t"					\
						 "int $0x80\n\t"								\
						 "mov %%eax, %0\n\t"							\
																		\
						 "pop %%ebx\n\t"								\
						 :"=m"(ret)										\
						 :"a"(NR_##name)								\
						 );												\
	ret;																\
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
	return int80_carry_stack_args_0(fork);
}

static inline void exit(int status){
	int80_carry_stack_args_1(exit);	
}

static inline int wait4(int pid, int *status, int option, struct rusage *ru){
	return int80_carry_stack_args_4(wait4);
}

static inline void * mmap2(void *addr, int length, int prot, 
						int flags, int fd, int pgoffset){
	return (void *)int80_carry_stack_args_6(mmap2);
}

static inline void * munmap(void *addr, int length){
	return (void *)int80_carry_stack_args_2(munmap);
}

static inline int open(char *filepath, int flags, int mode){
	return int80_carry_stack_args_3(open);
}

static inline unsigned long brk(unsigned long brk){
	return int80_carry_stack_args_1(brk);
}

static inline unsigned long lseek(int fd, int offset, int origin){
	return int80_carry_stack_args_3(lseek);
}

static inline int read(int fd, char *buf, unsigned long size){
	return int80_carry_stack_args_3(read);
}

static inline int write(int fd, char *buf, unsigned long size){
	return int80_carry_stack_args_3(write);
}

static inline int close(int fd){
	return int80_carry_stack_args_1(close);
}

static inline int pipe(int fd[2], int flags)
{
	return int80_carry_stack_args_2(pipe);
}

#endif
