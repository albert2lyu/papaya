#include<fork.h>
#include<proc.h>
#include<mm.h>
#include<asm_lable.h>
#include<schedule.h>
#include<linux/sched.h>
#include<linux/mylist.h>
#include<linux/printf.h>

void chgpg(u32*dir,int vpg,int rw){
	/**check the validation of page dir-entry. does it point to a valid page
	 * table?if not,alloc a clean page as page-table*/
	u32 *dirent = dir + PG_H10(vpg);
	assert(*dirent & PG_P);
	u32 *tbl = (u32*)KV((*dirent)>>12<<12);/**trip attr-bit*/
	if(rw){
		tbl[PG_L10(vpg)] |= PG_RWW;
	}
	else tbl[PG_L10(vpg)] &= ~PG_RWW;
/*	__asm__ __volatile__("invlpg");*/
	__asm__("mov %cr3, %eax\n\t"
			"mov %eax, %cr3");
}

static int copy_fd( struct pcb *child){
	struct files_struct *my = current->files;
	struct files_struct *his = kmem_cache_alloc(files_struct_cache, 0);
	his->max_fds = my->max_fds;
	if(my->filep == my->origin_filep){
		his->filep = his->origin_filep;
	}
	else{
		his->filep = kmalloc2( sizeof(struct file *)  * my->max_fds, 0);
	}
	//memcpy(his->filep, my->filep, sizeof(struct file *) * max_fds);
	for( int i = 0; i < my->max_fds; i++ ){
		struct file *file = my->filep[i];
		his->filep[i] = file;
		if(file){
			get_file(file);	
		}
	}

	child->files = his;	

	return 0;
}

static int copy_fs(struct pcb *child){
	struct fs_struct *his = kmem_cache_alloc(fs_struct_cache, 0);
	*his = *current->fs;
	dget(his->root);	
	dget(his->pwd);
	mntget(his->rootmnt);		
	mntget(his->pwdmnt);

	child->fs = his;
	return 0;
}

static struct vm_area * clone_vma(struct vm_area *me, struct mm *hismm){
	union pte *mydir, *hisdir;
	union pte *mytbl, *histbl;
	union vm_flags vm_flags;
	bool cow;
	union linear_addr vaddr;
	struct page *thispage;

	struct vm_area *he = kmem_cache_alloc(vm_area_cache, 0);
	*he = *me;
	he->mm = hismm;

	mydir = PGDIR_OF_MM(me->mm);
	hisdir = PGDIR_OF_MM(hismm);
	vm_flags = me->flags;
	cow = !vm_flags.shared && vm_flags.maywrite;
	
	vaddr.value = me->start;
	goto next_4M;
	while(vaddr.value < me->end){			//copy page range
		int i = vaddr.tbl_idx;
		union pte *entry = mytbl + i;
		if( entry->value == 0 ) goto _continue;
		if( !entry->present) spin("swapped page on disk ?");
		if(cow){
			mytbl[i].writable = false;
			invlpg((void *)vaddr.value);
		}
		else if(vm_flags.shared);		//shared page, just copy entry
		else if(vm_flags.maywrite);		//read-only page, just copy entry
		else;							//never reached here

		histbl[i] = mytbl[i];
		thispage = pte2page_t(mytbl[i]);
		get_page(thispage);

		_continue:
		vaddr.value += __4K;
		if(vaddr.value % __4M == 0){
			int idx;
			next_4M:
			idx = vaddr.dir_idx;
			if( hisdir[idx].value == 0 )	//第一页目录项可能已经有table了
											//TODO 考虑优化，在goto前处理这个if
					hisdir[idx].value = __pa(__alloc_page(__GFP_ZERO)) 
										| PG_USU | PG_RWW | PG_P;
			assert(hisdir[idx].present);	//maybe i  write pages swap oneday
			mytbl = pte2page( mydir[idx] );
			histbl = pte2page( hisdir[idx] );
		}
	}
	
	if(me->file){
		get_file(me->file);
	}

	return he;
}

static int dup_mmap(struct mm *mymm, struct mm *hismm)
{
	struct vm_area *clone;
	struct vm_area *root = mymm->vma;					assert(root);
	struct vm_area *this = root;
	do{
		if(this->flags.dontcopy) continue;

		clone = clone_vma(this, hismm);	
		O_APPEND_SAFE(hismm->vma, clone);	
	}while( (this = this->next) && this != root );

	return 0;
}

static int clone_mm(struct pcb *child){
	struct mm *hismm = kmem_cache_alloc(mm_cache, 0);
	union pte *pgdir = __alloc_page( __GFP_ZERO);
	*hismm = *current->mm;
	hismm->users = 1;

	//map kernel space
	union pte *mydir  = PGDIR_OF_MM(current->mm);
	memcpy((void*)(pgdir + 256*3), mydir + 256*3, 256*4);

	hismm->cr3.value = __pa(pgdir);	
	hismm->vma = 0;		

	dup_mmap(current->mm, hismm);

	child->mm = hismm;
	return 0;
}

int do_fork(unsigned long clone_flags, unsigned long stack_start,
			struct pt_regs *regs, unsigned long stack_size)
{
	//int retval = 0;
	unsigned ppg = page_idx(alloc_pages(__GFP_ZERO, 1));
	struct pcb * child = (void *)KV(ppg<<12);	/*子进程的pcb*/
	/*step1 do copy: task_struct, stack_frame, page dir&tbl*/
	memcpy((void *)child, (void *)current, 0x2000);		//TODO
	//? p->regs = current->regs;

	if(!current->mm) goto set_back_routine;

	child->time_slice = child->time_slice_full = 10;

	//copy files
	if(clone_flags & CLONE_FD){
		copy_fd(child);	
	}else{
		current->files->count++;				
	}

	//copy fs
	if(clone_flags & CLONE_FS){
		copy_fs(child);
	}
	else current->fs->count++;

	//copy mm
	if(clone_flags & CLONE_VM){
		clone_mm(child);
	}
	else{
		get_mm(current->mm);
	}

	unsigned long pcb2pcb;
	stack_frame *float_regs;
	set_back_routine: 
	/*step2: do adjust*/
	/*设置内核的返回路线*/
	/*为子进程捏造一个thread,因为它肯定是通过调度而返回的*/
	pcb2pcb = (unsigned long)child - (unsigned long)current;
    float_regs = (void *)((unsigned long)regs + pcb2pcb);
	child->thread.esp = (unsigned long)float_regs;
	float_regs->eax = 123;
	if(!(regs->cs & 3)){
		float_regs->ebp += pcb2pcb;
	}
	child->thread.eip = (unsigned long)ret_from_sys_call;
	

	sprintf(child->p_name, "mirror:%s", current->p_name);	//TODO danger !
	child->pid = 1;
	//current->pid = 0;
	LL_I_INCRE(list_active, child, prio);

	return 12345;
}
int sys_fork(stack_frame regs){
	return do_fork(
					CLONE_FD | CLONE_FS |CLONE_VM, 
				   	0, 
				   	&regs, 
				   	0
				   );
}
