#ifndef PAGE_H
#define PAGE_H

#define PAGE_SHIFT 12
#define PAGE_SIZE 0x1000
#define pa_idx(paddr) ((paddr)>>PAGE_SHIFT)

#define PG_P 1
#define PG_NP 0
#define PG_USU 4
#define PG_USS 0
#define PG_RWW 2
#define PG_RWR 0
#define PG_H10(pg_id) (pg_id>>10)
#define PG_L10(pg_id) (pg_id&(0x400-1))
#endif
