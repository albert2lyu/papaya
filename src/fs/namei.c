/* 1, linux不允许目录和文件同名, 这也方便了内核实现。
 */
#include<linux/fs.h>
#include<proc.h>
#include<linux/errno.h>
#include<list.h>

#define IS_MNT_PT(dentry) ( !list_empty( &(dentry)->vfsmount) )
#define LOOKUP_DIR 1
/* 1, after processing, 'indir' may stand on a mountpoint when encountering the 
 * final root directory.
 * 2, 这个函数就是让'indir'继续walk。
 */
static void follow_dotdot( struct in_dir *indir){
	/* see if we are already in root directory for partial process*/
	if(indir->dentry == current->fs->root) return;

	/* see if we are in a small root, i.e. a local root directory*/
	struct vfsmount *mnt_parent = indir->mnt->parent;
	if(indir->dentry == indir->mnt->small_root){
		/* see if we are already in 'ROOT DEVICE', if yes, partial user must have
		 * pressed 'cd ..' in root directory '/' */
		if(mnt_parent == indir->mnt) return;	/*partial check seems unnecessary*/
		/* OK, we have a parent device */
		indir->dentry = indir->mnt->mountpoint;
		indir->mnt = mnt_parent;
		follow_dotdot(indir);
		/*是不是存在一种情况：parent device存在，但挂载点是它的根目录，这个
		 *要看do_mount是怎么实现的。应该不会，那不就相当于挂在parent device的
		 *挂载点上了吗，怎么挂*/
	}
	
	/* we are safe, just goto parent directory*/
	indir->dentry = indir->dentry->parent;
}

/*
 *如果一个dentry是mountpoint，那它的->vfsmount成员就链着一串vfsmount结构，在
 *其中找到->parent是@from的就好了
 * TODO 考虑在vfsmount里添加一个child指针，代码也许会简洁许多
 */
static struct vfsmount *
enter_mounted(struct dentry *mountpoint, struct vfsmount *from){
	struct list_head *tmp = mountpoint->vfsmount.next;
	while( tmp != &mountpoint->vfsmount){
		struct vfsmount *mnt = MB2STRU(struct vfsmount, tmp, clash);
		if(mnt->parent == from) return mnt;
		tmp = tmp->next;
	}
	return 0;
}

/* 若当前节点还未被cache，那就要把“目录”和“节点名”下发给具体的文件系统，让它们从磁盘上找。
 * 虽然如此，仍然有一部分工作可以由vfs完成，例如分配新的dentry并做初步的initialization,
 * 查找失败的话释放dentry等等。。。
 * 所以有这个 "real_lookup"。 这个函数的参数特别自然。
 */
static struct dentry *real_lookup(struct dentry *dir, struct qstr *name){
	/* d_create的开销不小，如果查找失败，又要free掉。为什么不等到查找成功再调用呢?
	 * 因为大多数情况是不会失败的。 默认了这一点，会带来一些好处。
	 */
	struct dentry *subdir = d_create(dir, name);
	/*fetch inode*/
	/*e.g. ext2_lookup */
	struct inode_operations *i_ops = dir->inode->operations;
	int err = i_ops->lookup(dir->inode, subdir);
	if(err) {
		//dir->count--;		暂时不考虑
		kfree(subdir);	
		return 0;
	}
	/* 顺便cache这个new dentry的inode*/
	struct inode *inode = iget(subdir->sb, (u32)subdir->inode);	/*some tricks */
	if(!inode){
		kfree(subdir);	
		return 0;
	}
	/* 关联并hash */
	subdir->inode = inode;
	hashtable_add(dentry_hashtable, d_rehash(subdir->parent, subdir->name.hash),\
				  &subdir->hash);
	return subdir;
}


static struct dentry *cached_lookup(struct dentry *parent, struct qstr *partial, int flags)
{
	struct dentry *result = d_lookup(parent, partial);
	return result;
}

int pathwalk(char *path, struct in_dir *indir, int flags){
	int hotflags = 0;
	const char *foot = path;
	struct qstr partial;
	if(*foot == '/'){
		indir->dentry = current->fs->root;
		indir->mnt = current->fs->rootmnt;
		foot++;
	}
	else{
		indir->dentry = current->fs->pwd;
		indir->mnt = current->fs->pwdmnt;
	}

	step:
	if(*foot == 0) return 0;
	partial.name = foot;

	while(*foot && *foot != '/') foot++;
	partial.len = foot - partial.name;
	//partial.hash = qstr_mk_hash(&partial);		
	partial.hash = str_hash(partial.name, partial.len);
	if(*foot == '/'){
		hotflags |= LOOKUP_DIR;
		foot++;
	}
	
	if(partial.name[0] == '.'){
		switch(partial.len){
			case 2:
				if(partial.name[1] != '.') break;
				follow_dotdot(indir);
			case 1:
				goto step;
			default:
				break;
		}
	}

	/* we stand on a common 'path partial^' */
	struct dentry *subdir = cached_lookup(indir->dentry, &partial, hotflags);
	if(!subdir) subdir = real_lookup(indir->dentry, &partial);
	if(!subdir) return 1;

	/* enter device(i.e. goto it's root dentry) if @subdir is a mountpoint ,
	 * 这一段代码应该始终在pathwalk的末尾，因为indir->mnt被“破坏了”
	 */
	struct vfsmount *just_enter = indir->mnt;
	bool meet_mnt = 0;
	while(IS_MNT_PT(subdir)){
		meet_mnt = 1;
		just_enter = enter_mounted(subdir, just_enter);
		if(!just_enter) break;
		subdir = just_enter->small_root;
		indir->mnt = just_enter;	/*indir的mnt成员只可能在这儿变*/
		indir->dentry = subdir;		/*这个赋值，意味着我们进入了下一个节点*/
	}
	
	if(!meet_mnt){
		indir->dentry = subdir;
	}
	goto step;
}









