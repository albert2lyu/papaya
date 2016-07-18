//1, 暂时不考虑超时重发：所有的包都会顺利抵达。 但稍后实现timer的时候，记得timer
//的action一定要用bh做，不然会cli模式下，依稀bh操作很可能引发bug。
//2, TCP结束时,尝试3次握手怎么样.
#include<net/tcp.h>
#include<linux/skbuff.h>
#include<net/ip.h>
#include<linux/byteorder/generic.h>
#include<utils.h>


static void print_tcpmsg(struct tcphdr *hdr);

enum{
	 lianjiebucunzai,
	 faqizhe_dengdaiqueren,
	 yingdazhe_dengdaiqueren,
	 lianjieyijianli,
	 gaotuizhe_dengdaiqueren,
	 houtuizhe_dengdaiqueren,
	 gaotuizhe_baoliuzhenting
};
 

struct connect{
	u32 myip;
	u32 hisip;
	u16 myport;
	u16 hisport;
	int state;
	u32 seq_got;		//zuijinyigeshoudaodebaowendesequence number
	u32 seq_out;		//zuijinyigefachudebaowendesequence number
	struct connect *next;
	struct connect *prev;
};

#define lianjiebiaochang 1024
static struct connect **lianjiebiao;

static struct connect *
__connection_lookup(u32 hisip, u16 hisport, u32 myip, u16 myport);
static struct connect *
__connection_create(u32 hisip, u16 hisport, u32 myip, u16 myport);

static struct connect * connection_lookup(struct sk_buff * comer);
static struct connect * connection_create(struct sk_buff *comer);

static void tcp_fin(void){

}

#define TCPHDR_FLIP(tcphdr)	\
		do{												\
			BYTE_ENDIAN_FLIP2(tcphdr->myport);			\
			BYTE_ENDIAN_FLIP2(tcphdr->yourport);		\
			BYTE_ENDIAN_FLIP4(tcphdr->seq);				\
			BYTE_ENDIAN_FLIP4(tcphdr->ack);				\
			BYTE_ENDIAN_FLIP2(tcphdr->wndsize);			\
			BYTE_ENDIAN_FLIP2(tcphdr->chksum);			\
			BYTE_ENDIAN_FLIP2(tcphdr->urgptr);			\
		}while(0)

void tcp_layer_recv(struct sk_buff *comer, struct pseudo_hdr *pseudo_hdr){
	struct tcphdr *tcphdr = comer->tcphdr;

	//oprintf("ip tot_len:%x hdr_len:%x\n", comer->iphdr->tot_len, comer->iphdr->len);
	int tcplen = IP_PAYLOAD_LEN(comer->iphdr);

	int checksum = crc16_compute_be(tcphdr, tcplen);
	int checksum2 = crc16_compute_be(pseudo_hdr, sizeof(struct pseudo_hdr));
	int sum = checksum + checksum2;
	sum = (sum & 0xffff) + (sum >> 16);
	assert(~sum);

	TCPHDR_FLIP(tcphdr);	

	print_tcpmsg(tcphdr);
	struct connect *connect = connection_lookup(comer);
	if(connect) connect->seq_got = tcphdr->seq;
	assert(tcphdr->flag_rst == 0);
	if(!connect){
		connect = connection_create(comer);
		connect->seq_got = tcphdr->seq;
		if(tcphdr->flags == TCP_FLAG_SYN){
			/*XXX 发送这个询问包*/
			oprintf("someone try connecting me ");
			tcphdr->flag_ack = 1;
			tcphdr->flag_syn = 1;
			tcphdr->ack = connect->seq_got + 1;
			tcphdr->seq = connect->seq_out + 1; //fasongsyn,xiaohaoyigexuliehao
			EXCHG_U16(tcphdr->myport, tcphdr->yourport);	
			TCPHDR_FLIP(tcphdr);

			tcphdr->chksum = 0;
			int checksum = crc16_compute_be(tcphdr, tcplen);
			int sum = checksum + checksum2;
			sum = (sum & 0xffff) + (sum >> 16);
			tcphdr->chksum = htons( ~sum );

			connect->state = yingdazhe_dengdaiqueren;
			connect->seq_out = tcphdr->seq;	
			
			ip_echo(comer, PROTOCOL_TCP, comer->iphdr->ttl);
			return;
		}
		else goto ignore;
	}

	if(connect->state == lianjiebucunzai){	// the initial state by default
		goto ignore;	
	}
	else if(connect->state == faqizhe_dengdaiqueren){	//zaidengdaidierciwoshou
		if(tcphdr->ack == connect->seq_got && 
				tcphdr->flags == (TCP_FLAG_SYN | TCP_FLAG_ACK) ){

			//TODO 此处若被另一个同源包中断?不会,这是bottom half
			/* we are waiting it */
			// XXX EMIT ack pkg
			/* 注意,发出去的这个ACK可能丢失, server收不到的话,它会再发一次
			 * ACK+SYN包.那时,我们已经是STAT_ESTLBSHED状态了.
			 */
			connect->state = lianjieyijianli;
		}
		else goto ignore;
	}
	else if(connect->state == yingdazhe_dengdaiqueren){
		if(tcphdr->flags == TCP_FLAG_ACK && connect->seq_got == tcphdr->ack){
			oprintf("got an ack now, i just sent an ack+syn\n");
			connect->state = lianjieyijianli;	
		}
		else goto ignore;
	}
	else if(connect->state == lianjieyijianli){
		assert(tcphdr->flag_ack);		//TODO zhegeduanyansihushicuode
		if(tcphdr->flags == TCP_FLAG_FIN){	//duifangyaoduankaile
			//send ack and fin		
			connect->state = houtuizhe_dengdaiqueren;
		}
		else goto ignore;
	}
	else if(connect->state == gaotuizhe_dengdaiqueren){
		if(tcphdr->flag_ack){
			connect->state = gaotuizhe_baoliuzhenting;
			if(tcphdr->flag_fin){
				//send ack	
				connect->state = lianjiebucunzai;
			}
		}
		else goto ignore;
	}

	else if(connect->state == gaotuizhe_baoliuzhenting){
		if(tcphdr->flag_syn){
			//send ack
			connect->state = lianjiebucunzai;
		}
		else goto ignore;
	}

	else if(connect->state == houtuizhe_dengdaiqueren){
		if(tcphdr->flags == TCP_FLAG_ACK){
			connect->state = lianjiebucunzai;		
		}
		else goto ignore;
	}
	else assert(0);
	return;

	ignore:
	oprintf("ignore this tcp message\n");
	//print_tcpmsg(comer);
}

static void print_tcpmsg(struct tcphdr *hdr){
	oprintf("tcp message, seq:%x, ack:%x\n", hdr->seq, hdr->ack);	
}
static struct connect *
__connection_lookup(u32 hisip, u16 hisport, u32 myip, u16 myport){
		int index = tcphash(hisip, hisport, myport) % lianjiebiaochang;
		struct connect *curr = lianjiebiao[index];
		while(curr){
			if(curr->hisip == hisip && curr->hisport == hisport &&
			   curr->myip == myip && curr->myport == myport) 
				return curr;
			curr = curr->next;
		}
		return 0;
}

/* 根据某个接收到的tcp报文,查找相应的tcp connect 结构体*/
static struct connect * connection_lookup(struct sk_buff * comer){
	return __connection_lookup(comer->iphdr->myip, comer->tcphdr->myport,
							   comer->iphdr->yourip, comer->tcphdr->yourport);
}

static struct connect *
__connection_create(u32 hisip, u16 hisport, u32 myip, u16 myport){
		int index = tcphash(hisip, hisport, myport) % lianjiebiaochang;
		struct connect *connect = kmalloc2( sizeof(struct connect), 0);
		connect->myip = myip;
		connect->hisip = hisip;
		connect->hisport = hisport;
		connect->myport = myport;
		connect->state = lianjiebucunzai;

		connect->seq_out = 0;	/*TODO use a random value as initial Sequence*/

		LL_I(lianjiebiao[index], connect);
		return connect;
}

/* 根据某个接收到的tcp报文,创建相应的tcp connect 结构体*/
static struct connect *
connection_create(struct sk_buff *comer){
	return __connection_create(comer->iphdr->myip, comer->tcphdr->myport,
							  comer->iphdr->yourip, comer->tcphdr->yourport);	
}

void init_tcp(void){
	assert( sizeof(struct tcphdr) == 20);
	lianjiebiao = static_alloc( sizeof(void *), lianjiebiaochang);
}