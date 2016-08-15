#ifndef NET_TCP_H
#define NET_TCP_H
#include<valType.h>
#include<linux/ip.h>

#define TCP_FLAG_FIN  (1)
#define TCP_FLAG_SYN  (1<<1)
#define TCP_FLAG_RST  (1<<2)
#define TCP_FALG_PSH  (1<<3)
#define TCP_FLAG_ACK  (1<<4)
#define TCP_FALG_URG  (1<<5)
#define TCP_FALG_ECE  (1<<6)
#define TCP_FALG_CWR  (1<<7)

#pragma pack(push)
#pragma pack(1)

struct tcp_opt{
	u8 kind;
	u8 len;
	union{
		u8 byte[0];
		u16 word[0];
		u32  dword[0];
	}data;
};

/*
    0                   1                   2                   3   
    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |          Source Port          |       Destination Port        |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                        Sequence Number                        |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                    Acknowledgment Number                      |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |  Data |           |U|A|P|R|S|F|                               |
   | Offset| Reserved  |R|C|S|S|Y|I|            Window             |
   |       |           |G|K|H|T|N|N|                               |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |           Checksum            |         Urgent Pointer        |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                    Options                    |    Padding    |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                             data                              |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
*/
struct tcphdr{
	u16 myport;
	u16	yourport;
	u32 seq;
	u32	ack;
	int resv: 4;
	int	len:  4;			/* by unit of 4-bytes */
	union{
	struct{
		int flag_fin: 1;
		int flag_syn: 1;
		int flag_rst: 1;
		int flag_psh: 1;
		int flag_ack: 1;
		int flag_urg: 1;
		int flag_ece: 1;
		int flag_cwr: 1;
	};
		u8 flags;
	};
	u16 wndsize;
	u16 chksum;
	u16 urgptr;
	struct tcp_opt opt_area[0];
};

#pragma pack(pop)

#define TCPHDR_LEN (sizeof(struct tcphdr))
static inline u32 tcphash(u32 hisip, u16 hisport, u32 myport){
	u32 hash = iphash(hisip) +  (hisport & 0xff) + (hisport >> 8) 
							 +  (myport & 0xff) + (myport >> 8);
	return hash;
}
void init_tcp(void);
void tcp_layer_recv(struct sk_buff *comer);
#endif
