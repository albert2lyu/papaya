//1, 暂时不考虑超时重发：所有的包都会顺利抵达。 但稍后实现timer的时候，记得timer
//的action一定要用bh做，不然会cli模式下，依稀bh操作很可能引发bug。
//2, TCP结束时,尝试3次握手怎么样.
#include<net/tcp.h>
#include<linux/skbuff.h>

static void print_tcpmsg(struct sk_buff *skb);

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
	u32 next_seq;
	u32 next_ack;
};

#define lianjiebiaochang 1024
static connect *lianjiebiao;

static struct connect *
_connection_lookup(u32 hisip, u16 hisport, u32 myip, u16 myport);
static struct connect *
_connection_create(u32 hisip, u16 hisport, u32 myip, u16 myport);
static struct connect * connection_lookup(struct sk_buff * comer);

void tcp_layer_recv(struct sk_buff *comer){
	struct tcphdr *tcphdr = comer->tcphdr;
	struct connect *connect = connection_lookup(comer);
	assert(tcphdr->flag_rst == 0);
	if(!connect){
		connect = connection_create();
		if(tcphdr->flags == TCP_FLAG_SYN){
			/*XXX 发送这个询问包*/
			connect->state = faqizhe_dengdaiqueren;
			return;
		}
		else goto ignore;
	}

	if(connect->state == lianjiebucunzai){	// the initial state by default
		goto ignore;	
	}
	else if(connect->state == faqizhe_dengdaiqueren){	//zaidengdaidierciwoshou
		if(tcphdr->ack == connect->next_seq && 
				tcphdr->flags == TCP_FLAG_SYN | TCP_FLAG_ACK ){

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
		if(tcphdr->flags = TCP_FLAG_ACK && connect->next_seq == tcphdr->ack){
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
	//oprintf("ignore, )
	print_tcpmsg(comer);
}

static void print_tcpmsg(struct sk_buff *skb){
	
}
static struct connect *
__connection_lookup(u32 hisip, u16 hisport, u32 myip, u16 myport){
		//XXX
		return 0;
}

/* 根据某个接收到的tcp报文,查找相应的tcp connect 结构体*/
static struct connect * connection_lookup(struct sk_buff * comer){
	return __connection_lookup(comer->iphdr->myip, comer->tcphdr->myport,
							   comer->iphdr->yourip, comer->tcphdr->yourport);
}

static struct connect *
_connection_create(u32 hisip, u16 hisport, u32 myip, u16 myport){
		//XXX
		return 0;
}

/* 根据某个接收到的tcp报文,创建相应的tcp connect 结构体*/
static struct connect *
connection_create(struct sk_buff *comer){
	return _connection_create(comer->iphdr->myip, comer->tcphdr->myport,
							  comer->iphdr->yourip, comer->tcphdr->yourport);	
}

void init_tcp(void){
	lianjiebiao = static_alloc( sizeof(void *), lianjiebiaochang);
}