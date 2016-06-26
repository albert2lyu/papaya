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
	int len;			/* sizeof (data_area) */
	int truesize;		/* sizeof (data_area + sk_buff) */

	char *head;			/* address of data-buffer */
	char *data;			/* points to real data-area */
	char *tail;			/* end of data-area */
	char *end;			/* end of data-buffer */

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
struct sk_buff *dev_alloc_skb2(u32 msgtype, int len);
void net_init(void);
void skbuff_init(void);





#endif
