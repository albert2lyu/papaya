//pseudo code

#include<linux/softirq.h>

#define this_cpu_var
#define cpu_var
#define get_cpu_var
#define put_cpu_var

#define NR_SOFTIRQ 32
static softirq {
	bh_fn routine;
	void *data;
}softirqs[NR_SOFTIRQ];
/*
 * 1, one bit for one channel, thus, we can have 32 softirq.
 * 2, 用一个机器字作为status的好处是, 我们可以看看它是不是0
 * 就能判断是否有softirq等待执行. 很快.
 */
//static unsigned long active[];    改用DEFINE_PER_CPU实现.


void init_softirq(void){
    /* volatile是必要的, 因为中断代码里通常会标记active
     * 我们必须保证每次都从内存里取用它.
     */
    DEFINE_PER_CPU(volatile unsigned long, actives);
}
/*
 *
 */
void do_softirq(void){
    unsigned long active;

    if(in_interrupt())  return;
    local_bh_disable();
     
    while(1){
        int id;
        struct softirq *bh;

        local_irq_disable();
        active = this_cpu_var(actives);
        if( !active ) break;

        this_cpu_var(actives) = 0;
        local_irq_enable();
    
        while( (id = __bs(active) )!== -1){
            __btr(&active, id); 
            bh = &softirqs[id];
            bh->routine( bh->data );
        }
    }
   
   assert( cli_already() );
    /* We already verify that all softirq done, so we leave.
     * Note! we must leave in an 'cli' state. because new 
     * hardware interrupts may occure during this small 
     * window and raise new softirq. Well, our code works 
     * well in that case, but that's just not clean.
     * In one word, when we decide to leave, we leave 
     * immediately.
     */
    local_bh_enable();

}
