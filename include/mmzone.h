#ifndef MMZONE_H
#define MMZONE_H
#include<list.h>
#include<mm.h>
#define MAX_ORDER 10

#define __GFP_DEFAULT 0
#define __GFP_ZERO (1<<0)
#define __GFP_DMA (1<<1)
#define __GFP_HIGHMEM (1<<2)
#define __GFP_NORMAL (1<<3)

#define ZONE_DMA 0
#define ZONE_NORMAL 1
#define ZONE_HIGHMEM 2
#define ZONE_MAX 3

#define ZONE_DMA_PA 0
#define ZONE_NORMAL_PA 0X1000000
#define ZONE_HIGHMEM_PA (896*0x100000)
/**physical ram management*/
typedef struct free_area_struct{
	struct list_head free_list;
	int nr_free;
}free_area_t;

typedef struct zone_struct{
	/**frequently used members*/
	unsigned  free_pages;
	free_area_t free_area[MAX_ORDER+1];	
	struct page *zone_mem_map;	/**first page descriptor of zone*/
	unsigned  spanned_pages;

}zone_t;

zone_t zone_dma;
zone_t zone_normal;
zone_t zone_highmem;
zone_t *__zones[3];
unsigned size_of_zone[3];
void init_zone(void);


#define  __free_page(page) __free_pages(page, 0)
#define free_page(frame_addr)  free_pages(frame_addr, 0)


void free_pages(unsigned frame_addr, int order);








#endif
