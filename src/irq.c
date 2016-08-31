#include<linux/errno.h>
#include<irq.h>
#include<proc.h>
#include<linux/bh.h>
/**生成一个irqacion，并挂到中断服务队列里
* @irq note! should sub by 0x20.
* note, the status is marked IRQ_DISABLED, so you should clear this bit manually
* after you do 'request_irq',(see time.c init_time()) otherwise...
*/
int request_irq(int irq, void (*handler)(int, void*, struct stack_frame *), unsigned flags, void *dev){
	if(irq < 0 || irq >=NR_IRQS || !handler) return -EINVAL;

	struct irqaction *action = kmalloc(sizeof(struct irqaction));
	action->func = handler;
	action->flags = flags;
	action->dev = dev;
	action->next = 0;
	
	int retval = setup_irq(irq, action);	//挂入
	if(retval) kfree(action);
	return retval;
}

int setup_irq(int irq, struct irqaction *new){
	/**
	struct irqaction **p_curr = &irq_desc[irq].action;
	while((*p_curr)->next) p_curr = &(*p_curr)->next;
	(*p_curr)->next = new;
	 */
	struct irqaction *curr = irq_desc[irq].action;
	if(!curr) irq_desc[irq].action = new;
	else{
		while(curr->next) curr = curr->next;
		curr->next = new;
	}
	return 0;
}

/**
 * 1,暂时不实现REPLAY操作
 */
unsigned do_IRQ(stack_frame regs){
	int err_code = regs.err_code + 256;
	int irq = err_code - 0x20;
	//if(irq != 0) oprintf(" !%u ", irq);
	irq_desc_t *desc = irq_desc + irq;
	unsigned status = desc->status;

	u16 isr = pic_get_isr();
	u16 imr = read_imr_of8259();
	switch(irq){
		case 15:
			assert(!(isr >> 15));
			assert(imr >> 15);
			out_byte(0x20, 0x20);
		case 7:
			assert(!(isr & 0x80));
			assert(imr & 0x80);
			//oprintf("\n imr:%x, isr:%x\n", imr, isr);
			return 0;
		default:
			//oprintf("8159A ack:%u\n", irq);
			desc->hw_handler->ack(irq);	
	}
	if(irq == 1){
		//oprintf("\n a key pressed \n");
		int key_code=in_byte(0x60);
		oprintf(" *%x* ", key_code);	
		extern int __less_go;
		if(key_code <= 0x34) __less_go = true;		//igonre break code
		return 0;
	}
	//若action队列是空的，或者INPROCESS，或者DISABLED，则置IRQ_PENDING位，这次
	//中断也就早早结束了。就是这条语句避免了中断套嵌。
	if(!desc->action || status & (IRQ_INPROCESS | IRQ_DISABLED)){
		desc->status |= IRQ_PENDING;
/*		oprintf("pending and out\n");*/
/*		oprintf("p ");*/
		goto out;
	} 
	/*FIXME 执行到这儿，desc可能是pending状态，是否在这儿清除之*/	
	/*while将可能的中断套嵌化解成循环，中断信号的处理都是串行化的。*/
	desc->status |= IRQ_INPROCESS;
	while(1){
/*		oprintf("handle a irq%x signal\n", irq);*/
/*		spin("handing");*/
		handle_IRQ_event(irq);	/**这个过程中服务程序可能sti，造成新的中断送上来
								  但同一channel的信号被串行化，不同channel的中断
								  允许套嵌处理*/
		if(!(desc->status & IRQ_PENDING)) break;
		desc->status &= ~IRQ_PENDING;
	}
out:
/*	spin("do IRQ out");*/
/*	oprintf("do_IRQ out\n");*/
	desc->status &= ~IRQ_INPROCESS;
	desc->hw_handler->end(irq);

	//we don't cli() here, because code above runs in cli mode . TAKE CARE
	if(bh_flags & BH_FLAG_DISABLE){
		static int bh_collision_count = 0;
		bh_collision_count++;
		char title[] = {'B', 'H', 0xAE, 0};
		char buf[16];
		sprintf(buf, " %u", bh_collision_count);
		write_bar(1, 0, title, buf);
		//oprintf(" #*& ");
	}
	else do_bh();

	return 0;
}

/**
 * 1,返回值暂时是无意义的。
 */
int handle_IRQ_event(int irq){
	int status = 0;
	struct irqaction *action = irq_desc[irq].action;
/*	oprintf("irq:%x,%x\n", irq, irq_desc[irq].action);	*/
	while(action){
		/**如果这不是一个“快速中断服务例程”，开中断*/
		if(!(action->flags & SA_INTERRUPT)){
			spin("sti now");
			 __asm__ __volatile__ ("sti");
		}
		action->func(irq, action->dev, 0);		
		__asm__ __volatile__ ("cli");

		action = action->next;
	}
/*	oprintf("out\n");*/
	return status;
}






