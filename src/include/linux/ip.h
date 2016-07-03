#ifndef IP_H
#define IP_H
#include<valType.h>
#pragma pack(push)
#pragma pack(2)
struct iphdr{
	int version: 4;
	u32 len: 4;						/* header length */
	u8 ignore;
	u16 tot_len;					/* total length, header included */
	u16 msgid;						/* IP datagram identification */
	int flag_reserved: 1;
	int flag_df: 1;					/* don't fragment */
	int flag_mf: 1;					/* more fragments */
	u32 me_offset: 13;				/* the offset of this IP fragment */
	u8 ttl;
	u8 protocol;
	u16 chksum;
	u32 myip;
	u32 yourip;
};
#pragma pack(pop)
#endif
