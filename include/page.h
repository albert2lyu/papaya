#ifndef X86_PAGE_H
#define X86_PAGE_H

#define PAGE_SHIFT 12
#define PAGE_SIZE 0x1000
#define pa_idx(paddr) ((paddr)>>PAGE_SHIFT)
#define pa_pg pa_idx

#define PG_P 1
#define PG_NP 0
#define PG_USU 4
#define PG_USS 0
#define PG_RWW 2
#define PG_RWR 0
#define PG_COW (1<<8)
/*TODO cancell the following two macros, and 'vpg', 'ppg' is a good transfer*/
#define PG_H10(pg_id) (pg_id>>10)
#define PG_L10(pg_id) (pg_id&(0x400-1))

#define invlpg(vaddr) __asm__ __volatile__("invlpg %0": :"r"(vaddr)) 
#define FLUSH_TLB __asm__ __volatile__("mov %%cr3, %0\n\t"	\
										"mov %0, %%cr3\n\t"\
										:\
										:"r"(0));

/*get page struct by a virtual address*/
#define __va_pg(vaddr) (mem_map + (((vaddr) - PAGE_OFFSET) >> 12))
#define __pa_pg(paddr) (mem_map + ((paddr) >> 12))
#endif
