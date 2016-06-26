#include<linux/skbuff.h>
#include<linux/netdevice.h>
#include<linux/if_ether.h>
#include<net/arp.h>
#include<linux/ip.h>
#include<linux/udp.h>
#include<linux/icmp.h>

struct slab_head *skbuff_cache;
void skbuff_init(void){
	skbuff_cache =  kmem_cache_create("skbuff_cache", sizeof(struct sk_buff), 0,
										SLAB_HWCACHE_ALIGN, 0, 0);
}

/* @msgtype 
 * bit[0~15]  main protocol type: IP(0x0800), ARP(0x0806)
 * bit[24~31] upper class protocol type: icmp(1), udp(17), tcp(6)
 * bit[16~23] sub-type of icmp:	....
 */
struct sk_buff *dev_alloc_skb2(u32 msgtype, int len){
	struct sk_buff *skb = kmem_cache_alloc(skbuff_cache, 0);
	len += sizeof( struct ethhdr);
	switch(msgtype & 0xffff){
		case 0x0806:	//arp
			len += sizeof( struct arphdr );
			break;
		case 0x0800:	//ip
			len += sizeof( struct iphdr);
			switch(msgtype >> 24){
				case 17:	//udp
					len += sizeof( struct udphdr);
					break;
				case 1:		//icmp
					switch(msgtype << 8 >> 24){
						case 3:
							len += sizeof( struct icmpmsg_un);
							break;
						case 17:
						case 18:
							len += sizeof( struct icmpmsg_mask);
							break;
						case 13:
						case 14:
							len += sizeof( struct icmpmsg_tstamp);
							break;
						default:
							spin("unknown icmp type");
					}
				default:
					spin("unknown IP type");
			}
		default:
			spin( "unknown main protocol type" );
	}

	char *data = kmalloc2( len, 0);
	skb->data = data;
	skb->ethhdr = (void *)data;
	skb->second_hdr = (void *)(data + sizeof(struct ethhdr) );
	if( (msgtype & 0xffff) == 0x0800){	//upper protocol based on IP
		skb->third_hdr = (void *)((u32)skb->second_hdr + sizeof(struct iphdr));
	}

	/*TODO more initialization */
	skb->len = len;
	skb->dev = pick_nic();
	return skb;
}
struct sk_buff * dev_alloc_skb( int len ){
	struct sk_buff *skb = kmem_cache_alloc(skbuff_cache, 0);
	char *buffer = kmalloc2( len, 0 );
	skb->data = buffer;
	skb->ethhdr = (void *)buffer;

	skb->len = len;
	skb->truesize = len + sizeof(struct sk_buff);
	skb->dev = pick_nic();
	return skb;	
}

void dev_free_skb( struct sk_buff *skb){
	/* strong order */
	kfree2(skb->data);
	kmem_cache_free( skbuff_cache, skb );
}
