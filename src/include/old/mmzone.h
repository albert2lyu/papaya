#ifndef MMZONE_H
#define MMZONE_H
#include<list.h>
#include<linux/mm.h>
#include<asm/page.h>

#define G_PGNUM (gmemsize>>12)
typedef struct page{
	struct list_head lru;
	int _count;
	int cow_shared;	/* I don't know the the mechanism of '_count' for temporary
					   , so, just use another field 'cow_count' to implent cow.
					   if = 0, not shared
					   if >= 1, shared by (cow_count+1) process
					 */
	int private;
	int PG_highmem:1;
	int PG_private:1;
	unsigned PG_zid:2;
	unsigned debug:8;
	int padden:20;
}page_t;

#define page_idx(page_t) ((unsigned)((page_t) - mem_map))
#define pte_pfn(pte) ((pte)>>PAGE_SHIFT)
#define pfn_page(pfn) (mem_map + (pfn))
#define pte_page(pte) ( pfn_page( pte_pfn(pte) ) )
#define page_va(page) __va( (page - mem_map) << PAGE_SHIFT)
#define virt_to_page(vaddr) pfn_page( __pa(vaddr) >> PAGE_SHIFT)
struct page *mem_map;

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
	int frees,allocs;
}free_area_t;

typedef struct zone_struct{
	/**frequently used members*/
	unsigned  free_pages;
	free_area_t free_area[MAX_ORDER+1];	
	struct page *zone_mem_map;	/**first page descriptor of zone*/
	unsigned  spanned_pages;
	int allocs,frees;	//counts for allocate/free operation. For Debug
}zone_t;

zone_t zone_dma;
zone_t zone_normal;
zone_t zone_highmem;
zone_t *__zones[3];
unsigned size_of_zone[3];
void init_zone(void);




void free_pages(struct page *page, int order);

/**
 * similar to __free_pages(), but receives linear address of the first page 
 * frame as argument.
 * > 关于这8个函数的返回值和参数:
 *   1, __alloc_page/s　的返回值是void *，因为多数情况，调用者是在哦你给某个类型
 *      的指针等着接收它的返回值。如果返回ulong，用户每次得手动转换。
 *   2, 作为对1的补充，一定不要void *ptr = __alloc_page/s()这样的代码。
 *		因为如果手误写作void *ptr = alloc_page/s(),编译器检测不到。然后，你很
 *		可能把ptr所指当一个页去写，其实你写入mem_map数组里了。这很致命。
 *	 3, __free_page/s接收的是void *参数，因为要与__alloc_page/s一致。
 *		这也符合常规思维，C语言里的free也是接收void *。
 *		但如果跟free_page/s用混了，编译器同样检测不出来。话说回来，选择了void *
 *		做参数，就要面对这一点。
 */
static inline void __free_pages(void* frame_addr, int order){
	unsigned ppg = __pa(frame_addr) >> 12;	
	free_pages(mem_map + ppg, order);
}

static inline void __free_page(void * frame_addr){
	__free_pages(frame_addr, 0);
}

static inline void free_page(struct page * page){
	free_pages(page, 0);
}

/* 1, 正宗的页分配函数是alloc_pages,返回struct page结构。
 * 2, alloc_page()是单数形式，只分配一个页。
 * 3, 对应的下划线版本，功能一样，但返回linear address。
 * 4, papaya就提供这4个页分配函数。
 */
struct page *alloc_pages(u32 gfp_mask, int order);
static inline void * __alloc_pages(u32 gfp_mask, int order){
	u32 ppg = page_idx(alloc_pages(gfp_mask, order));
	return (void *)KV(ppg<<12);
}

static inline struct page *alloc_page(u32 gfp)
{
	return alloc_pages(gfp, 0);
}

static inline void * __alloc_page(u32 gfp)
{
	return __alloc_pages(gfp, 0);
}





//get/put page
static inline struct page *get_page(struct page *page){
	page->_count++;
	return page;
}

static inline void put_page(struct page *page){
	page->_count--;
}

#endif
