#include<linux/binfmts.h>
#include<elf.h>
#include<linux/mm.h>
#include<proc.h>
#define MAP_FIXED 0
#define MAP_DENYWRITE 0

/*.bss段紧跟在.data段后面，我们用brk为.bss段分配空间。
   但是，注意.data区的尾巴不能占满一个页。剩下的这些字节，只能由.bss吃掉。
 * 这就意味着：我们在mmap()data段之后，必须清除最后一页的后面部分。(也许这其实
   是mmap()份内的事)
 */
static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs){
	struct mm *mm = current->mm;
	Elf32_Ehdr *eheader = (void *)bprm->buf;
	int phnum = eheader->e_phnum;
										assert(	eheader->e_ident[0] == 0x7f &&
												eheader->e_ident[1] == 'E'  &&
												eheader->e_ident[2] == 'L'  && 
												eheader->e_ident[3] == 'F');
	Elf32_Phdr *phdr = (void *)__alloc_page(0);
	int offset = k_seek(bprm->file, eheader->e_phoff, 0);
										assert(offset == eheader->e_phoff);
	int rbytes = k_read(bprm->file, (void *)phdr, phnum * PH_SIZE);
										assert( rbytes == phnum * PH_SIZE);
	bool meet_final_entry = false;
	for(int i = 0; i < phnum; i++){
		ulong vm_flags;
		if(phdr[i].p_type != PT_LOAD) continue;
										assert(!meet_final_entry);
										assert(phdr[i].p_memsz > 0);
		ulong vaddr = phdr[i].p_vaddr;
		ulong fileoff = phdr[i].p_offset;
										assert(vaddr % __4K == fileoff % __4K);
		vaddr = floor_align(vaddr, __4K);
		fileoff = floor_align(fileoff, __4K);
			
		vm_flags = 0;
		if(phdr[i].p_flags & PF_R) vm_flags |= VM_READ;
		if(phdr[i].p_flags & PF_W){
			meet_final_entry = true;	//遇到数据段了，断定这是最后一个segment
			vm_flags |= VM_WRITE;
			mm->start_data = phdr[i].p_vaddr;
			//> end_data总是指向bss区紧后面。所以end_data地址，通常并非data
			//  区的vm_area的vm_end。会在它下面。
			//> .bss段之所归入brk的vma，是因为两者属性相投。而.data段的vma则
			//   要求映射到具体的文件。
			// >内核在brk时，要顾及到end_data，要保留最少量的brk区域用于
			//  .bss。
			ulong end_data = phdr[i].p_vaddr + phdr[i].p_filesz;
			ulong end_bss = phdr[i].p_vaddr + phdr[i].p_memsz;
			mm->end_data = end_bss;
			mm->brk = mm->start_brk = ceil_align(end_data, __4K);
		}
		else if(phdr[i].p_flags & PF_X){
			vm_flags |= VM_EXEC;
			mm->start_code = phdr[i].p_vaddr;
			mm->end_code = phdr[i].p_vaddr + phdr[i].p_memsz;
		}
		else;
		
		void *ret = mmap(vaddr, phdr[i].p_filesz, vm_flags, 
						MAP_FIXED | MAP_DENYWRITE, bprm->file, fileoff);
											   assert(ret == (void *)vaddr);
	}
	//不是说有bss区，我们就要为它brk
	//假如bss区很小，跟.data区在一个页内，我们把那个页剩余部分扫干净就行了
	long bss_hole = mm->end_data - mm->start_brk;
	if(bss_hole > 0) k_brk( ceil_align(mm->end_data, __4K) );

	regs->cs = (u32)&selector_plain_c3;	
	regs->fs = regs->gs = 0;
	regs->ds = regs->es = regs->ss  =  (u32)&selector_plain_d3;
	regs->eip = (ulong)eheader->e_entry; 
	//g_tss->esp0 = (unsigned long)current + THREAD_SIZE;
	return 0;
}

struct linux_binfmt elf_format = {
	load_binary: load_elf_binary,
};










