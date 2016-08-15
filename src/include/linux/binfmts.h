#ifndef BINFMTS_H
#define BINFMTS_H

struct linux_binprm{
	char *filepath;
	char **argv;
	char **envp;

	int fd;
};
#endif
