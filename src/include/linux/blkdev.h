#ifndef BLKDEV_H
#define BLKDEV_H
#include <valType.h>
#include <list.h>
#include<proc.h>
#define READ 0
#define WRITE 1
#define MAJOR(dev_id)  ((dev_id) >> 8)
#define MAX_BLKDEV 200
#define MAX_REQUEST 32
#define MINOR(dev_id) ((dev_id) & 0xff)
#define BLOCK_SIZE 1024

#define SYSID_EXTEND 0X5
#define SYSID_LINUX 0X83
#define SYSID_FAT16 0X6
#define SYSID_FAT32 1 
#define SYSID_NTFS 0x7
#define SYSID_CELL 0x20
struct partition{
	char boot;
	char start_head;
	char _start_sector;
	char start_cylender;

	char sys_id;//means the fs type ID.
	char end_head;
	char end_sector;
	char end_cylender;

	unsigned start_sector;
	unsigned total_sectors;
};

struct request{
	struct list_head tentacle;
	u16 dev_id;
	int cmd;
	unsigned start;
	int count;
	char *buf;
	struct pcb *asker;
};
/* block unit: a dev-major owns many block units, for example, an IDE channel 
 * can have two hard disks, and this is not the end --- each disk has several
 * partations which are called block units
 */
struct blk_unit {
	/* the start sector id and total sectors of a block units.
	 * we don't want to touch the concept of 'sector' in block layer, but 
	 * there's no way, a disk-partation is not promised aligned on BLOCK_SIZE
	 */
	unsigned start_sector;
	unsigned total_sectors;
};
struct blk_dev{
	/*@dev_id we need it to acknowledge the device-major, because, for example,
	 * the primary IDE channel(major 3) and the secondary IDE(major 22) share
	 * a same "do_request()", so do_request need to know service for whom*/
	void (*do_request)(u16 dev_id);			
	void (*add_request)(struct request *rq);

	struct blk_unit **units;
};
struct blk_dev blk_devs[MAX_BLKDEV];
struct request_queue{
	struct list_head  queue_head;	
	/* make_request是块设备操作的通用例程，按正常思维，是不随queue而变的，
	 * 是通用的，不应该放在queue里，应该独立成正常的函数。
	 * 但事实上，有些情况下会随queue而变，例如有些“设备”是虚拟的，中间层，对
	 * 它们的操作请求，会转变成对更底层设备的请求。 所以它们的make_request不
	 * 一样。
	 * 感觉很脏。
	 */
	//void (* mk_request)(u16 dev_id, int rw, unsigned start, int count, char *buf);
	/* do_request points to function implemented by driver programmers,
	of course. because it is it operating the device IO port */
	//void (*do_request)(struct request_queue *q);
	char running;	/*whether the IO is running. 
					  Note! for IDE disk, if it's queue is empty, the 'running'
					  field can be still true. for one IDE channel owns two
					  disks, and they share one 'current-request' */
};

/*for most circumstances, one device major corresponds to one queue, but for 
 *some 'major'(e.g. IDE), every child device owns a queue. so we need a getter.
 */
typedef struct request_queue * (get_queue_fn)(u16 dev_id);	/*access 1*/
struct queue_getter{
	struct request_queue request_queue;		/*access 2*/
	get_queue_fn * get_queue;	/*access 1*/
	void *data;		/* set by driver programmers to help himself implement
						the 'blk_get_queue(), for he usually need some addi-
						tional data when searching the corresponding queue*/
};

struct request_queue * blk_get_queue(u16 dev_id);

int ll_rw_block2(u16 dev_id, int rw, unsigned start, int count, char *buf);
int ll_rw_block(u16 dev_id, int rw, unsigned start, int count, char *buf);
void register_queue_getter(int major, get_queue_fn *get_queue, void *data);
#endif
