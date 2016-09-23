#include<schedule.h>
#include<proc.h>
#include<utils.h>
#include<linux/sched.h>
#include<linux/printf.h>
/**account clock interrupt. this variable is the base of system soft-clock*/
unsigned ticks;


/**if a process halts and wand waits for a certain message,we move it to this list*/
static struct pcb *list_sleep;
struct pcb **pcb_lists[3] = {&list_active, &list_expire, &list_sleep};
void active_sleep(struct pcb *p,u32 msg_type,u32 msg_bind){
	int IF = cli_ex();

	p->msg_type=msg_type;
	p->msg_bind=msg_bind;
	LL_DEL(list_active,p);
	LL_I_INCRE(list_sleep,p,prio);

	if(IF) sti();
}

void active_expire(struct pcb *p){
	int IF = cli_ex();

	LL_DEL(list_active,p);
	LL_I_INCRE(list_expire,p,prio);

	if(IF) sti();
}

void sleep_active(struct pcb *p){
	int IF = cli_ex();

	LL_DEL(list_sleep,p);
	LL_I_INCRE(list_active,p,prio);
/*	oprintf("active p:%s, now list_active=%s\n", p->p_name, list_active->p_name);*/
	p->msg_type = 0;

	if(IF) sti();
}

void sleep_expire(struct pcb *p){
	int IF = cli_ex();

	LL_DEL(list_sleep,p);
	LL_I_INCRE(list_expire,p,prio);
	p->msg_type = 0;

	if(IF) sti();
}
void do_timer(struct pt_regs *pregs){
	char barbuf[16];

	ticks++;
	if(ticks % 100 == 0){
		char title[16] = { 148,' ', 0};
		sprintf(barbuf, "%u", ticks/100);
		write_bar(0, 0, title, barbuf);
	}
	if(ticks % 300 == 0) oprintf("^");

	//memset(barbuf, 0, sizeof(barbuf));
	sprintf(barbuf, "%*x", 12, current->time_slice);
	write_bar(0, 1, "#", barbuf);

	if(pregs->cs & 3) {	//发生在内核态的石英晶片中断不递减时间片
		assert(current->time_slice > 0);
		if(--current->time_slice == 0){
			oprintf("switch");
			active_expire(current);
			current->need_resched = 1;
		}
	}

	/**handle process who is sleeping on MSGTYPE_TIMER*/
	struct pcb *curr=list_sleep;
	while(curr){
		/**we pre-store curr->next now,for it may be changed later for LL_operation*/
		struct pcb *next = curr->next;
		if(curr->msg_type==MSGTYPE_TIMER){
			curr->msg_bind--;
/*			oprintf("check list_sleep,msg_bind:%u\n",curr->msg_bind);*/
			if(curr->msg_bind==0){
				 /**a process sleeping on MSGTYPE_TIMER won't always be moved to
				  * list_active on waked, cause it's time slice  may be used out
				  */
				//oprintf("WAKE process %s now,it's time_slice = %u\n",curr->p_name,curr->time_slice);
				if(curr->time_slice){
					sleep_active(curr);
					//spin("see list_active");
					current->need_resched = 1;
				} 
				else sleep_expire(curr);
			}
		}
		curr = next;
	}
//	oprintf("schedule now..\n");
}

/**schedule 流程之后的代码都不能用Ｃ了，要用汇编。因为schedule之后的堆栈已经
 * 切换到pregs指示的stack_frame，尽量不要再操作堆栈了.
 * 2, 考虑eflags在切换前后是否需要保持保存，恢复。以及能否保存，恢复。
 */
void schedule(void){
	int IF;
	IF = cli_ex();

/*	oprintf("begin schedule\n");*/
	current->need_resched = 0;
	struct pcb *next = 0;
/*	__asm__("cli");*/
	/**list_active is built in ascending order of 'prio',so the root node own
	 * best previlige.
	 */

	/**none process in active list,so try to exchange 'list_active' and 
	 * 'list_expire' pointer,and renew all process's time_slice in expire list.
	 */
	if(!list_active && list_expire){
		struct pcb*p=list_expire;
		while(p){
			p->time_slice = p->time_slice_full;
			p=p->next;
		}
		EXCHG_PTR(list_active,list_expire);
	}

	if (list_active) next = list_active;
	/**none process available now, run idle*/
	else next = idle;
/*	oprintf("schedule get next:%s\n", next->p_name);*/
	if(next == current){
		//oprintf("next==current:%s\n", current->p_name);
		/**这儿不该spin，因为唤醒timer进程时，也会印发调度，而唤醒的
		 * timer进程可能是劣优先级的
		 */
/*		spin("next == current");*/
		return;
	}

	/**
	 * 1, 如果调度出来的是内核进程，不用更新cr3,也不用更新esp0
	 * 2, 现在已经是在向next进程切换了。
	 */
	if(next->mm){
		//不能这样断言，因为papaya从内核线程execve出来的那个用户进程
		//在execve的过程中，它会sleep(因为要加载可执行文件),那，它醒过来肯定
		//是被schedule挑中的。而此时它的8K栈底的regs还没有初始化。
		//它execve结束，返回到用户空间，也是通过float regs resume的。
		//一直到它第一次从用户空间陷入内核，底部的regs才会得到初始化。
		//assert(next->regs.cs == (u32)&selector_plain_c3);

		/*如果没有这一句，进程仍然能正常返回到用户空间并运行，只是下次中断
		 * 陷入内核时，它就找不到自己的内核栈了*/
		g_tss->esp0 = (unsigned)next + THREAD_SIZE;	

		//这一句好。
		__asm__ __volatile__("movl %0, %%cr3\n\t"
							:
							:"r"(next->mm->cr3.value));
	} 
	/**
	 * 1, 内联汇编不能想当然，像下面的，不要一边保护寄存器，一边在输入部随便用
	 * "r"约束，应该指定寄存器,"a","b","c"这样。
	 * 2, linux没有保存ebx，按理说，ebx属于callee-saved，应该保存。----应该是
	 * ebx从这一步就开始存储current指针了。
	 * 3, 为什么要保护ebp指针呢。
	 * 4, 参考2.6.26 保存eflags。 2.4里是没有保存的。
	 */
	__asm__ __volatile__(
						"pushfl\n\t"
						"pushl %%esi\n\t"
						"pushl %%edi\n\t"
						"pushl %%ebp\n\t"
						"movl %%esp, %0\n\t"
						"movl $1f, %1\n\t"	/*1, current进程已经被封存起来
											 *2, 用movl %%eip, %1更直观，but..
											 *3, we can't touch stack before
											 * label 1f */

						"movl %2, %%esp\n\t"
						"jmp *%3\n\t"
						/**已经完全切换到next进程了,其实%3通常就是下面的lable
						 * 1f,这个跳是照顾新进程，不一定是跳到哪里去。
						 */
						"1:\n\t"
						"popl %%ebp\n\t"
						"popl %%edi\n\t"
						"popl %%esi\n\t"
						"popfl\n\t"
						:"=m"(current->thread.esp),"=m"(current->thread.eip)
						:"m"(next->thread.esp), "m"(next->thread.eip),"b"(current)
						);
	if(IF) sti();	//TODO 上面的pushf/popf还必要吗 
					//感觉没必要，schedule是一段关键的代码，从开头就关中断了
					//像这样的sti（)还是减少吧
	return;
}


int schedule_timeout(unsigned msec){
	int slice = (msec-1)/10 + 1;
	active_sleep(current, MSGTYPE_TIMER, slice);
	schedule();
	return slice;
}

/**1, put a ring0 process into sleep mod.
 * 2, can also be called by the context of a ring3 process trapped into kernel
 */
void kp_sleep(u32 msg_type,u32 msg_bind){
	active_sleep(current,msg_type,msg_bind);
	schedule();

	/**
	__asm__ __volatile__(
			"int $0x80\n\t"
			:
			:"a"(1),"d"(msg_type),"c"(msg_bind)
	);
	 */
}

void wake_up(struct pcb *p){
	sleep_active(p);
}
void kthread_sleep(u32 msg_type, u32 msg_bind){
	active_sleep(current, msg_type, msg_bind);	
	__asm__ __volatile__ ("int $0x81");
	return;
}




	/**if a process uses out the time slice, move it to list_expire
	 * atten:current process may be already in list_sleep
	 * 2, BUG 这儿是通过msg_tpe判断是否再休眠，其实0是MSGTYPE_DEEP
	 */

/**
	if(current->msg_type == 0 && current->time_slice == 0){
		oprintf("i want to expire process:%s",current->p_name);
		active_expire(current);
 */












