#include<asm/page.h>
#include<linux/mm.h>
#include<proc.h>
#include<irq.h>

static int count_pgerr;
/*
31                4                             0
+-----+-...-+-----+-----+-----+-----+-----+-----+
|     Reserved    | I/D | RSVD| U/S | W/R |  P  |
+-----+-...-+-----+-----+-----+-----+-----+-----+

    P: When set, the fault was caused by a protection violation.
    When not set, it was caused by a non-present page.
    W/R: When set, write access caused the fault; otherwise read access.
    U/S: When set, the fault occurred in user mode; otherwise in supervisor mode.
    RSVD: When set, one or more page directory entries contain reserved bits which are set to 1.
    This only applies when the PSE or PAE flags in CR4 are set to 1.
    I/D: When set, the fault was caused by an instruction fetch.
    This only applies when the No-Execute bit is supported and enabled. 
*/
void do_page_fault(struct pt_regs *pregs, union pgerr_code errcode){
	int IF = cli_ex();

	if(++count_pgerr >= 2) spin("double page fault");
	u32 err_addr;
	__asm__ __volatile__(
			"movl %%cr2,%0"
			:"=r" (err_addr)
			:
	);

	oprintf("page error: err_addr:%x, eip:%x, esp:%x\n", err_addr, pregs->eip, pregs->esp);
	oprintf("error code:%s: %c %c\n",
			errcode.protection ? "page protection error":"page not exist error",			errcode.from_user ? 'U':'S',
			errcode.on_write ? 'W':'R'
		   );

	if(err_addr == 0) spin("attempt to access address 0");
	if(in_interrupt() || !current->mm)	spin("OOPs !");

	if(errcode.$nopage == 0){	//0 means nopage
		struct vm_area *vma = find_vma(current->mm, err_addr);
		if(!vma){
			assert(err_addr >= __3G);
			spin("kernel space page fault");
		}
		if(vma->start <= err_addr){		//Ok, we find the ill area
			if(vma->ops && vma->ops->nopage){
				vma->ops->nopage(vma, err_addr, errcode);
			}
			else{
				common_no_page(vma, err_addr, errcode);
			}
		}
		else spin("in vm_area gaps");
	}
	else{	//errcode.protection == 1
		spin("protection error");	
	}

	count_pgerr--;
	if(IF) sti();
	return;
}

//exception 1, no error code
int do_breakpoint_fault(struct pt_regs *regs){
	spin("breakpoint fault\n");
	return 0;
}






