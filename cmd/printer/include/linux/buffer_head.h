#ifndef BUFFER_HEAAD_H
#define BUFFER_HEAAD_H
#include<valType.h>
#include<list.h>


struct buffer_head{		//also called sectors_mmap
	u32 dev_id;
	ulong block;
	char *data;

	bool io;			//最近一次与磁盘IO的结果
	bool lock;			//加载或回写磁盘时, 会对缓冲区加锁
	bool dirty;			
	//bool uptodate;	//它跟dirty是反的, 时防止磁盘的数据比缓冲块新(缓冲块失效?)
						//我们暂时不需要它
	int count;
	struct list_head hash;
	struct list_head lru;
	struct list_head wait;
};

#endif
