#include<mmzone.h>
#include<utils.h>

void info_zone(int zone_id){
	oprintf("zone%u[spanned_pages:%x]\n", __zones[zone_id]->spanned_pages);
}
/**pages lower than 0x100000 are not managed for temporary*/
zone_t *__zones[3] = {&zone_dma, &zone_normal, &zone_highmem};
static unsigned pa_of_zone[3] = {ZONE_DMA_PA, ZONE_NORMAL_PA, ZONE_HIGHMEM_PA};
void init_zone(void){
	for(int i = 0; i <= 2; i++){
		__zones[i]->zone_mem_map = mem_map + pa_idx(pa_of_zone[i]);
		__zones[i]->spanned_pages = size_of_zone[i]>>12;
	}
	/**main initalization of buddy system:
	 * all free physical pages shall be grouped by 'order' exp and linked
	 * into buddy-system's free_list. 
	 */
	init_free_area(ZONE_DMA, 0x200000>>12);
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
		free_area[i].nr_free = 0;
	}

	int linked = start_idx;		/**how many pages already linked into freelist*/

	while(linked < zone->spanned_pages){
		zone_map[linked].PG_zid = zone_id;	
		zone_map[linked]._count = 1;
		__free_pages_bulk(zone_map + linked, zone, 0);
		linked++;
	}

	oprintf("linked:%x, span:%x, zone_mem_map:%x\n", linked, zone->spanned_pages, zone->zone_mem_map);
}

/**
 * @zone	this argument is not needed, it can be referred using page->zid.
 */
void __free_pages_bulk(struct page *page, zone_t *zone, int order){
	free_area_t * free_area = zone->free_area;
	struct page *orphan = page;
	struct page *assume_head = 0;	/**the assume head of the new double size
									  block*/
	struct page *phy_neighbor = 0;
	int curr_order;
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
			oprintf("boundary outside ");
			break;
		} 
		if(!page_is_buddy(phy_neighbor, curr_order)) break;

		/**pick up the buddy page from free_list*/
		list_del(&phy_neighbor->lru); free_area[curr_order].nr_free--;
		phy_neighbor->PG_private = 0;
		/**the orphan grow up double size, search buddy again*/
		orphan = assume_head;		
	}
	/**insert orphan to free_list*/
	INIT_LIST_HEAD(&orphan->lru);
	list_add(&orphan->lru, &free_area[curr_order].free_list);
	orphan->PG_private = 1;
	orphan->private = curr_order;
	orphan->_count = -1;
	free_area[curr_order].nr_free++;
/*	oprintf("free a block");*/
}

int page_is_buddy(struct page *page, int order){
	if(page->PG_private == 0 || page->_count != -1 || page->private != order){
/*		oprintf("not_buddy:page:%x?%x;,PG_private:%u,_count:%u,private:%u,order:%u ",page, page_idx(page), page->PG_private, page->_count, page->private, order);*/
		return 0;
	}
/*	oprintf("is b ");*/
	return 1;
}
struct page *__rmquene(zone_t *zone , int order){
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
	return (page_t *)((unsigned)lru - MEMBER_OFFSET(page_t, lru));
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


void __free_pages(page_t *page, int order){
	zone_t *zone = __zones + page->PG_zid;
	page->_count--;
	if(page->_count != -1) return;
	__free_pages_bulk(page, zone, order);
}


/**
 * similar to __free_pages(), but receives linear address of the first page 
 * frame as argument.
 */
void free_pages(unsigned frame_addr, int order){
	unsigned ppg = __pa(frame_addr) >> 12;	
	__free_pages(mem_map + ppg, order);
}






