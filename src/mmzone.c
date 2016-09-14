#include<mmzone.h>
#include<utils.h>

void init_free_area(int zone_id, int start_idx);
void __free_pages_bulk(struct page *page, zone_t *zone, int order);
void cleave(free_area_t *free_area, int order);
void info_zone(int zone_id){
	oprintf("zone%u[spanned_pages:%x]\n", __zones[zone_id]->spanned_pages);
}
/**pages lower than 0x100000 are not managed for temporary*/
zone_t *__zones[3] = {&zone_dma, &zone_normal, &zone_highmem};
static unsigned pa_of_zone[3] = {ZONE_DMA_PA, ZONE_NORMAL_PA, ZONE_HIGHMEM_PA};
void init_zone(void){
	oprintf("init buddy \n");
	for(int i = 0; i <= 2; i++){
		__zones[i]->zone_mem_map = mem_map + pa_idx(pa_of_zone[i]);
		__zones[i]->spanned_pages = size_of_zone[i]>>12;
	}
	/**main initalization of buddy system:
	 * all free physical pages shall be grouped by 'order' exp and linked
	 * into buddy-system's free_list. 
	 */
	init_free_area(ZONE_DMA, 0x300000>>12);	/*BUG 3M以上用作内核初始化堆栈，不要覆盖*/
	init_free_area(ZONE_NORMAL, HEAP_SIZE>>12);
	init_free_area(ZONE_HIGHMEM, 0);
}

/**
 * @start_idx  jmp an area we ignore for temporary,such as 0-2M of zone_dma
 * FIXME every page's descriptor shall be inited, but not yet.
 */
void init_free_area(int zone_id, int start_idx){
	zone_t *zone = __zones[zone_id];
	free_area_t *free_area = zone->free_area;
	struct page *zone_map = zone->zone_mem_map;
	for(int i = 0; i <= MAX_ORDER; i++){
		INIT_LIST_HEAD(&free_area[i].free_list);
												free_area[i].frees = 0;
												free_area[i].allocs = 0;
	}

	int linked = start_idx;		/**how many pages already linked into freelist*/

	while(linked < zone->spanned_pages){
		zone_map[linked].PG_zid = zone_id;	
		zone_map[linked]._count = 1;
		zone_map[linked].private = 8;
		//__free_pages_bulk(zone_map + linked, zone, 8);
		free_pages(zone_map + linked, 8);
		//linked++;
		linked += 1 << 8;	/* 按M来初始化 */
	}
	zone->frees = zone->allocs = 0;
/*	oprintf("linked:%x, span:%x, zone_mem_map:%x\n", linked, zone->spanned_pages, zone->zone_mem_map);*/
}

/**
 * @zone	this argument is not needed, it can be referred using page->zid.
 */
void __free_pages_bulk(struct page *page, zone_t *zone, int order){
	assert(cli_already());
	assert(page->_count == 0 && "only allow invoked by free_pages");
	assert(order == page->private && "just comment this line, but be aware \
									aware of what happended");
	assert(zone->free_area[order].nr_free >= 0);

	free_area_t * free_area = zone->free_area;
	struct page *orphan = page;
	struct page *assume_head = 0;	/**the assume head of the new double size
									  block*/
	struct page *phy_neighbor = 0;
	int curr_order;
	orphan->PG_private = 0;
	for(curr_order = order; curr_order < MAX_ORDER; curr_order++){
		int block_pgs = 1<<curr_order;
		/*locate the the block-header-page bordered on, which is the suspicious
		 *buddy
		 */
		if(page_idx(orphan) / block_pgs % 2 == 0){
			phy_neighbor = orphan + block_pgs;
			assume_head = orphan;	
		}
		else{
			phy_neighbor = orphan - block_pgs;
			assume_head = phy_neighbor;
		}

		if(phy_neighbor < zone->zone_mem_map || \
			phy_neighbor >= zone->zone_mem_map + zone->spanned_pages){
			oprintf("buddy:boundary outside ");
			break;
		} 
		if(!page_is_buddy(phy_neighbor, curr_order)) break;

		/**pick up the buddy page from free_list*/
		list_del(&phy_neighbor->lru); free_area[curr_order].nr_free--;
		//不管三七二十一，先把摘下来的PG_private给关闭。后面会有一个
		//给最终的assume_head加PG_private位的操作
		phy_neighbor->PG_private = 0;
		/**the orphan grow up double size, search buddy again*/
		orphan = assume_head;		
	}
	/**insert orphan to free_list*/
	INIT_LIST_HEAD(&orphan->lru);
	list_add(&orphan->lru, &free_area[curr_order].free_list);
	orphan->PG_private = 1;		//necessary, 因为页分配出去时，这个bit被清除
	orphan->private = curr_order;
	assert(orphan->_count == 0);	//orphan->_count = 0;
	free_area[curr_order].nr_free++;
/*	oprintf("free a block");*/
}

int page_is_buddy(struct page *page, int order){
	if(page->PG_private == 0 || page->_count != 0 || page->private != order){
/*		oprintf("not_buddy:page:%x?%x;,PG_private:%u,_count:%u,private:%u,order:%u ",page, page_idx(page), page->PG_private, page->_count, page->private, order);*/
		return 0;
	}
	return 1;
}
struct page *__rmquene(zone_t *zone , int order){
	int IF = cli_ex(); 
								zone->allocs++;
								zone->free_area[order].allocs++;
								assert(zone->free_area[order].nr_free >= 0);
	free_area_t *free_area = zone->free_area;
	int i = order;
	while(free_area[i].nr_free == 0){
		i++;
		if(i == MAX_ORDER + 1) spin("page frame reclaming required");
	}
	while(i > order){
		cleave(zone->free_area, i);
		i--;
	}
	struct list_head *lru = free_area[i].free_list.next;
	list_del_init(lru);		free_area[i].nr_free--;

	struct page *it =  (page_t *)((unsigned)lru - MEMBER_OFFSET(page_t, lru));
	it->_count = 1;	
	it->PG_private = 0;
	it->debug = zone->allocs;		//标记这个bulk是第几次alloc出去的

	if(IF) sti();
	return it;
}


/**split a block into two half, just like cell cleavation.
 */
void cleave(free_area_t *free_area, int order){
	struct list_head *free_list = &free_area[order].free_list;		
	/**pick up the first linked page_t, and split the block it indicates*/	
	struct list_head *lru = free_list->next;
	list_del_init(lru);	
	free_area[order].nr_free--;

	page_t *mother = (page_t *)((unsigned)lru - MEMBER_OFFSET(page_t, lru));
	page_t *child1 = mother;
	child1->private--;
	page_t *child2 = child1 + (1<<child1->private);
	*child2 = *child1;
	list_add(&child1->lru, &free_area[order - 1].free_list);
	list_add(&child2->lru, &free_area[order - 1].free_list);
	free_area[order - 1].nr_free += 2;
}



/**some common functions in linux kernel*/


//TODO here we have bug...	zone_t *__zones[3];
void free_pages(page_t *page, int order){
	int IF = cli_ex();

	zone_t *zone = __zones[page->PG_zid];
											zone->frees++;
											zone->free_area[order].frees++;
	page->_count--;
	if(page->_count == 0){
		__free_pages_bulk(page, zone, order);
	}

	if(IF) sti();
}


struct page *alloc_pages(u32 gfp_mask, int order){
	/**discard gfp_mask for temporary*/
	struct page *page;
	extern int avoid_gcc_complain;
	if(gfp_mask & __GFP_DMA){
		page = (void *)__rmquene(&zone_dma, order);
	}
	else if(gfp_mask & __GFP_HIGHMEM){	/*BUG 高端内存区不能是全映射的，而且根本没页表*/
		avoid_gcc_complain = 
		( page = (void *)__rmquene(&zone_highmem, order) ) ||
		( page = (void *)__rmquene(&zone_normal, order) ) ||
		( page = (void *)__rmquene(&zone_dma, order) ) 	;
	}
	else
		avoid_gcc_complain = 
		( page = (void *)__rmquene(&zone_normal, order) ) ||
		( page = (void *)__rmquene(&zone_dma, order) )	;
		
	assert(page);
	if(gfp_mask & __GFP_ZERO){
		unsigned ppg = page - mem_map;
		char *vaddr = (char *)KV(ppg << 12);
		memset(vaddr, 0, 4096<<order);
	}
	return page;
}







