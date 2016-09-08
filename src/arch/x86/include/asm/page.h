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


// >不一定比“|, &"用起来更方便。先局部的用一用，尤其是pte
// >这样，一个普通的整形变成了union，其实是反而隐藏了类型信息。但不妨一试。
//  毕竟pte是特殊的，基础的，读者常常知道pte是个unsigned。
#pragma pack(push)
#pragma pack(1)
union pte{
	int value; 		
	struct {
		unsigned present: 1;
		unsigned writable: 1;
		unsigned user: 1;
		unsigned PWT: 1;
		unsigned PCD: 1;
		unsigned accessed: 1;
		unsigned dirty: 1;
		unsigned : 2;
		unsigned avl: 3;
		unsigned physical: 20;
	};
};

union linear_addr{
	unsigned value;
	struct{
		unsigned offset: 12;
		unsigned tbl_idx: 10;
		unsigned dir_idx: 10;
	};
};

union cr3{
	int value; 		
	struct {
		unsigned : 12;
		unsigned physical: 20;
	};
};
#pragma pack(pop)

#endif
