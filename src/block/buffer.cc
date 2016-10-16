/*[1]
   buffer layer应该是比block layer更上层一些.
   但是因为它们结合的很紧密，所以放在一个文件夹.
 *[2]
   热表, 或缓冲块表, 或hotable, 都是一个意思
   指的是每个blk_unit所携带的缓冲块哈希表. 
   注意它的元素类型是 struct buffer_head *, 不是list_head
 *[3]
   {在哈希表里或全局链里发现一个块, 处于锁定状态. 为了获取它
   而睡眠, 醒来时发现这个块被回收作它用.}
   上面的情况在papaya里是不存在的, 因为一个正在被回收的缓冲块,
   不会出现在任一链里. 而我们睡眠等待前, 也会递增这个块的引用.
   没有人捷足先登, 也不会有人捷足后登.
 *[4]
   bread()其实叫做disk_map更好一些. 获取叫diskblock_map
 *[5]
   有一些代码不容易测. 像比读写扇区出错的代码.
 *TODO
  > 最后统一的做"竞争条件"的审查, 主要是防止硬中断(IDE?)造成的破坏
  > wait_on_buffer有必要做了
  > 也许应该协调写, 像比内核线程刚生成了一系列的块回写, 你又
  > 同时写这些buffer, 那磁盘上的数据肯定很难看. 应该是不允许的. 我想最简单的方法是, 无论你准备写入还是
  > 读出, 都检查一下lock. (不过读似乎不要紧, 既然已经获取块操作权了, 那这个块肯定已经被buffer了)
  > 还要考虑一种情况: U盘中途被拔出了怎么办? 真的不需要uptodate标志吗?   
  > ll_rw_block直接返回了错误怎么办? 例如你读取块超界.
  > 感觉空闲块的初始化可以全挪到 缓冲块表_添加() 这个函数里, 不要零零星星的初始化, 不要节约那一点内存.
  > ll_rw_block要检查块边界范围
 */
#include<linux/buffer_head.h>
#include<linux/blkdev.h>
#include<schedule.h>
#include<linux/slab.h>

static struct slab_head *bufferhead_cache;
static struct list_head huanchongkuaiquanjulian;	/*lianrulesuoyoudehuanchongkuai 
> anLRUpaixu. zuijinyongdaodezaizuiweibu; zuilengdekuaizaizuikaitou*/
static unsigned long globalist_len;			/* muqiandeyouduoshaogehuanchongkuai */
static unsigned long globalist_max = 32 * 1024;	/*zuiduozheyaoduogekuai, dagai128M */

static struct buffer_head *
hotable_lookup(struct blk_unit *unit, ulong block_id);


/* buffers_global_list */
static inline void globalist_add(struct buffer_head *new){		
	list_add_tail(&new->lru, &huanchongkuaiquanjulian);
	globalist_len++;												asrt(globalist_len < globalist_max);
}

//increment_bh
static inline void increment_bh(struct buffer_head *block){
	block->count++;
}

//decrement_bh
static inline void  decrement_bh(struct buffer_head *block){	asrt(block->count > 0);
	block->count--;
}

/* put_buffer() or munmap_disk() */
void munmap_disk(struct buffer_head *block){					asrt(block->count > 0);
	decrement_bh(block);
	//TODO somethine else
}

static inline void wait_on_buffer(struct buffer_head *bh){
	while(bh->lock){
		sleep_on(&bh->wait);
	}
}
/* this function name is not good, but vivid.
 * cache_hit
 */
static struct buffer_head * huanchongkuaimingzhong(u32 dev, long block){
	//如果命中了, 但是被加锁了, 那就等着, 这个等需要用sleep_on
	//ll_rw_block里要处理sleep_on和asker两种情况了.
	struct blk_unit *unit;
	struct buffer_head *mingzhongkuai;

	unit = BLK_UNIT(dev);
	mingzhongkuai = hotable_lookup(unit, block);	
	if(!mingzhongkuai)		return 0;

	increment_bh( mingzhongkuai );	//buran, daihuiershuixingle, zhegekuaikenengyijingbeihuishoule
	wait_on_buffer( mingzhongkuai );		//zhengzaiIO?
																asrt(mingzhongkuai->block == block 
																&& mingzhongkuai->dev_id == dev);
	/* 现在的情况是, 我们(namely a process)很高兴的在hash表里找到
	 * 了想要的块. 但是发现它最近一次IO出错. 我们不会轻易放弃的*/
	if(mingzhongkuai->io == false){
		ll_rw_block( READ, mingzhongkuai);
		wait_on_buffer( mingzhongkuai );
	}
	if(mingzhongkuai->io == false){
		decrement_bh( mingzhongkuai );
		mingzhongkuai = 0;
		
	}
	return mingzhongkuai;
}

/* 从hash表中摘除, 从全局链中摘除 */
static void pickoff_bh(struct buffer_head *bh){
	list_del(&bh->lru);
	list_del(&bh->hash);
	globalist_len--;
}

/* get least-recently-used 
 * 如果脏了, 就发送磁盘写命令, 并立刻返回.
   所以回收到的"最冷块"不要直接用, 要调用一下wait_on_buffer
 */
static struct buffer_head *recycle_lru(void){
	if(list_empty(&huanchongkuaiquanjulian))	return 0;

	struct buffer_head *coldblock; 
	coldblock = container_of(huanchongkuaiquanjulian.next, struct buffer_head, lru);
	if(coldblock->count > 0)	spin("unusual case");

	pickoff_bh(coldblock);		//strong order
	if(coldblock->dirty){
		ll_rw_block(WRITE, coldblock);	//lock_buffer
	}
	return coldblock;	
}


/* 新建一个空白缓冲块, 加入全局链, 目前是一次长一个 */
static struct buffer_head * xinjiankongbaikuai(void){
	struct 	buffer_head *bh;
	bh = kmem_cache_alloc(bufferhead_cache, 0);				asrt(bh);
	void *data = __alloc_page(0);
	bh->data = data;
	bh->lock = false;	//yaoqubieyu"recycle_lru", nagekenengyinhuixieershangsuo
	INIT_LIST_HEAD(&bh->wait);
	return bh;
}

/* 
 * get_unused
 > 返回的缓冲块可能是新建的(当缓冲块总量较少, 处于扩张阶段)
   也可能是回收了"冷块"( 当缓冲块总量到了上线 )
 > 返回的块是个"孤儿", 不在hash表里, 也不在全局链里
 > 返回的buffer_head里的成员, 除了b_lock, b_wait,其它都是"垃圾数据"
   无效的. 要重新初始化. 这样做很好.
 */
static struct buffer_head *qingqiukongxiankuai(void){
	//如果dirty了,要回写到磁盘
	//先尝试扩张缓冲块容量
	struct buffer_head *empty;
	if(globalist_len < globalist_max){
		empty = xinjiankongbaikuai();							
	}
	else{
		empty = recycle_lru();								
	}
															asrt(empty && list_empty( &empty->wait ));
	return empty;	
}


void init_blklayer_buffer(void){
	INIT_LIST_HEAD(&huanchongkuaiquanjulian);	
	bufferhead_cache = kmem_cache_create(
							"bufferhead_cache", 
							sizeof(struct buffer_head), 0,
							SLAB_HWCACHE_ALIGN, 0, 0 );
}

void init_blklayer(void){
	init_blklayer_basic();
	init_blklayer_buffer();
}


/* 根据扇区数量, 计算所需的热表长度(返回单位是双page,也就是8K,  不是byte)
 * 为什么是双页呢, 因为list_head是8字节, 双页正好1024个slot
 */
static int suoxurebiaochang(struct blk_unit *unit){
	ulong danlianrongliang = __4K * HOTABLE_LEN2;		//yigepengzhuangliannengrongnaduoshaohuanchongkuai(in byte)
	ulong shuangyerongliang = danlianrongliang * __1K ;	//liangyedehaxibiaonengyingsheduoshaohuanchongkuai(in byte)
	ulong dev_size =  512 * unit->total_sectors; //total size
	return ceil_div( dev_size, shuangyerongliang);
}

/* 目前这个接口还不强.
 * 像IDE设备, 他是直接操作blkdevs[]数组.
   但它初始化一个dev的各个unit后,必须调用这个接口
 * TODO 把更多的reigster操作挪到这里
 */
void register_blkdev(int major){ 							assert(major < MAX_BLKDEV);
	struct blk_dev *blkdev;
	blkdev = &blk_devs[major];								asrt(blkdev->unitmax > 0);

	//为已初始化的块设备分配缓冲块哈希表
	for(int i = 0; i < blkdev->unitmax; i++){
		struct blk_unit *unit;

		//ignore <whole disk> MINOR, you must register it mannually
		if(i % blkdev->units_per) continue;	

		unit = blkdev->units[i];
		if(!unit) continue;									asrt(unit->total_sectors != 0);
															asrt(!unit->hotable && "registered already!");
		register_blkunit(unit, MKDEV(major, i));
	}
}

/* 注册一个unit, 这个接口是必须的.
	像比, 用户新建一个分区之后, 需要专门针对这个分区(unit)初始化
 * TODO 给unit添加id成员, 把更多的regiser动作搜集到这里
 */
void register_blkunit(struct blk_unit *unit, u32 dev){				asrt(unit && unit->total_sectors );
	struct list_head *hotable;
	int hotable_len;		//bushibytechang, shielement num

	int page_need = suoxurebiaochang(unit) * 2;	//fanhuideshi"shuangye"
	int order_need = pgorder_needed(page_need);	
	int page_giveyou = __4K << order_need;	//shijigeiniduoyixie
	hotable = __alloc_pages(order_need, 0);				asrt(hotable);
	hotable_len = page_giveyou * __4K /sizeof(struct list_head);
	for(int i = 0 ; i < hotable_len; i++){
		INIT_LIST_HEAD( &hotable[i] );
	}

	unit->hotable = hotable;
	unit->hotable_len= hotable_len;
	unit->dev_id = dev;
}

/* hotable_add
 * 把一个"游离"的空闲块添加到一个设备的缓冲块表里, 
 * 这个"游离的"buffer_head里的多数信息是"乱码", 对它的初始化也是在这儿. 
 * 这是个危险的操作, 因为我们没有uptodate字段, 调用它之后要紧接着load数据
 * 为什么要有这样一个函数呢, 没什么原因, 只是常规的一大步
 */
static void hotable_add(struct blk_unit *unit, 
						struct buffer_head *new)
{
	new->dev_id = unit->dev_id;
	//new->block = block;
	new->dirty = false;	//cishidataquhuanshikongbaide, tanbushangdirty
	new->count = 1;		//asrt(buffer->count == 1);
	new->lock = false;	//TODO BUG yinggaibachushihuahanshutiquchulai
						//这样很别扭. 解锁是安全的?

	struct list_head *hashtbl = unit->hotable;
	int hash = new->block % unit->hotable_len;
	list_add(&new->hash, &hashtbl[hash]);

}

/* hotable_lookup */
static struct buffer_head *
hotable_lookup(struct blk_unit *unit, ulong block_id){
	int hash = block_id % unit->hotable_len;
	struct list_head *collision = unit->hotable + hash;
	struct buffer_head *curr;
	list_for_each_safe(collision, curr, hash){
		if(curr->block == block_id) return curr;
	}
	return 0;
}


/* This is bread(), also called mmap_disk()
 * 其实是两个不同的抽象模型, 缓冲块 vs. 扇区映射
   "映射"的概念只是有限的用, 只在特别合适地方, 像比这里
 > It does two jobs: let the block layer guarantee @dev:@block 
   already buffered; Then, increment it's reference count.
   That is to say, Hi~ I am reading that block! don't 
   release until i put it.
 
 > Note! we don't have a bwrite()! 
   You can write into this block after grep it using bread(),
   kupdate() or bdflush() will write it back to disk. 
 
 > 因此, 缓冲块的"快速读"和"快速写"是没有锁保护的.
   b_lock成员不是干这个的.

 > 并不是说, 你调用了bread()之后, 就终身无忧, 可以一直用它,
   不是的. 如果bread()之后, 进程A睡眠, 等他再次醒来, 可能
  	bdflush()已经被调用了, 这个页正在回写磁盘, 如果此时进程A
	写这个页面, 是非常恐怖的, 磁盘最终被写成什么样不敢看
	所以, 一般都是调用了bread()之后, 读完, 赶紧release()
	或者说每次写入前, 用wait_on_buffer协调一下.
 */
struct buffer_head *mmap_disk(u32 dev, ulong block){
	struct buffer_head *buffer;
	maybe_lucky:
	buffer = huanchongkuaimingzhong(dev, block);	//kenengdaozhishuimian TODO  bugaishuimian, bashuimiandedaimanuodaozhelilai?
	if(buffer) return buffer;			

	buffer = qingqiukongxiankuai();	//zhegehanshubuhuishuimian
	if(buffer->lock){	//womenbuyongxunhuandengdai, yinweizhegekuaiyijingtuolianle
						//现在只有我们知道它, 我们等它回写完
		kp_sleep(0, 0);		
		goto maybe_lucky;
	}

	/* 现在,  这个缓冲块彻底属于我们了.
	 * 因为稍后从磁盘加载内容, 会睡眠. 我们先把这个缓冲块
	 * 添加到hash表里, 挂个号. 
	 * 这样, 在我们睡眠的这段时间里, 如果有别的进程请求这个块,
	 * 就可以命中了. 它只管sleep_on(buffer->lock)就行了.
	 */
	buffer->block = block;	
	hotable_add( BLK_UNIT(dev), buffer);
	globalist_add(buffer);

	ll_rw_block(READ, buffer);
	wait_on_buffer(buffer);
	/* 执行到这儿, 一定解锁了.
	 * 其实无所谓了, 到了这儿, 这个块可以很安全的用了. 
	 * 再没有必要检查lock了, 就算它正在往磁盘回写又怎么样?
	 * bh->lock不是用来协调这些的. 我们对缓冲块的持有者之间
	 * 的读写, 以及与内核线程的定时回写, 没有任何的限制.
	 */
	if(buffer->io == false){		//IO error
		//缓冲块表_删除();
		//全局链表_删除();
		decrement_bh(buffer);
		buffer = 0;											spin("IO fault");
	}
	return buffer;
}


/* Expensive. Don't use it 
 * @return 0 on success  +relied
 */
int ll_rw_blocks(u32 dev_id, int rw, 
		ulong start, ulong blocknum, void *buf)
{
	char *from, *to;
	struct buffer_head *bh;

	if(rw == READ) to = buf;
	else from = buf;

	for(int i = start; i < start + blocknum; i++){
		bh = mmap_disk(dev_id, i);							asrt(bh);	
		if(rw == READ) from = bh->data;
		else			to	= bh->data;

		memcpy(to, from, BLOCK_SIZE);
		munmap_disk(bh);
	}
	return 0;
}
#if 0
struct buffer_head *qingqiuxierukuai(u32 dev, ulong block){

}
#endif
 









