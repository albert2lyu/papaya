#ifndef LINUX_RESOURCE_H
#define LINUX_RESOURCE_H

struct rusage{
	int krnl_time;
	int user_time;
};
#endif
