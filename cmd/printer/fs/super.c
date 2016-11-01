#include<linux/fs.h>
#include<utils.h>
static  struct file_system_type *fs_types;
void init_vfs(void){
	dentry_cache = kmem_cache_create("dentry_cache", sizeof(struct dentry), 0,
										SLAB_HWCACHE_ALIGN, 0, 0);
	inode_cache = kmem_cache_create("inode_cache", sizeof(struct inode), 0,
										SLAB_HWCACHE_ALIGN, 0, 0);

	inode_hashtable = kmalloc(sizeof(struct list_head) * I_HASHTABLE_LEN);
	dentry_hashtable = kmalloc(sizeof(struct list_head) * D_HASHTABLE_LEN);
	for(int i = 0; i < I_HASHTABLE_LEN || i < D_HASHTABLE_LEN; i++){
		if(i < I_HASHTABLE_LEN) INIT_LIST_HEAD(inode_hashtable + i);
		if(i < D_HASHTABLE_LEN) INIT_LIST_HEAD(dentry_hashtable + i);
	}
}

void register_filesystem(char *name, int (*read_super)(struct super_block *)){
	struct file_system_type *t = kmalloc(sizeof(struct file_system_type));
	strcpy(t->name, name);
	t->read_super = read_super;
	LL_INSERT(fs_types, fs_types, t);	
}

//BUG 挂载根设备时，应该会出错
/*我们挂载一个文件系统，当然是为了后续能操作它。
 * mount的过程基本上是具体文件系统向vfs层做”新生报道“(或者说自我介绍)的过程：
 * Hi, 这是我的root dentry，请过目。 这是我的read_inode方法，请过目..
 * vfs的设计者恰恰把这些重要的结构体指针和函数指针放到super_block里，所以mount的核心操作
 * 就是调用具体文件系统的read_super函数。由它们填写一份super_block。
 * warning:这个函数不能用来挂载总root，因为它调用了pathwalk，而pathwalk默认总root是已经
 * 挂载了的。
 */
struct vfsmount * do_mount(u16 dev, char *dir, char *type){
	struct file_system_type *curr = fs_types;
	while(curr){
		if(strcmp(curr->name, type) == 0) break; 
		curr = curr->next;
	}
	if(!curr) return 0;

	struct in_dir indir;
	//assert(0 && "pathinit required");
	/*如果是挂载到"/"，那连mountpoint这个dentry都要虚拟*/
	if(dir[0] == '/' && dir[1] == 0){	
		indir.dentry = d_create(0, &(struct qstr){"/", 1, 0});
		indir.mnt = 0;	/*置0，不像linux那样，指向自己*/
	}
	else{
		int err = pathwalk(dir, &indir, 0);
		if(err) return 0;
	}

	struct vfsmount *vfsmnt = kmalloc( sizeof(struct vfsmount) );
	struct super_block *sb = kmalloc( sizeof(struct super_block) );
	sb->dev = dev;
	curr->read_super(sb);

	vfsmnt->sb = sb;	//main job done
	vfsmnt->small_root = sb->root;
	vfsmnt->mountpoint = indir.dentry;
	vfsmnt->parent = indir.mnt;	

	list_add(&vfsmnt->clash, &indir.dentry->vfsmount);
	return vfsmnt;
}

int sys_mount(char * dev_name, char *dir_name, char *type, unsigned flags, void *data){
	return 0;
}


