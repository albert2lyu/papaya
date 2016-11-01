#ifndef UDP_H
#define UDP_H
#include<linux/skbuff.h>
#include<valType.h>

#pragma pack(push)
#pragma pack(1)

struct udphdr{
	u16 myport;	
	u16 yourport;
	u16 tot_len;
	u16 chksum;
	char data[0];
};

#pragma pack(pop)


void udp_layer_receive(struct sk_buff *comer);
#endif
