#ifndef LIST_H
#define LIST_H
/*the host structures will be organised into a circle link-list */

typedef struct list_head{
	struct list_head *prev;
	struct list_head *next;
}list_head_t;

#define INIT_LIST_HEAD(l)\
	do{\
		(l)->prev = (l)->next = l;\
	} while(0)

static inline void __list_add(list_head_t *new, list_head_t *prev,
												list_head_t *next){
		new->next = next;
		next->prev = new;
		new->prev = prev;
		prev->next = new;
}

/**
 * 1,assume only one entry in list, (new)'s 'next' pointer will point back to
 * 'head', and (head)'s prev will point to 'new'. So, the list is circle list.
 */

static inline void list_add(list_head_t *new, list_head_t *head){
	__list_add(new, head, head->next);
}

static inline void list_add_tail(list_head_t *new, list_head_t *head){
	__list_add(new, head->prev, head);
}


/**
 * 1, if you pass the same value as prev and next, the list will be broken on
 * this entry, and the entry itself is picked up from list, just as a new
 * initialized list-head.
 */
static inline void __list_del(list_head_t *prev, list_head_t *next){
	prev->next = next;
	next->prev = prev;
}

/* if only one entry left in a list, this function has no effect*/
static inline void list_del(list_head_t *entry){
	__list_del(entry->prev, entry->next);
}

static inline void list_del_init(list_head_t *entry){
	__list_del(entry->prev, entry->next);
	INIT_LIST_HEAD(entry);
}

static inline int list_empty(list_head_t *entry){
	return entry->next == entry;
}

static inline int list_meet_tail(list_head_t *first, list_head_t *entry){
	return entry->next == first;
}

/* search from the 2th node, for many list, the 1th list_head isn't in a mother struct*/
#define LIST_FIND2(stru_t, mb_t, root, key, value, result) 		\
	do{													\
		struct list_head * node = root->next;			\
		stru_t *obj;									\
		while(node != root){							\
			 *obj = MB2STRU(stru_t, node, mb_t);		\
			if( (obj)->key == value ) break;			\
			node = node->next;							\
		}												\
		if(node == root) result = 0;					\
		else result = obj;								\
	} while(0);

static inline void hashtable_add(list_head_t *hashtable, int hash, list_head_t *new){
	list_add(new, hashtable + hash)	;
}

/* not necessary
static inline void hashtable_del(list_head_t *hashtable, int hash, list_head_t *todel){
	list_del(todel);
}
*/
#define MB2STRU(stru_type, mb_addr, mb_name)\
			(stru_type *)( (u32)(mb_addr)-  (u32)&((stru_type *)0)->mb_name )	
#endif






