#ifndef PMM_H
#define PMM_H
#include<valType.h>
#include<page.h>

#define KV(physical_addr) ((u32)(physical_addr)+PAGE_OFFSET)
//for kmalloc
//16M ~ 18M occupied by ramdisk
#define HEAP_BASE 18*0x100000
#define HEAP_SIZE (64*0x100000)
typedef struct empty_blockk{
	struct empty_blockk*prev;
	struct empty_blockk*next;
	int size;
}EMPTY_BLOCK;
#define BLOCK_DATA_END(block) ((int)((char*)block+sizeof(EMPTY_BLOCK)+block->size-1))
void*kmalloc(int byte);
void kfree(void*pt);
void heap_init(void);
void del_node(EMPTY_BLOCK*block);
void insert_after(EMPTY_BLOCK*mother,EMPTY_BLOCK*block);


#endif
