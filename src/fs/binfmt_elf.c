#include<linux/binfmts.h>
#include<elf.h>
#include<linux/mm.h>
#include<proc.h>
#define MAP_FIXED 0
#define MAP_DENYWRITE 0

static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs){
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
		int filesz;
		if(phdr[i].p_type != PT_LOAD) continue;
										assert(!meet_final_entry);
										assert(phdr[i].p_memsz > 0);
		ulong vaddr = phdr[i].p_vaddr;
		ulong fileoff = phdr[i].p_offset;
										assert(vaddr % __4K == fileoff % __4K);
		vaddr = floor_align(vaddr, __4K);
		fileoff = floor_align(fileoff, __4K);
		ulong memsz = phdr[i].p_memsz;
		if(( filesz = phdr[i].p_filesz )){
			ulong vm_flags = 0;
			if(phdr[i].p_flags & PF_R) vm_flags |= VM_READ;
			if(phdr[i].p_flags & PF_W) vm_flags |= VM_WRITE;
			if(phdr[i].p_flags & PF_X) vm_flags |= VM_EXEC;
			
			memsz -= filesz;
			void *ret = mmap(vaddr, filesz, vm_flags, 
							MAP_FIXED | MAP_DENYWRITE, bprm->file, fileoff);
													assert(ret == (void *)vaddr);
		}
		else oprintf("warning: this elf-file seems has .bss only");
		if(memsz){
			//brk(memsz);
			meet_final_entry = true;
		}
	}

	regs->cs = (u32)&selector_plain_c3;	
	regs->fs = regs->gs = 0;
	regs->ds = regs->es = regs->ss  =  (u32)&selector_plain_d3;
	regs->eip = (ulong)eheader->e_entry; 
	return 0;
}

struct linux_binfmt elf_format = {
	load_binary: load_elf_binary,
};










