#ifndef FS_H
#define FS_H
#include<linux/dcache.h>
#include<proc.h>
#include<linux/slab.h>

/* flags in file.mode 
 */

/* file is open for reading */
#define FMODE_READ 		1
/* file is open for writing */
#define FMODE_WRITE 	2
/* file is seekable */
#define FMODE_SEEK 		4

struct inode_operations{

	/* 1, @DESC pathwalk时，若^path partial相应的dentry不在内存里，就要从所属
	 * 目录里找。
	 * 2, @dir 当前的path partial所属目录。
	 * 3, @dentry 传这个参数，是一石二鸟。 它首先作为参数，夹带了私货"name",即当
	 * 前节点的名字， 等找到这个name对应的entry,它又用来存储结果。
	 * 4, 成功时返回0。比较奇怪。
	 */
	int (*lookup)(struct inode *dir, struct dentry *dentry);	
	
};

struct super_block;
struct file_operations;
struct inode{
	unsigned ino;	
	u16 dev;
	u16 rdev;
	u32 mktime;
	u32 chgtime;
	u32 size;
	struct super_block *sb;
	struct inode_operations *operations;
	struct file_operations *file_ops;
	struct list_head hash;
	
	#define INODE_COMMON_SIZE 128
	char common[INODE_COMMON_SIZE];
};

struct super_operations{
	int (*read_inode)(struct inode *inode);
};
struct super_block{
	struct super_operations *operations;
	struct dentry *root;
	u16 dev;
	char common[512];
};

struct in_dir{
	struct dentry *dentry;
	struct vfsmount *mnt;
};

struct file_system_type{
	char name[16];
	int (*read_super)(struct super_block *);
	struct file_system_type *next, *prev;
};

struct list_head *inode_hashtable;	
#define I_HASHTABLE_LEN 4096

struct file{
	struct dentry *dentry;
	unsigned pos;
	unsigned flags;
	unsigned mode;		/*注意，这个mode跟open()的参数mode没有关系，它跟flags差不多，我
						 *还不知道linux为什么要把flags的低两位挪到这个字段里*/
	int count;
	void *data;
};

/* 这些接口的参数跟标准的API有差别。 因为即使子文件系统接管lseek, read等，vfs还是帮助完成
 * 一部分通用的流程， vfs提供的这些接口是精简过的。
 */
struct file_operations{
	int (*lseek)(struct file *, int offset, unsigned origin);
	int (*read)(struct file *, char *path, unsigned size, 
				unsigned *ppos);	/* @ppos should be abount read-ahead, i guess */
	int (*open)(struct inode *, struct file *);
	int (*onclose)(struct file *);
};

/*这两个函数我很喜欢*/
/* check whether the specified fd has an open file */
static inline struct file *fcheck(unsigned fd){
	if(fd >= current->files->max_fds) return 0;
	return current->files->filep[fd];
}
static inline struct file *fget(int fd){
	struct file *file = fcheck(fd);
	if(file){
		file->count++;
	}
	return file;
}
void register_filesystem(char *name, int (*read_super)(struct super_block *));
struct vfsmount * do_mount(u16 dev, char *dir, char *type);
void init_vfs(void);

int pathwalk(char *path, struct in_dir *indir, int flags);
struct inode *iget(struct super_block *sb, unsigned ino);
int sys_open(char *, unsigned, unsigned);
int sys_read(unsigned, char*, unsigned);

struct slab_head *inode_cache;
struct slab_head *file_cache;


struct file * k_open(char *path, ulong flags, ulong mode);
int k_seek(struct file *file, int offset, unsigned origin);
int k_read(struct file *file, char *buf, unsigned size);

#endif
