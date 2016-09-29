#ifndef PROC_H
#define PROC_H
#include "valType.h"
#include<utils.h>
#include<ku_proc.h>
#include<mm.h>
#include<asm/resource.h>
#include<linux/mm.h>

#define P_NAME_MAX 16

extern struct tss base_tss;
#define g_tss (&base_tss)

extern struct pcb *task0, *task1;

/**some important process's pcb is fixed under papaya*/
struct pcb *__hs_pcb;
struct pcb *__ext_pcb;

/**keyboard buffer,the keyboard driver will send key-code to this structure if 
 * this process is listening on MSGTYPE_CHAR
 */
#define size_buffer 16
typedef struct{
	char c[size_buffer];
	int head;
	int tail;
	int num;
}OBUFFER;

/**1 these descriptor selectors are defined in kernel.asm
 * 2 why we need them?		every time we init a new pcb for a burning process,we will set it's ds,cs,fs,gs,ss as plain-memory mod
 * XXX this seems to be a ugly action,we can init these fields in a breath just when pcb_table is created,because they will be never touched any more.ok).
 * */
extern int selector_plain_c0,selector_plain_d0,selector_plain_c1,selector_plain_d1,selector_plain_c3,selector_plain_d3;

struct dentry;	struct vfsmount;	struct file;
struct fs_struct{
	int count;
	struct dentry *root, *pwd;
	struct vfsmount *rootmnt, *pwdmnt;
};

#define NR_OPEN_DEFAULT 32
/* open file table structure
 * 1, @file_array points to __file_array at first, and switch to the new allocated
 * file array(bigger size) when a process open two many files.
*/
struct files_struct{
	 /* 
	 fd_set *close_on_exec;		Feature CLOSE_ON_EXEC unimplemented 
	 fd_set *open_fds;			We don't use it to speed up get_unused_fd()
	 */
	int max_fds;			/* max index of array filep[] */
	struct file **filep;	/* current file array */
	struct file *origin_filep[NR_OPEN_DEFAULT];
	int count;
};

struct thread{
	unsigned esp;
	unsigned eip;
};

/**the stack frame when cpu traps into kernel for exception or interrupt*/
typedef struct pt_regs{
	u32 ebx,ecx,edx,esi;		/**we use four registers to pass syscall args*/
	u32 edi,ebp,eax;
	u32 ds,es,gs,fs;
	u32 err_code;
	u32 eip,cs,eflags,esp,ss;	/**auto pushed by hardware*/
}stack_frame;

#define EFLAGS_STACK_LEN 7
struct eflags_stack{
				int base[EFLAGS_STACK_LEN + 1];	
				int esp;	
};
#define PCB_SIZE 0x2000
#define THREAD_SIZE 0x2000
/**process control block. all information and property of a process.
 **/
struct pcb{
	union{
		struct{
			int need_resched;
			int sigpending;
			int state;
			int exit_status;
			struct pcb *prev;
			struct pcb *next;
			u32 pid;
			char p_name[16];
			u32 prio;
			u32 time_slice,time_slice_full;
			u32 msg_type,msg_bind;
			struct mm *mm;
			struct thread thread;
			struct fs_struct *fs;
			struct files_struct *files;
			struct rlimit rlimits[RLIMIT_MAX];
			struct eflags_stack fstack;
			u32 magic;		/*for debug*/
			struct list_head children;
			struct list_head sibling;
			struct pcb *mother;					//who fork me?
			struct pcb *monitor;				//who adopt me?
			u32 __task_struct_end;
		};
		char padden[PCB_SIZE-sizeof(stack_frame)];
	};
	stack_frame regs;
};

/**when a usr-process traps into kernel,we usually need refer to it's pcb*/
#define current (get_current())
struct pcb *get_current();

#include<linux/fs.h>
struct tss{
	unsigned short back_link,__blh;
	unsigned long esp0;
	unsigned short ss0,__ss0h;
		unsigned long esp1;
	unsigned short ss1,__ss1h;
		unsigned long esp2;
	unsigned short ss2,__ss2h;
		unsigned long cr3;
	unsigned long eip;
	unsigned long eflags;
	unsigned long eax,ecx,edx,ebx;
	unsigned long esp;
	unsigned long ebp;
	unsigned long esi;
	unsigned long edii;
	unsigned short es, __esh;
	unsigned short cs, __csh;
	unsigned short ss, __ssh;
	unsigned short ds, __dsh;
	unsigned short fs, __fsh;
	unsigned short gs, __gsh;
	unsigned short ldt, __ldth;
	unsigned short trace, bitmap;
	unsigned long __cacheline_filler[5]  ;
};

/**system call always return a value,obviouslly we can not write like 'rerurn xx',but things are similarily easy,just set the 'eax'-field of process who traps into kernel mod*/
#define SET_PID_EAX(pid,return_val)	pcb_table[pid].regs.eax=return_val

void fire(struct pcb *p);
void fire_asm(u32 addr_pcb);
void proc_init(void);
struct pcb * create_process(u32 addr,int prio,int time_slice,char*p_name);

void obuffer_init(OBUFFER* pt_obuffer);
void obuffer_push(OBUFFER* pt_obuffer,char c);
unsigned char obuffer_shift(OBUFFER* pt_obuffer);


/* 暂时让fstack附属于进程，来解决因进程切换引起的push/pop混乱。但应该还是会有特殊情形，
   会使的push/pop混乱 小心
   另外，下面的函数只能在进程里调用
   */
///////////////////////////////////////////////////////////////////////////
// 我感觉这对push/pop操作有问题。 尤其是irq_pop的时候，可能修改别的flag。
// 你弄这么复杂，只是为了避免if,else。单其实不一定更快。 
///////////////////////////////////////////////////////////////////////////
#define __fstack (current->fstack)
static inline void cli_push(void){
	__asm__ __volatile__("pushfl\n\t"
						 "cli\n\t"
						 "pop  %0\n\t"
						 :"=r"(__fstack.base[++__fstack.esp])
						 );
	if(__fstack.esp == EFLAGS_STACK_LEN) spin("eflags stack overflow !");
}

static inline void sti_push(void){
	int esp = __fstack.esp;
	__asm__ __volatile__("pushfl\n\t"
						 "sti\n\t"
						 "pop  %0\n\t"
						 :"=r"(__fstack.base[++esp])
						 );
	if(esp == EFLAGS_STACK_LEN) spin("eflags stack overflow !");
	__fstack.esp = esp;
}

static inline void flagi_pop(void){
	if(__fstack.esp == -1) spin("eflags stack bottom boundary!");
	__asm__ __volatile__("pushfl\n\t"
						 "andl $0xfffffdff, (%%esp)\n\t"
						 "or %0, (%%esp)\n\t"
						 "popfl\n\t"
						 :
						 :"r"(__fstack.base[__fstack.esp--] & (1<<9) )
						 );
	
}
void init_pcb(struct pcb *baby,u32 addr,int prio,int time_slice,char*p_name);
void fire_thread(struct pcb *p);


int alloc_pid(int pid);

static inline 
struct files_struct *get_files(struct files_struct *files){
	files->count++;
	return files;
}
void put_files(struct files_struct *files);


void put_fs(struct fs_struct *fs);
static inline 
struct fs_struct *get_fs(struct fs_struct *fs){
	fs->count++;
	return fs;
}

int try_release_krnl_resource(struct pcb *p);
int try_release_user_space(struct mm *mm);
int __release_mm(struct mm *mm);

/* 释放mm分两步走，put_mm是第二步。第一步是 try_release_user_space.
 * 递减count计数，若为０．则释放mm结构体,以及里面的pgdir。
 * 注意，在调用put_mm之前,你必须调用release_user_space()释放掉用户空间,
 * 因此，所put的mm是一个空壳
 * 为什么要分两步走呢？因为，像比在exit进程时，只是释放用户空间，但页目录
   并不销毁，把put_mm的工作，交给父进程。
 */
static inline void 
put_mm(struct mm *that){
	that->users--;
	if(that->users == 0){
		__release_mm(that);
	}
}

static inline struct mm *
get_mm(struct mm *that){
	that->users++;	
	return that;
}

extern struct slab_head *fs_struct_cache, *files_struct_cache;

#endif



























