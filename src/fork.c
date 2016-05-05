#include<fork.h>
#include<proc.h>
#include<mm.h>
#include<asm_lable.h>
#include<schedule.h>

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
int sys_fork(stack_frame regs){

	unsigned ppg = page_idx(alloc_pages(__GFP_ZERO, 1));
	struct pcb * p = (void *)KV(ppg<<12);	/*子进程的pcb*/
	/*step1 do copy: task_struct, stack_frame, page dir&tbl*/
	memcp((void *)p, (void *)current, MEMBER_OFFSET( struct pcb, __task_struct_end) );
	p->regs = current->regs;

	ppg = page_idx(alloc_pages(__GFP_ZERO, 0));
	p->cr3 = (void *)(ppg << 12);
	unsigned *pdir = (void *)KV(ppg<<12);	/*子进程的page directory*/
	unsigned *currdir = (void *)KV(current->cr3);

	memcp((void*)(pdir + 256*3), (void *)(currdir + 256*3), 256*4);
	for(int i = 0; i < 256*3; i++){
		if(!currdir[i]) continue;
	
		ppg = alloc_pages(__GFP_ZERO, 0) - mem_map;
		pdir[i] = currdir[i] << 20 >> 20;
		pdir[i] |= ppg << 12;

		/*we get access to the two tables from kernel before we handle them*/
		unsigned *currtbl = (void *)KV(currdir[i] >> 12 << 12);
		unsigned *ptbl = (unsigned *)KV(ppg << 12);	/*ok*/
		for(int j = 0; j < 1024; j++){
			struct page *page = pte_page(currtbl[j]);	/*validity not guarantee*/
			if(!currtbl[j])	{

			}
			else if((currtbl[j] & PG_P) == 0){
				spin("can not handle swapped page");
			}
			else if(currtbl[j] & PG_RWW){
				assert(page->cow_shared == 0);
/*				oprintf("do for copy on right, before:%x>>>\n", currtbl[j]);*/
/*				oprintf("i:%x, j:%x, currdir[i]:%x, currtbl[j]:%x\n", i, j, currdir[i], currtbl[j]);*/
				currtbl[j] &= ~PG_RWW;
//				currtbl[j] |= PG_COW;	/**利用第intel忽略的bit9指示cow*/
				ptbl[j] = currtbl[j];
				page->cow_shared = 2;
				FLUSH_TLB;
/*				oprintf("done:%x<<<\n", currtbl[j]);*/
			}
			else if((currtbl[j] & PG_RWW) == 0){
				oprintf("read-only page, just copy>>>\n");
/*				oprintf("i:%x, j:%x, currdir[i]:%x, currtbl[j]:%x<<<\n", i, j, currdir[i], currtbl[j]);*/
				/*the parent process owns a 'cow' page*/
				/*this is not a ordinary read-only page*/
				if(page->cow_shared >= 1){
					page->cow_shared++;
				}
				ptbl[j] = currtbl[j];
				FLUSH_TLB;
			}
			else{
				oprintf("i:%x, j:%x, currdir[i]:%x, currtbl[j]:%x\n", i, j, currdir[i], currtbl[j]);
				spin("unknown table entry");
			}
		}
	}

	/*step2: do adjust*/
	/*设置内核的返回路线*/
	p->thread.esp = (u32)&p->regs;
	p->pregs = (void *)p->thread.esp;
	p->thread.eip = (u32)ret_from_sys_call;
	p->regs.esp = p->regs.esp;
	
	p->regs.eax = 0;
	p->p_name = "init2";
	LL_I_INCRE(list_active, p, prio);

	current->regs.eax = 0xaa;
	return 12345;










}
