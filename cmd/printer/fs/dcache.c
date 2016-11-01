#include<linux/dcache.h>
#include<list.h>
#include<utils.h>


/* d_create时，会为qstr的字符串分配空间，专门存起来 */
struct dentry *d_create(struct dentry *parent, struct qstr *qstr){
	//struct dentry *dentry = kmalloc(sizeof(struct dentry));
	struct dentry *dentry = kmem_cache_alloc(dentry_cache, 0);
	if(!dentry) return dentry;
	char *str = kmalloc(qstr->len + 12);	/*kmalloc的bug，需要+12*/	
	strncpy(str, qstr->name, qstr->len);
	str[qstr->len] = 0;
	dentry->name.name = str;
	dentry->name.len = qstr->len;
	dentry->name.hash = qstr->hash;

	dentry->parent = 0;
	dentry->inode = 0;
	dentry->operations = 0;
	if(parent){
		dentry->parent = parent;
		dentry->sb = parent->sb;	/*? 挂载一个设备时，small_root的parent应该是0吧,
										这儿对吗*/
	}
	INIT_LIST_HEAD(&dentry->hash);
	INIT_LIST_HEAD(&dentry->vfsmount);
	return dentry;
}

int d_rehash(struct dentry *dir, unsigned hash){
	hash = hash + (u32)dir / 4;		//将directory地址也参与杂凑
	return hash % D_HASHTABLE_LEN;
}

struct dentry *d_lookup(struct dentry *dir, struct qstr *name){
	struct list_head *tentacle = dentry_hashtable + d_rehash(dir, name->hash);	
	struct list_head *end = tentacle;

	/*traverse the list */
	while( (tentacle = tentacle->next)!= end){
		struct dentry *ent = MB2STRU(struct dentry, tentacle, hash);
		if(ent->parent != dir) continue;
		if(ent->operations && ent->operations->compare){
			if(ent->operations->compare( &ent->name, name)) continue;
		}
		else{	//common compare
			if(name->len != ent->name.len) continue;
			if(strncmp((char *)ent->name.name, (char *)name->name, name->len)) continue;
		}
		
		return ent;
	}
	return 0;
}


/*设置dentry并挂入杂凑队列
 * 杂凑时需要“所在目录"的dentry，这里没有传进来一个parent参数，是因为@dentry已经在
 * d_create时被设置了parent。
 */
 /*
void d_add(struct dentry* dentry, struct inode *inode){
	dentry->inode = inode;
	struct list_head *head = d_hash(dentry->parent, dentry->name->hash);
	list_add(&dentry->hash, head);
}
*/









