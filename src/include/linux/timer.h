#ifndef LINUX_TIMER_H
#define LINUX_TIMER_H
#include<valType.h>
#include<list.h>
enum{
	TIMER_STOPPED,
	TIMER_RUNNING
};
struct timer{
	u32 origin;
	u32 life;
	void (*act)(void *data);
	void * data;
	int state;
	struct list_head node;
};

void my_timerlist_dida(void);
void init_mytimer(void);
struct timer *create_mytimer(u32 life, void(*act)(void* data), void *data);
void trigger_mytimer(struct timer *timer);
#endif
