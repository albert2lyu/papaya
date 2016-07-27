//不要混淆了，echo_down和echo，前者是通用函数，后者是icmp特有的消息类型。
#include<net/icmp.h>
#include<utils.h>
#include<linux/skbuff.h>
#include<linux/byteorder/generic.h>

static struct sk_buff *example;
static void icmp_down(struct sk_buff *skb, u32 dest_ip, u32 src_ip);
static void icmp_echo_down(struct sk_buff *skb);
void icmp_echo(u32 dest_ip){
	//BREAK  在icmp_down里设置了 tcp length了，估计这里就不需要拷贝98字节了。
	//但猫里出去的却没有收到reply。
	struct sk_buff *baby = dev_alloc_skb(70);	
	//memcpy(baby->ethhdr, example->ethhdr, 70);
	struct icmphdr * icmphdr = baby->icmphdr;
	icmphdr->type = ICMP_ECHO;
	icmphdr->subtype = 0;
	icmphdr->data.dword[0] = __RDTSC_U();
	icmp_down(baby, dest_ip, 0);
}

void icmp_receive(struct sk_buff *comer){
	struct icmphdr *hdr = comer->icmphdr;
	oprintf("@ICMP type: %u, subtype: %u\n", hdr->type, hdr->subtype);
	int icmp_len = IP_PAYLOAD_LEN(comer->iphdr);
	u16 checksum = crc16_compute_be(hdr, icmp_len);
	if((u16)~checksum) spin("ICMP CRC16 check failed");
	switch(hdr->type){
		case ICMP_ECHO:{
				hdr->type = ICMP_ECHOREPLY;
				example = comer;
				icmp_echo_down(comer);
				icmp_echo(MAKE_IP(192, 168, 1, 1));
				//icmp_echo(MAKE_IP(192, 168, 0, 22));
				//arp_inquire(MAKE_IP(192,168,1,1));
				break;
		}
		case ICMP_ECHOREPLY:{
			u32 now = __RDTSC_U();
			struct __eax *eax = (void *)&comer->iphdr->myip;
			oprintf("echo reply from : %u.%u.%u.%u, time cost :%u\n",
					eax->AH, eax->AL, eax->ah, eax->al,
					hdr->data.dword[0] - now);
			break;
		}
		default:
			oprintf("ignore it..");
	}
	return;
}

static void icmp_down(struct sk_buff *skb, u32 dest_ip, u32 src_ip){
	crc16_write_be(skb->icmphdr, skb->pkgsize - 14 - 20, &skb->icmphdr->checksum);	
	ip_down(skb, PROTOCOL_ICMP, dest_ip, src_ip, 64);
}

static void icmp_echo_down(struct sk_buff *skb){
	crc16_write_be(skb->icmphdr, IP_PAYLOAD_LEN(skb->iphdr), &skb->icmphdr->checksum);	
	ip_echo_down(skb, PROTOCOL_ICMP, 64);

}






