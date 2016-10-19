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
  > 用到mmap_disk()的几个syscall的中断要打开. 别不敢.
 */
#include<linux/buffer_head.h>
#include<linux/blkdev.h>
#include<schedule.h>
#include<linux/slab.h>

static struct slab_head *bufferhead_cache;

static struct buffer_head *
hotable_lookup(struct blk_unit *unit, ulong block_id);

static struct list_head freelist;
/* 为什么需要忙碌链呢? 其实我们是需要一个全局链. 否则遍历
   缓冲块做统一回写时不方便.
   但那样的话, buffer_head又多需要一个指针成员
 */
static struct list_head busylist;
static ulong totalbusy;
static ulong totalfree;
static ulong totalnow;	// == totalbusy + totalfree
static ulong totalmax = 256;	//neihehuageikuaishebeihuanchongcengdeshangxian
static int shengchanglidu = 8;

/* 下面4个API, 其实处理的是缓冲块在 忙/闲链之间的流动.
 * 新的块不会进入直接进入忙链. 而进入闲链也不会通过走下面的
 * API */
static inline void busylist_add( struct buffer_head *it){
	list_add( &it->lru, &busylist );	//bujushouwei
	totalbusy++;
}

static inline void busylist_del( struct buffer_head *it){	
	list_del(&it->lru);
	totalbusy--;
}

/* 认为接收的块是刚从忙碌链里来的, 按lru规则, 放在链尾 
   扩增空闲链时不会调用这个函数
 */
static inline void freelist_add( struct buffer_head *it){
	list_add_tail( &it->lru, &freelist );
	totalfree++;	
}

static inline void freelist_del( struct buffer_head *it){
	list_del(&it->lru);
	totalfree--;
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
	if(block->count == 0){
		//list_add_tail(&block->lru, &空闲链);
		busylist_del( block );
		freelist_add( block );
	}
	//TODO somethine else 真是英明
}

static inline void wait_on_buffer(struct buffer_head *bh){
	while(bh->lock){
		sleep_on(&bh->wait);
	}
}
/* this function name is not good, but vivid.
 * cache_hit
 */
static struct buffer_head * cache_hit(u32 dev, long block){
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


/* 新建一个空白缓冲块, 加入全局链, 目前是一次长一个 */
static struct buffer_head * xinjiankongbaikuai(void){
	struct 	buffer_head *bh;
	bh = kmem_cache_alloc(bufferhead_cache, 0);				asrt(bh);
	void *data = __alloc_page(0);
	bh->data = data;
	bh->lock = false;	//yaoqubieyu"recycle_lru", nagekenengyinhuixieershangsuo
	bh->hash.prev = bh->hash.next = 0;
	bh->dirty = false;
	INIT_LIST_HEAD(&bh->wait);
	return bh;
}

static bool expand_freelist(void){							assert( list_empty( &freelist ));
	u32 newtotal = totalnow + shengchanglidu;
	if(newtotal > totalmax){
		return false;	
	}
	for(int i = 0; i < shengchanglidu; i++){
		struct buffer_head *new = xinjiankongbaikuai();				asrt(new);
		/* 插入最前面, 我们当然要优先用空白块 */
		list_add(&new->lru, &freelist);
	}
	totalnow = newtotal;
	totalfree += shengchanglidu;
	return true;
}

/* 
   freelist里既有才分配的空白块, 又有才unmap回来的块.
   我么需要区别它们, 因为要把后者从热表里脱链.
   怎么区分? 新分配的块的hash字段是0, 使用过的块一定不是.

   @返回块规格: 
   dirty = ? 崭新块: false, 表示不比磁盘块新
   			 回收块: true, 如果早已经回写过了
			 		 false, 如果是在回收时才启动的回写.
   lock = ? 崭新块: false
   			回收块: true, 如果早已经回写过了
					false, 如果是在回收时才启动的回写.
	io = true
  	wait = 自循环	
	count = 1	因为就是你请求了我	

	简单的说, 请求到的块, 是一个孤儿, 跟任何链表都脱离了关系
	而且可能因为正在回写磁盘而加锁.
 */
static struct buffer_head *qingqiukongxiankuai(void){
	struct buffer_head *orphan;
	if( list_empty( &freelist) ){
		bool ok = expand_freelist();						if(!ok) return false;
	}
	
	/* 从空闲链中拿 */
	orphan = container_of(freelist.next, 
							struct buffer_head, lru);
	//list_del( &orphan->lru );
	freelist_del( orphan );

	/*不拘prev还是next, 只要是0, 说明这是一个崭新的块. */
	if(orphan->hash.prev == 0);	//do nothing;
	else{	//zhegekuaihuandaizaihashbiaoli
		list_del( &orphan->hash );	//congrebiaotuolian
		if(orphan->dirty){									assert(0 && "write-back not implemented yet");
			if(!orphan->lock)	ll_rw_block(WRITE, orphan);
			else;	/*ruguoshangsuole, nazhenghewoyi, tawufeizaizhixing
					 *yicicipanIO. ruguozhengzaihuixie, nahenhao; ruguo
					 * zhengzaidu, najiugengbuyongcaoxinle. buguanzenyang,
					 * jizhukongxianlianlidesuoyoukuaidecountdushi0 */
		}
	}
															assert( list_empty(&orphan->wait));
	orphan->count = 1;
	return orphan;	
}


void init_blklayer_buffer(void){
	INIT_LIST_HEAD(&freelist);	
	INIT_LIST_HEAD(&busylist);	
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
		if( (i % blkdev->unitcycle) == 0) continue;	

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

	int pages_need = suoxurebiaochang(unit) * 2;	//fanhuideshi"shuangye"
	int order_need = pgorder_needed(pages_need);	
	int pages_giveyou = 1 << order_need;	//shijigeiniduoyixie
	hotable = __alloc_pages(0, order_need);				asrt(hotable);
	hotable_len = pages_giveyou * __4K /sizeof(struct list_head);
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
{															asrt(new->count == 1);
	new->dev_id = unit->dev_id;
	new->dirty = false;	//cishidataquhuanshikongbaide, tanbushangdirty
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
	struct buffer_head *raw;

	//如果访问的块落在某个分区, 则转化成对那个分区的访问
	blk_devs[MAJOR(dev)].global2local(&dev, &block);

	buffer = cache_hit(dev, block);	//kenengdaozhishuimian TODO  bugaishuimian, bashuimiandedaimanuodaozhelilai?
	if(buffer) return buffer;			
	
	raw = qingqiukongxiankuai();										asrt(raw);
	if(raw->lock){	//womenbuyongxunhuandengdai, yinweizhegekuaiyijingtuolianle
						//现在只有我们知道它, 我们等它回写完
		kp_sleep(0, 0);		 								
		//空闲块已经可用了, 但我们不甘心, 再去hash表碰碰运气
		if( (buffer = cache_hit(dev, block) ) ){
			freelist_add(raw);	//huanhuiqu
			return buffer;
		}
	}
	buffer = raw;											

	/* 现在,  这个缓冲块彻底属于我们了.
	 * 因为稍后从磁盘加载内容, 会睡眠. 我们先把这个缓冲块
	 * 添加到hash表里, 挂个号. 
	 * 这样, 在我们睡眠的这段时间里, 如果有别的进程请求这个块,
	 * 就可以命中了. 它只管sleep_on(buffer->lock)就行了.
	 */
	buffer->block = block;	
	hotable_add( BLK_UNIT(dev), buffer);
	busylist_add(buffer);

	ll_rw_block(READ, buffer);
	wait_on_buffer(buffer);
	/* 执行到这儿, 一定解锁了.
	 * 其实无所谓了, 到了这儿, 这个块可以很安全的用了. 
	 * 再没有必要检查lock了, 就算它正在往磁盘回写又怎么样?
	 * bh->lock不是用来协调这些的. 我们对缓冲块的持有者之间
	 * 的读写, 以及与内核线程的定时回写, 没有任何的限制.
	 */
	if(buffer->io == false){		//IO error
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

	for(int i = 0; i < blocknum; i++){
		bh = mmap_disk(dev_id, start + i);							asrt(bh);	
		if(rw == READ) {
			from = bh->data;
			to = buf + i * BLOCK_SIZE;
		}
		else{
			from = buf + i* BLOCK_SIZE;
			to	= bh->data;
		}

		memcpy(to, from, BLOCK_SIZE);
		munmap_disk(bh);
	}
	return 0;
}
#if 0
struct buffer_head *qingqiuxierukuai(u32 dev, ulong block){

}
#endif
 

#if 0
/* get least-recently-used 
 * 如果脏了, 就发送磁盘写命令, 并立刻返回.
   所以回收到的"最冷块"不要直接用, 要调用一下wait_on_buffer
 */
static struct buffer_head *recycle_lru(void){
	if(list_empty(&globalist))	return 0;

	struct buffer_head *coldblock; 
	coldblock = container_of(globalist.next, struct buffer_head, lru);
	if(coldblock->count > 0)	spin("unusual case");

	pickoff_bh(coldblock);		//strong order
	if(coldblock->dirty){
		//BUG here 可能人家已经在回写了
		ll_rw_block(WRITE, coldblock);	//lock_buffer
	}
	return coldblock;	
}
#endif


#if 0
	<zheshijiude "qingqiukongxiankuai">
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
#endif


#if 0
static struct list_head globalist;	/*lianrulesuoyoudehuanchongkuai 
> anLRUpaixu. zuijinyongdaodezaizuiweibu; zuilengdekuaizaizuikaitou*/
static unsigned long globalist_len;			/* muqiandeyouduoshaogehuanchongkuai */
//static unsigned long 全局链容量 = 32 * 1024;	/*最多这么多个块, 大概128M */
static unsigned long globalist_max = 256;	/*zuiduozheyaoduogekuai, dagai128M */


/* buffers_global_list */
static inline void globalist_add(struct buffer_head *new){		
	list_add_tail(&new->lru, &globalist);
	globalist_len++;												asrt(globalist_len <= globalist_max);
}


/* 从hash表中摘除, 从全局链中摘除 */
static void pickoff_bh(struct buffer_head *bh){
	list_del(&bh->lru);
	list_del(&bh->hash);
	globalist_len--;
}
#endif




