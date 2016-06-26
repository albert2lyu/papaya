#ifndef IP_H
#define IP_H
#include<valType.h>
#pragma pack(push)
#pragma pack(2)
struct iphdr{
	int version: 4;
	u32 len: 4;
	u8 ignore;
	u16 totlen;
	u16 id;
	u32 flags: 3;
	u32 frag_ofst: 13;
	u8 ttl;
	u8 protocol;
	u16 chksum;
	u32 myip;
	u32 yourip;
};
#pragma pack(pop)
#endif
