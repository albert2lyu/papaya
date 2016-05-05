#include<list.h>
#include<linux/fs.h>
#include<utils.h>

/* read a inode(located in sb->dev:ino) from disk and cache it
 * @hash just a shorthand, actually, we can cauculate it by @sb and @ino 
 */
static struct inode *cache_inode(struct super_block *sb, u32 ino, int hash){
	struct inode *inode = kmalloc(sizeof(struct inode));
	inode->ino = ino;
	inode->sb = sb;
	inode->dev = sb->dev;
	sb->operations->read_inode(inode);	

	/* a good inode generated, we send it to hashtable */
	hashtable_add(inode_hashtable, hash, &inode->hash);
	return inode;
}
static int hash(struct super_block *sb, u32 ino){
	return ((u32)sb/4 + ino) % I_HASHTABLE_LEN;
}

/* find or build the inode indicated by @sb and @ino */
struct inode *iget(struct super_block *sb, unsigned ino){
	int hash_value = hash(sb, ino);
	struct list_head *head = inode_hashtable + hash_value;
	struct list_head *curr = head->next;
	while(curr != head){
		struct inode *inode = MB2STRU(struct inode, curr, hash);
		if(inode->ino == ino && inode->sb == sb){
			//inode->count++;
			return inode;
		}
		curr = curr->next;
	}
	
	/* not cached yet, read from disk and cache it*/
	return cache_inode(sb, ino, hash_value);
}
