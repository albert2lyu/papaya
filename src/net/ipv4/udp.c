#include<disp.h>
#include<net/udp.h>
#include<linux/skbuff.h>
#include<linux/byteorder/generic.h>

static void info_udpmsg(struct udphdr *udphdr);

/* udp header byte endian flip */
#define UDPHDR_BE_FLIP(udphdr)\
	do{													\
		BYTE_ENDIAN_FLIP2( (udphdr)->myport );			\
		BYTE_ENDIAN_FLIP2( (udphdr)->yourport );		\
		BYTE_ENDIAN_FLIP2( (udphdr)->tot_len );			\
		BYTE_ENDIAN_FLIP2( (udphdr)->chksum );			\
	}while(0)
	

void udp_layer_receive(struct sk_buff *comer){
	/*check sum verify? */		
	UDPHDR_BE_FLIP(comer->udphdr);	
	info_udpmsg(comer->udphdr);
}

static void info_udpmsg(struct udphdr *udphdr){
	oprintf("UDP port(%x) ==> port(%x) ", udphdr->myport, udphdr->yourport);	
	//int datalen = udphdr->tot_len - 8;
//	__less(udphdr->data, datalen);
	//oprintf(" %x bytes :%*s\n", datalen, datalen, udphdr->data);
}
