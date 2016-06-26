#ifndef BYTEORDER_GENERIC_H
#define BYTEORDER_GENERIC_H
#include<valType.h>
static inline u16 htons(u16 hostshort){
	__asm__ __volatile__("xchg %%ah, %%al"
						 :"=a"(hostshort)
						 :"a"(hostshort)
						 );
	return hostshort;
}

static inline u32 htonl(u32 hostlong){
	__asm__ __volatile__("bswap %1"
						 :"=r"(hostlong)
						 :"r"(hostlong)
						 );
	return hostlong;
}
#define ntohs(x) htons(x)
#define ntohl(x) htonl(x)
#endif
