#ifndef LINUX_SCHED_H
#define LINUX_SCHED_H

int kernel_thread(int (*fn)(void *), void *arg, unsigned flags);
	

#endif
