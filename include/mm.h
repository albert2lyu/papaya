#ifndef MM_H
#define MM_H
#include<valType.h>
#include<utils.h>
#include<pmm.h>
#include<ku_mm.h>
#include<list.h>
#include<mmzone.h>
#define i386_endbase 0xa0000
#define PROC_ENTRY (0x8048000)  //这个概念根本就是错的
#define PAGE_OFFSET 0XC0000000
#define page_idx(page_t) ((unsigned)((page_t) - mem_map))
#define pte_pfn(pte) ((pte)>>PAGE_SHIFT)
#define pfn_page(pfn) (mem_map + (pfn))
#define pte_page(pte) ( pfn_page( pte_pfn(pte) ) )
#define __pa(vaddr) ((unsigned)(vaddr) - PAGE_OFFSET)
#define __va(paddr) ((unsigned)(paddr) + PAGE_OFFSET)
#define page_va(page) __va( (page - mem_map) << PAGE_SHIFT)
#define virt_to_page(vaddr) pfn_page( __pa(vaddr) >> PAGE_SHIFT)
/**macor 'alloc_page' defined for backward compatible, don't use it*/
#define alloc_page(gfp, order) page_idx(alloc_pages(gfp, order))
#define kmalloc_pg __get_free_pages
#define G_PGNUM (gmemsize>>12)
struct page *mem_map;
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
	int padden:28;
}page_t;

struct memseg_info{
	u32 base_low, base_high;
	u32 len_low, len_high;
	u32 type;
};

void map_pg(u32*dir,int vpg_id,int ppg_id,int us,int rw);
struct page *alloc_pages(u32 gfp_mask, int order);
char* kmalloc_pg(u32 gfp_mask, int order);
void mm_init(void);
extern u32 gmemsize;

/* when @size bytes required, we */
static inline int size2pages(int size){
	int  least_pages = (size + (PAGE_SIZE - 1)) >> PAGE_SHIFT;	
	/* round it to the power of 2 */
	return ceil2n(least_pages);
}
#endif



