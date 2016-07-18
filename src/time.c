#include<linux/timer.h>
#include<time.h>
#include<irq.h>
static int time_bh;
static void timer_interrupt(int irq){
	//oprintf("timer_interrupt:%u\n",irq);	
	do_timer();
	mark_bh(time_bh);
}

void time_bottomhalf(void *data){
	my_timerlist_dida();			//嘀嗒	
}
void init_time(void){
	/** request irq0, namely IGATE 0x20 */
	request_irq(0, &timer_interrupt, SA_INTERRUPT, 0);	
	//enable_8259A_irq(0);
	irq_desc[0].status &= ~IRQ_DISABLED;
	time_bh = alloc_bh(time_bottomhalf, 0);
	init_mytimer();
}



