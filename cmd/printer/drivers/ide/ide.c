/*TODO 
  > we need do more argument check
  > IEDNITY没调通, 目前初始化unit[0]时指定的400M
    写入命令后中断有上来, 但是读出来的信息全是0. 
	identify_intr里调用win_result检查会assert住.
 */
#include<linux/ide.h>
#include<irq.h>
#include<schedule.h>
#include<linux/buffer_head.h>

static struct request * ide_get_next_rq(struct ide_hwif *hwif);
static void ide_do_request(u32 dev_id);
/*基本上是按0.11来的，同时又向上遵循2.4的块设备接口。
*/
/*do_rw_disk() issues READ and WRITE commands to a disk
 */
/* 0-63是硬盘1(master), 64-127是硬盘2(slave) */
#define DEVICE_NR(dev_id) (MINOR(dev_id) / 64)

#define CURR_HWIF(dev_id) (ide_hwifs + channel_id(dev_id))
#define MAX_HWIFS 3
/* this array may be a waste of memory, because IDE-devices are disappearing,
 * and, why not use a pointer array instead?  ... i don't know. Anyway, linux2.4
 * is doing just that*/
static struct ide_hwif ide_hwifs[MAX_HWIFS] = {
	[0] = {
		.io_ports={0x1f0, 0x1f1,0x1f2,0x1f3,0x1f4,0x1f5,0x1f6,0x1f7,0x3f6},		
	},
	[1] = {
		.io_ports={0x170, 0x171,0x172,0x173,0x174,0x175,0x176,0x177,0x3f6},		
	},
};

static void add_request(struct request * rq);

/*block device major => IDE channel 0: 3th;  IDE channel 1: 22th */
static int  channel_id(int dev_id){
	return MAJOR(dev_id) / 22;
}
static struct request *tentacle2request(struct list_head *head){
	return MB2STRU(struct request, head, tentacle);
}

#if 1
static void* ide_identify(u32 dev_id){
	struct request * rq;

	int IF = cli_ex();
	//关中断, 保证当前进程能睡眠成功?
	//因为害怕刚发送命令,中断就来了,以至于唤醒一个running tsk
	rq = kmalloc0( sizeof( struct request) );
	rq->dev_id = dev_id;
	rq->buf = __alloc_page(__GFP_ZERO);
	rq->cmd = WIN_IDENTIFY;
	rq->asker = current;
	add_request(rq);
	kp_sleep(0, 0);

	if(IF) sti();
	return (void *)rq->buf;
}
#endif

/* 在ide_read_partation时, 读取mbr, ebr都调用了disk_mmap, 
 * 而且用的是(整硬盘寻址). 那时的虽然也经过这个函数, 但
 * 因为几个分区都没初始化, 相当于绕过了这个函数.
 * 所以, 尽量不要在那时读分区内部的块, 即使读了, 也要
 * 立刻释放. 不然以后会出现一个"硬盘块"对应多个"缓冲块"的
 * 情况.
 */
static void global2local(u32 *_dev, ulong *_block){			
	struct blk_dev *blkdev;
	struct blk_unit **units;

	u32 dev = *_dev;
	ulong block = *_block;
	u32 major = MAJOR(dev);
	u32 minor = MINOR(dev);
	blkdev = blk_devs + major;	
	units = blkdev->units;									asrt(units[minor]);
	if(!units[minor]->hanzi)	return;
	
	//认定它的子分区的id一定比它大 ,像0号代表整个磁盘, 我们
	//就从1号开始搜; 像x号表示扩展分区, 我们就从x+1号开始
	for(int i = minor % blkdev->unitcycle + 1;
		i < blkdev->unitcycle; i++)
	{
		struct blk_unit *unit  = blkdev->units[ minor + i];
		if(!unit) continue;
		
		int lba_offset = block2lba(block) - unit->start_sector;
		if(lba_offset >= 0 && 
			lba_offset < block2sectors(unit->total_sectors))
		{													u32 newdev = MKDEV(major, minor + i);
															oprintf(">>redirect %x to %x:%x>>>", dev,
																	newdev, lba_offset / BLOCK_SECTORS);
			*_dev = MKDEV(major, minor + i);
			*_block = lba_offset / BLOCK_SECTORS;
			if(unit->hanzi) global2local(_dev, _block);
		}
	}
}
/*delete current and choose next request as current */
void ide_end_request(struct ide_hwif *hwif){				 assert(hwif->cur_rq);
	struct buffer_head *bh;
	struct request *to_del;

	to_del = hwif->cur_rq;
	bh = to_del->bh;	
	hwif->cur_rq = ide_get_next_rq(hwif);
	list_del_init(&to_del->tentacle);
	to_del->dev_id = 0;
	hwif->handler = 0;

	bh->lock = false;		//解锁
	bh->dirty = false;		//块已经干净了
	bh->io = true;			//IO成功

	wake_up(&bh->wait);
}

static int win_result(struct ide_hwif *hwif){
	int i = in_byte(hwif->io_ports[SLOT_REG_STATUS]);
	if( (i & (STATUS_BUSY | STATUS_READY | STATUS_WRERR | STATUS_SEEK | STATUS_ERR)) == (STATUS_READY | STATUS_SEEK) )	\
		return 0;
	if(i & STATUS_ERR) i = in_byte(hwif->io_ports[SLOT_REG_ERROR]);//read error register
	return i;
}
static void identify_intr(struct ide_hwif *hwif){			
	asrt( win_result( hwif) == 0);	//re-enable interrupt
	struct request *cur_rq = hwif->cur_rq;
	port_read(hwif->io_ports[SLOT_REG_DATA], cur_rq->buf, 512);	
	//还需要读status寄存器, 来enable下一次中断.
	hwif->cur_rq = ide_get_next_rq(hwif);
	list_del_init(&cur_rq->tentacle);
	hwif->handler = 0;
	
	sleep_active(cur_rq->asker);
	ide_do_request(cur_rq->dev_id);	
}
//static void read_intr(struct ide_drive *drive){
//i think we just need to know the intr from which channel
static void read_intr(struct ide_hwif *hwif){
	if(win_result(hwif)){
		assert(0);
	}
	//如果是多扇区写，就是通过这个if和return来支持的。
	struct request *cur_rq = hwif->cur_rq;
	//oprintf(" %u => %x @%s", cur_rq->count, cur_rq->buf, cur_rq->asker->p_name);
	port_read(hwif->io_ports[SLOT_REG_DATA], cur_rq->buf, 512);	
	if(--cur_rq->count){
		cur_rq->buf += 512;
		oprintf("%c", 0xfe);
		return;
	}
	ide_end_request(hwif);
	ide_do_request(cur_rq->dev_id);	
}

static void write_intr(struct ide_hwif *hwif){
	if(win_result(hwif)){
		assert(0);
	}
	struct request *cur_rq = hwif->cur_rq;
	if(--cur_rq->count){
		cur_rq->buf += 512;	//Note, we move buffer pointer before do write. this
							// is different from read_intr().
		port_write(hwif->io_ports[SLOT_REG_DATA], cur_rq->buf, 512);
		return;
	}
	ide_end_request(hwif);
	ide_do_request(cur_rq->dev_id);
}

static void ide_intr(int irq, void *_hwif, struct pt_regs *reg){
	assert(((struct ide_hwif *)_hwif)->handler);
	//oprintf("ide intr invoked\n");
	((struct ide_hwif*)_hwif)->handler(_hwif);
}


/*get drive */
static struct ide_drive *get_info_ptr(u16 dev_id){
	int unit = DEVICE_NR(dev_id);
	int channel = channel_id(dev_id);	
	return &ide_hwifs[channel].drive[unit];
}

/*issue to which channel, which driver */
void hd_out(int *io_ports, int cmd, int drv, int lba, int count, void *buf){
	while(in_byte(io_ports[SLOT_REG_STATUS]) & STATUS_BUSY) oprintf("@hd_out waiting on IDE controllor's BSY-bit\n");
	oprintf("writing IDE registers\n");
	//activate the interrupt enable bit

	struct lba *lba_stru = (struct lba *)(&lba);
	struct select * select = &(lba_stru->select);
	select->drv = drv;
	select->lba = 1;
	select->bit5 = select->bit7 = 1;

	out_byte(io_ports[SLOT_REG_CONTROL],0);				// 0x3f6

	out_byte(io_ports[SLOT_REG_FEATURES], 0);				// 0x1f1  写前预补偿
	out_byte(io_ports[SLOT_REG_COUNT],count);				// 0x1f2
	out_byte(io_ports[SLOT_REG_LBA_LOW],lba_stru->low);	// 0x1f3
	out_byte(io_ports[SLOT_REG_LBA_MID],lba_stru->middle);	// 0x1f4
	out_byte(io_ports[SLOT_REG_LBA_HIGH],lba_stru->high);	// 0x1f5
	out_byte(io_ports[SLOT_REG_DEVICE], *(u8 *)select);		// 0x1f6
	out_byte(io_ports[SLOT_REG_COMMAND], cmd);				// 0x1f7
}

//@drive seems not needed
static void __start_request(struct request *rq){
	int ctrl;
	struct ide_hwif *hwif = &ide_hwifs[channel_id(rq->dev_id)];
	if(rq->cmd == READ){
		ctrl = WIN_READ;
		hwif->handler = read_intr;		
	}
	else if(rq->cmd == WRITE){
		ctrl = WIN_WRITE;
		hwif->handler = write_intr;		
	}
	else if(rq->cmd == WIN_IDENTIFY){ //内部命令
		hwif->handler = identify_intr;
		ctrl = WIN_IDENTIFY;
	}
	else assert(0);
	//收到的请求是以块为单位的, 在发送前转化成扇区
	//TODO 有必要修改request结构体吗?
	if(ctrl != WIN_IDENTIFY){
		rq->start = BLK_UNIT(rq->dev_id)->start_sector + block2sectors(rq->start);
		rq->count *= BLOCK_SECTORS;		/*rq->count永远是1呀*/
	}
	hd_out(hwif->io_ports, ctrl, DEVICE_NR(rq->dev_id),rq->start, rq->count, rq->buf);

	//only about 400ns, we wait it
	if(rq->cmd == WRITE){
		int i;
		int waiting = 3000 * 100;
		for(i = 0; i < waiting && STATUS_DRQ == 0; i++);
		assert(i != waiting && "waiting DRQ changes to 1, overtime ");
		port_write(hwif->io_ports[SLOT_REG_DATA], rq->buf, 512);	
	}
		
	//write drive->io_ports[]
}
/*1, @dev_id, we just want to know to process which IDE channel.
 *2, ide_do_request always regard 'cur_rq' as done job , he trys to fetch the next
 */
static void ide_do_request(u32 dev_id){
	/*we should know the channel id first, different IDE channel is taked as diff-
	 * erent major block devices*/
	struct ide_hwif *hwif = ide_hwifs + channel_id(dev_id);
	if(!hwif->cur_rq){
		//oprintf("[rq list empty now!] ");
		static int empty_count;
		oprintf("[E %u] ", empty_count++);
		return;
	}
	__start_request(hwif->cur_rq);
}

static struct request_queue * ide_get_queue(u16 dev_id){
	struct ide_drive * drive = get_info_ptr(dev_id);
	if(drive) return &drive->queue;
	return 0;
}

static void add_request(struct request * rq){
	int dev_id = rq->dev_id;
	int major = MAJOR(dev_id);								
	struct request_queue *q = blk_get_queue(dev_id);	
	struct ide_hwif * hwif = ide_hwifs + channel_id(dev_id);

	cli_push();
	list_add(&rq->tentacle, &q->queue_head);
	flagi_pop();
	if(!hwif->cur_rq){
		hwif->cur_rq = rq;
		blk_devs[major].do_request(dev_id);
	}
}
/* i implement function to initialze the second IDE channel but just do implem-
 * ention and never call it. i don't know how to identify the second IDE channel
 * and i even don't want to learn about it. i doubt no body use a secondary IDE 
 * disk nowadays, let alone channel.
 *
 * 我们在read_partation阶段, 把生成
 *
*/
void ide_read_partation(int major, int drive){
	struct buffer_head *ebr_block = 0, 
					   *mbr_block = 0;
	struct blk_dev *blkdev = &blk_devs[major];
	struct blk_unit **units = blkdev->units;

	if(!units) {											assert(blkdev->unitmax == 128);
		units = (void *)kmalloc0(4 * blkdev->unitmax);
		blkdev->units = units;
	}
	/*try initialize device 0/64 firstly, i.e. whole disk*/
	int i = drive * blkdev->unitcycle;	//0 or 64
	int disk_devid = MKDEV(major, i);
	u16 *disk_info = ide_identify(disk_devid);
	u32  disk_sectors = *(u32 *)(disk_info+60);


	if(!units[i])	
		units[i] = kmalloc0(sizeof(struct blk_unit));
	units[i]->start_sector = 0;
	units[i]->total_sectors = disk_sectors;
	units[i]->hanzi = true;
	register_blkunit( units[i], disk_devid );	

	mbr_block = mmap_disk(disk_devid, 0);					asrt(mbr_block);
	char *mbr = mbr_block->data;
	//ll_rw_block2(disk_devid, READ, 0, 1, mbr);
	struct partition *dp = (void *)(mbr + 446);
	int ebr_lba = 0;
	//note! extend-partation may not be the 4th partation
	for(i = 0; i <=3; i++){
		int uid = i + 64*drive + 1;	/*device unit id*/
		if(dp[i].start_sector == 0) 
				continue;	/* ignore empty entry */
		if(!units[uid]) 
			units[uid] = kmalloc( sizeof(struct blk_unit) );
		units[uid]->start_sector = dp[i].start_sector;
		units[uid]->total_sectors = dp[i].total_sectors;
		units[uid]->hotable = 0;	/* MUST */

		if(dp[i].sys_id == SYSID_EXTEND) {
			ebr_lba = dp[i].start_sector;
			units[uid]->hanzi = true;
		}
		else units[uid]->hanzi = false;
		register_blkunit(units[uid], MKDEV(major, uid));
	}
	
	/* 怎么识别最后一个逻辑分区，是dp[0].start_sector，
	 * 还是dp[1].start_sector。 */
	next_ebr:
		if(ebr_lba == 0) goto done;							oprintf("\nread next ebr");
		//ll_rw_block2(disk_devid, READ, ebr_lba/2, 1, mbr);	
		if(ebr_block) munmap_disk(ebr_block);
		ebr_block = mmap_disk(disk_devid, lba2block(ebr_lba) );
		dp = (void *)(ebr_block->data + 446);
		int uid = i + 64 * drive + 1;						/*TODO 一个空的扩展分区会触发这里 */
															assert(dp[0].start_sector);	 
		/*OK, this EBR precedes a logical partition*/
		if(!units[uid]) //没必要用if吧
			units[uid] = kmalloc( sizeof(struct blk_unit));
		units[uid]->start_sector = ebr_lba + dp[0].start_sector;
		units[uid]->total_sectors = dp[0].total_sectors;
															
		//完成了一个逻辑分区的描述, 下面分配缓冲块表
		register_blkunit( units[uid], MKDEV(major, uid) );
		if(dp[1].start_sector) ebr_lba += dp[1].start_sector;
		else ebr_lba = 0;
		i++;
		goto next_ebr;
	done:
		if(ebr_block)	munmap_disk(ebr_block);	
		if(mbr_block) munmap_disk(mbr_block);
		//register_blkdev(major);
}

void ide_init(void){
	register_queue_getter(3, ide_get_queue, 0);			
	register_queue_getter(22, ide_get_queue, 0);			
	for (int i = 0; i < MAX_HWIFS; i++){
		for(int j = 0; j <=1; j++){
			INIT_LIST_HEAD(&ide_hwifs[i].drive[j].queue.queue_head);
		}
	}

	ide_hwifs[0].drive[0].present = 1;
	ide_hwifs[0].drive[1].present = 1;
	request_irq(0xe,  ide_intr, SA_INTERRUPT, ide_hwifs);
	irq_desc[0xe].status &= ~IRQ_DISABLED;
	//request_irq(0x10,  ide_intr, SA_INTERRUPT, ide_hwifs + 1);
	blk_devs[3].do_request = ide_do_request;
	blk_devs[3].add_request = add_request;
	blk_devs[3].global2local = global2local;
//	blk_devs[3].end_request = ide_end_request;
	blk_devs[22].do_request = ide_do_request;
	blk_devs[22].add_request = add_request;
	blk_devs[22].global2local = global2local;
	blk_devs[3].unitmax = 128;
	blk_devs[3].unitcycle = 64;
	blk_devs[22].unitmax = 128;
	blk_devs[22].unitcycle = 64;
//	blk_devs[22].end_request = ide_end_request;
}


/* if 'cur_rq'(i.e. current request) exists, we regard it as done, and pick next
 * from the rest*/
static struct request * ide_get_next_rq(struct ide_hwif *hwif){
	struct request *cur_rq = hwif->cur_rq;
	if(cur_rq){	/*try fetch next along the list*/
			struct request_queue *curq = ide_get_queue(cur_rq->dev_id);
			if(!list_meet_tail(&curq->queue_head, &cur_rq->tentacle)) 
				return tentacle2request(cur_rq->tentacle.next);
	}
	
	/*repick from the start of the queue( ignore the queue_head itself), because 
	 *that list_head lives in 'struct request_queue', not in 'struct request' */
	for(int i = 0; i <=1; i++){
		if(hwif->drive[i].present == false) continue;
		struct request_queue * q = &hwif->drive[i].queue;
		if(list_empty(&q->queue_head)) continue;
		struct request * rq = tentacle2request(q->queue_head.next);
		if(rq != cur_rq) return rq;
	}
	return 0;	
}




