#include<disp.h>
#include<utils.h>
#include<mm.h>
#include<valType.h>
#include<proc.h>
#include<bootinfo.h>
#include<elf.h>
#include<fork.h>
static int pgerr_count;
u32 gmemsize=0;
char testbuf[1024];
void init_memory(void){
	heap_init();
	/**detect pphysical memory: print memory information and init global variable 'gmemsize'*/
	int memseg_num = realinfo->memseg_num;
	struct memseg_info *memseg =realinfo->memseg_info;
/*	oprintf("%12s%12s%10s\n","start","len","type");*/
	for(int i=0; i<memseg_num; i++){
//		oprintf("%12x%12x%10s\n",memseg[i].base_low,memseg[i].len_low,\									memseg[i].type==1?"free":"occupied");
		if(memseg[i].type == 1 && memseg[i].base_low > gmemsize) \
			gmemsize = memseg[i].base_low+memseg[i].len_low;
	}
/*	oprintf("physical memory size:%x\n",gmemsize);	*/

	/**initialize mem_map*/
	int mapsize = G_PGNUM * sizeof(struct page);
	mem_map = kmalloc(mapsize);
	/* 不再清零内存，因为似乎很耗时，暂时只identify一下，读比写快*/
	memtest(mem_map, mapsize);
	//memset((char *)mem_map, 0, G_PGNUM*sizeof(struct page));

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

/**
 * page-error exception handler
 * alloc a physical page and mapped it to the ill virtual page
 * 2，如果是ring0发生页错误，那打印出来的esp是无效的，因为pregs指向里根本没
 * 保存esp，同级堆栈切换。
 * 3, 空指针解引用会page_fault。现在就会。 因为0号页表项是空的。 以后也会一直留空，就是
 * 为了捕获内核的0地址访问。 内核要访问0地址，直接访问3G就行了。
 */
void do_page_fault(stack_frame *preg, unsigned err_code){
	//oprintf("pgerr trapped from ring %u,curr_process:%s\n",current->pregs->cs&3,current->p_name);
	pgerr_count++;
	u32 err_addr;
	__asm__ __volatile__(
			"movl %%cr2,%0"
			:"=r" (err_addr)
			:
	);
	if(err_addr == 0) spin("attempt to access address 0");
	//u32 err_code=current->pregs->err_code;
	oprintf("sick process:%s,pcb:%x,err_code:%x, err_addr:%x,eip:%x,esp:%x\n",current->p_name,current, err_code, err_addr,current->pregs->eip,current->pregs->esp);
/*		oprintf("%s: %c %c\n",(err_code&1)?"page protection error":"page not exist error",(err_code&B(0100))?'U':'S',(err_code&B(0010))?'W':'R');*/
	if((err_code&B(0001)) == 0){
	/**page fault:page not exist*/

		/*为init进程加载代码页*/
		if(strcmp(current->p_name, "init") == 0 && (err_addr>>12 == 0x8048)){
			int vpg = err_addr >> 12;
			map_pg((u32 *)KV(current->cr3), vpg, alloc_page(__GFP_ZERO, 0), PG_USU, PG_RWR);	/*加载代码页.text, .rodata*/
			map_pg((u32 *)KV(current->cr3), vpg+1, alloc_page(__GFP_ZERO, 0), PG_USU, PG_RWW);		/*加载数据页 .data.bss*/
			//底下这一句是有效的，可见chgpg函数没问题。但在
			//fork里就是不生效。
			cell_read("../src/usr/src/init", testbuf);
			oprintf("%s",testbuf);
			current->pregs->eip = loadelf(testbuf);
		}
		/*堆栈页是在这里加载的，是通用加载*/
		else{
			map_pg((u32*)KV(current->cr3),err_addr>>12,alloc_page(__GFP_ZERO,0),PG_USU,PG_RWW);
		}	
		if(pgerr_count==2) spin("pgerr_count == 2");
	}

	/*WP exception*/
	else if(err_code & B(0010)){
		int vpg = err_addr >> 12;
		unsigned *dir = (u32 *)(KV(current->cr3) & ~0xfff);
		unsigned *tbl = (u32 *)(KV(dir[PG_H10(vpg)]) & ~0xfff);
		unsigned pte = tbl[PG_L10(vpg)];
		unsigned *ppte = tbl + PG_L10(vpg);
		struct page *page = pte_page(pte);
		if(page->cow_shared >= 1){
			oprintf("meet a PG_COW\n");
			
			if(page->cow_shared >= 2){	/*assign it a new clone page frame*/
				struct page	*newpage = alloc_pages(__GFP_ZERO, 0);
				char *pageframe = (char *)page_va(newpage);
				memcp(pageframe, (char *)page_va(page), 4096);

				*ppte = (pte & 0xfff) | ( (newpage-mem_map) << 12 );
			}
			if(page->cow_shared == 1){
					
			}
			*ppte |= PG_RWW;
			page->cow_shared--;
		}	
		else{
			oprintf("normal WP error, not PG_COW\n");
		}
	}
	else if((err_code & B(0010)) == 0){
		spin("read error");
	}
	else{
		spin("can not handle page protection error\n");
	} 
/*	oprintf("do pgerr_count-- and return now\n");*/
	pgerr_count--;
	return;
}


struct page *alloc_pages(u32 gfp_mask, int order){
	/**discard gfp_mask for temporary*/
	struct page *page;
	if(gfp_mask & __GFP_DMA){
		page = (void *)__rmquene(&zone_dma, order);
	}
	else if(gfp_mask & __GFP_HIGHMEM){
		( page = (void *)__rmquene(&zone_highmem, order) ) ||
		( page = (void *)__rmquene(&zone_normal, order) ) ||
		( page = (void *)__rmquene(&zone_dma, order) ) 	;
	}
	else
		( page = (void *)__rmquene(&zone_normal, order) ) ||
		( page = (void *)__rmquene(&zone_dma, order) )	;
		
	assert(page);
	unsigned ppg = page - mem_map;
	char *vaddr = (char *)KV(ppg << 12);
	memset(vaddr, 4096<<order, 0);
	return page;
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
/*		oprintf("@map_pg bad entry,alloc one page as table\n");*/
		*dirent  = alloc_page(__GFP_ZERO,0)<<12|us|PG_RWW|PG_P;
	}
	u32 *tbl = (u32*)KV((*dirent)>>12<<12);/**trip attr-bit*/
/*	oprintf("@map_pg tbl at:%x\n",tbl);*/
	tbl[PG_L10(vpg)] = ppg<<12|us|rw|PG_P;
	FLUSH_TLB;
}
/**
 * |---kernel(1M)---|---kernel pgdir+kernel pgtbl(1M)---|---heap(14M)---|
 */
void mm_init(void){
	init_memory();
	init_zone();
}

