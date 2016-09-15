#include<asm/page.h>
#include<linux/mm.h>

void vm_update_pgprot(struct vm_area *vma){
	union pte *pte = &vma->empty_pte;
	ulong vm_flags = vma->flags.value;

	pte->value = PG_P | PG_USU;
	if(vm_flags & VM_WRITE) pte->writable = 1;

	//NX bit unexists on common 32-bit mode.
	//if(vm_flags & VM_EXEC) pte->nx = 1; 
}

/* resolve page-not-exsit error 
 * 用于解决usr space的缺页。所以分配的物理页的是用户页
 * @flags  新的页表项的低12位。
 *		   因为每个vm_area	都有自己的pgprot模板。这个参数正是因此才有的。
 */
void __resolve_address(union pte *pgdir, u32 vaddr, u32 pgprot){

	union linear_addr laddr = {value:vaddr};
	union pte *dirent = pgdir + laddr.dir_idx;
	if(dirent->present == 0){
		dirent->value = __pa(__alloc_page(__GFP_ZERO)) | PG_USU | PG_RWW | PG_P;
	}
	union pte *pgtbl = (void *)__va(dirent->value & PAGE_MASK);	
	pgtbl[laddr.tbl_idx].value = (ulong)__pa(__alloc_page(0)) | pgprot;
}


/* just map it to a physical page 
 */
int common_no_page(struct vm_area *vma, u32 err_addr, union pgerr_code errcode){
	if(errcode.on_write && vma->empty_pte.writable == false)	
			spin("attempt to write a read-only vma");

	__resolve_address((void *)__va(vma->mm->cr3.value & PAGE_MASK),
					err_addr,	vma->empty_pte.value);	
	return 0;
}



