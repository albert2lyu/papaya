#ifndef SCHEDULE_H
#define SCHEDULE_H
#include<valType.h>
#include<list.h>
extern unsigned ticks;
/**if a process is prepared for running,we say it's 'active'.all active process
 * are stored in this linked-list in ascendsing order of 'prio'.
 */
struct pcb *list_active;

/**if a process uses out the time_slice,we say it's 'expire'.
 * an expire process will never be scheduled until it's time_slice renewed.
 */
struct pcb *list_expire;

void sleep_active(struct pcb *p);
void schedule(void);
void wake_up(struct list_head *root);
void sleep_on(struct list_head *root);

#define __SAVE()\
	__asm__ __volatile__(\
	"pushl $0\n\t"\
	"pushl %%fs\n\t"\
	"pushl %%gs\n\t"\
	"pushl %%es\n\t"\
	"pushl %%ds\n\t"\
	"pushl %%eax\n\t"\
	"pushl %%ebp\n\t"\
	"pushl %%edi\n\t"\
	"pushl %%esi\n\t"\
	"pushl %%edx\n\t"\
	"pushl %%ecx\n\t"\
	"pushl %%ebx\n\t"\
	"movl %%esp, %0\n\t"\
	:"=m"(current->pregs)\
	:\
	)

void kp_sleep(u32 msg_type,u32 msg_bind);
#endif
