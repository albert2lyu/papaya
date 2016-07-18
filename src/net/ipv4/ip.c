#include<linux/ip.h>
#include<linux/if_ether.h>
#include<linux/skbuff.h>
#include<linux/netdevice.h>
#include<utils.h>
#include<linux/mylist.h>
#include<linux/byteorder/generic.h>
#define FRAG_BEGIN 1
#define FRAG_MID 2
#define FRAG_END 3
/* @return 
 * 0: No;  
 * 1: yes, first fragment; 
 * 3, yes, the final one; 
 * 2, yes, 2 ~ n-1
 */
static inline int is_fragment(struct iphdr *iphdr){
	if(!iphdr->flag_mf && iphdr->me_offset == 0) return 0;		
	if(iphdr->me_offset == 0 && iphdr->flag_mf) return FRAG_BEGIN;
	if(iphdr->me_offset && !iphdr->flag_mf) return FRAG_END;
	return FRAG_MID;
}

#define FRAG_OFFSET(iphdr) ((iphdr)->me_offset << 3)
/* the length(including header) of the origin ip datagram 
 * indicated by the final fragment 
 */
#define IP_ORIGIN_SIZE(frag_end) \
	( (frag_end)->me_offset * 8 + (frag_end)->tot_len)

/* flip byte endian order of some fields in ip header */
#define IPHDR_FLIP(iphdr) 							\
	do{												\
		BYTE_ENDIAN_FLIP2((iphdr)->tot_len);		\
		BYTE_ENDIAN_FLIP2((iphdr)->msgid);			\
		BYTE_ENDIAN_FLIP2((iphdr)->flag_off);		\
		BYTE_ENDIAN_FLIP2(iphdr->chksum);			\
		BYTE_ENDIAN_FLIP4((iphdr)->myip);			\
		BYTE_ENDIAN_FLIP4((iphdr)->yourip);			\
	}while(0)
	
/* collector[FRAG_TBL_LEN]
 * This is a hash table organised as an array of link-list, to collect all 
 * ip fragments for reassemble.  
 * Source IP value as hash seed.
 * IP fragments from one host will be sent to a same link-list.
 */
static struct sk_buff **collector;
#define FRAG_TBL_LEN 128 

static void ip_up(struct sk_buff *skb);
static struct sk_buff *ip_adopt_one(struct sk_buff *skb);
static struct sk_buff * ip_reassemble(struct sk_buff *group_head);
static struct sk_buff *ip_fragment(struct sk_buff *orgin);

void ip_layer_init(void){
	collector = static_alloc(sizeof(void *), FRAG_TBL_LEN);
}

/* 1, the entry of incoming IP Message. We convert all it's members to little 
 *    byte endian.
 */
void ip_layer_receive(struct sk_buff *skb){
	struct iphdr *iphdr = skb->iphdr;
	assert(iphdr->version == 4 && iphdr->len == 5);
	/* CRC16 check must be done before byte endian flip */
	u16 checksum = crc16_compute_be(iphdr, 20);
	if((u16)~checksum != 0) spin("crc check failed");

	IPHDR_FLIP(iphdr);

	/* see if this is an ip fragment */
	if( is_fragment(skb->iphdr)){		/* throw it into fragments collector*/
		struct sk_buff *group_head = ip_adopt_one(skb);
		assert(group_head);
		if(group_head->iphdr->flag_mf == false && 
		   group_head->gotsize + IPHDR_LEN == IP_ORIGIN_SIZE(group_head->iphdr))
		{
			skb = ip_reassemble(group_head);
		}
		else{
			oprintf("+");
			return;
		}
	}

	ip_up(skb);
	return;
}

/* identifier, protocol, checksum, flip 
 * 这时IP层向下的出口，我们在此把IP头转换成网络字节序。
 */
static int __ip_down(struct sk_buff *skb, u8 me_protocol, u8 ttl){
	assert(skb->dev);

	struct iphdr *iphdr = skb->iphdr;
	iphdr->protocol = me_protocol;
	iphdr->msgid = skb->dev->ip_identifier++;
	iphdr->ttl = ttl;
	
	if(iphdr->tot_len < 1486){
		IPHDR_FLIP(iphdr);
		crc16_write_be(iphdr, IPHDR_LEN, &iphdr->chksum);
		arp_down(skb);
		return 0;
	}

	/* we need slice this ip datagram */
	struct sk_buff *group_head = ip_fragment(skb);
	/* hand over all fragments to arp layer */
	struct list_head *curr = &group_head->node;
	void *begin = curr;
	do{
		struct sk_buff *frag = MB2STRU(struct sk_buff, curr, node);
		arp_down(frag);
		curr = curr->next;
	}while(curr != begin);
	//dev_free_skb(skb);
	return 0;
}

/* 如果IP分片的话，那header在分片函数里都会弄好，这儿就不用弄了,不对，只管
 * 加工好一个IP报文，分片是最后的事
 * 2, 一些字段不让上层设置。像比identifier，怎么生成怎么递增这是IP层的事情,
 *    像比frag_offset，这个字段本来就是给IP层分片提供的设施，上层就更管不着了。
 * 3, 考虑开放ttl字段给上层吗。 icmp的tracerout是明显要用的。
 */
int ip_down(struct sk_buff *skb, u8 me_protocol, 
			u32 dest_ip, 	u32 src_ip,
			u8 ttl){

	struct iphdr *iphdr = skb->iphdr;
	iphdr->version = 4;
	iphdr->len = 5;
	iphdr->ignore = 0;
	iphdr->tot_len = skb->pkgsize - ETHHDR_LEN;
	return __ip_down(skb, me_protocol, ttl);
}

int ip_echo(struct sk_buff *skb, u8 me_protocol, u8 ttl){
	struct iphdr *iphdr = skb->iphdr;
	EXCHG_U32(iphdr->myip, iphdr->yourip);
	return __ip_down(skb, me_protocol, ttl);
}

/* 产生的IP分片都是网络字节序的，因为分片时肯定要写入CRC，写入CRC就需要先
 * 做字节翻转
 */
static struct sk_buff *ip_fragment(struct sk_buff *orgin){
	assert(0);
	return 0;
}
/* two jobs: merge data, release skbuffs.
 * 要求第一片必须是终止分片。
 */
static struct sk_buff * ip_reassemble(struct sk_buff *group_head){
	assert(is_fragment(group_head->iphdr) == FRAG_END);

	struct iphdr *iphdr = group_head->iphdr;
	int tot_len = IP_ORIGIN_SIZE(iphdr);
	struct sk_buff *origin_skb = dev_alloc_skb(tot_len + ETHHDR_LEN);	
	int index = iphash(iphdr->myip) % FRAG_TBL_LEN;

	assert(sti_already());
	cli();
	LL_CHECK(collector[index], group_head);
	LL_DEL(collector[index], group_head);	
	sti();
	

	/* restore ethernet header and ip header */
	memcpy(origin_skb->ethhdr, group_head->ethhdr, ETHHDR_LEN + IPHDR_LEN);
	/* now, we merge payload area */
	struct list_head *curr = &group_head->node;	
	void *start = curr;
	do{
		struct sk_buff *skb = MB2STRU(struct sk_buff, curr, node);
		oprintf("copy fragment to .., len:%x\n", IP_PAYLOAD_LEN(skb->iphdr));
		memcpy( 
				(char *)origin_skb->third_hdr + FRAG_OFFSET(skb->iphdr), 
				skb->third_hdr,
				IP_PAYLOAD_LEN(skb->iphdr)
			  );	
		curr = curr->next;

		//dev_free_skb(skb);
	}while(curr != start);

	origin_skb->iphdr->me_offset = 0;
	origin_skb->iphdr->tot_len = tot_len;
	return origin_skb;
}

static void ip_up(struct sk_buff *skb){
	struct iphdr *iphdr  = skb->iphdr;
	struct pseudo_hdr pseudo_hdr = {
		myip: htonl(iphdr->myip),
		yourip: htonl(iphdr->yourip),
		zero: 0,
		protocol: iphdr->protocol,
		payload_len: htons(IP_PAYLOAD_LEN(iphdr))
	};
	switch(iphdr->protocol){
		case 1:
			icmp_receive(skb);
			break;
		case 2:
			oprintf("@IGMP\n");
			break;
		case 6:
			tcp_layer_recv(skb, &pseudo_hdr);
			break;
		case 17:
			udp_layer_receive(skb);
			break;
		default:
			oprintf("unknown protocol: %u\n", iphdr->protocol);
			spin("spin");
	}

}

/* return the queue head of that ip fragment group.
 * 禁止重入。
 * 2， bufsize这时就用来存放gotsize，反正它也没什么用。
 * TODO 不需要把终止片放在第一个。
 */
static struct sk_buff *ip_adopt_one(struct sk_buff *skb){
	assert(skb->iphdr->me_offset | skb->iphdr->flag_mf);
	struct iphdr *iphdr = skb->iphdr;
	unsigned src_ip = iphdr->myip;
	/* Has any friend been hashed ?*/
	struct sk_buff *group_head = 0;
	int index = iphash(src_ip ) % FRAG_TBL_LEN;
	LL_SCAN_ON_KEY(collector[index], iphdr->msgid, iphdr->msgid, group_head);
	/* No.
	 * 将这个skb插入一级队列，并暂时作为二级队列的队列头*/
	if(!group_head){
		LL_I(collector[index], skb);
		INIT_LIST_HEAD(&skb->node);
		skb->gotsize = IP_PAYLOAD_LEN(skb->iphdr);
		oprintf("no friend found, insert as first one. just return\n");
		return skb;
	}
	oprintf("see? find a friend");
	/* 相应的ip分片组已经存在 */
	list_add( &skb->node, &group_head->node);	//插在第一片后面
	if(!iphdr->flag_mf){	//收到的是中止IP片，把它调换到二级队列头
		LL_REPLACE(collector[index], group_head, skb);
		assert("meet the final one, replace done\n");
		skb->gotsize = group_head->gotsize;
		group_head = skb;
	}
	group_head->gotsize += IP_PAYLOAD_LEN(skb->iphdr);
	return group_head;
}







