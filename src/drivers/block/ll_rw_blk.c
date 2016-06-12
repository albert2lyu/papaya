//TODO init list head	LIST_HEAD_INIT
//TODO queue atomic operation
#include <linux/blkdev.h>
#include <schedule.h>
#include<utils.h>

static struct request rq_arr[MAX_REQUEST];
static struct queue_getter queue_getters[MAX_BLKDEV];

void register_queue_getter(int major, get_queue_fn *get_queue, void *data){
	assert(major < MAX_BLKDEV && major > 0);
	queue_getters[major].get_queue = get_queue;
	queue_getters[major].data = data;
}

/* give me a dev_id, return you the corresponding request_queue.
 * work flow: try 'get_queue' firstly which points to a certain getter imple-
 * mented by driver programmers.
 */
struct request_queue * blk_get_queue(u16 dev_id){
	struct queue_getter *getter = &queue_getters[MAJOR(dev_id)];
	if (getter->get_queue)
		return getter->get_queue(dev_id);	/*driver programmer need 'dev_id',
											  of course */
	else 
		return &getter->request_queue;
};

/*--------------------OK, we finished the 'queue fetch' function */
//i think this function may also need do 'cli'. linux0.11 didn't.
static struct request *get_free_request(void){
	for(int i = 0; i < MAX_REQUEST; i++){
		if(rq_arr[i].dev_id == 0) return rq_arr + i;
	}
	assert(0);
	return 0;
}

//static void end_request_common(u16 dev_id){}

/* 'generic' means most block device use this function making request. i.e.,
 * their 'make_request_fn' points here
 */
void generic_mk_request(u16 dev_id, int rw, unsigned start, int count, char *buf){
	cli_push();
	int major = MAJOR(dev_id);
	struct request * rq = get_free_request();
	rq->dev_id = dev_id;
	rq->cmd = rw;
	rq->start = start;
	rq->count = count;
	rq->buf = buf;
	rq->asker = current;

//	struct request_queue *q = blk_get_queue(dev_id);
	blk_devs[major].add_request(rq);	
	/*try trigger IO */
	/*
	if(q->running == false){
		q->running = true;
		blk_devs[major].do_request(dev_id);
	}
	*/
	flagi_pop();
}


void blkdev_layer_init(void){
	for(int i =0; i < MAX_BLKDEV; i++){
		//queue_getters[i].get_queue = 0;
	}
	for( int i = 0; i < MAX_REQUEST; i++){
		//rq_arr[i].dev_id = 0;	//unnecessary
		INIT_LIST_HEAD(&rq_arr[i].tentacle);
	}
}

//not correctly, we can't take partation as device, now.
int ll_rw_block(u16 dev_id, int rw, unsigned start, int count, char *buf){
//	struct request_queue *queue = 	blk_get_queue(dev_id);
	//oprintf("\nmake request:%u, %u, %u, %u, %x\n", dev_id, rw, start, count, buf);
	generic_mk_request(dev_id, rw, start, count, buf);
	return 0;
}

/*1, handle count larger than 256 sectors
 *2, this function is blocked
 */
int ll_rw_block2(u16 dev_id, int rw, unsigned start, int count, char *buf){
	unsigned curr = start;
	while(curr <= start + count - 1){
		int left = count - (curr - start);
		//1 block = 2 sectors
		/*TODO need more elegant code. 
		 * the following is critical area.
		 * we must ensure the disk IRQ won't issue before 'kp_sleep'.
		 * real machine can tolerate here without 'cli', but QEMU can not.
		 * In Qemu, the disk IRQ occurs before 'kp_sleep' done', so bugs occur.
		 */
		cli_push();
		ll_rw_block(dev_id, rw, curr, left < 256/2 ? left:128, buf);
		kp_sleep(0, 0);
		flagi_pop();
		/*-----critical area, end----- TODO use irq push pop */

		curr +=  128;
		buf+= 512;
	}
	return 0;	
}




