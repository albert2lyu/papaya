#include<time.h>
#include<irq.h>
static void timer_interrupt(int irq){
	//oprintf("timer_interrupt:%u\n",irq);	
	do_timer();
}

void init_time(void){
	/** request irq0, namely IGATE 0x20 */
	request_irq(0, &timer_interrupt, SA_INTERRUPT, 0);	
	//enable_8259A_irq(0);
	irq_desc[0].status &= ~IRQ_DISABLED;
}



