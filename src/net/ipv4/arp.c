/* 1, arp协议并不直接参与到package的格式里，它是通过维护一张ip-mac映射表，来提供
 *     “最后一百米”的寻址。
 */
#include<net/arp.h>
#include<linux/slab.h>
#include<linux/byteorder/generic.h>
#include<utils.h>
#include<linux/netdevice.h>
#include<linux/skbuff.h>
#include<linux/ip.h>
/* For those sk_buffs who are waiting the ARP layer to resolve their target 
 * MAC address. The Arp layer will try updating the 'IP-MAC' table by sending 
 * an ARP package to net-cable. And then, will re-process these strayed children
 * Note! @later_down must share a same length with @arptbl. some code relies on 
 * that.
 */
static struct sk_buff **later_down;
static u8 __mac_broadcast[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
static u8 __mac_empty[6] = {0};
u32 __local_ip = MAKE_IP(192, 168, 0, 9);	/*TODO one for each nic */
struct arp_record{
	u32 his_ip;
	char his_mac[6];
	struct arp_record *prev, *next;
};
#define ARP_TBL_LEN 256
static struct arp_record **arptbl;

void arp_init(void){
	later_down = kmalloc2( 4 * ARP_TBL_LEN, __GFP_ZERO);
	arptbl = kmalloc2 (4 * ARP_TBL_LEN, __GFP_ZERO);
}

/* BUG 一个问题，为什么要向网关发送ARP，为什么要向一个单独的主机发送ARP */
static void init_arp_msg(struct sk_buff *arpmsg, 
							int operation,
							u8 *mymac, u32 myip, 
							u8 *yourmac,  u32 yourip)
{
	assert( arpmsg->pkgsize == 14 + 28 && arpmsg->dev);

	//struct arp_packet packet = kmalloc2( sizeof( struct arp_packet), 0)
	struct ethhdr *ethhdr = arpmsg->ethhdr;
	struct arphdr *arphdr = arpmsg->arphdr;
	struct net_device *dev = arpmsg->dev;
	
	if(!mymac) mymac= dev->mac;

	memcp(ethhdr->mymac, mymac, 6);
	memcp(ethhdr->yourmac, yourmac ? yourmac : __mac_broadcast, 6);
	ethhdr->protocol = htons(0x0806);

	arphdr->hardware = htons(1);
	arphdr->protocol = htons(0x0800);
	arphdr->operation = htons(operation);
	arphdr->haddr_len = 6;
	arphdr->paddr_len = 4;
	/* Note, we fill in 'yourmac', 'yourip' before 'mymac', 'myip', because 
	 * in some cases, we just copy "myip' to 'yourip'.
	 */
	memcpy(arphdr->yourmac, yourmac ? yourmac : __mac_empty, 6);
	arphdr->yourip = htonl(yourip);

	memcpy(arphdr->mymac, mymac, 6);
	arphdr->myip = htonl(myip ? myip : __local_ip);
}

static u8 *arp_lookup(u32 ip){
	spin(" arp look up");
	return 0;
}
/* invoked within arp_act() when an ARP reply message comes, or within 
 * arp_respond() when an ARP inquiry message comes. They both running in a 
 * bottom half, so arp_learn() is never re-entered. 
 *
 */
static struct arp_record * arp_learn(u8 *comer_mac, u32 comer_ip){
	int index = comer_ip % ARP_TBL_LEN;
	struct arp_record *record = arptbl[index];
	while(record){
		if( record->his_ip == comer_ip) break;
		record = record->next;
	}
	/* ok, this ARP message comes from a known host, try update */
	if(record){
		memcpy( record->his_mac, comer_mac, 6);
	}
	else{	/* a new IP, we will learn it */
		record = kmalloc2( sizeof( struct arp_record), 0 );		
		record->his_ip = comer_ip;
		memcpy( record->his_mac, comer_mac, 6);
		
		LL_I( arptbl[index], record);
		oprintf("ARP Learn:" );
		print_mac(comer_mac);
		oprintf("<==");
		print_ip(comer_ip);
		oprintf("\n");
	}
	return record;
}

void arp_inquire(u32 yourip, u8 *mymac, u32 myip ){
	//spin("in arp_inquire");
	struct sk_buff *skb = dev_alloc_skb2( 0x0806, 0);
	init_arp_msg(skb, 1, mymac, myip, 0, yourip);
	waiting_for_transmit(skb);
}

static void arp_respond(struct sk_buff *msg, u8 *mymac, u32 myip){
	arp_learn(msg->arphdr->mymac, msg->arphdr->myip);	

	init_arp_msg(msg, 2, mymac, myip, msg->arphdr->mymac, msg->arphdr->myip);
	waiting_for_transmit(msg);	
}

/* when we receive an ARP reply on operation 1 */
static void arp_act(struct sk_buff *skb){
	struct arphdr *arphdr = skb->arphdr;
	assert(arphdr->operation == 2 &&
			arphdr->yourmac[3] == skb->dev->mac[3]);

	struct arp_record * record = arp_learn( arphdr->mymac ,arphdr->myip);

	int index = record->his_ip % ARP_TBL_LEN;
	struct sk_buff * waiting = later_down[index];
	while(waiting){
		struct sk_buff *_next = waiting->next;
		if(waiting->iphdr->yourip == record->his_ip){
			memcpy(waiting->ethhdr->yourmac, record->his_mac, 6);
			cli();
			LL_DEL(later_down[index], waiting);
			sti();	//BUG
			waiting_for_transmit(waiting);
		}
		waiting = _next;
	}
}
/* @DESC receive a package from upper layer, and fill in the  ehter-header's
 * 'MAC' field corresponding to it's IP. if the target ip is addressed in the 
 * subnet of the sender, we fill in the 'MAC' field by scaning the IP-MAC table.
 * Otherwise, we let it be the MAC of the Gateway.(i.e we will send this package
 * to Gateway)
 */
void arp_down(struct sk_buff *skb){
	assert(0);
	#if 1
	memcpy(skb->ethhdr->mymac, skb->dev->mac, 6);

	struct iphdr * iphdr = skb->iphdr;
	struct net_device *dev = skb->dev;
	//skb_cursor_up(skb, sizeof(struct ethhdr));
	unsigned dest_ip;
	if((iphdr->yourip & dev->ipmask) == (dev->ip & dev->ipmask)){
		dest_ip = dev->gateway_ip;	
	}
	else dest_ip = iphdr->yourip;

	u8 *dest_mac = arp_lookup(dest_ip);
	if(dest_mac){
		memcpy(skb->ethhdr->yourmac, dest_mac, 6);
		cli();
		LL2_A( &dev->tx_queue, skb);
		sti();
	}
	else{
		oprintf("[!]\n");
		cli();
		//LL2_A( waiting_list(skb), skb);		
		int index = iphdr->yourip % ARP_TBL_LEN;
		LL_I( later_down[index], skb);
		sti();
	}
	#endif
}



void arp_layer_receive( struct sk_buff *comer_skb ){
	assert(comer_skb->pkgsize = 14 + 28);

	struct arphdr *arphdr = (void *)(comer_skb->ethhdr + 1);
	comer_skb->arphdr = arphdr;
	////////////Entry here !!
	///////////network byte order to host order, only performed on arp header
	BYTE_ENDIAN_FLIP2(arphdr->hardware);
	BYTE_ENDIAN_FLIP2(arphdr->protocol);
	BYTE_ENDIAN_FLIP2(arphdr->operation);
	BYTE_ENDIAN_FLIP4(arphdr->myip);
	BYTE_ENDIAN_FLIP4(arphdr->yourip);

	//////////done
	u8 *mac = arphdr->mymac;
	oprintf("arp layer receive: operation=%u, from mac(%x %x %x %x %x %x)", arphdr->operation, mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
	if(arphdr->operation == 1){		/* it's an inquiry */
		arp_respond(comer_skb, 0, 0);
	}	
	else if(arphdr->operation == 2){	/* it's a REPLY */
		arp_act(comer_skb);
	}
	else spin("unknown operation");
	
	oprintf(" ARP layer exit\n");
}
