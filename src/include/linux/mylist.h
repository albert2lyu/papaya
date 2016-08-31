#ifndef MYLIST_H
#define MYLIST_H

/* 'll2' type link-list. It's nothing new, just with a pointer to the tail
struct ll2{
	struct xx *root;
	struct xx *tail;
}
*/

#define LL2_POP(ll2) 											\
	do{															\
		assert( (ll2 && (ll2)->root && (ll2)->tail));			\
		ll2->root = ll2->root->next;							\
		if(ll2->root) ll2->root->prev = 0;						\
		else ll2->tail = ll2->root;								\
	}while(0)													

/* link-list operation: Append*/
#define LL2_A(ll2, node)										\
	do{															\
		assert(   (ll2)  && (node) );							\
		assert(   ( (ll2)->root == 0 && (ll2)->tail == 0 ) ||	\
				  ( (ll2)->root != 0 && (ll2)->tail != 0)		\
			  );												\
		(node)->prev = (ll2)->tail;								\
		if( (ll2)->tail ){										\
			(ll2)->tail->next = node;							\
		}														\
		else{													\
			(ll2)->root = node;									\
		}														\
		(node)->next = 0;										\
		(ll2)->tail = node;										\
	}while(0)

#define LL2_DEL(ll2, node)										\
 do{															\
	 assert( (ll2) && (node) && (ll2)->root && (ll2)->tail );	\
	 if( (node)->prev ){										\
		(node)->prev->next = (node)->next;						\
	 }															\
	 else{														\
	 	assert( (ll2)->root == node );							\
		(ll2)->root = (node)->next;								\
	 }															\
	 															\
	 if( (node)->next ){										\
	 	(node)->next->prev = (node)->prev;						\
	 }															\
	 else{														\
		assert( (ll2)->tail == node );							\
		(ll2)->tail = (node)->prev;								\
	 }															\
 }while(0)

/*----------END of operations for ll2-type link-list --------------*/



/**deleting node from an empty linked-list is forbidden.
 * you must specify the target list's root-node when you use these macros.
 */

#if 0
//list和location必须非0
#define LL_APPEND(list, location, new)\
	do{\
		assert((list) && (location) && (new));\
		d
	}
#endif

/**list: root node
 * location: the node you want to insert at
 * new: the node you want to inser
 * LL means linked-list
 * @list 和 @location可以都为0,单不能一个为０，另一个非０ 
 * 所以 第二个测试,(list && location)是说，不相等可以，但必须都不为０
 */
#define LL_INSERT(list,location,new)\
	do{\
		assert( ( (list) == (location) ) || ( (list) && (location) ) );\
		assert((new));\
		if(!list && !location) {\
			list = new;\
			new->next = new->prev = 0;\
			break;\
		}\
		new->next=location;\
		new->prev=location->prev;\
		if(location->prev) location->prev->next=new;\
		location->prev=new;\
		if(list==location) list=new;\
	} while(0)

#define LL_I(root, new)									\
	do{													\
		if(root){										\
			new->prev = root;							\
			new->next = root->next;						\
			if(root->next) root->next->prev = new;		\
			root->next = new;							\
		}												\
		else{											\
			root = new;									\
			new->prev = new->next = 0;					\
		}												\
	}while(0)

#define LL_I2(root, new)								\
	do{													\
		assert(root);									\
		if(root->next) root->next->prev = new;			\
		new->next = root->next;							\
		new->prev = root;								\
		root->next = new;								\
	}while(0)

#define LL_REPLACE(root, old, new)						\
	do{													\
		new->prev = old->prev;							\
		new->next = old->next;							\
		if(new->prev) new->prev->next = new;			\
		if(new->next) new->next->prev = new;			\
		if(root == old) root = new;					\
	}while(0)
/**insert a node to list in an ascending order by compare 'attr'
* 这里用root备份list，而用list遍历，是取巧的方法。
* 2, 相等时会插在既有节点后面。
* 3, attr相等时不会停，会继续往后搜索，直到遇到比他大的，或者tail。所以进入
* 插入操作时，只有两种情况:list iterator是tail，或list iterator的attr大。特殊
* 情况是既为tail，attr又bigger。
* 4, 插入时，不要认为遍历停下来的时候，如果new->attr >= list->attr，就是遇到了
* tail。 这取决于你的遍历条件，如果条件是next when new->attr > list->attr，
* 那就是说，attr相等时也会停下来。 所以插入时候，不要假定是在末端。（虽然，这样
* 效率会低一些)
* 5, 为了效率，可以遇到=就停下来，插入的时候，发现new->attr仍然>，那就判定是
* tail。这样插入更快。 但随之而来的结果，attr=attr时，new会不断插在前面。
*/
#define LL_I_INCRE(list,new,attr)\
	do{\
		assert(new);\
		if(!list){\
			list=new;\
			new->prev=new->next=0;\
			break;\
		}\
		void*root=list;\
		while(list->next &&  new->attr > list->attr) list=list->next;\
		if(new->attr > list->attr){\
			new->next = 0;\
			new->prev=list;\
			list->next = new;\
			list=root;\
		}\
		else{\
			new->next = list;\
			new->prev = list->prev;\
			if(list->prev) list->prev->next = new;\
			list->prev=new;\
			if(root==list) list=new;\
		}\
	} while(0)

//DECRE INSERT在相等时的插入顺序待定
#define LL_I_DECRE(list,new,attr)\
	do{\
		assert(new);\
		if(!list){\
			list=new;\
			new->prev=new->next=0;\
			break;\
		}\
		void*root=list;\
		while(list->next && new->attr < list->attr) list=list->next;\
		if(new->attr < list->attr){\
			new->next = 0;\
			list->next=new;\
			new->prev=list;\
			list=root;\
		}\
		else{\
			new->next=list;\
			new->prev=list->prev;\
			if(list->prev) list->prev->next=new;\
			list->prev=new;\
			if(root==list) list=new;\
		}\
	} while(0)

#define LL_DEL(list,location)\
	do{\
		assert(list&&location);\
		assert(!(!location->next && !location->prev && (list!=location)));\
		if(location->prev) location->prev->next=location->next;\
		if(location->next) location->next->prev=location->prev;\
		if(list==location) list=location->next;\
	} while(0)

#define LL_INFO(list,attr)\
	do{\
		void*root=list;\
		while(list){\
			printf("%d ",list->attr);\
			list=list->next;\
		}\
		list=root;\
	} while(0)

#define LL_ASSIGN(list,attr,value)\
	do{\
		void *root = list;\
		while(list){\
			list->attr=value;\
			list=list->next;\
		}\
		list = root;\
	} while(0)

#define LL_SCAN_ON_KEY(root, key, value, result)\
	do{\
		result = root;\
		while(result){\
			if( (result)->key == (value) ){\
				break;\
			}\
			result = (result)->next;					\
		}\
	}while(0)


/* 检查node是否在root指示的list里 */
#define LL_CHECK(root, node)									\
	do{															\
		void *backup = root;									\
		while(root){											\
			if(root == node) break;								\
			root = root->next;									\
		}														\
		assert(root && "can not find node in that list");		\
		root = backup;											\
	}while(0)





#endif















