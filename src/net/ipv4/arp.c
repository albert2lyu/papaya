/* 1, arp协议并不直接参与到package的格式里，它是通过维护一张ip-mac映射表，来提供
 *     “最后一百米”的寻址。
 */
#include<net/arp.h>
#include<linux/netdevice.h>
#include<linux/slab.h>
#include<linux/byteorder/generic.h>
#include<utils.h>
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

/* 只是做最简单的初始化，这样arp_inquire和arp_respond里面的代码会有重复，先
 * 不做进一步的提炼。 因为对ARP的所有类型还没学，慢慢进化。
 *
 */
static void init_arp_msg(struct sk_buff *arpmsg,  int operation){
	struct arphdr *arphdr = arpmsg->arphdr;

	arpmsg->ethhdr->protocol = htons(0x0806);

	arphdr->hardware = htons(1);
	arphdr->protocol = htons(0x0800);
	arphdr->operation = htons(operation);
	arphdr->haddr_len = 6;
	arphdr->paddr_len = 4;
}

static u8 *arp_lookup(u32 ip){
	int index = iphash(ip) % ARP_TBL_LEN;
	struct arp_record * root = arptbl[index];
	struct arp_record *it  = 0;
	LL_SCAN_ON_KEY(root, his_ip, ip, it);
	if(it){
		return (u8*)it->his_mac;
	}
	return 0;
}
/* invoked within arp_act() when an ARP reply message comes, or within 
 * arp_respond() when an ARP inquiry message comes. They both running in a 
 * bottom half, so arp_learn() is never re-entered. 
 *
 */
static struct arp_record * arp_learn(u8 *comer_mac, u32 comer_ip){
	int index = iphash(comer_ip )% ARP_TBL_LEN;
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
		//oprintf("ARP Learn:" );
		//print_mac(comer_mac);
		//oprintf("<==");
		//print_ip(comer_ip);
		//oprintf("\n");
	}
	return record;
}

#if 0
void __arp_inquire(u32 yourip, u8 *mymac, u32 myip ){
	//spin("in arp_inquire");
	struct sk_buff *skb = dev_alloc_skb2( 0x0806, 0);
	init_arp_msg(skb, 1, mymac, myip, 0, yourip);
	waiting_for_transmit(skb);
}
#endif

//arp询问，一般不指定自己的mac，只是根据对方ip挑选网卡
void arp_inquire(u32 yourip){
	struct net_device *netdev = pick_nic(yourip, 0);
	assert(netdev);

	struct sk_buff *skb = dev_alloc_skb2( 0x0806, 0);
	struct arphdr *arphdr = skb->arphdr;
	init_arp_msg(skb, 1);
	skb->dev =  netdev;
	memcpy(skb->ethhdr->yourmac, __mac_broadcast, 6);
	memcpy(skb->ethhdr->mymac, netdev->mac, 6);

	memset(arphdr->yourmac, 0, 6);
	memcpy(arphdr->mymac, netdev->mac, 6);
	arphdr->yourip = htonl(yourip);
	arphdr->myip = htonl(netdev->ip);

	waiting_for_transmit(skb);
}

/* 这个接口只考虑常规应答，我是什么ip，什么mac，就照直告诉它。 */
static void arp_respond(struct sk_buff *msg){
	struct arphdr * arphdr = msg->arphdr;
	struct ethhdr * ethhdr = msg->ethhdr;
	struct net_device *netdev = msg->dev;

	arp_learn(msg->arphdr->mymac, msg->arphdr->myip);	

	init_arp_msg(msg, 2);

	memcpy(ethhdr->yourmac, arphdr->mymac, 6);
	memcpy(ethhdr->mymac, netdev->mac, 6);

	memcpy(arphdr->yourmac, ethhdr->yourmac, 6);
	memcpy(arphdr->mymac, netdev->mac, 6);
	arphdr->yourip = htonl(arphdr->myip);

	arphdr->myip = htonl(netdev->ip);

	waiting_for_transmit(msg);	
}

/* when we receive an ARP reply on operation 1 */
static void arp_act(struct sk_buff *skb){
	struct arphdr *arphdr = skb->arphdr;
	assert(arphdr->operation == 2 &&
			arphdr->yourmac[3] == skb->dev->mac[3]);

	struct arp_record * record = arp_learn( arphdr->mymac ,arphdr->myip);

	int index = iphash(record->his_ip )% ARP_TBL_LEN;
	struct sk_buff * waiting = later_down[index];
	//oprintf("laterdown try waked!target ip:%s, got index:%u\n", mk_ipstr(record->his_ip), index);
	while(waiting){
		oprintf("$");
		struct sk_buff *_next = waiting->next;
		if(waiting->iphdr->yourip == htonl(record->his_ip)){
			//oprintf("find one in later_down\n");
			memcpy(waiting->ethhdr->yourmac, record->his_mac, 6);
			cli();
			LL_DEL(later_down[index], waiting);
			sti();	//BUG
			waiting_for_transmit(waiting);
		}
		waiting = _next;
	}
}
/* @DESC 
 * Now, an IP datagram wanna go out. We let arp layer determine it's next hop,
 * to a gateway, or directly to another host in LAN.
 */
void arp_down(struct sk_buff *skb){
	struct iphdr * iphdr = skb->iphdr;
	unsigned yourip = ntohl(iphdr->yourip);
	//unsigned myip = ntohl(iphdr->myip);

	struct net_device * dev = skb->dev;
	assert(dev);

	memcpy(skb->ethhdr->mymac, skb->dev->mac, 6);
	skb->ethhdr->protocol = htons(0x0800);

	//skb_cursor_up(skb, sizeof(struct ethhdr));
	unsigned nexthop;
	if((yourip & dev->ipmask) == (dev->ip & dev->ipmask)){
		nexthop = yourip;
	}
	else nexthop = dev->gateway_ip;

	u8 *dest_mac = arp_lookup(nexthop);
	if(dest_mac){
		memcpy(skb->ethhdr->yourmac, dest_mac, 6);
		waiting_for_transmit(skb);
	}
	else{
		oprintf("[!]\n");
		cli();
		int index = iphash(yourip )% ARP_TBL_LEN;
		//oprintf("hash ip:%s, got index:%u", mk_ipstr(yourip), index);
		LL_I( later_down[index], skb);
		sti();
		arp_inquire(yourip);
	}
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
	//u8 *mac = arphdr->mymac;
	//oprintf("arp layer receive: operation=%u, from mac(%x %x %x %x %x %x)", arphdr->operation, mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
	if(arphdr->operation == 1){		/* it's an inquiry */
		arp_respond(comer_skb);
	}	
	else if(arphdr->operation == 2){	/* it's a REPLY */
		arp_act(comer_skb);
	}
	else spin("unknown operation");
	
	//oprintf(" ARP layer exit\n");
}
