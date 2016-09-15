#ifndef BINFMTS_H
#define BINFMTS_H
#include<valType.h>
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

bool register_binfmt(struct linux_binfmt* binfmt);
#endif
