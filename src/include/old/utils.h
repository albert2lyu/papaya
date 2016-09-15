#ifndef UTILS_H
#define UTILS_H
#include<ku_utils.h>
#include<linux/mylist.h>
#include<valType.h>
#include<linux/assert.h>
#include<linux/byteorder/generic.h>
#include<linux/string.h>
//杂凑值是一个0 -> 2^32-1 区间的一个无符号整数
static inline unsigned str_hash(const char *str, int len){
    unsigned seed = 131; // 31 131 1313 13131 131313 etc..
    unsigned hash = 0;
	for (int i = 0; i < len; i++) 	hash = hash * seed + str[i];
	//hash = hash & 0x7FFFFFFF; 
	return hash;
}
/* @desc  round x to 2^n
 * e.g. Given 65, got 128. Given 63, got 64.
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

static inline ulong ceil_align(ulong x, ulong granularity){
	ulong mask = granularity - 1;
	return (x + mask) & ~mask;
}

static inline ulong floor_align(ulong x, ulong align){
	ulong mask = align - 1;
	return x & ~mask;
}
#include<mm.h>
/**the following two macros aim at beautify code.
 * and,can you write a 'break_say'?
 */
#define return_say(msg)		do{oprintf("%s",msg);return;} while(0)
#define returnx_say(x,msg)	do{oprintf("%s",msg);return x;} while(0)

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

#define DSI(str,i)\
dispStr(str,0x400);\
dispInt(i);

//留着以后测吧
#define POINTER_SHIFT(pt,type,len) (type*)((u32)pt+len) 
#define EXCHG_U32(a,b) do{unsigned c=a;a=b;b=c;} while(0)
#define EXCHG_PTR(a, b) do { void *tmp = a; a = b; b = tmp; } while(0)
#define EXCHG_U16(a,b) do{ u16 tmp = a; a = b; b = tmp; } while(0)
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

#define MEMBER_OFFSET(stru_type, member_name) \
	(unsigned)&(((stru_type *)0)->member_name)

void memtest(void *, int len);
void udelay(unsigned long usecs);

/* by unit of Us */
static inline unsigned __RDTSC_U(void){
	unsigned tsc;
	__asm__ __volatile__("rdtsc\n\t"
						 "shr $18, %%eax\n\t"
						 "shl $14, %%edx\n\t"
						 "or %%eax, %%edx\n\t"
						 :"=d"(tsc));
	return tsc;
}
/* by unit of MS */
static inline unsigned __RDTSC(void){
	unsigned tsc;
	__asm__ __volatile__("rdtsc\n\t"
						 "shr $21, %%eax\n\t"
						 "shl $11, %%edx\n\t"
						 "or %%eax, %%edx\n\t"
						 :"=d"(tsc));
	return tsc;
}

static inline void barrier(void){
	__asm__ __volatile__("":::"memory");
}

static inline void mdelay(int ms){
	int curr = __RDTSC();
	int clock = curr + ms;
	while(1){
		barrier();
		if(__RDTSC() >= clock) return;
	}
}

static inline void cli(void){
	__asm__ __volatile__("cli");
}

static inline void sti(void){
	__asm__ __volatile__("sti");
}

/* @return 		cli already ? 
 * 这个函数可以用cli_already和if组合完成，我暂时用它，是因为可以把pushf和cli
 * 指令的间隔做到最近。但它俩之间，仍然可能会被中断。再看。
 */
static inline bool cli_ex(void){
	int IF;
	__asm__ __volatile__("pushf\n\t"
						 "cli\n\t"
						 "pop %0\n\t"
						 "andl $0x200, %0\n\t"
						 :"=r"(IF)
						 :);
	return IF;
}

static inline unsigned get_eflags(void){
	unsigned eflags;
	__asm__ __volatile__("pushfl\n\t"
						 "pop  %0\n\t"
						 :"=r"(eflags)
						 );
	return eflags;
}

static inline bool cli_already(void){
	unsigned eflags = get_eflags();
	return !(eflags & (1 << 9)) ;
}

static inline bool sti_already(void){
	return !cli_already();
}
#define MAKE_IP(a, b, c, d) (((a)<<24) + ((b)<<16) + ((c)<<8) + d)
char *MAKE_IP_STR(u32 ip);
int oprintf(char*format,...);
static inline void print_mac(u8 * mac){
	oprintf(" %x %x %x %x %x %x ", mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
}
static inline void print_ip(u32 ip){
	oprintf(" %u.%u.%u.%u ", ip>>24&0xff, ip>>16&0xff, ip>>8&0xff, ip&0xff);
}

#define ARR_CELLS(array, stru_t) ( sizeof(array) / sizeof(stru_t))
unsigned read_imr_of8259(void);

/* CRC16, for memory area on big endian */
/* 我们总是在刚接受到一个报文，还没把它转化成本地字节序之前，做CRC校验。
   我们总是在即将发出一个报文，已经把它转化成网络字节序之后，计算并填写CRC值。
   这样，我们跟目标主机面对的是一模一样的报文。(每个bit都一样)。利于我们编程。

   因为我们是小端机器，所以我们要“装作”大端机器去计算CRC校验值。一份报文被分成
   n个16字节大小的cell，我们要确保我们读出来的每个cell的value，和大端机器眼中是
   一样的。这就是crc16_compute_be()唯一要注意的。

   @return 返回的CRC校验值是本地字节序。当然应该这样，一半的情形下，我们只关心
   它是否为0 。
 */
u16 crc16_compute_be(void *area, int len);

/* @DESC 
 * We compute the CRC16 checksum of a memory area, and write the result 
   to @chksum  in netword byte order.
 * @return 		
   We return the checksum in host byte order, just keep consistant
 	with crc16_compute_be(). It's indifferent, we seldom cares about this value.
 */
static inline u16 crc16_write_be(void *area, int len, u16 *chksum){
	*chksum = 0;
	u16 x = crc16_compute_be(area, len);
	*chksum = htons(~x);
	return x;
}

void __less(void *buf, int len);

int memcmp(void *s1, void *s2, int len);
struct __eax { u8 al; u8 ah; u8 AL; u8 AH;};
char * mk_ipstr(u32 ip);

int __bs0s(unsigned *);		
#endif
