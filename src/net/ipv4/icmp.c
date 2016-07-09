#include<net/icmp.h>
#include<utils.h>
#include<linux/skbuff.h>

void icmp_receive(struct sk_buff *skb){
	struct icmphdr *hdr = skb->icmphdr;
	oprintf("@ICMP type: %u, subtype: %u\n", hdr->type, hdr->subtype);
	return;
}
