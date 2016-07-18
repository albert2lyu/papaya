#ifndef IP_H
#define IP_H
#include<valType.h>
#define PROTOCOL_ICMP 1
#define PROTOCOL_IGMP 2
#define PROTOCOL_TCP 6
#define PROTOCOL_UDP 17
#pragma pack(push)
#pragma pack(1)
/*
    0                   1                   2                   3
    7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |Version|  IHL  |Type of Service|          Total Length         |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |         Identification        |Flags|      Fragment Offset    |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |  Time to Live |    Protocol   |         Header Checksum       |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                       Source Address                          |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                    Destination Address                        |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                    Options                    |    Padding    |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
*/
/* 注意跨字节的bitfield必须等所属的word被flip成小端模式，才能用bitfield访问。
 * 这不是特例，它跟word，dword要用ntoh转换后才能访问一样。
 */
struct iphdr{
	u32 len: 4;						/* header length */
	int version: 4;
	u8 ignore;
	u16 tot_len;					/* total length, header included */
	u16 msgid;						/* IP datagram identification */
	union{
		struct{
			u16 me_offset: 13;				/* the offset of this IP fragment */
			int flag_mf: 1;					/* more fragments */
			int flag_df: 1;					/* don't fragment */
			int flag_reserved: 1;
		};
		u16 flag_off;
	};
	u8 ttl;
	u8 protocol;
	u16 chksum;
	u32 myip;
	u32 yourip;
};

struct pseudo_hdr{
	u32 myip;
	u32 yourip;
	u8 zero;
	u8 protocol;
	u16 payload_len;
};
#pragma pack(pop)

#define IPHDR_LEN ( sizeof( struct iphdr ) )
#define IP_PAYLOAD_LEN(iphdr) (iphdr->tot_len - (iphdr->len * 4) )
static inline unsigned iphash(unsigned ip){
	u8 *byte = (u8 *)&ip;
	return (byte[0] + byte[1] + byte[2] + byte[3]);
}

struct sk_buff;
int ip_echo(struct sk_buff *skb, u8 me_protocol, u8 ttl);
int ip_down(struct sk_buff *skb, u8 me_protocol, 
			u32 dest_ip, 	u32 src_ip,
			u8 ttl);
#endif
