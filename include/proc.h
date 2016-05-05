#ifndef PROC_H
#define PROC_H
#include "valType.h"
#include<utils.h>
#include<ku_proc.h>
#include<mm.h>
#include<asm/resource.h>


extern struct tss base_tss;
#define g_tss (&base_tss)


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
	struct dentry *root, *pwd, *altroot;
	struct vfsmount *rootmnt, *pwdmnt, *altrootmnt;
};

#define NR_OPEN_DEFAULT 32
/* open file table structure
 * 1, @file_array points to __file_array at first, and will point to the new allocated
 * file array(bigger size) when a process open two many files.
*/
struct files_struct{
	int max_fds;
	struct file **filep;	/* current file array */
	struct file *__file_array[NR_OPEN_DEFAULT];
};

struct thread{
	unsigned esp;
	unsigned eip;
};

/**the stack frame when cpu traps into kernel for exception or interrupt*/
typedef struct{
	u32 ebx,ecx,edx,esi;		/**we use four registers to pass syscall args*/
	u32 edi,ebp,eax;
	u32 ds,es,gs,fs;
	u32 err_code;
	u32 eip,cs,eflags,esp,ss;	/**auto pushed by hardware*/
}stack_frame;


#define PCB_SIZE 0x2000
/**process control block. all information and property of a process.
 **/
struct pcb{
	union{
		struct{
			/**'pregs' must be the first member of pcb, otherwise, code in
			 * kernel.asm will go wrong when investige 'pregs' in assemble mod*/
		 	stack_frame *pregs;		/**when a ring0 process interrupted by a
									  certain exception or interruption,the
									  cpu current(namely eax,ebx...) won't be
									  saved in member[regs].so we need a pointer
									  to know the real saved location.*/
			int need_resched;
			int sigpending;
			struct pcb *prev;
			struct pcb *next;
			u32 pid;
			char *p_name;
			u32 prio;
			u32 time_slice,time_slice_full;
			u32 msg_type,msg_bind;
			u32 *cr3;
			u32 ring;
			struct thread thread;
			struct fs_struct *fs;
			struct files_struct *files;
			struct rlimit rlimits[RLIMIT_MAX];
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
struct pcb * create_process(u32 addr,int prio,int time_slice,char*p_name,int ring);

void obuffer_init(OBUFFER* pt_obuffer);
void obuffer_push(OBUFFER* pt_obuffer,char c);
unsigned char obuffer_shift(OBUFFER* pt_obuffer);
#endif



























