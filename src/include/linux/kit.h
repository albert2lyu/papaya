#ifndef KIT_H
#define KIT_H


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

/* Usually, we need to know the minimal 'order' we need to 
   allocate @nr pages.
   e.g 34 pages => order 8 needed, that's 2^8
 */
static inline int pgorder_needed(int nr){
	int order;
	nr = ceil2n(nr);	
	__asm__ __volatile__("bsr %1, %0"
						 :"=r"(order)
						 :"r"(nr)
						 );
	return order;
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

static inline ulong ceil_align(ulong x, ulong granularity){
	ulong mask = granularity - 1;
	return (x + mask) & ~mask;
}

static inline ulong floor_align(ulong x, ulong align){
	ulong mask = align - 1;
	return x & ~mask;
}

//留着以后测吧
#define POINTER_SHIFT(pt,type,len) (type*)((u32)pt+len) 
#define EXCHG_U32(a,b) do{unsigned c=a;a=b;b=c;} while(0)
#define EXCHG_PTR(a, b) do { void *tmp = a; a = b; b = tmp; } while(0)
#define EXCHG_U16(a,b) do{ u16 tmp = a; a = b; b = tmp; } while(0)

#define ptr_offset(ptr, bytes) \
	((void *)( (unsigned long)ptr + (unsigned long)(bytes) ) )











#endif
