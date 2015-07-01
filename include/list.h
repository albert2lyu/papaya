#ifndef LIST_H
#define LIST_H

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
#endif






