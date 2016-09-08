#ifndef X86_BIT_H
#define X86_BIT_H

static inline int __bs(unsigned x){
	unsigned lowest;
	__asm__ __volatile__("bsf %1, %0\n\t"
						 "jnz ok\n\t"
						 "mov $-1, %0\n\t"
						 "ok:\n\t"
						 :"=r"(lowest)
						 :"r"(x)
						 );
	return lowest;

}

static inline int __bsr(unsigned x){
	unsigned highest;
	__asm__ __volatile__("bsr %1, %0\n\t"
						 "jnz okok\n\t"
						 "mov $-1, %0\n\t"
						 "okok:\n\t"
						 :"=r"(highest)
						 :"r"(x)
						 );
	return highest;

}

static inline int __bs0r(unsigned x){
	return __bsr(~x);

}

static inline int __bs0(unsigned x){
	return __bs(~x);
}

int __bt(void *base, int bit_id);
int __bts(void *base, int bit_id);		///bit test and set
int __btr(void *base, int bit_id);		//bit test and reset
//int __btc(void *base, int bit_id);	complement, we don't use it

/*  @desc	mask the highest @m bits of digit @x.
			Note, just make a right-value, @x won't be changed.
 *  @x	any type of "u32, u16, u8" is ok
		POINTER not allowed.	
		signed digit is allowed, but not suggested.
 *  @m	how many bits you want to mask
 */
#define MASK_H(x, m) ({							\
					int n = sizeof(x) * 8;		\
					int throw = 32 - n + (m);		\
					unsigned u = x;	\
					u = u << throw >> throw;	\
					u;					\
					})

// L means lowest
#define MASK_L(x, m) ((x) >> (m) << (m))

#endif
