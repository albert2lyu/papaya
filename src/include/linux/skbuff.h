#ifndef SKBUFF_H
#define SKBUFF_H
#include<linux/slab.h>
#include<valType.h>
struct ethhdr;
struct arphdr;
struct iphdr;
struct icmphdr;
struct udphdr;
struct net_device;
/* 1, sk_buff doesn't contain data, it holds pointer to a data-buffer who contains,
 *    sk_buff also collects some ctrl information.
 * 2, the data-buffer contains a data-area, and gaps exists before the data area and 
 *    after, for flexible usage.
 */
struct sk_buff{
	int pkgsize;			/* package length */
	int bufsize;		/* buffer size */

	char *data;			/* i.e. buffer */

	struct sk_buff *next, *prev;
	struct net_device *dev;
	
	struct ethhdr *ethhdr;
	union{
		struct iphdr *iphdr;
		struct arphdr *arphdr;
		void *second_hdr;
	};
	union{
		struct icmphdr *icmphdr;
		struct udphdr *udphdr;
		void *third_hdr;
	};
};


void dev_free_skb( struct sk_buff *skb);
struct sk_buff * dev_alloc_skb( int len );
struct sk_buff *dev_alloc_skb2(u32 msgtype, size_t len);
void net_init(void);
void skbuff_init(void);





#endif
