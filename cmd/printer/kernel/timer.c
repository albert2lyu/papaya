#include<linux/timer.h>
#include<list.h>
#include<linux/slab.h>
#include<utils.h>
static struct list_head my_timerlist;

void trigger_mytimer(struct timer *timer){
	timer->act(timer->data);
	list_del(&timer->node);		//TODO free it?
	timer->state = TIMER_STOPPED;
	timer->life = timer->origin;
}

/* 操作timer队列的时候，需要关中断吗*/
void my_timerlist_dida(void){
	struct list_head *curr = my_timerlist.next;
	while(curr != &my_timerlist){
		struct timer *timer = MB2STRU(struct timer, curr, node);
		//oprintf("info timer: %x  %x", timer->life, timer->act);
		struct list_head *_next = curr->next;
		timer->life--;
		if(timer->life == 0){
			trigger_mytimer(timer);
		}
		curr = _next;		//TODO 可以更简单，不需要这样
	}
}

void init_mytimer(void){
	INIT_LIST_HEAD(&my_timerlist);
}

/* @life 	by unit of ms */
struct timer *create_mytimer(u32 life, void(*act)(void* data), void *data){
	assert(life && act);
	struct timer *timer = kmalloc2(sizeof(struct timer), 0);
	timer->act = act;
	timer->origin = timer->life / 10;	/* convert unit from ms to ticks */
	timer->life = timer->origin;
	timer->state = TIMER_STOPPED;
	timer->data = data;
	return timer;
}

void start_mytimer(struct timer *timer){
	bool IF = cli_ex();
	list_add(&timer->node, &my_timerlist);
	timer->state = TIMER_RUNNING;
	if(IF){
		sti();
	}
}

void reset_mytimer(struct timer *timer){
	bool IF = cli_ex();
	timer->life = timer->origin;
	if(IF){
		sti();
	}
}

void stop_mytimer(struct timer *timer){
	bool IF = cli_ex();
	list_del(&timer->node);
	timer->state = TIMER_STOPPED;
	if(IF){
		sti();
	}
}






