#include<net/icmp.h>
#include<utils.h>
#include<linux/skbuff.h>
#include<linux/byteorder/generic.h>

void icmp_echo(struct sk_buff *skb){
	
}
void icmp_receive(struct sk_buff *skb){
	struct icmphdr *hdr = skb->icmphdr;
	oprintf("@ICMP type: %u, subtype: %u\n", hdr->type, hdr->subtype);
	int icmp_len = IP_PAYLOAD_LEN(skb->iphdr);
	u16 checksum = crc16_compute_be(hdr, icmp_len);
	if((u16)~checksum) spin("ICMP CRC16 check failed");
	switch(hdr->type){
		case ICMP_ECHO:{
				hdr->type = ICMP_ECHOREPLY;
				crc16_write_be(hdr, icmp_len, &hdr->checksum);
				ip_echo(skb, PROTOCOL_ICMP, skb->iphdr->ttl);
				break;
		}
		case ICMP_ECHOREPLY:
			oprintf("unbelievable, ICMP ECHO REPLY received..\n");
			break;
		default:
			oprintf("ignore it..");
	}
	return;
}
