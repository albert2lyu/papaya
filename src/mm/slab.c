#include<list.h>
#include<mm.h>
#include<linux/slab.h>

/* 'color' not implemented */
struct slab{
	struct list_head tentacle;
	unsigned short inuse;
	unsigned short free;	/* indicate the first free object, for quick allocation*/
	void * objs;
	//unsigned short objnum;	/* how many objects contained in this slab */
	unsigned short freelist[0];	/* array linked list, to hold free objects */
};

struct slab_head{
	struct list_head slabs_partial;
	struct list_head slabs_usedout;
	struct list_head slabs_fresh;

	struct list_head global;	/*also chained into global list of  cache descriptors */
	unsigned objsize;	/* type 'u16' is not enough */
	u16 objnum;	/* per slab */
	unsigned free_objs;	/*free objects count in total */
	unsigned gfporder;	/* 2^n pages per slab, gfporder is n*/
	unsigned gfpflags;	/* e.g. GFP_DMA */	
	const char *name;

	void (*ctor)(void *, struct slab_head *, unsigned);	/* constructor func */
	void (*dtor)(void *, struct slab_head *, unsigned); /* de-constructor func */
};

//如果对象很小，那实际的objs_per_slab会远大于8. 如果对象较大，一个page装不了8个，相应的算法会按8*objsize来申请多于1个页。申请到的空间（是连续页）至少能装8个objects。但因为要分配空间存放slab描述符和空闲对象链表数组，所以至少实际的slabhead->objnum=7。
#define OBJNUM_PER_SLAB 8

struct slab_head cache_cache[1];
/* 我们需要剥出来这个函数，因为在建立cache_cache这个slab队列时，是在slab尚未初始化的时候。
 * cache_cache这个slab_head本身是要手动分配的。 
 */
static inline int __register_slab_type(char *name, int objsize, 
								int offset, unsigned flags,
								void (*ctor)(void *, struct slab_head *, unsigned),
								void (*dtor)(void *, struct slab_head *, unsigned),
								struct slab_head *slabhead							
								)
{
	int granularity;
	if(flags & SLAB_HWCACHE_ALIGN){
		if(objsize >= L1_CACHLINE_SIZE) granularity = L1_CACHLINE_SIZE;
		else granularity = ceil2n(objsize);
	}
	else granularity = BYTES_PER_WORD;
	objsize = ceil_align(objsize, granularity);	

	int pages_wegot = size2pages(objsize * OBJNUM_PER_SLAB);	/*how many pages we got*/
	int size_wegot  = pages_wegot << 12;
	int right_size = (size_wegot - sizeof(struct slab) );
	int objnum_most = right_size / sizeof(struct page);
	unsigned obj_start = size_wegot - objsize * objnum_most;	/*not real start*/

	int padden = obj_start - sizeof(struct slab);
	/* (padden + x * objsize) / sizeof( short ) = objnum_most - x */
	int x;		/* reduce the number of object(by x) to make room for freelist arry */
	if( padden/2 >= objnum_most) x = 0;
	else x = ceil_div(2 * objnum_most - padden , objsize + 2);	
	int objnum = objnum_most - x;
	
	slabhead->objsize = objsize;
	slabhead->objnum = objnum;
	slabhead->gfporder = __BSR(pages_wegot);
	slabhead->gfpflags = 0;
	if(flags & SLAB_CACHE_DMA) slabhead->gfpflags |= __GFP_DMA;	/* TODO */
	slabhead->ctor = ctor;
	slabhead->dtor = dtor;
	slabhead->name = name;

	INIT_LIST_HEAD(&slabhead->slabs_usedout);
	INIT_LIST_HEAD(&slabhead->slabs_partial);
	INIT_LIST_HEAD(&slabhead->slabs_fresh);
	INIT_LIST_HEAD(&slabhead->global);
	list_add(&slabhead->global, &cache_cache->global);

	return 0;
}

static inline void page_mark_slab(struct page *page, struct slab *slab){
	page->lru.prev = (struct list_head *)slab;
}

static inline void page_mark_cache(struct page *page, struct slab_head *slabhead){
	page->lru.next = (struct list_head *)slabhead;
}

static inline int slab_queue_grow(struct slab_head *slabhead, int flags){
	struct slab *slab = (struct slab *)
						__alloc_pages(slabhead->gfpflags, slabhead->gfporder);
	slab->inuse = 0;
	slab->free = 0;
	slab->objs = (void *)((u32)slab + PAGE_SIZE * (1 << slabhead->gfporder) - \
											slabhead->objnum * slabhead->objsize);
	for(int i = 0; i < slabhead->objnum; i++){
		void *obj = slab->objs + slabhead->objsize * i;
		slab->freelist[i] = i + 1;
		if(slabhead->ctor) slabhead->ctor(obj, slabhead, flags);
	}

	int pgnr = 1 << slabhead->gfporder;
	struct page *page = virt_to_page(slab);
	for(int i = 0; i < pgnr; i ++){
		page_mark_slab(page + i, slab);
		page_mark_cache(page +i , slabhead);
	}
	
	list_add(&slab->tentacle, &slabhead->slabs_fresh);
	slabhead->free_objs += slabhead->objnum;
	return 0;
}

static inline void *slab_alloc_one(struct slab_head *slabhead, struct slab *slab){
	assert(slab->inuse != slabhead->objnum);
	int freeid = slab->free;
	void * obj = slab->objs + slabhead->objsize * freeid;
	slab->free = slab->freelist[freeid];
	slab->inuse ++;
	return obj;	
}

void * kmem_cache_alloc(struct slab_head *slabhead, unsigned flags){
	if( list_empty(&slabhead->slabs_partial) ){
		if( list_empty(&slabhead->slabs_fresh) ){
			slab_queue_grow(slabhead, flags);	/* @0 TODO */	
		}
		struct list_head *fresh = slabhead->slabs_fresh.next;
		list_del(fresh);
		list_add(fresh, &slabhead->slabs_partial);
	}
	struct slab *slab = MB2STRU(struct slab, slabhead->slabs_partial.next, tentacle);
	void *obj = slab_alloc_one(slabhead, slab);
	slabhead->free_objs --;
	if(slab->inuse == slabhead->objnum){	/* used out, so move it to 'slabs_usedout' */
		list_del(&slab->tentacle);	/* remove from 'slabs_partial' list */
		list_add(&slab->tentacle, &slabhead->slabs_usedout);
	}
	return obj;
}
struct slab_head * register_slab_type(char *name, int objsize, 
								int offset, unsigned flags,
								void (*ctor)(void *, struct slab_head *, unsigned),
								void (*dtor)(void *, struct slab_head *, unsigned)
								)
{
	struct slab_head *slabhead = kmem_cache_alloc(cache_cache, 0);
	__register_slab_type(name, objsize, offset, flags, ctor, dtor, slabhead);	
	return slabhead;
}

static inline void slab_free_one(struct slab_head *slabhead, struct slab *slab, int tofree){
	slab->freelist[tofree] = slab->free;
	slab->free = tofree;
	slab->inuse --;
}

void kmem_cache_free(struct slab_head *slabhead, void *obj){
	struct page *page = virt_to_page(obj);
	assert(page->lru.next == (void *)slabhead);

	struct slab *slab = (void *)page->lru.prev;
	int tofree = (obj - slab->objs) / slabhead->objsize;
	slab_free_one(slabhead, slab, tofree);
	slabhead->free_objs ++;

	if(slab->inuse == slabhead->objnum - 1){	/* it's a 'usedout' slab just now */
		list_del(&slab->tentacle);
		list_add(&slab->tentacle, &slabhead->slabs_partial);
	}
	else if(slab->inuse == 0){
		list_del(&slab->tentacle);
		list_add(&slab->tentacle, &slabhead->slabs_fresh);
	}
	else;
}
struct cache_size{
	int size;
	struct slab_head *slabhead;
	struct slab_head *slabhead_dma;
};

#define COMMON_CACHE_NUM 12 
#define COMMON_CACHE_MIN 32
struct cache_size malloc_sizes[COMMON_CACHE_NUM];

/* optimization needed here, how to guarantee SLAB_FLAG won't be messed up with __GFPxx
 * i want let kmem_cache_alloc do the memory cleaning when meet __GFP_ZERO 
 */
void *kmalloc2(unsigned size, unsigned flags){
	for(int i = 0; i <COMMON_CACHE_NUM; i++ ){
		if(malloc_sizes[i].size >= size){
			void *obj =  kmem_cache_alloc(flags & __GFP_DMA ?
					malloc_sizes[i].slabhead_dma : malloc_sizes[i].slabhead, flags);
			if(obj && (flags & __GFP_ZERO)) memset(obj, 0, size);
			return obj;
		}
	}
	assert("too big size" && 0);
	return NULL;
}

void kfree2(void *obj){
	struct page *page = virt_to_page(obj);
	kmem_cache_free((struct slab_head *)page->lru.next, obj);
}

/* invoked during system initialization */
void kmem_cache_init(void){
	__register_slab_type("slab_head", sizeof( struct slab_head), 0, SLAB_HWCACHE_ALIGN, 
							NULL, NULL, cache_cache);	
	
	for( int i = 0; i < COMMON_CACHE_NUM; i++){
		int size = COMMON_CACHE_MIN << i;
		malloc_sizes[i].size = size;
		malloc_sizes[i].slabhead = register_slab_type( "common", size,
									0, 0, NULL, NULL);
		malloc_sizes[i].slabhead_dma = register_slab_type( "common_dma", size,
									0, SLAB_CACHE_DMA, NULL, NULL);
	}
}

void *address[2048];
struct slab_head *slabheads[128];
int cur_idx;
void __kmem_cache_alloc_free(struct slab_head *slabhead, int nr_repeat){
	assert(nr_repeat < 2048);
	/*保证alloc的次数是objnum_per_slab的整数倍*/
	nr_repeat = (nr_repeat / slabhead->objnum + 1) * slabhead->objnum;
	int i;
	int j;
	for(i = 0; i < nr_repeat; i++){	/* do allocation */
		address[i] = kmem_cache_alloc(slabhead, 0);
	}
	for(i = 0; i < nr_repeat; i++){	/* free them */
		kmem_cache_free(slabhead, address[i]);
	}
	for(i = 0; i < nr_repeat; i++){	/* do allocation */
		void * obj = kmem_cache_alloc(slabhead, 0);
		for(j = 0; j < nr_repeat; j++){
			if( obj == address[j] ){
				/* memory trample */
				memset(obj, 1, slabhead->objsize);
				address[j] = 0;
				oprintf(". ");
				break;
			}
		}
		assert(j != nr_repeat);
	}
}

void kmem_cache_alloc_free(char *name, int size, unsigned flags, int nr_repeat){
	assert(nr_repeat < 2048);
	struct slab_head *slabhead = kmem_cache_create(name, size, 0, flags, 0, 0);
	__kmem_cache_alloc_free(slabhead, nr_repeat);
	slabheads[cur_idx++] = slabhead;
}
void kmem_cache_test(void){
	/*1,反复分配和释放*/	
	/*
	kmem_cache_alloc_free("5B", 5, SLAB_HWCACHE_ALIGN|SLAB_CACHE_DMA, 100);
	kmem_cache_alloc_free("15B", 15, SLAB_HWCACHE_ALIGN, 100);
	kmem_cache_alloc_free("31B", 31, SLAB_HWCACHE_ALIGN, 100);
	kmem_cache_alloc_free("33B", 33, SLAB_HWCACHE_ALIGN, 100);
	*/
	for (int i = 0; i < COMMON_CACHE_NUM; i++){
		int j;
		for(j  =0 ; j < 100; j++){
			void *obj = kmalloc2( malloc_sizes[i].size - 1 , __GFP_DMA);
			assert(obj);
			address[j] = obj;
			memset(obj, 0xcc, malloc_sizes[i].size);	/* memory trample */
		}
		/*内存肯定还是够的，但free出现了问题*/
		for(j  =0 ; j < 100; j++){
			kfree2(address[j]);	
		}
	}
}

// TODO: 将来单独实现这个函数；  foo heap； size和objnum分开，是为了顺便对齐
void * static_alloc(int objsize, int objnum){
	assert(objsize %4 == 0 && objnum > 0 && objnum < 2048);	//2048, just ...
	return kmalloc2(objsize * objnum, __GFP_ZERO);
}





