#include<asm/bit.h>
#include<linux/bh.h>
#include<linux/slab.h>
#include<utils.h>

#define NUM_BH 32
static unsigned active;	/* bitmap for active bh */
static unsigned using;		/* bitmap for allocated/free bh slot */
static struct bh{
	bh_fn routine;
	void *data;
}bh_strus[NUM_BH];

void bh_init(void){
	assert(active * using == 0);
}

void do_bh(void){
	int id;
	unsigned shadow;

	bh_disable();
	cli();

	repeat:
	shadow = active;
	active = 0;
	sti();
	while( (id = __bs(shadow)) != -1 ){
		__btr(&shadow, id);		/* clear active bit, for later scanning*/
		struct bh *bh = bh_strus + id;		assert( bh->routine );
		bh->routine( bh->data );
	}
	cli();
	if(active){
		//oprintf(" active again during just bh routine, do it\n");
		goto repeat;
	}
	bh_enable();
}

int alloc_bh(bh_fn routine, void *data){
	oprintf(">");
	int id = __bs0s(&using);		
	if(id == -1) spin("bh allocation failed");
	assert(!__bt(&active, id));
	bh_strus[id].routine = routine;
	bh_strus[id].data = data;
	return id;
}

void free_bh(int id){
	if(id < 0 || id > NUM_BH) spin(" illegal bh id to free");	
	if(!__bt(&using, id)) 	spin("attempt to free a non-using bh");
	if(!__bt(&active, id)) spin("attempt to free an active bh");

	__btr(&using, id);	
}

void mark_bh(int id){
	if(id < 0 || id > NUM_BH) spin(" illegal bh id to mark");	
	if(!__bt(&using, id)) 	spin("attempt to mark a non-using bh");
	//if(!__bt(&active, id)) spin("this bh is already active");

	__bts(&active, id);
}




