#ifndef IF_ETHER_H
#define IF_ETHER_H
#include<valType.h>

#pragma pack(push)
#pragma pack(1)
struct ethhdr{
	char yourmac[6];
	char mymac[6];
	u16 protocol;
};
#pragma pack(pop)

#define ETHHDR_LEN (sizeof( struct ethhdr) )
#endif
