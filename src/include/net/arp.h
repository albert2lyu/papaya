#ifndef ARP_H
#define ARP_H
#include<valType.h>
#include<linux/if_ether.h>
#include<linux/skbuff.h>

#pragma pack(push)
#pragma pack(1)

struct arphdr{
	u16 hardware;
	u16 protocol;
	u8 haddr_len;
	u8 paddr_len;
	u16 operation;
	u8 mymac[6];
	u32 myip;
	u8 yourmac[6];
	u32 yourip;
};

struct arp_packet{
	struct ethhdr ethhdr;
	struct arphdr arphdr;
};

#define ARP_PACK_SIZE (sizeof(struct arp_packet))
#pragma pack(pop)

void mk_arp_packet(struct arp_packet *packet, u8 *mymac, unsigned myip, u8 *yourmac,  u32 yourip);
void arp_init(void);
void arp_layer_receive(struct sk_buff *skb);
void arp_down(struct sk_buff *skb);
void arp_inquire(u32 yourip, u8 *mymac, u32 myip );
#endif









