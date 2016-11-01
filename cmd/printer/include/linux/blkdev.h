#ifndef BLKDEV_H
#define BLKDEV_H
#include <valType.h>
#include <list.h>
#include<proc.h>
#include<linux/buffer_head.h>
#define READ 0
#define WRITE 1
#define MAJOR(dev_id)  ((dev_id) >> 8)
#define MINOR(dev_id) ((dev_id) & 0xff)
/* 下面这个宏是为了以后扩大minor, 255个可能会不够用 */
#define MKDEV(major, minor) ( ((major) << 8) + minor )	

/* a dangerous macro, take care */
#define BLK_UNIT(dev_id) (blk_devs[ MAJOR(dev_id) ].units[MINOR(dev_id)])

#define MAX_BLKDEV 200
#define MAX_REQUEST 32
#define BLOCK_SIZE 4096		/* 读写块设备的基本单位是4K.主要原因是:
							> 1k的话, 无法保证在一个物理页内的连续.不利于mmap()
							> 况且, 现代的硬盘设备, 不在乎多读几个扇区
							> 唯一可能就是对小文件不太友好. 因为文件系统通常
							  是把块设备的block size作为自己的block size, 但真
							  要硬着头皮, 也能做出来适合小文件的1K粒度的文件系统
							*/

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
	unsigned start;		//start block id
	int count;			//block count
	char *buf;
	struct pcb *asker;
	struct buffer_head *bh;
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
	unsigned start_sector;		/*这儿将来改成start_block, 不考虑非4K情况*/
	unsigned total_sectors;
	struct list_head *hotable;	/*热表 或 缓冲块表 */
	int hotable_len;			/* 热表长 或 缓冲块表长, 
								也许更好的名字是hotable_entnum,
								注意! 单位是element, 不是byte */
	#define HOTABLE_LEN2 64		/*碰撞调解链的长度上限. 太长了会慢
								8K的哈希表映射256M, 8M能映射256G的缓冲块
								很够了, 内存也没那么大*/
	u32 dev_id;
	bool hanzi;		/*含子的中文拼音. 因为有些unit不是纯粹的分区, 像次设备号
					  为0时, 指代整个硬盘. 像扩展分区, 它包含了所有的逻辑分区
					  所以用户访问这样的unit时, 我们先尝试把这次请求转成一个
					  针对普通的其内含分区的请求, 当然, 这种转化可能失败 
					  例如硬盘有未分区的地方, 扩展分区未分给逻辑磁盘的地方*/
};
struct blk_dev{
	/*@dev_id we need it to acknowledge the device-major, because, for example,
	 * the primary IDE channel(major 3) and the secondary IDE(major 22) share
	 * a same "do_request()", so do_request need to know service for whom*/
	void (*do_request)(u32 dev_id);			
	void (*add_request)(struct request *rq);
	void (*global2local)(u32 *dev, ulong *block);

	/* 像8号major, SCSI硬盘, 容纳16个硬盘, 每个硬盘16个分区(0号其实不是)
	   那它的unitmax就是255, unitcycle就是16.
	   像3号major, IDE硬盘, 容纳两个硬盘, 每个硬盘64个分区
	   那它的unitmax就是128, unitcycle就是64.
	   之所以存放的是unitmax, 而不是physical_max,(上例中分别是16和2)
	   是因为unitmax使用的更频繁, 而physical_max(即物理设备)用得不多
	 */
	struct blk_unit **units;
	int unitmax;		//并不总是255,像IDE,最多64个分区
	int unitcycle;		//每个物理设备
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

int ll_rw_blocks(u32 dev_id, int rw, ulong start, ulong count, void *buf);
//int ll_rw_block(u16 dev_id, int rw, unsigned start, int count, char *buf);
int ll_rw_block(int rw, struct buffer_head *bufferhead);
void register_queue_getter(int major, get_queue_fn *get_queue, void *data);

void register_blkunit(struct blk_unit *unit, u32 dev);
void register_blkdev(int major);
struct buffer_head *mmap_disk(u32 dev, ulong block);
void munmap_disk(struct buffer_head *block);

void init_blklayer_basic(void);
void init_blklayer(void);


void generic_mk_request(int rw, struct buffer_head *bh);

/* 这几个宏将来会挪回ide.c里, 因为现在blk_unit的存储512. 所以少不了用这几个宏*/
#define BLOCK_SECTORS (BLOCK_SIZE / 512)
#define block2sectors(blocknum) ( (blocknum )* BLOCK_SECTORS)
#define block2lba block2sectors
#define lba2block(lba) ( (lba) / BLOCK_SECTORS)

#endif
