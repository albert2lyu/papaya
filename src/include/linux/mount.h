#ifndef MOUNT_H
#define MOUNT_H
#include<linux/dcache.h>
#include<valType.h>
struct super_block;
struct vfsmount{
	u16 dev;
	struct super_block *sb;
	struct dentry *small_root;
	struct dentry *mountpoint;
	struct vfsmount *parent;
	struct list_head clash;	/*those who are mounted on the same dentry */
};

#endif
