/* 虽然本模块提供了其他接口，但是重点还是do_mmap_pgoff,sys_brk.
 */

#include<linux/mm.h>
#include<linux/fs.h>
#include<linux/mylist.h>

static unsigned long do_brk(struct mm *mm, unsigned long brk);
void insert_vm_area(struct vm_area *new);
struct page *
do_no_page(struct vm_area *area, u32 address, union pgerr_code errcode){
	spin("ddd");
	return 0;
}

static bool __cache_file_page(struct file* file, u32 page_addr, u32 file_off){
	int offset = k_seek(file, file_off, 0);		
												assert(offset == file_off);
	int rbytes = k_read(file, (void *)page_addr, PAGE_SIZE);
												assert(rbytes > 0);
	return true;
}




int common_no_page(struct vm_area *vma, u32 err_addr, union pgerr_code errcode);
/*
 * 1, 虽然文件偏移是以页为单位的，但目前文件系统还不支持64位offset, 所以这儿
 *    暂时不用long long算byte offset
 */
struct page * 
cache_file_page(struct vm_area *vma, u32 err_addr, union pgerr_code errcode){
	u32 linear_addr = err_addr & PAGE_MASK;
	u32 pgoff = vma->pgoff	+ ((err_addr - vma->start) >> PAGE_SHIFT);
	u32 offset = pgoff << PAGE_SHIFT;
	common_no_page(vma, linear_addr, errcode);	//先映射给它物理页	
	__cache_file_page(vma->file, linear_addr, offset);
	return __va2pg(linear_addr);
}

struct vm_operations mmap_area_ops = 
{
	nopage:cache_file_page,		
};
//这不是一个供内核使用的mmap。它是普通的被sys_mmap, sys_mmap2调用的。
//相当于linux 2.4的do_mmap_pgoff，我们没有pgoff后缀，因为papaya只考虑32位平台,
//而在32位平台上，以页单位为为文件偏移是当然的。否则操作不了大文件。
//实际上，linux2.3.4里就是这个函数，做的是类似的工作。不过它以byte为单位。
//man手册上说linux从2.3.31就支持了mmap2，在哪儿支持的，但是我在2.3.4的源码里，看到系统调用号截止到190，2.4里192号才是mmap2。
//@prot @flags 
//vm_area里有一个pgprot，但那是empty_pte的低12位,此处的是VM_READ, VM_WRITE..
//vm_area里也有一个flags，但那是VM_READ, VM_WRITE,是此处prot的超集,此处的flags
//是MAP_FIXED, MAP_LOCK之类。
//TODO stack area也用mmap来做？
// >整个mmap的所做的工作，仅仅是根据参数建立一个vma并插入到mm->vma链表里。重头戏交由do_page_fault的facility完成。
//所以我把的参数的名字变一下。
/* u32 do_mmap(u32 addr, u32 len, int prot, int flags, int fd, u32 pgoff){ */
void * do_mmap(u32 addr, u32 len, int vm_flags, int map_flags, struct file *file, u32 pgoff){
	if(len == 0) return 0;

	//u32 file_off = pgoff << PAGE_SHIFT;
	addr = ceil_align(addr, __4K);
	len = ceil_align(len, __4K);

	addr = get_unmapped_area(addr, len);			assert(addr);
	struct vm_area *vma = kmem_cache_alloc(vm_area_cache, 0);

	vma->mm = current->mm;
	vma->start = addr;
	vma->end = addr + len;
	vma->flags.value = vm_flags;
	vma->file = file;
	vma->pgoff = pgoff;
	if(file){
		vma->ops = &mmap_area_ops;
	}
	else{
		vma->ops = 0;
	}
	vm_update_pgprot(vma);

	assert(vma->mm->vma);		//至少有stack vm area	
	//O_INSERT_INCRE_ON(vma->mm->vma, vma, start);			//TODO use insert_vm_area()
	insert_vm_area(vma);
	return (void*)addr;
}

/* find the first vm_area whose end > addr, NULL if none. 
 * 为什么不更进一步，精确到 that_vma->start <= addr呢。
   因为这样更灵活，这个函数的作用不止是定位某个addr位于哪个vm_area。
   别的用途，像比，给定某个addr(它位于一个空闲的address range)，
   我们想知道这个addr后面紧跟的vm_area。
 */
struct vm_area *find_vma(struct mm *mm, unsigned long addr){
	struct vm_area *right_one = O_SCAN_UNTIL_MEET_LARGER(mm->vma, end, addr);
	return right_one;
}




/*
	1G	+------------+
		|            |
		|            |
		+------------+
		|   vma      |
		+------------+
	--> |          	 |
		|            |
		+------------+
		| 	vma      |
		|  (beneath) |
		+------------+
		|            |
	3G	+------------+
*/
/* search for an unmaped address range big enough to satisfy @len
 * search from 1G if @addr == 0.
 * search from @addr otherwise 
 * @return 0 when failed.
 */
u32 get_unmapped_area(u32 addr, u32 len){
	if(!addr)  addr = __1G;
	addr = ceil_align(addr, PAGE_SIZE);
	len = ceil_align(len, PAGE_SIZE);

	for(struct vm_area *beneath = find_vma(current->mm, addr); 		
		addr + len < __3G; 	
		addr = beneath->end,  beneath = beneath->next)
	{
		if(!beneath || addr + len <= beneath->end){
			assert((addr & ~PAGE_MASK) == 0);
			return addr;				
		}
	}
	return 0;
}

/* You can call it. This is the kernel version.
 * @offset  file offset, by unit of byte
 */
void * mmap(ulong addr, u32 len, int vm_flags, int map_flags, struct file *file, u32 offset){
	assert(addr % __4K == 0 && offset % __4K == 0);
	void *ret = do_mmap(addr, len, vm_flags, map_flags, file, offset >> 12);	
	assert(ret == (void *)addr);	//这个函数由内核调用，我要保证它总是成功
	return ret;
}

void insert_vm_area(struct vm_area *new){
	assert(new  && new->mm && new->mm->vma);
	struct mm *mm = new->mm;
	struct vm_area *root = mm->vma;
	struct vm_area *node = mm->vma;
	do{
		if(node->start > new->start){
			break;
		}
		node = node->next;
	}while(node != root);
	if(new->start < root->start) mm->vma = new;
	new->next = node;
	new->prev = node->prev;
	node->prev = new;
	new->prev->next = new;
}

/* brk area看上去就是一个普通的vma，但linux没有调用do_mmap，而是自己重新写了一
   遍。 它肯定有它的理由，等我明白它的理由，非那样做不可的时候，我再把papaya的
   brk写得那么复杂吧。
 */
unsigned long sys_brk(unsigned long brk){
	//struct mm *mm = current->mm;
	return 0;	
}


unsigned long k_brk(unsigned long brk){
	return do_brk(current->mm, brk);
}

/* 4K对齐。
 * @return new break on success,  and current break on failure.
 */
static unsigned long do_brk(struct mm *mm, unsigned long brk){
	unsigned long newbrk, oldbrk;
	long  newbytes;
											assert(mm->start_brk && mm->brk);
	newbrk = ceil_align(brk, __4K);
	oldbrk = mm->brk;			//mm->brk一定是对齐的，不用检查
	newbytes = newbrk - oldbrk;
	if(newbytes == 0) goto failed;	//也许不该失败，人家就是想brk到原处呢?

	if(mm->brk == mm->start_brk){	//brk area not initialized yet
		if(newbytes <= 0) goto failed;
		mmap(mm->start_brk, newbytes, VM_READ | VM_WRITE, 0, 0, 0);
		goto success;
	}
	struct vm_area *brk_area = find_vma(mm, mm->start_brk);
									assert(brk_area->start == mm->start_brk);
	if(newbytes > 0){
		vm_area_expand( brk_area, newbrk);
	}
	else{	//(newbytes < 0)
		vm_area_shrink( brk_area, newbrk );
	}
	success:	
		mm->brk = newbrk;
		return newbrk;	
	failed:		return oldbrk;
}

bool vm_area_expand(struct vm_area *vma, unsigned long new_end){
											assert(new_end > vma->end 
													&& new_end % __4K == 0);
	//struct vm_area *barrier;
	if( find_vma_intersection(vma->mm, vma->end, new_end) )
			return false;
	vma->end = new_end;
	return true;
}

bool vm_area_shrink(struct vm_area *vma, unsigned long new_end){
											assert(new_end < vma->end
													&& new_end > vma->start
													&& new_end % __4K == 0);
	for(int vaddr = vma->end; vaddr < new_end; vaddr += __4K){
		__release_address( PGDIR_OF_MM(vma->mm), vaddr );
	}
	vma->end = new_end;
	return true;
}














