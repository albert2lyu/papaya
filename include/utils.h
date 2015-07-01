#ifndef UTILS_H
#define UTILS_H
#include<ku_utils.h>
#include<mm.h>
#include<valType.h>
/**the following two macros aim at beautify code.
 * and,can you write a 'break_say'?
 */
#define return_say(msg)		do{oprintf("%s",msg);return;} while(0)
#define returnx_say(x,msg)	do{oprintf("%s",msg);return x;} while(0)
/**emulate binary-digit.
 * note! this macro never checks security of 'x',so make sure x no more
 * than 8 bit. write like B(00000100). case like B(000011110) is wrong
 */
#define B(x) ((0x##x&1)+(0x##x>>4&1)*2+(0x##x>>8&1)*4+(0x##x>>12&1)*8+\
	(0x##x>>16&1)*16+(0x##x>>20&1)*32+(0x##x>>24&1)*64+(0x##x>>28&1)*128)
void detect_cpu(void);//send cpu information to specified area
extern void dispAX();
extern void dispEAX();
extern void dispStr(char const*const pt,unsigned int ahMod);
extern void dispInt(unsigned int);
extern void dispStrn(char const*const pt,unsigned int ahMod);
extern unsigned char in_byte(int port);
u32 in_dw(int port);
extern void out_byte(int port,unsigned value);
void out_dw(int port,u32 value);
extern int ring,path_ring0,ienter,stack_position,crack_eip;
void assert_func(char*exp,char*file,char*base_file,int line);
void port_read(unsigned port,void*buf,unsigned byte);
void port_write(unsigned port,void*buf,unsigned byte);
void send_hd_eoi(void);
void spin(char *msg);
/**
 * description: search a string of bit 1 from a memory segment.
 * arguments: [addr] memory segment start address.
 * 		   	  [num_111] the length of bit string
 * 		   	  [scope] how many dword(=4byte) you want to scan before stopping.
 * return: [-1] scan failed.
 * 		   [>=0] start bit offset of the matched bit string.
 * TODO:in order to simplify the algorithm(another reason is to speed up the scanning),
 * this function doesn't support a cross-border match,for example,the target memory
 * segment looks like: ...[000..00111][1100..000]... ('[]' contains a dword,namely 32 bits), if you
 * want to search a bit string '11111', you will fail. 
 * Maybe someday we will need a cross-border match, implement it by then.
 */
int bitscan111(u32 addr, int num_111, int scope);

/**description: set a ceartain bit in memory
 * arguments: [addr] start address
 * 			  [bit_off] bit offset from start address, -2G~+2G(unit is bit,not byte) is valid.
 */
void bitset(u32 addr,int bit_off);

void bitclear(u32 addr, int bit_off);

/**description: set a string of  bits in memory
 * arguments: [num] how many bits you want to set.
 * atten: if you want to set a string of bits longer than 32,use bitsset_long() instead of this
 */
void bitsset(u32 addr, int bit_off, int num);

void bitsclear(u32 addr, int bit_off, int num);

/**
 * arguments: [bit_off] don't pass a negative value
 */
bool  bitsset_long(u32 addr, int bit_off, int num);
bool  bitsclear_long(u32 addr, int bit_off, int num);

int bit1_count(char*addr,int bytes);
void memcpy(char*dest,char*src,int bytes);
int strlen(char*str);
char*strcpy(char*dest,char*src);
#define assert(exp)\
do{if(!(exp)) assert_func(#exp,__FILE__,__BASE_FILE__,__LINE__);} while(0);

#define DSI(str,i)\
dispStr(str,0x400);\
dispInt(i);

//留着以后测吧
#define POINTER_SHIFT(pt,type,len) (type*)((u32)pt+len) 
#define EXCHG_U32(a,b) do{void *c=a;a=b;b=c;} while(0)
boolean strmatch(char*seg,char*whole);
void info_heap(void);

/**deleting node from an empty linked-list is forbidden.
 * you must specify the target list's root-node when you use these macros.
 */

/**list: root node
 * location: the node you want to insert at
 * new: the node you want to inser
 * LL means linked-list
 */
#define LL_INSERT(list,location,new)\
	do{\
		assert(list&&location&&new);\
		new->next=location;\
		new->prev=location->prev;\
		if(location->prev) location->prev->next=new;\
		location->prev=new;\
		if(list==location) list=new;\
	} while(0)

/**insert a node to list in an ascending order by compare 'attr'*/
#define LL_I_INCRE(list,new,attr)\
	do{\
		assert(new);\
		if(!list){\
			list=new;\
			new->prev=new->next=0;\
			break;\
		}\
		void*root=list;\
		while(list->next&&list->attr<new->attr) list=list->next;\
		if(list->attr<new->attr){\
			list->next=new;\
			new->next=0;\
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

#define LL_I_DECRE(list,new,attr)\
	do{\
		assert(new);\
		if(!list){\
			list=new;\
			new->prev=new->next=0;\
			break;\
		}\
		void*root=list;\
		while(list->next&&list->attr>new->attr) list=list->next;\
		if(list->attr>new->attr){\
			list->next=new;\
			new->prev=list;\
			new->next=0;\
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

#define MEMBER_OFFSET(stru_type, member_name) \
	(unsigned)&(((stru_type *)0)->member_name)
#endif
