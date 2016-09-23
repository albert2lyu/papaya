#ifndef DCACHE_H
#define DCACHE_H
#include<list.h>
#include<linux/mount.h>

struct list_head *dentry_hashtable;
#define D_HASHTABLE_LEN 1024

struct qstr{
	const char *name;		/*TODO intialized with memcpy when do d_alloc */
	int len;
	unsigned hash;
};
struct dentry_operations{
	int (*compare) (struct qstr *, struct qstr *);		/* 节点名比对,例如，有些文件系统忽略大小写*/
};
struct dentry{
	struct inode *inode;
	struct dentry *parent;
	struct super_block *sb;
	struct qstr name;		/* partial name */
	struct dentry_operations *operations;
	struct list_head vfsmount;
	int count;

	struct list_head hash;
};

/**
 * d_add - add dentry to hash queues
 * @entry: dentry to add
 * @inode: The inode to attach to this dentry
 *
 * This adds the entry to the hash queues and initializes @inode.
 * The entry was actually filled in earlier during d_alloc().
 */
 /*
static inline d_add(struct dentry *dentry, struct inode *inode){
	dentry->inode = inode;
	struct list_head *queue = d_hash(dentry->parent, dentry->name.hash);
	list_add(dentry->hash, queue);
}
*/

/* Allocation counts.. */

/**
 *	dget, dget_locked	-	get a reference to a dentry
 *	@dentry: dentry to get a reference to
 *
 *	Given a dentry or %NULL pointer increment the reference count
 *	if appropriate and return the dentry. A dentry will not be 
 *	destroyed when it has references. dget() should never be
 *	called for dentries with zero reference counter. For these cases
 *	(preferably none, functions in dcache.c are sufficient for normal
 *	needs and they take necessary precautions) you should hold dcache_lock
 *	and call dget_locked() instead of dget().
 */
 #if 0
 static struct  dentry *dget(struct dentry *dir){
 	dir->count ++;
	return dir;
 }
 #endif


#if 0
/* 
 * This is dput
 *
 * This is complicated by the fact that we do not want to put
 * dentries that are no longer on any hash chain on the unused
 * list: we'd much rather just get rid of them immediately.
 *
 * However, that implies that we have to traverse the dentry
 * tree upwards to the parents which might _also_ now be
 * scheduled for deletion (it may have been only waiting for
 * its last child to go away).
 *
 * This tail recursion is done by hand as we don't want to depend
 * on the compiler to always get this right (gcc generally doesn't).
 * Real recursion would eat up our stack space.
 */

/*
 * dput - release a dentry
 * @dentry: dentry to release 
 *
 * Release a dentry. This will drop the usage count and if appropriate
 * call the dentry unlink method as well as removing it from the queues and
 * releasing its resources. If the parent dentries were scheduled for release
 * they too may now get deleted.
 *
 * no dcache lock, please.
 */

void dput(struct dentry *dentry)
{
	if (!dentry)
		return;

repeat:
	if (atomic_read(&dentry->d_count) == 1)
		might_sleep();
	if (!atomic_dec_and_lock(&dentry->d_count, &dcache_lock))
		return;

	spin_lock(&dentry->d_lock);
	if (atomic_read(&dentry->d_count)) {
		spin_unlock(&dentry->d_lock);
		spin_unlock(&dcache_lock);
		return;
	}

	/*
	 * AV: ->d_delete() is _NOT_ allowed to block now.
	 */
	if (dentry->d_op && dentry->d_op->d_delete) {
		if (dentry->d_op->d_delete(dentry))
			goto unhash_it;
	}
	/* Unreachable? Get rid of it */
 	if (d_unhashed(dentry))
		goto kill_it;
  	if (list_empty(&dentry->d_lru)) {
  		dentry->d_flags |= DCACHE_REFERENCED;
		dentry_lru_add(dentry);
  	}
 	spin_unlock(&dentry->d_lock);
	spin_unlock(&dcache_lock);
	return;

unhash_it:
	__d_drop(dentry);
kill_it:
	/* if dentry was on the d_lru list delete it from there */
	dentry_lru_del(dentry);
	dentry = d_kill(dentry);
	if (dentry)
		goto repeat;
}

#endif










struct dentry *d_create(struct dentry *parent, struct qstr *qstr);
struct dentry *d_lookup(struct dentry *dir, struct qstr *name);

#include<linux/slab.h>
struct slab_head *dentry_cache;

int d_rehash(struct dentry *dir, unsigned hash);
static inline struct dentry * dget(struct dentry *dentry){
	dentry->count++;
	return dentry;
}

static inline void dput(struct dentry *dentry){
	dentry->count--;
}
#endif
