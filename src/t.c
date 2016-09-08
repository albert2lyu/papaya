#include<stdio.h>
#pragma pack(push)
#pragma pack(1)
union pte{
	int value; 		
	struct {
		unsigned present: 1;
		unsigned writable: 1;
		unsigned user: 1;
		unsigned : 2;
		unsigned accessed: 1;
		unsigned dirty: 1;
		unsigned : 2;
		unsigned avl: 3;
		unsigned physical: 20;
	};
};

union linear_addr{
	unsigned value;
	struct{
		unsigned offset: 12;	
		unsigned tbl_idx: 10;
		unsigned dir_idx: 10;
	};
};

#pragma pack(pop)

#define DO(stru) ({ *(int *)&(stru) &= ~0xfff;  stru; })
//#define DO(stru) ({ (stru) &= ~0xfff;  stru; })

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

int main(void){
	int xx = MASK_H( (unsigned short)0xffff, 7);
	printf("%x", xx);
	#if 0
	union linear_addr laddr;
	laddr.value = 0x40333;
	
	printf("%p", laddr);
	#endif
	return 0;
}







