#include<proc.h>
#include<disp.h>
#include<utils.h>
#include<mm.h>
#include<ku_utils.h>
#include<linux/fs.h>
#include<linux/cell.h>
#include<linux/mount.h>
#include<schedule.h>
#include<asm_lable.h>
#include<linux/blkdev.h>
#include<linux/ide.h>
#include<linux/slab.h>
#include<linux/pci.h>
#include<linux/skbuff.h>
#include<linux/timer.h>
#include<linux/binfmts.h>
char *testbuf;
char *bigbuf;
int avoid_gcc_complain;
extern int p1,p2,sec_data;
extern void tty(void);
extern void tty1(void);
extern void p3(void);
extern void p4(void);
extern void hs(void);
extern void t(void);
extern void fs_ext(void);
extern void mm(void);
char cpu_string[16];
void idle_func(void);
void func1(void);
int func2(void *arg);
void func0(void);
void func_init(void);
void usr_func(void);
struct pcb *idle;
static void probe(void);

void kernel_c(){
	init_display();
	write_bar(2, 2, "BH ", "see");

	int count = 0;
	while(0){
		count++;
		mdelay(20);
		oprintf("hello world, %x  ", count);
	}
	//while(1);
	//k_screen_reset();
	probe();

	mm_init();
	kmem_cache_init();
	mm_init2();			/*this partion has to be done after kmem_cache_init() */
		
	net_init();
	pci_init();
	//kmem_cache_test();
	proc_init();
	init_ISA_irqs();
	init_time();
	ide_init();
	blkdev_layer_init();
/*	init_fs();*/
	/*
	 * 1, 用内核函数生成一个ring1进程没问题，ring1进程的好处是，有大多数系统权限
	 * 在访问内核空间时（例如它的eip就跑在内核空间的代码区),但它又是作为普通
	 * 进程来调度的，即，进程被中断时，它也是push了esp和ss,iret时，也是切换了
	 * 堆栈的。 而且我们把非ring0的”用户空间堆栈“都设置在USR_STACK_BASE,也就是，
	 * 3G - 64byte的地方。 所以fire()一个ring1进程的时候，会立刻陷入页错误，因
	 * 为3G-64byte的virtual address不在该进程的页表里。mm例程能轻松解决这个错误
	 * 2, 但是ring1进程不能调用一些敏感的内核函数，像比schedule_timeout(), 
	 * 像比ll_rw_block,因为 
	 * 这些函数依赖于current指针，esp必须停在pcb内。
	 * 3, ring0进程运行的时候，永远不会被抢占。除非它主动调用schedule。用need_
	 * sched软schedule都不行。
	 * 4, ring0进程的坏处是，虽然它不会被抢占，但它有时间片，扣为0之后，虽然它
	 * 还能继续运行，但在扣为0的那一刻就被do_timer给active_expire了。此后，它
	 * 如果想调用active_sleep就不行了。因为它已经处于一个出错的状态。（即，明明
	 * 在expire队列里，却还运行着)
	 * 5, 所以我们来避免产生这种”错误局面“，我们把它的time_slice生成 0xffffffff,
	 * 同时也能提醒内核程序员：你要手动让他sleep，不然别的进程会饿死。
	 */
	bigbuf = (void *)__alloc_pages(__GFP_DEFAULT, 8+1);//4k * 256 * 2 = 2M
	//struct pcb *f1 = create_process((u32)func1,9,10,"func1",0);	
	struct pcb *f0 = create_process((u32)func0,9,0xffffffff,"func0");
	//struct pcb *f2 = create_process((u32)func2,9,5,"func2",1);
	struct pcb *f_init = create_process((u32)func_init,4,0xffffffff,"func_init");
	//struct pcb *u_f = create_process(0x8048000,9,100,"init",3);
	//avoid_gcc_complain = (int)f1;
	avoid_gcc_complain = (int)f0;
	//avoid_gcc_complain = (int)f2;
	avoid_gcc_complain = (int)f_init;
	//avoid_gcc_complain = (int)u_f;
	//tty 调用的getchar时会sleep,等醒来,再被调度时,已经到了ring1堆栈.
	//暂时把tty放在ring1,但它是按照一个用户进程编写的.它不会调用内核其它模块的函数.暂时不能放在ring3,是因为跳到ring3后,是因为tty的代码是在ring0.
/*	create_process((u32)tty,9,5,"tty",1);*/
	//time_slice = 0x0fffffff,never be expired to avoid bug.
	//note: give hs a higher prio to let it run firstly, that's necessary
/*	__ext_pcb = create_process((u32)fs_ext, 9, 0x0fffffff,"ext", 0);*/
/*	__hs_pcb = create_process((u32)hs, 9, 0x0fffffff,"hs", 0);*/

	idle=(struct pcb*)__alloc_pages(__GFP_DEFAULT,1);
	init_pcb(idle,idle_func,10,0xffffffff,"idle",0);
	
	/**
	 * 1, 不要用create_process创建idle进程，因为这个函数会把它挂入list_active里。	 * 2, 不要让idle进程休眠，因为sleep_active对它的操作会出错。
	 */
	//idle = create_process((u32)idle_func, 10,0xfffffff, "idle",0);
	/**
	 * 1, it's necessary to fire a process manually before the first clock
	 * interruption occures, because clock-handler will call 'do_time()' and
	 * 'schedule()' which can not work well without process-switch context.
	 * (for example,'current'(see in proc.h) will be invalid when esp register
	 * not in the kernel stack of a process.
	 */
	ramdisk_init(); 
/*	cell_read("t.c", testbuf);*/
/*	oprintf("%s", testbuf);*/
/*	spin("ss");*/
	fire_thread(f_init);
	assert(0);
}


#if 0
void func1(void){
	oprintf("func1 run..\n");
	int counter = 0;
	while(1){
		oprintf("func1:%u\n", counter++);
		schedule_timeout(3000);
	}
}
#endif
void timer_handler(void *data){
	oprintf("timer handler ");
}

void func0(void){
	extern struct linux_binfmt elf_format;
	register_binfmt(&elf_format);
	#if 0
	__asm__ __volatile__(".intel_syntax prefix\n\t"
						"int 0x80\n\t"
						".att_syntax prefix\n\t"
						:"=a"(x)
						:"a"(1)
						);
	#endif
	kernel_thread(func2, (void *)123, 0);	

	while(1){
		//mdelay(30 );
		oprintf("%s ", "func0 ");
		//oprintf("%u ", x);
		schedule_timeout(1000);
	}

}

int func2(void *arg){
	oprintf("func2 run..\n");
	while(1){
		oprintf(">>>>");
		schedule_timeout(1000);
	}
}
void func_init(void){
	#if 0
	while(1){
		oprintf("func_init sleep");
		kp_sleep(0, 0);
		oprintf("func_init waked up");
	}
	#endif

	oprintf("func init run..\n");
	ide_read_partation(0x3, 0);
	init_vfs();
	register_filesystem("cell", cell_read_super);	
	struct vfsmount *mnt_stru = do_mount(0x301, "/", "cell");	
	if(!mnt_stru) spin("root device mount failed");
	struct fs_struct *fs_stru = current->fs;
	fs_stru->root = fs_stru->pwd = mnt_stru->small_root;
	fs_stru->rootmnt = fs_stru->pwdmnt = mnt_stru;
	//current->fs = fs_stru;

	struct in_dir indir;
	//int err = pathwalk("/home/mnt/", &indir, 0);	avoid_gcc_complain = err;
	mnt_stru = do_mount(0x305, "/home/mnt/", "cell");	
	//int err = pathwalk("/home/mnt/5", &indir, 0);
	testbuf = kmalloc(512 * 200);
	int fd = sys_open("/home/mnt/5/_dimg.c", 2, 0);
	//TODO rbytes的返回值是对的，但实际读入的却不止 指定的size这么多
	int rbytes = sys_read(fd, testbuf, 100);
	avoid_gcc_complain = rbytes = (unsigned)&indir;

	int x = 0;
	__asm__ __volatile__(
						"int $0x80\n\t"
						:"=a"(x)
						:"a"(2), "b"("/home/doado"), "c"(0), "d"(0)
						);
	oprintf("execve failed, error code %u ", x);
	while(1);

	//assert("func init keep running" && 0);
	//while(1);
	while(1) schedule_timeout(1000);
	
}
void usr_func_backup(void){
	while(1);
}

void idle_func(void){
	while(1){
/*		oprintf("idle..");*/
		__asm__("hlt");
		/*这个条件判断很必要，它看一眼有没有别的进程，一个没有，它执行下一个
		 * idle
		 */
		if(list_active || list_expire) schedule();
	}
}

struct cpuid_family{
	u32 stepping_id:4;
	u32 model:4;
	u32 family:4;
	u32 type:2;
	u32 :2;
	u32 model_extend:4;
	u32 family_extend:8;
	u32 :4;
};
static void probe(void){
	struct cpuid_family cpuid_family;
	int cpuid_input_max=0;
	int xapic_support=0;
	int x2apic_support=0;
	int multi_thread_support=0;
	int addressable_core_num=0;
	int addressable_logic_num=0;
	__asm__ __volatile__(
			"mov $0,%%eax\n\t"
			"cpuid\n\t"
			"movl %%eax,%3\n\t"

			"movl $1,%%eax\n\t"
			"cpuid\n\t"
			"movl %%eax,%6\n\t"
			"bt $9,%%edx\n\t"
			"setc %0\n\t"
			"bt $21,%%ecx\n\t"
			"setc %1\n\t"
			"bt $28,%%edx\n\t"
			"setc %2\n\t"

			"shl $8,%%ebx\n\t"
			"shr $24,%%ebx\n\t"
			"mov %%ebx,%4\n\t"

			"movl $4,%%eax\n\t"
			"movl $0,%%ecx\n\t"
			"cpuid\n\t"
			"shr $26,%%eax\n\t"
			"inc %%eax\n\t"
			"movl %%eax,%5\n\t"
			"end:nop"
			:"=m"(xapic_support),"=m"(x2apic_support),"=m"(multi_thread_support),"=m"(cpuid_input_max),"=m"(addressable_logic_num),\
			"=m"(addressable_core_num), "=m"(cpuid_family)
			:
			:"memory"
			);
	oprintf("cpu family:%x model:%x\n",cpuid_family.family+(cpuid_family.family_extend<<4), cpuid_family.model+(cpuid_family.model_extend<<4));
	#if 1
	if(!xapic_support ) spin("xapic not support");
	oprintf("apic/xapic_support support:%s\n",xapic_support ? "yes" : "no");
	oprintf("x2apic_support support:%s\n",x2apic_support ? "yes" : "no");
	oprintf("multi-threading support:%s\n",multi_thread_support ? "yes" : "no");
	oprintf("cpuid input max:%u\n",cpuid_input_max);
	oprintf("addressable cores:%u\n",addressable_core_num);
	oprintf("addressable logics:%u\n",addressable_logic_num);
	#endif
	/* 删掉了一个（宏调用）,build_equal_map和一段汇编码。
	   这个函数是映射0xfee00000这个页，用(0x200000-0x2000)处的page做页表。
	   这个函数好丑
	  *后面的一段汇编吗操作了0xfee00300，这段地址应该是：illustrates the 
	   interrupt command register mapped to two, contiguous 16-byte-aligned
	   memory regions with addresses “FEE0—0300” and “FEE0—0310.”
	  */

}

#if 0
static int scan_dirty_machine_words(unsigned start, unsigned end){
	int count = 0;
	for(int i = start; i < end; i += 4){
		unsigned x  = *(unsigned *)(i+PAGE_OFFSET);
		if( x ){
			oprintf("%u ", x);
			count++;
		}
	}
	return count;
}
#endif
