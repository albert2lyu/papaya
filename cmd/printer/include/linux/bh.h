#ifndef BH_H
#define BH_H

typedef int(*bh_fn)(void *data) ;
#define BH_FLAG_DISABLE 1
unsigned bh_flags;
static inline void bh_enable(void){
	bh_flags &= ~ BH_FLAG_DISABLE;	
}

static inline void bh_disable(void){
	bh_flags |= BH_FLAG_DISABLE;
}

int alloc_bh(bh_fn routine, void *data);
void free_bh(int bhid);
void mark_bh(int bhid);
void do_bh(void);

#endif
