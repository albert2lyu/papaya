#include<linux/slab.h>
#include<proc.h>
#include<linux/binfmts.h>
#include<linux/mm.h>
#include<asm/errno.h>

char * copy_string(char *str);
char ** copy_strings(char **strs);
static int release_user_space(struct mm *mm);
static int search_binary_handler(struct linux_binprm *binprm, 
								 struct pt_regs *regs);

static struct vm_area *mk_stack_area(void){
	struct vm_area *vma = kmem_cache_alloc(vm_area_cache, 0);	
	vma->end = __3G;
	vma->start = __3G - __1M;
	vma->flags.value = VM_STACK;
	vma->mm = current->mm;
	vma->ops = NULL;
	vma->file = NULL;
	vma->pgoff = 0;
	vma->next = vma->prev = vma;
	vm_update_pgprot(vma);
	return vma;
}

/* 关中断的粒度可以细一些，因为需要读磁盘
 * > 这个函数有可能返回，例如参数错误，可执行文件格式错误
 */
int do_execve(char *filepath, char *argv[], char *envp[], struct pt_regs *regs){
	int ret;
	struct mm *oldmm;
	struct linux_binprm binprm;
	struct file * file  = k_open(filepath, 0, 0);
											if(!file) return -EINVAL;
	binprm.filepath = filepath;
	binprm.argv = argv;
	binprm.envp = envp;

	if(filepath < (char *)__3G)
		binprm.filepath = copy_string(filepath);

	if(argv && argv < (char **)__3G)
		binprm.argv = copy_strings(argv);

	if(envp && envp < (char **)__3G)	
		binprm.envp = copy_strings(envp);

	binprm.file = file;
	int rbytes = k_read(file, binprm.buf, 128);
											assert(rbytes == 128);
	oldmm = current->mm;
	//binprm prepared
	//有必要把argv, envp传递给bin_handler吗
	cli();	//文件读完了，下面要切换CR3设置tss，这个step之后也别打开。再细看。


	//step+ : assign new mm_struct and switch cr3 to gain new user space access
	struct mm *mm = kmem_cache_alloc(mm_cache, 0);
	u32 * pgdir = __alloc_page(__GFP_ZERO);
	memcpy(pgdir + 256 * 3, (u32 *)__va(__1M) + 256*3, 224 * 4);
	mm->cr3.value = __pa(pgdir);
	mm->start_brk = mm->brk = 0;
	mm->vma =  0;
	mm->users = 1;
	current->mm = mm;

	__asm__ __volatile__ ("mov %0, %%cr3\n\t"
						 :
						 :"r"(current->mm->cr3.value)
						 );
	g_tss->esp0 = (unsigned long)current + THREAD_SIZE;

	//暂时不实现drop_mm，分两步走挺好用。
	if(oldmm){
		//step+ : 释放用户空间的所有页。以及相应的页表,vma。
		release_user_space(oldmm);
		//step+ : it's time to release the old mm_struct totally
		put_mm(oldmm);
	}
	/*-------------旧的mm至此完全销毁--------*/


	//step+: make stack area
	current->mm->vma = mk_stack_area();

	//step +: copy arguments to stack bottom
	u32 esp = __3G;
	int argc, envc= 0;
	char **stack_argv = (void *)__alloc_page(0);
	char **stack_envp = (void *)__alloc_page(0);

	int i;
	char **usr_args = binprm.envp;	//arguments vector passed from user space
	char **stack_args = stack_envp;		//记录送上用户堆栈之后，每个参数的地址
	copy_args_to_user_stack:
	for(i = 0; usr_args && usr_args[i]; i++){
		int len = strnlen(usr_args[i], __4K);	if(len == __4K) return -EINVAL;
		esp -= len;
		strcpy((char *)esp, usr_args[i]);
		stack_args[i] = (char *)esp;
	}
	stack_args[i] = 0;
	if(usr_args == binprm.envp){
		envc = i;
		usr_args = binprm.argv;
		stack_args = stack_argv;
		goto copy_args_to_user_stack;
	}
	else	argc = i;

	//make argv[],envp[] on user stack
	esp &= ~3;	//align on 4 byte

	esp -= (envc + 1) * 4;
	for(i = 0; i < envc; i++) ((ulong *)esp)[i] = (ulong)stack_envp[i];

	esp -= (argc + 1) * 4;
	for(i = 0; i < argc; i++) ((ulong *)esp)[i] = (ulong)stack_argv[i];

	*(u32 *)(esp += 4) = argc;
	regs->esp = esp;
	/* Done. 
	 * arguments on user stack prepared 
	 * argc argv[0] argv[1] .. argv[argc-1] 0 envp[0] .. envp[x] 0 str-area
	 */
												__free_page(stack_argv);
												__free_page(stack_envp);
												//TODO 释放copy-strings页
	//step 4: search bin_handler
	ret = search_binary_handler(&binprm, regs);	assert(ret == 0);

	current->time_slice = current->time_slice_full = 10;
	strncpy(current->p_name, filepath, P_NAME_MAX);

	return ret;
	//step 5: prepare return routine 这一步交给loader吧
	//对，这样写就可爱的多，怎么清晰怎么来。不考虑安全性的代码，往往是最简洁的
	//尽可能的在do_execve里完成多数操作，必要的才交个loader。
}

static struct linux_binfmt *formats;
bool register_binfmt(struct linux_binfmt* binfmt){
	if(!binfmt || !binfmt->load_binary) return false;

	//struct linux_binfmt *fmt = formats;
	int IF = cli_ex();
	if(!formats){
		formats = binfmt;
		binfmt->next = binfmt->prev = binfmt;
	}
	else{
		O_INSERT_BEFORE(formats, binfmt);
	}
	if(IF) sti();

	return true;;
}


//成功，返回0
//这个loader认不出来它:-ENOEXEC
//loader认出来了，但加载时发生错误，返回loader抛出的errno(非ENOEXEC)
static int search_binary_handler(struct linux_binprm *binprm, 
								 struct pt_regs *regs)
{
	struct linux_binfmt *fmt = formats;
	if(!fmt);
	do{
		//成功无返回; 非匹配格式，返回0; 失败返回负数
		int ret = fmt->load_binary(binprm, regs);
		if(ret == -ENOEXEC) ;					//没认出来，继续
		else if(ret == 0 ) return 0;			//成功
		else if(ret != -ENOEXEC) return ret;	//认出来了，但加载错误
		else;
		fmt = fmt->next;
	}while(fmt != formats);

	return -ENOEXEC;
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
		if(vaddr.value % __4M){
			put_page( __va2page_t(pgtbl) );	//释放一个页表
			dirent = pgdir + vaddr.dir_idx;	
			pgtbl = pte2page(*dirent);
		}
	}
	kmem_cache_free(vm_area_cache, vma);
	return 0;
}
//释放用户空间的所有页。以及相应的页表,vma。
static int release_user_space(struct mm *mm){
	struct vm_area *vma, *next;
																				assert(mm->vma);
	//释放用户空间的所有页，页表,vm_area结构体
	vma = mm->vma;
	do{
		next = vma->next;
		release_vm_area(vma);
	}while( next != mm->vma && (vma = next));

	return 0;
}


//错，这儿只会关闭某些文件，不会放弃files_struct
#if 0
static int drop_fd(struct files_struct *files){
	if(files->filep != files->origin_filep){
		kfree2(files->filep);
	}
	//kmem_cache_free()
	return 0;
}
#endif


/* 释放mm_struct, 以及相应的pgdir
 * only invoked by put_mm
 */
int __release_mm(struct mm *mm){
	union pte *	pgdir;															assert(mm != current->mm);

	pgdir = PGDIR_OF_MM(mm);
	__free_page(pgdir);

	kfree2(mm);

	return 0;	
}


char * copy_string(char *str){
	char *page = __alloc_page(0);
	strncpy(page, str, __4K);
	return page;
}

/* return result loc[] 
 * TODO 现在这样弄，是没有办法释放的
 */
char ** copy_strings(char **array){
	char **loc = __alloc_page(0);
	char *page = __alloc_page(0);
	char *dest = page;
	int i;
	for(i = 0; array[i]; i++){
		char *src = array[i];
		loc[i] = dest;
		while(*src){
			*dest++ =*src++;
			if(dest - page >= __4K)
				spin("bad");
		}
		*dest++=0;
	}
	loc[i] = 0;
	return loc;
}
















