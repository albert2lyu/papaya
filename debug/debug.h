#ifndef X86_DEBUG_H
#define X86_DEBUG_H

#pragma pack(push)
#pragma pack(1)
union dr_ctrl{
	unsigned value;
	struct{
		unsigned L0: 1;
		unsigned G0: 1;
		unsigned L1: 1;
		unsigned G1: 1;
		unsigned L2: 1;
		unsigned G2: 1;
		unsigned L3: 1;
		unsigned G3: 1;		//bit 7

		unsigned:	 8;		//bit 8 ~ 15

		unsigned RWE0: 2;
		unsigned LEN0: 2;
		unsigned RWE1: 2;
		unsigned LEN1: 2;
		unsigned RWE2: 2;
		unsigned LEN2: 2;
		unsigned RWE3: 2;
		unsigned LEN3: 2;
	};
};

#define RWE_EXEC 0
#define RWE_W_ONLY 1
#define RWE_WR 3

#define BRK_ADDR_ALIGN_1 0
#define BRK_ADDR_ALIGN_2 1
#define BRK_ADDR_ALIGN_4 3

#pragma pack(pop)
#endif
