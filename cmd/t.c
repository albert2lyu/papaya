static inline unsigned readb(void *addr){
	unsigned value;
	__asm__ __volatile__("xor %0, %0\n\t"
						 "movb (%%ebx), %b0\n\t"
						 :"=r"(value)
						 :"b"(addr)
						 );
	return value;
}

#pragma pack (push)
#pragma pack (1)
struct pci_config_addr{
	int always:2 ;		/* 0 ~ 1 */
	unsigned reg: 6;	/* 2 ~ 7 */
	union{
		struct{
			unsigned func: 3;	/* 8 ~ 10 */
			unsigned dev: 5;	/* 11 ~ 15 */
			unsigned bus: 8;	/* 16 ~ 23 */
		};
		unsigned short value;
	};
	unsigned reserved:	7;
	int enabled:	1;
};

#pragma pack (pop)
struct pci_config_addr2{
	int always:2 ;		/* 0 ~ 1 */
	unsigned reg: 6;	/* 2 ~ 7 */
	union{
		struct{
			unsigned func: 3;	/* 8 ~ 10 */
			unsigned dev: 5;	/* 11 ~ 15 */
			unsigned bus: 8;	/* 16 ~ 23 */
		};
		unsigned short value;
	};
	unsigned reserved:	7;
	int enabled:	1;
};
int main(void ){
	int x = 0x67686970;
	int a = 1 + 1;
}
