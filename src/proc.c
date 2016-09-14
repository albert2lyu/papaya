#include<asm_lable.h>
#include<proc.h>
#include<schedule.h>
#include<mm.h>
#include<utils.h>
#include<schedule.h>
#define PCB_MAGIC_NUMBER 0xaabbccdd
/**process only run at ring0,ring1,ring3*/
static int selector_plain_d[4]={(int)&selector_plain_d0,(int)&selector_plain_d1,0,(int)&selector_plain_d3};
static int selector_plain_c[4]={(int)&selector_plain_c0,(int)&selector_plain_c1,0,(int)&selector_plain_c3};
int __eflags=0x1200;//IOPL=1,STI	__prefix, 避免gdb犯晕:p eflags

/* only create ring 0 process */
void init_pcb(struct pcb *baby,u32 addr,int prio,int time_slice,char*p_name){
	baby->regs.ss=(selector_plain_d[0]);
	baby->regs.esp = (u32)&(baby->regs);
	//baby->regs.esp=(ring==0)?(u32)&(baby->regs):USR_STACK_BASE;
	baby->regs.eflags=__eflags;//IOPL=1,STI
	baby->regs.cs=(selector_plain_c[0]);
	baby->regs.eip=addr;
	baby->regs.gs=baby->regs.fs=baby->regs.es=baby->regs.ds=(selector_plain_d[0]);
	//fill in other members
	baby->need_resched = 0;
	baby->sigpending = 0;
	baby->prio=prio;
	baby->pid=0;
	baby->time_slice=baby->time_slice_full=time_slice;
	baby->p_name=p_name;
	//baby->pregs=&baby->regs;
	baby->thread.esp = (int)&baby->regs;
	baby->thread.eip = (int)restore_all;
	baby->fs = kmalloc0( sizeof(struct fs_struct));
	baby->files = kmalloc0( sizeof( struct files_struct) );
	baby->files->filep = baby->files->__file_array;
	baby->files->max_fds = sizeof(baby->files->__file_array) / 4;
	baby->rlimits[RLIMIT_NOFILE].cur = 512;
	baby->rlimits[RLIMIT_NOFILE].max = 1024;
	baby->fstack.esp = -1;
	baby->magic = PCB_MAGIC_NUMBER;
	baby->mm = 0;
	//第一个内核进程启动时，不需要设置cr3。因为内核此时就用着内核页表。
	//baby->cr3=(u32*)0x100000;	/**use kernel page directory*/
	#if 0
	if(ring){
		baby->cr3=(u32*)((alloc_pages(__GFP_DEFAULT,1) - mem_map) <<12);	/**note!cr3 use real physical address*/
		memcpy((char*)(baby->cr3+256*3)+0xc0000000,(char*)0xc0100c00,224*4);
	}
	else baby->cr3=(u32*)0x100000;	/**use kernel page directory*/
	#endif
}

struct pcb * create_process(u32 addr,int prio,int time_slice,char*p_name){
//	oprintf("@create_process addr=%x\n",addr);
	struct pcb *baby = (struct pcb*)__alloc_pages(__GFP_DEFAULT,1);
	init_pcb(baby,addr,prio,time_slice,p_name);
	oprintf("new process:baby addr:%x\n",baby);
	LL_I_INCRE(list_active,baby,prio);	
/*	oprintf("created a process..\n");*/
	return baby;
}


/**the following are so-called circular arr operations. */
void obuffer_init(OBUFFER* pt_obuffer){
	for(int i=0;i<size_buffer;i++) pt_obuffer->c[i]=0;
	pt_obuffer->head=0;
	pt_obuffer->tail=size_buffer-1;
	pt_obuffer->num=0;
}

void obuffer_push(OBUFFER* pt_obuffer,char c){
	assert(pt_obuffer->num<size_buffer);
	int next=(pt_obuffer->tail+1)%size_buffer;
	pt_obuffer->c[next]=c;
	
	pt_obuffer->num++;
	pt_obuffer->tail=next;
}

unsigned char obuffer_shift(OBUFFER* pt_obuffer){
	if(pt_obuffer->num==0) return 0;
	int head=pt_obuffer->head;
	int c=pt_obuffer->c[head];

	pt_obuffer->head=(head+1)%size_buffer;
	pt_obuffer->num--;
	return c;
}


struct pcb *get_current(void){
	struct pcb *p;
	__asm__ __volatile__("andl %%esp,%0":"=r"(p):"0"(~8191));
	if((void *)p < (void *)0xc0000000 || p->magic != PCB_MAGIC_NUMBER){
		oprintf("\n at %x ", (unsigned)p);
		spin("get ill current");
	}
	return p;
}

void proc_init(void){
	/**ensure pcb structure equal 0x2000,i am conscious about member-align*/
	if(sizeof(struct pcb)!=PCB_SIZE) spin("struct pcb size wrong");
}

void pcb_info(struct pcb *p){
//	oprintf("%s","asdf");
	oprintf("p_name:%s entry:%x prio:%u time_slice:%u\n",p->p_name,p->regs.eip,p->prio,p->time_slice);
}



/**following two functions can only be called out-of-proc,then,process recently
 * trapped into kernel will be fired immediately.
 * it return a value and errno to the process who just does a 'syscall'.set 
 * return_errno -1 when the syscall done successfully.
 */
/**
void syscall_ret_to(struct pcb *pcb,int return_val,int return_errno){
	if(return_errno!=-1) errno = return_errno;
	pcb->regs.eax = return_val;
	//BUG 进程陷入内核就一定是休眠状态吗,为什么要sleep_acive呢.
	fire(pcb);
}
 */

/**
void syscall_ret(int return_val,int return_errno){
	syscall_ret_to(current, return_val, return_errno);		
}
 */


/*following function can only be called within proc,like fs_ext,the difference 
 * is that they will not call 'fire(pcb)' immediately,so we call it 'soft'.In m
 * ost case,a kernel-process will surrender it's timeslice after finishing jobs,
 * we trust it and never use 'fire(pcb)' to snatch it's timeslice.*/
/**
void syscall_soft_ret_to(struct pcb *pcb,int return_val,int return_errno){
	if(return_errno!=-1) errno = return_errno;
	pcb->regs.eax = return_val;
	sleep_active(pcb);
}
 */





#if 1
void fire_thread(struct pcb *p){
	assert(p->mm == 0);		//it should be a kernel thread
	extern bool task_available;
	task_available = true;

	__asm__ __volatile__(
		"movl %0,%%esp\n\t"
		"jmp restore_all\n\t"
		:
		:"r"(&p->regs)
	);
	#if 0
	__asm__ __volatile__(
		"movl %0,%%esp\n\t"
		"popl %%ebx\n\t"
		"popl %%ecx\n\t"
		"popl %%edx\n\t"
		"popl %%esi\n\t"
		"popl %%edi\n\t"
		"popl %%ebp\n\t"
		"popl %%eax\n\t"
		"popl %%ds\n\t"
		"popl %%es\n\t"
		"popl %%gs\n\t"
		"popl %%fs\n\t"
		"addl $4,%%esp\n\t"
		"iretl\n\t"
		:
		:"r"(&p->regs)
	);
	#endif
}

#endif





