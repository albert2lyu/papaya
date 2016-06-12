#ifndef UTILS_H
#define UTILS_H
#include<ku_utils.h>
#include<valType.h>
//杂凑值是一个0 -> 2^32-1 区间的一个无符号整数
static inline unsigned str_hash(const char *str, int len){
    unsigned seed = 131; // 31 131 1313 13131 131313 etc..
    unsigned hash = 0;
	for (int i = 0; i < len; i++) 	hash = hash * seed + str[i];
	//hash = hash & 0x7FFFFFFF; 
	return hash;
}
/* @desc  round x to 2^n
 * e.g. given 65, got 128
 */
static inline unsigned ceil2n(int x){
	int highest;
	__asm__ __volatile__("bsr %1, %0"
						 :"=r"(highest)
						 :"r"(x)
						 );
	int mask = (1 << highest) - 1;
	return (x + mask) & ~mask;
}

/* e.g.  ceil_div(10, 3) = 4, ceil_div(10, 4) = 3, ceil_div(10, 5) = 2 */
static inline unsigned ceil_div(unsigned a, unsigned b){
	unsigned quotient;
	__asm__ __volatile__("xor %%edx, %%edx\n\t"
						 "div %%ebx\n\t"
						 "add $-1, %%edx\n\t"
						 "adc $0, %%eax\n\t"
						:"=a"(quotient)
						:"a"(a), "b"(b));
	return quotient;
}

static inline unsigned __BSR(unsigned x){
	unsigned highest;
	__asm__ __volatile__("bsr %1, %0"
						 :"=r"(highest)
						 :"r"(x)
						 );
	return highest;
}

static inline unsigned ceil_align(unsigned x, unsigned granularity){
	unsigned mask = granularity - 1;
	return (x + mask) & ~mask;
}

#include<mm.h>
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
void memcpy(void*dest,void*src,int bytes);
int strlen(char*str);
char*strcpy(char*dest,char*src);
char*strncpy(char*dest, const char*src, int n);
int strcmp(const char *str1, const char *str2);
int strncmp(const char *str1, const char *str2, int n);
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
/* 0, 这一组函数不会在critical area用,所以cli_already默认是初始是false
 * 1, 这组函数是胆小的函数，just for debug usage
 */
 /*
int cli_already;		//we use this variable because we can't touch eflags
static inline void cli_safe(){
	if(cli_already) spin("cli already"); 
	__asm__ __volatile__("cli");
	cli_already = 1;
}
static inline void sti_safe(){
	if(!cli_already) spin("not cli yet");
	__asm__ __volatile__("sti");
	cli_already = 0;
}
*/
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
		assert(new);\
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

#define MEMBER_OFFSET(stru_type, member_name) \
	(unsigned)&(((stru_type *)0)->member_name)

void memtest(void *, int len);
void udelay(unsigned long usecs);

#endif
