#ifndef BINFMTS_H
#define BINFMTS_H
struct pt_regs;

struct linux_binprm{
	char *filepath;
	char **argv;
	char **envp;

	struct file *file;
	char buf[128];
};

struct linux_binfmt{
	int (*load_binary)(struct linux_binprm *, struct pt_regs *);
	struct linux_binfmt *next, *prev;		
};

#endif
