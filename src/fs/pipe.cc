/*[1]
 * pipe的原理很简单. 只不过, 为了把它纳入vfs的管理,
 * 我们要捏造出来一种pipe类型的文件. 这不麻烦, 我们只需要
 * 提供一个dentry, 一个inode, 让fs能顺藤摸瓜,拿到
 * file_operation结构体就好了. 对这个结构体的实现, 是我们
 * 的主要工作.
 * 其余的inode_operation, dentry_operation, read_super等等
 * 都不需要实现.
 *[2]
 * 管道的productor/consumer都可能不只一个. 所以醒来之后, 不
 * 见得你就有空间可写/读. 何况还可能是另一端exit时叫醒了你.
 *[3]
 * 写端exit时, 在关闭文件时, 会释放所有附着其上的等待者.
 * 这种设计是否有副作用? 至少对管道是必要的. 因为productor
 * 在退出时必须唤醒消费者, 不然它永远醒不过来了.
 *[4]
 * 消费者怎么判断生产者已经退出? 在内核里当然好判断. 但我是
 * 说在用户程序里, 仅仅通过返回值(rbytes)吗? 那非阻塞模式
 * 又该怎么判断?
 * -----方法就是判断返回值. 
 * 		0表示读到了末尾. 虽然什么也没读到, 也是成功的.
 * 		-1表示失败. EAGAIN指示你读的是一个NON_BLOCK文件, 
 *		而且这次读本该被阻塞的. EAGAIN指示这次读是被信号读
 *		是被信号打断的. 你该重启read(). 
 *[5]
 * read的阻塞, 只在"一个字节都读不到"的情况发生.
 * 只要能读到一个字节, 即使小于请求长度, 也会成功返回.
 * 同理, 管道的阻塞, 也只是在一个字节都读不到的情况下发生.
 *[6]
 * 管道的阻塞是可被信号打断的
 *		
 * TODO 暂时是在关中断条件下运行的. 为对临界区做保护.
 */
#include<linux/fs.h>
#include<linux/pipe.h>
#include<linux/fcntl.h>
#include<linux/errno.h>
#include<old/schedule.h>


struct pipe_inode_private{
	ulong keyongshuju;	/* shengyumeiyouduwandezijie.
					 * meiciread/writehou, zhegeziduanhuiyouxiangyingde
					 * zengjian. tawei0, jidaibiaomeishujukedule.
					 */
};
#define I_COMMON(inode) \
	( (struct pipe_inode_private *)(inode->common) )


static int read(struct file *rfile, char *buf, ulong rlen, 
					ulong *ppos)
{
	struct file *wfile;
	ulong toread;
	char *ring;
	struct inode *inode;
	struct pipe_inode_private *private;

	inode = rfile->dentry->inode;
	private = (void *)inode->common;
	ring = (void *)inode->ino;
	wfile = rfile->data;
	toread = rfile->pos;
	
	//被唤醒, 不一定是因为有数据可读了
	while( private->keyongshuju == 0){
		if(wfile->count == 1) return 0;	//suoyouxieduanduguanbile
		if(rfile->flags & O_NONBLOCK) return -EAGAIN;
		//FIXME need we do wake_up here?
		/* sleep again, do you know what happened?
		 * maybe another reader was scheduled before us ..*/
		sleep_on(&inode->wait);
	}														assert(( toread + private->keyongshuju) % __4K 
																	 == wfile->pos);
	ulong keduliang = private->keyongshuju;
	ulong xuduliang = rlen;
	ulong shiduliang = keduliang > xuduliang ? xuduliang : keduliang;

	for( ulong i = 0; i < shiduliang; i++){	//slow...
		buf[i] = ring[toread];
		toread = (toread + 1) % __4K;
	}
	private->keyongshuju -= shiduliang;
	rfile->pos = toread;

	wake_up(&inode->wait);
	return shiduliang;
}


/*[1] 
 * 所有consumer退出后, 生产者会收到管道破裂信号. 但这个信号
 * 不是又consumer在exit时发出的, 而是writer检测到reader个数
 * 为0时, 向自己发送的.
 */
	
static int write(struct file *wfile, char *buf, ulong wlen, 
					ulong *ppos)
{
	struct file *rfile;
	ulong towrite;
	char *ring;
	struct inode *inode;
	struct pipe_inode_private *private;

	inode = wfile->dentry->inode;
	private = (void *)inode->common;
	ring = (void *)inode->ino;
	towrite = wfile->pos;
	rfile = wfile->data;

	ulong kexieliang;
	while( (kexieliang = __4K - private->keyongshuju) == 0){
		if(rfile->count == 1){
			//raise SIGPIPE
			return -1;
		}
		if(wfile->flags & O_NONBLOCK){
			return -1;
		}
		sleep_on( &inode->wait );
	}														assert(( towrite + kexieliang) % __4K 
																	 == rfile->pos);
	ulong xuxieliang = wlen;	
	ulong shixieliang = xuxieliang > kexieliang ? kexieliang : xuxieliang;
	for( int i = 0; i < shixieliang; i++ ){
		ring[towrite] = buf[i];
		towrite = (towrite + 1) % __4K;
	}														
	wfile->pos = towrite;
	private->keyongshuju += shixieliang;

	wake_up(&inode->wait);
	return shixieliang;
}

static struct file_operations pipe_file_ops = {
	open: 0,
	lseek: 0,
	read:read,
	write:write,
	onclose:0
};

/*
 *@flags 这个flags不会包含太多的有效bit, 这只是管道而已.
 *		 只有有O_NONBLOCK, O_CLOEXEC. 
 *		 如果有别的bit, 会返回-EINVAL. 
 *		 bit 0和bit 1更是不需要.
 *
 */
int do_pipe( int fds[2],  int flags){
	struct file *rfile, *wfile;	
	struct dentry *dentry;
	struct inode *inode;
	//struct super_block *sb;

	rfile = kmem_cache_alloc( file_cache, 0);
	wfile = kmem_cache_alloc( file_cache, 0);
	dentry = kmem_cache_alloc( dentry_cache, __GFP_ZERO);
	inode = kmem_cache_alloc( inode_cache, __GFP_ZERO);
	INIT_LIST_HEAD( &inode->wait );


	inode->file_ops = &pipe_file_ops;
	inode->ino = (ulong)__alloc_page(0); //fanzhenginoziduanmeiyong
	I_COMMON(inode)->keyongshuju = 0;	//ensure

	dentry->inode = inode;
	rfile->dentry = dentry;
	rfile->pos = 0;
	rfile->flags = flags;
	rfile->count = 2;
	rfile->data = 0;

	*wfile = *rfile;
	rfile->mode = 0b01;
	wfile->mode = 0b10;
	wfile->data = get_file(rfile);	/* duxieduanhufang */
	rfile->data = get_file(wfile);
	/* 注意, 上面的get_file()是必要的, 我们要保证管道的主人
	 * 退出时, 它的file结构体不被回收. 因为管道另一端的进程
	 * 还要访问它 */

	int r_fd = get_unused_fd();
	int w_fd = get_unused_fd();
	current->files->filep[r_fd] = rfile;
	current->files->filep[w_fd] = wfile;

	fds[0] = r_fd;
	fds[1] = w_fd;

	return 0;
}











