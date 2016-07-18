#ifndef LINUX_TIMER_H
#define LINUX_TIMER_H
#include<valType.h>
#include<list.h>
struct timer{
	u32 origin;
	u32 life;
	void (*act)(void *data);
	void * data;
	struct list_head node;
};

void my_timerlist_dida(void);
void init_mytimer(void);
struct timer *create_mytimer(u32 life, void(*act)(void* data), void *data);
#endif
