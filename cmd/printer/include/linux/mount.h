#ifndef MOUNT_H
#define MOUNT_H
#include<linux/dcache.h>
#include<valType.h>
struct super_block;
struct vfsmount{
	u16 dev;
	struct super_block *sb;		/* super-block of the baby device */
	struct dentry *small_root;	/* root dentry of the baby device */
	struct dentry *mountpoint;	
	struct vfsmount *parent;
	struct list_head clash;	/*those who are mounted on the same dentry */
	int count;
};

static inline struct vfsmount *mntget(struct vfsmount *mnt){
	mnt->count++;
	return mnt;
}

static inline void mntput(struct vfsmount *mnt){
	mnt->count--;
}

#endif
