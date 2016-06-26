#ifndef SLAB_H
#define SLAB_H

struct slab_head;
#define SLAB_HWCACHE_ALIGN 1
#define SLAB_CACHE_DMA 2
#define SLAB_ZERO 4

#define L1_CACHLINE_SIZE 32
#define BYTES_PER_WORD 4

//kenrel level API, for linux compatible
struct slab_head * register_slab_type(char *name, int objsize, 
								int offset, unsigned flags,
								void (*ctor)(void *, struct slab_head *, unsigned),
								void (*dtor)(void *, struct slab_head *, unsigned)
								);
#define kmem_cache_create register_slab_type
void *kmalloc2(unsigned size, unsigned flags);
void kfree2(void *obj);
void * kmem_cache_alloc(struct slab_head *slabhead, unsigned flags);
void kmem_cache_free(struct slab_head *slabhead, void *obj);
void kmem_cache_init(void);
void kmem_cache_test(void);
#endif
