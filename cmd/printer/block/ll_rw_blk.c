//TODO init list head	LIST_HEAD_INIT
//TODO queue atomic operation
#include <linux/blkdev.h>
#include <schedule.h>
#include<utils.h>
#include<linux/buffer_head.h>

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
 * TODO make_request而异, 就不要区分了吧.
 */
//void generic_mk_request(u16 dev_id, int rw, unsigned start, int count, char *buf){
void generic_mk_request(int rw, struct buffer_head *bh){
	cli_push();
	int major = MAJOR(bh->dev_id);
	struct request * rq = get_free_request();
	rq->bh = bh;
	rq->dev_id = bh->dev_id;
	rq->cmd = rw;
	rq->start = bh->block;
	rq->count = 1;
	rq->buf = bh->data;
	rq->asker = current;

	blk_devs[major].add_request(rq);	//硬盘闲的话, 这儿会触发IO
	flagi_pop();
}


void init_blklayer_basic(void){
	for(int i =0; i < MAX_BLKDEV; i++){
		//queue_getters[i].get_queue = 0;
	}
	for( int i = 0; i < MAX_REQUEST; i++){
		//rq_arr[i].dev_id = 0;	//unnecessary
		INIT_LIST_HEAD(&rq_arr[i].tentacle);
	}
}

//not correctly, we can't take partation as device, now.
//TODO bh->lock bh->uptodate
//linux里, 在add_request里, 检查了bh->dirty和uptodate字段,
//我们的ll_rw_block不这样做, 我们忠实的执行buffer层的调用.
//int ll_rw_block(u16 dev_id, int rw, unsigned start, int count, char *buf){
int ll_rw_block(int rw, struct buffer_head *bh){
//	struct request_queue *queue = 	blk_get_queue(dev_id);
	//oprintf("\nmake request:%u, %u, %u, %u, %x\n", dev_id, rw, start, count, buf);

	/* 将来这部分代码会简单一些.
		将来不会再用512作为blk_unit的存储单位.
		真的, 你要是怕, 还不如用byte, 一劳永逸.
		要不然就大胆的用4K. 也省得这儿麻烦 
	*/
	u32 dev_id = bh->dev_id;
	struct blk_unit *unit = BLK_UNIT(dev_id);
	u32 rw_start = block2lba( bh->block );
	u32 rw_sectors = block2sectors( bh->count );
	u32 rw_end = rw_start + rw_sectors;
	if(rw_end <= unit->total_sectors);
	else spin("ll_rw out-of-boundray");

	bh->lock = true;
	generic_mk_request(rw, bh);
	return 0;
}









