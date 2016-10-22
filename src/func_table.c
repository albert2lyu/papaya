#include<linux/NR_syscall.h>

extern void (*sys_execve)(void);
extern void (*sys_fork)(void);
extern void (*sys_printf)(void);
extern void (*sys_exit)(void);
extern void (*sys_wait4)(void);
extern void (*sys_open)(void);
extern void (*sys_read)(void);
extern void (*sys_write)(void);
extern void (*sys_lseek)(void);
extern void (*sys_close)(void);
extern void (*sys_pipe)(void);

#define ENTRY(name) [NR_ ## name] = (unsigned long)&sys_ ## name


unsigned long func_table[255] =
{
	ENTRY(fork),
	ENTRY(execve),
	ENTRY(printf),
	ENTRY(exit),
	ENTRY(wait4),

	ENTRY(open),
	ENTRY(read),
	ENTRY(write),
	ENTRY(lseek),
	ENTRY(close),

	ENTRY(pipe),
};


