#include<asm_lable.h>
#include<proc.h>
#include<schedule.h>
#include<mm.h>
#include<utils.h>
#include<schedule.h>
#define PCB_MAGIC_NUMBER 0xaabbccdd
static int selector_plain_d[4]={(int)&selector_plain_d0,(int)&selector_plain_d1,0,(int)&selector_plain_d3};
static int selector_plain_c[4]={(int)&selector_plain_c0,(int)&selector_plain_c1,0,(int)&selector_plain_c3};
int __eflags=0x1200;//IOPL=1,STI	__prefix, 避免gdb犯晕:p eflags

/* only create ring 0 process */
void init_pcb(struct pcb *baby,u32 addr,int prio,int time_slice,char*p_name){
	extern  u32 NEED_RESCHED_OFFSET;
	int off1 = (u32)&NEED_RESCHED_OFFSET ;
	int off2 = MEMBER_OFFSET(struct pcb, need_resched);
	assert(off1 == off2);

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
	baby->pid = alloc_pid(0);
	baby->time_slice=baby->time_slice_full=time_slice;
	strncpy(baby->p_name, p_name, P_NAME_MAX);

	baby->thread.esp = (int)&baby->regs;
	baby->thread.eip = (int)restore_all;
	baby->fs = kmalloc0( sizeof(struct fs_struct));
	baby->files = kmalloc0( sizeof( struct files_struct) );
	baby->files->filep = baby->files->origin_filep;
	baby->files->max_fds = sizeof(baby->files->origin_filep) / 4;
	baby->rlimits[RLIMIT_NOFILE].cur = 512;
	baby->rlimits[RLIMIT_NOFILE].max = 1024;
	baby->fstack.esp = -1;
	baby->magic = PCB_MAGIC_NUMBER;
	baby->mm = 0;
	INIT_LIST_HEAD(&baby->sibling);
	INIT_LIST_HEAD(&baby->children);
	baby->mother = baby->monitor = 0;
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
}

/* @pid = -1 			random allocation
		>= 0			try allocate this number
 * @return 
 		>= 0			on success
		= -1			on failure
 * 为了调试方便，目前是0,1,2,3逐个分配的..
 */
int alloc_pid(int pid){
	static int pid_fresh = 0;
	if(pid >= 0 && pid != pid_fresh) spin("bad @pid");
	return pid_fresh++;
}

void set_pid(int pid, struct pcb *p){
	p->pid = pid;
	/* TODO insert into hashtable */
}

void put_files(struct files_struct *files){
	files->count--;
	if(files->count > 0) return;

	//释放fd数组
	if(files->filep != files->origin_filep) 
		kfree2(files->filep);

	//尝试关闭文件
	for(int i = 0; i < files->max_fds; i++){
		struct file *file = files->filep[i];
		if(file) k_close(file);
	}

	kmem_cache_free(files_struct_cache, files);
}

void put_fs(struct fs_struct *fs){
	fs->count--;
	if(fs->count > 0) return;

	mntput(fs->pwdmnt);	
	mntput(fs->rootmnt);	
	dput(fs->pwd);
	dput(fs->root);

	kmem_cache_free(fs_struct_cache, fs);
}

/* 释放这个vm_area内的所有用户页和页表。最后释放这个vm_area_struct本身。
 * 注意! 这个函数只能被release_user_space()调用，它能保证是按线性地址的顺序
   逐个释放vma,否则release_vm_area()里对页表的释放操作是危险的。
 */
static int  release_vm_area(struct vm_area *vma){
	union linear_addr vaddr;
	struct mm *mm;           									
	union pte *pgdir, *pgtbl;
	union pte *dirent;

	mm = vma->mm;
	pgdir = PGDIR_OF_MM(mm);

	vaddr.value = vma->start;
	pgtbl = pte2page(pgdir[vaddr.dir_idx]); 
	while(vaddr.value < vma->end){
		struct page *userpage;
		int i = vaddr.tbl_idx;	

		if(pgtbl[i].value == 0) goto _continue;
		userpage = pte2page_t( pgtbl[i] );
		put_page(userpage);					//释放一个用户页

		_continue:
		vaddr.value += __4K;
		if((vaddr.value % __4M) == 0){
			union pte prev = pgdir[vaddr.dir_idx - 1];
			put_page( pte2page_t(prev) );	//释放一个页表
			dirent = pgdir + vaddr.dir_idx;		//TODO 代码可简化
			pgtbl = pte2page(*dirent);
		}
	}
	kmem_cache_free(vm_area_cache, vma);
	return 0;
}


//释放用户空间的所有页。以及相应的页表,vma。
int try_release_user_space(struct mm *mm){
	struct vm_area *vma, *next;
																				assert(mm->vma);
	if(mm->users > 1) return 0;
	//释放用户空间的所有页，页表,vm_area结构体
	vma = mm->vma;
	do{
		next = vma->next;
		release_vm_area(vma);
	}while( next != mm->vma && (vma = next));

	mm->vma = 0;
	return 0;
}

int try_release_krnl_resource(struct pcb *p){

	put_files(p->files);
	put_fs(p->fs);

	p->files = 0;
	p->fs = 0;
	return 0;
}

/* 释放mm_struct, 以及相应的pgdir
 * only invoked by put_mm
 */
int __release_mm(struct mm *mm){
	union pte *	pgdir;															assert(mm != current->mm);

	pgdir = PGDIR_OF_MM(mm);
	__free_page(pgdir);

	mm->cr3.value = 0;
	kfree2(mm);

	return 0;	
}




