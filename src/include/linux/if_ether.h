#ifndef IF_ETHER_H
#define IF_ETHER_H
#pragma pack(push)
#pragma pack(1)
#include<valType.h>

struct ethhdr{
	char yourmac[6];
	char mymac[6];
	u16 protocol;
};

#pragma pack(push)
#define ETHHDR_LEN (sizeof( struct ethhdr) )
#endif
