#include<disp.h>
#include<utils.h>
#include<mm.h>
#include<valType.h>
#include<proc.h>
#include<bootinfo.h>
static int pgerr_count;
u32 gmemsize=0;
	
void init_memory(void){
	heap_init();
	/**detect pphysical memory: print memory information and init global variable 'gmemsize'*/
	int memseg_num = realinfo->memseg_num;
	struct memseg_info *memseg =realinfo->memseg_info;
	oprintf("%12s%12s%10s\n","start","len","type");
	for(int i=0; i<memseg_num; i++){
		oprintf("%12x%12x%10s\n",memseg[i].base_low,memseg[i].len_low,\
									memseg[i].type==1?"free":"occupied");
		if(memseg[i].type == 1 && memseg[i].base_low > gmemsize) \
			gmemsize = memseg[i].base_low+memseg[i].len_low;
	}
	oprintf("physical memory size:%x\n",gmemsize);	

	/**initialize mem_map*/
	mem_map = kmalloc(G_PGNUM * sizeof(struct page));

	size_of_zone[0] = 16*0x100000;
	if(gmemsize > ZONE_HIGHMEM_PA){
		size_of_zone[1] = (896-16)*0x100000;
		size_of_zone[2] = gmemsize - 896*0x100000;
	}
	else{
		size_of_zone[1] = gmemsize - 16*0x100000;
		size_of_zone[2] = 0;
	}
}
/**
 * page-error exception handler
 * alloc a physical page and mapped it to the ill virtual page
 * 2，如果是ring0发生页错误，那打印出来的esp是无效的，因为pregs指向里根本没
 * 保存esp，同级堆栈切换。
 */
void do_page_fault(stack_frame *preg, unsigned err_code){
	oprintf("pgerr trapped from ring %u,curr_process:%s\n",current->pregs->cs&3,current->p_name);
	pgerr_count++;
	u32 err_addr;
	__asm__ __volatile__(
			"movl %%cr2,%0"
			:"=r" (err_addr)
			:
	);
/*	u32 err_code=current->pregs->err_code;*/
	oprintf("sick process:%s,pcb:%x,err_code:%x, err_addr:%x,eip:%x,esp:%x\n",current->p_name,current, err_code, err_addr,current->pregs->eip,current->pregs->esp);
		oprintf("%s: %c %c\n",(err_code&1)?"page protection error":"page not exist error",(err_code&B(0100))?'U':'S',(err_code&B(0010))?'W':'R');
	if((err_code&B(0001)) == 0){
	/**page fault:page not exist*/
		map_pg((u32*)KV(current->cr3),err_addr>>12,alloc_page(__GFP_DEFAULT,0),PG_USU,PG_RWW);
		if(pgerr_count==2) spin("pgerr_count == 2");
	}
	else spin("can not handle page protection error\n");
	pgerr_count--;
	return;
}


struct page *alloc_pages(gfp_mask, order){
	/**discard gfp_mask for temporary*/
	return __rmquene(&zone_normal, order);
}


char *__get_free_pages(u32 gfp_mask, int order){
	u32 ppg = page_idx(alloc_pages(gfp_mask, order));
	return (char*)KV(ppg<<12);
}

inline void map_pg(u32*dir,int vpg,int ppg,int us,int rw){
	/**check the validation of page dir-entry. does it point to a valid page
	 * table?if not,alloc a clean page as page-table*/
	u32 *dirent = dir + PG_H10(vpg);
	if((*dirent & PG_P) == 0){
		oprintf("@map_pg bad entry,alloc one page as table\n");
		*dirent  = alloc_page(__GFP_ZERO,0)<<12|us|rw|PG_P;
	}
	u32 *tbl = (u32*)KV((*dirent)>>12<<12);/**trip attr-bit*/
	oprintf("@map_pg tbl at:%x\n",tbl);
	tbl[PG_L10(vpg)] = ppg<<12|us|rw|PG_P;
}
/**
 * |---kernel(1M)---|---kernel pgdir+kernel pgtbl(1M)---|---heap(14M)---|
 */
void mm_init(void){
	init_memory();
	init_zone();
}

