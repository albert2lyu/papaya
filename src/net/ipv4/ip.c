#include<linux/ip.h>
#include<linux/if_ether.h>
#include<linux/skbuff.h>

#if 0
/* collector[FRAG_TBL_LEN]
 * This is a hash table organised as an array of link-list, to collect all 
 * ip fragments for reassemble.  
 * Source IP value as hash seed.
 * IP fragments from one host will be sent to a same link-list.
 */
static struct sk_buff *collector;
#define FRAG_TBL_LEN 128 
#endif

/* 1, the entry of incoming IP Message. We convert all it's members to little 
 *    byte endian.
 */
void ip_layer_receive(struct sk_buff *skb){
	skb->iphdr = (void *)( skb->ethhdr + 1);
	struct iphdr *iphdr = skb->iphdr;

	//BYTE_ENDIAN_FLIP(skb)
	spin(" OK, ip layer receive");
}

#if 0
void ip_layer_init(void){
	collector = static_alloc(sizeof(void *), FRAG_TBL_LEN);
}
#endif







