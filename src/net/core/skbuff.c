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

/* This is a shorthand for creating some typical packages. e.g. ARP, ICMP.
 * @msgtype 
 * bit[0~15]  main protocol type: IP(0x0800), ARP(0x0806)
 * bit[24~31] upper class protocol type: icmp(1), udp(17), tcp(6)
 * bit[16~23] sub-type of icmp:	....
 *
 * @payload
 * Size of payload.
 * For datagram(i.e. ARP, ICMP) without payload,  leave it  0. For udp, tcp, 
 * 'payload' should be the size of their datagram with all headers tripped.
 */
struct sk_buff *dev_alloc_skb2(u32 msgtype, size_t payload){
	int len = sizeof( struct ethhdr);
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

	return dev_alloc_skb( len + payload );	
}

/* 1, Note, we initialize the third header pointer, but it may be invalid.(when
 *    it's not a IP datagram) 
 * TODO 也许buffer区是可以用结构体表示的，我现在在skb里存放的3个指针，其实
 * 已经是这种行为了，它们都是死的。该挪到buffer里去。现在的顾虑是，对网络协议
 * 种类了解的还不够多，linux这么做肯定有它的道理。
 */
struct sk_buff * dev_alloc_skb( int pkgsize ){
	int bufsize = pkgsize + 2;
	struct sk_buff *skb = kmem_cache_alloc(skbuff_cache, 0);
	skb->data = kmalloc2( bufsize, 0 );

	skb->ethhdr = (void *)( skb->data + 2 );
	skb->second_hdr = (void *)(skb->ethhdr + 1);
	skb->third_hdr = (void *)(skb->iphdr + 1);

	skb->dev = pick_nic();		/* TODO remove it later */
	skb->bufsize = bufsize;
	skb->pkgsize = pkgsize;
	return skb;	
}

void dev_free_skb( struct sk_buff *skb){
	/* strong order */
	kfree2(skb->data);
	kmem_cache_free( skbuff_cache, skb );
}
