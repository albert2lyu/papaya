//1, 暂时不考虑超时重发：所有的包都会顺利抵达. 但稍后实现timer的时候,记得timer
//的action一定要用bh做,不然会cli模式下,依稀bh操作很可能引发bug.
//2, TCP结束时,尝试3次握手怎么样.
//3, BUG 小心,tcphdr的option你做入口flip吗
//4, BUG tcp_checksum依赖的pseudo header是ip层计算好的. 如果你要发送一个tcp,
//   有时这个skb就是新申请的,需要你自己建立一个pseudo header.     
#include<net/tcp.h>
#include<linux/skbuff.h>
#include<net/ip.h>
#include<linux/byteorder/generic.h>
#include<utils.h>
#include<asm/bit.h>
#include<linux/timer.h>
#define TCP_PAYLOAD_LEN(skb)	(IP_PAYLOAD_LEN((skb)->iphdr) - (skb)->tcphdr->len * 4)
#define ETHHDR_LEN 14		//TODO remove it

#define zhizhentuiyi(ptr, bytes) ptr = (void *)((unsigned)(ptr) + bytes)
#define pianweixuhao(skb) ((skb)->tcphdr->seq + TCP_PAYLOAD_LEN(skb) - 1)
enum{
	TCP_OPT_EOL,
	TCP_OPT_NOP,
	TCP_OPT_MSS,
	TCP_OPT_WNDSCL,
	TCP_OPT_SACK_PERMIT,
	TCP_OPT_SACK,
	TCP_OPT_TSTAMP = 8,
	TCP_OPT_UTO = 28,
	TCP_OPT_AO = 29
};


/*
 * @l	The small segment
 * @L 	The big segment
 * @desc 	check whether @l sits within @L
 * @return 
 * 0	Yes
 * -1	@l sits left to @L
 * 1	@l sits right to @L
 */
static inline int l_in_L(unsigned l_start, int len, unsigned L_start, int LEN){
	int pianshoupianyi = l_start - L_start;
	int pianweipianyi = pianshoupianyi + len - 1;
	if(pianshoupianyi >= 0){
		if(pianweipianyi < LEN)	return 0;
		else return 1;
	}
	else{
		return -1;		
	}
	

}
static inline int zhizhenjianju(void *ptr1, void *ptr2){
	int distance = (u32)ptr2 - (u32)ptr1;
	assert(distance >= 0 && "argument order should be flipped");
	return distance;
}
//static void print_tcpmsg(struct tcphdr *hdr);
static u32 MY_WND_SIZE = 0x100000;
static u16 MY_MSS = 1460;
enum{
	 lianjiebucunzai,
	 faqizhe_dengdaiqueren,
	 yingdazhe_dengdaiqueren,
	 lianjieyijianli,
	 gaotuizhe_dengdaiqueren,
	 houtuizhe_dengdaiqueren,
	 gaotuizhe_baoliuzhenting
};
#pragma pack(push) 
#pragma pack(1)
#pragma pack(pop)
/* receive window */
/* 在create_connection时就初始化了 */
struct recv_wnd{
	u16 size;				/* tcphdr->wndsize */
	u8 scale;				/* the 'Window Scale' option appears only in the 
							 * SYN segment, so we record it for later usage
							 * of calculating real-time Window Size */

	int realsize;				/* realsize = size << scale */

	struct sk_buff *first;		/* always point to the most left side sk_buff we 
							 * have received currently */

	struct sk_buff *to_ack;		/* to be acknowledged, zhixiangyuleft edgeliantongdezuiyouyige
							   querenleta,jiuquerenlezhijiandeyidapian.zhejiushi"one ack 
							   corresponds to multiple segments". */

	u32 left;				/* left edge */

	struct timer *timer;	/*delay for issue acknowledgement*/
};
struct send_wnd{
	u16 size;
	char scale;
	int realsize;
	u32 left;
};
struct connect{
	u32 myip;
	u32 hisip;
	u16 myport;
	u16 hisport;
	int state;
	u32 seq_got;		//zuijinyigeshoudaodebaowendesequence number
	u32 seq_out;		//zuijinyigefachudebaowendesequence number
	u32 bytes_got;		//zuihouyigeshoudaodebaowendedataqudechangdu
	u32 bytes_out;		//zuihouyigefachudebaowendedataqudechangdu
	struct connect *next;
	struct connect *prev;
	struct recv_wnd recv_wnd;
	struct send_wnd send_wnd;
	struct net_device *netdev;	//XXX init it
	u16 max_seg_size;	//xieshanghoudeMSS
	bool sack_permit;	//duifangzhichiSACKma.buxuyaolingyigeme_sack_permit.womenziji
						//总是支持（permit)sack的. 也许把这个功能做个开关比较好
						//但那样代码会复杂.
	bool tstamp_permit;	//bencilianjiezhichitime stampma.yifangbuzhichi,jiushuangfangguanbi.
};

#define lianjiebiaochang 1024
static struct connect **lianjiebiao;

//declare 
static void tcp_ack_fin(struct connect *connect, struct sk_buff *comer){}
static void do_ack(void *_connect);
static struct sk_buff *
prepare_acksyn(struct connect * connect, struct sk_buff *comer);
static struct connect *
__connection_lookup(u32 hisip, u16 hisport, u32 myip, u16 myport);
static struct connect *
__connection_create(u32 hisip, u16 hisport, u32 myip, u16 myport);

static struct connect * connection_lookup(struct sk_buff * comer);
static struct connect * connection_create(struct sk_buff *comer);

static int tcp_down(struct sk_buff *skb, u32 dest_ip, u32 src_ip);
static int tcp_echo_down(struct sk_buff *skb);
static int wnd_adopt_one(struct connect *connect, struct sk_buff *one);
void tcp_dup_ack(struct connect *connect, struct sk_buff *trigger);
static void init_connect_with_syn(struct connect *connect, struct sk_buff *comer);
static int tcp_checksum(struct sk_buff *comer);

/* whether a tcp segment inside the receive-window */
static inline bool inside_window(struct sk_buff *skb, struct recv_wnd *recv_wnd){
	u32 pianshouxuhao = skb->tcphdr->seq;
	int pianchangdu = TCP_PAYLOAD_LEN(skb);
	return l_in_L(pianshouxuhao, pianchangdu, recv_wnd->left, recv_wnd->realsize);
}

static inline bool waiting_for_it(struct sk_buff *it, struct connect *connect){
	if(!it) return false;
	struct sk_buff *to_ack = connect->recv_wnd.to_ack;
	if(to_ack){
		if(it->tcphdr->seq == to_ack->tcphdr->seq + TCP_PAYLOAD_LEN(to_ack)){
			return true;
		}
	}
	else{
		if(it->tcphdr->seq == connect->recv_wnd.left) return true;
	}
	return false;
}
#if 0
static void tcp_fin(void){

}
#endif

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

void tcp_layer_recv(struct sk_buff *comer){
	struct tcphdr *tcphdr = comer->tcphdr;

	//oprintf("ip tot_len:%x hdr_len:%x\n", comer->iphdr->tot_len, comer->iphdr->len);
	tcp_checksum(comer);

	TCPHDR_FLIP(tcphdr);	

	//print_tcpmsg(tcphdr);
	struct connect *connect = connection_lookup(comer);
	assert(tcphdr->flag_rst == 0);
	if(!connect){
		connect = connection_create(comer);
		if(tcphdr->flags == TCP_FLAG_SYN){	//elseni,zheeryoubug
			init_connect_with_syn(connect, comer);
			connect->tstamp_permit = false;	//zanshiqiangzhiguanbizhegegongneng
			/* issue ack+syn */
			oprintf("someone try connecting me ");
			struct sk_buff *reply = prepare_acksyn(connect, comer);
			tcp_echo_down(reply);

			connect->state = yingdazhe_dengdaiqueren;
			connect->seq_out = tcphdr->seq;	
			connect->bytes_out = 1;

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
		if(tcphdr->flags == TCP_FLAG_ACK && 
			connect->seq_got + connect->bytes_got == tcphdr->seq&&
			connect->seq_out + connect->bytes_out == tcphdr->ack){

			oprintf("got an ack now, i just sent an ack+syn\n");
			connect->seq_got = tcphdr->seq;
			connect->bytes_got  = 0;
			connect->state = lianjieyijianli;	
		}
		else goto ignore;
	}
	//fin可能是捎带在最后一个数据包里. 也可能是单独发过来的. 
	//但是,我们总是分开回复.先回复一个ack,再回复fin.
	//不新分配skb,总是用利用收到的skb回复
	else if(connect->state == lianjieyijianli){
		if(!tcphdr->flag_ack) goto ignore;	//bixuyaodaiackbiaozhi
		if(tcphdr->flags == TCP_FLAG_FIN){	//duifangyaoduankaile
			//send ack and fin		
			connect->state = houtuizhe_dengdaiqueren;
			tcp_ack_fin(connect, comer);
		}

		else if(wnd_adopt_one(connect, comer)){
			if( waiting_for_it(comer, connect) ){
				struct recv_wnd *window = &connect->recv_wnd;
				window->to_ack = comer;
				/*try merge toward right side */
				while( waiting_for_it(window->to_ack->next, connect)){
					window->to_ack = window->to_ack->next;
				}
				/* try activate delay-ack-timer */
				if(window->timer->state == TIMER_STOPPED){
					start_mytimer(window->timer);	
				}
			}
			else{		/*It's an out-of-order segment. Respond immediately. */
				//接收到乱序报文时,receive window里累计了一些还没有确认的报文.先确认
				//它们,再发送Duplicate ACK
				trigger_mytimer(connect->recv_wnd.timer);

				tcp_dup_ack(connect, comer);
			}
		}
		//既不是fin,又不是合法的数据包
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
	oprintf("@tcp-ignore ");
	//print_tcpmsg(comer);
}


#if 0
void print_tcpmsg(struct tcphdr *hdr){
	oprintf("tcp message, seq:%x, ack:%x\n", hdr->seq, hdr->ack);	
}
#endif
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

		/* receive window是创建连接时就可以初始化的 */
		struct recv_wnd *recv_wnd = &connect->recv_wnd; 
		recv_wnd->size = MY_WND_SIZE && 0Xffff;
		int msb = __bsr(MY_WND_SIZE);
		recv_wnd->scale = msb > 15 ? msb - 15 : 0;
		recv_wnd->realsize = MY_WND_SIZE;
		recv_wnd->first = recv_wnd->to_ack = 0;
		recv_wnd->left =  0;
		recv_wnd->timer = create_mytimer(200, do_ack, connect);


		connect->seq_out = 0;	/*TODO use a random value as initial Sequence*/
		connect->bytes_out = 0;

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

#if 0
static void tcp_ack_data(struct sk_buff *comer){
	struct tcphdr *tcphdr = comer->tcphdr;
	int tcphdr_len = tcphdr->len * 4;
	int newip_len = 20 + tcphdr_len;
	comer->iphdr->tot_len = newip_len;
}
#endif
static int wnd_adopt_one(struct connect *connect, struct sk_buff *one){
	struct recv_wnd *window = &connect->recv_wnd;
	struct tcphdr *tcphdr = one->tcphdr;
	int laipianchangdu = TCP_PAYLOAD_LEN(one);
	u32 laipianshouxuhao = tcphdr->seq;
	if( !inside_window(one, window) ) return false;
	
	if(!window->first){
		window->first = one;	
	}
	else{
		struct sk_buff * append_at = window->to_ack ? window->to_ack 
													: window->first;
		while(append_at){
			u32 gaipianweixuhao = pianweixuhao(append_at);

			struct sk_buff *xiapian  = append_at->next;
			//若遍历到最后一片了,我们假设下一片在窗口右侧来计算间隙
			u32 xiapianshouxuhao = xiapian ? xiapian->tcphdr->seq 
								  : window->left + window->realsize;

			int liangpianjianxi = xiapianshouxuhao - gaipianweixuhao - 1;
			int jianxiqishi = gaipianweixuhao + 1;

			int within = l_in_L(laipianshouxuhao, laipianchangdu, jianxiqishi,  liangpianjianxi);
			if(within == -1) return false;		//old package
			else if(within == 0) {
				one->next = xiapian;
				one->prev = append_at;
				append_at->next = one;
				if(xiapian) xiapian->prev = one;
				return true;
			}
			//go on until find a suitable place to insert
			else append_at = xiapian;
		}
	}
	assert(0);
	return false;
}

void tcp_dup_ack(struct connect *connect, struct sk_buff *trigger){
	struct recv_wnd *recv_wnd = &connect->recv_wnd;

	int tcphdr_len = 60;
	struct sk_buff *skb = dev_alloc_skb(ETHHDR_LEN + IPHDR_LEN + tcphdr_len);	
	struct tcphdr * tcphdr = skb->tcphdr;
	tcphdr->myport = connect->myport;
	tcphdr->yourport = connect->hisport;
	tcphdr->seq = connect->seq_out + connect->bytes_out;
	//XXX 小心syn,fin 这样的包,它们的TCP_PAYLOAD_LEN是0	
	tcphdr->ack = connect->seq_got + connect->bytes_got;
	tcphdr->len = tcphdr_len / 4;
	tcphdr->resv = 0;
	tcphdr->flags = TCP_FLAG_ACK;
	tcphdr->wndsize = recv_wnd->size;	//XXX chushihuarecv_wnd,zaisynshihou
	tcphdr->urgptr = 0;	

	struct sk_buff *start = trigger;
	while(start){
		if( pianweixuhao(start->prev) + 1 == start->prev->tcphdr->seq ){
			start = start->prev;
			continue;	
		}
		break;
	}
	struct sk_buff *end = trigger;
	while(end){
		if( pianweixuhao(end) + 1 == end->next->tcphdr->seq ){
			end = end->next;
			continue;	
		}
	}
	//write options
	memset(skb->tcphdr->opt_area, TCP_OPT_NOP, tcphdr_len - 20);
	struct tcp_opt *opt = skb->tcphdr->opt_area;
	opt->kind = TCP_OPT_SACK;
	opt->len = 10;
	opt->data.dword[0] = ntohl(start->tcphdr->seq);	
	opt->data.dword[1] = ntohl(pianweixuhao(end));	

	tcp_down(skb, connect->hisip, connect->myip);
}
static void do_ack(void *_connect){
	struct connect *connect = _connect;
	struct recv_wnd *recv_wnd = &connect->recv_wnd;
	assert(recv_wnd->to_ack);

	struct sk_buff *skb = dev_alloc_skb(ETHHDR_LEN + IPHDR_LEN + TCPHDR_LEN);	
	struct tcphdr * tcphdr = skb->tcphdr;
	tcphdr->myport = connect->myport;
	tcphdr->yourport = connect->hisport;
	tcphdr->seq = connect->seq_out + connect->bytes_out;
	//XXX 小心syn,fin 这样的包,它们的TCP_PAYLOAD_LEN是0	
	tcphdr->ack = pianweixuhao(recv_wnd->to_ack) + 1;
	tcphdr->len = 20 / 4;
	tcphdr->resv = 0;
	tcphdr->flags = TCP_FLAG_ACK;
	tcphdr->wndsize = recv_wnd->size;	//XXX chushihuarecv_wnd,zaisynshihou
	tcphdr->urgptr = 0;	

	tcp_down(skb, connect->hisip, connect->myip);

	//the slide window moves forward.
	struct sk_buff *to_ack = recv_wnd->to_ack;
	recv_wnd->left = pianweixuhao(to_ack) + 1;
	recv_wnd->first = to_ack->next;
	recv_wnd->to_ack = 0;//BREAK
}

/* 不需要指定ip,skb里的net_device已经指定. 从哪个网卡发出去,ip就随它.
 * 2, 根据目标ip选择网卡,这是ip层的事情. 
 * @DESC 1, 翻转成网络字节序	2,添加校验和
 */
static void tcpxiachenrukou(struct sk_buff *skb){
	assert(skb->pseudo_hdr);
	struct tcphdr *tcphdr = skb->tcphdr;

	TCPHDR_FLIP(tcphdr);

	tcphdr->chksum = 0;
	u32 sum1 = crc16_compute_be(tcphdr, IP_PAYLOAD_LEN(skb->iphdr));
	u32 sum2 = crc16_compute_be(skb->pseudo_hdr, sizeof(struct pseudo_hdr));
	u32 checksum = sum1 + sum2;
	u16 carry = checksum >> 16;
	if(carry) checksum = carry + (checksum & 0xffff);
	tcphdr->chksum = htons(~checksum);
}

static int tcp_down(struct sk_buff *skb, u32 dest_ip, u32 src_ip){
	tcpxiachenrukou(skb);			
	return ip_down(skb, PROTOCOL_TCP, dest_ip, src_ip, 64);
}
static int tcp_echo_down(struct sk_buff *skb){
	//strong order
	EXCHG_U16(skb->tcphdr->yourport, skb->tcphdr->myport);
	tcpxiachenrukou(skb);
	return ip_echo_down(skb, PROTOCOL_TCP, 64);
}

/* 1, 至少发送SACK-PERMIT, MSS, WINDOW SCALE这三个option.目前关闭Tstamp选项.
 * 2, @comer 目前是"再利用"收到的syn segment的skb.
 */
static struct sk_buff *
prepare_acksyn(struct connect * connect, struct sk_buff *comer){
	struct tcphdr *tcphdr = comer->tcphdr;
	assert(tcphdr->len > TCPHDR_LEN + 12);	

	/*填写header里重要的字段*/
	tcphdr->seq = connect->seq_out + connect->bytes_out;	
	tcphdr->ack = connect->seq_out + connect->bytes_got;
	tcphdr->flags = TCP_FLAG_ACK | TCP_FLAG_SYN ;
	tcphdr->wndsize = connect->recv_wnd.size;
	tcphdr->urgptr = 0;
			//tcp_echo_down(comer);	//BUG 后面的会被打断吗,race conditions?

	/* write MSS option */
	struct tcp_opt *opt = tcphdr->opt_area;
	opt->kind = TCP_OPT_MSS;
	opt->len = 4;
	opt->data.word[0] = htons(connect->max_seg_size);
	zhizhentuiyi(opt, opt->len);

	opt->kind = TCP_OPT_WNDSCL;
	opt->len = 3;
	opt->data.byte[0] = connect->recv_wnd.scale;
	zhizhentuiyi(opt, opt->len);
	
	opt->kind = TCP_OPT_SACK_PERMIT;
	opt->len = 2;
	zhizhentuiyi(opt, opt->len);

	int end = zhizhenjianju(tcphdr->opt_area, opt);
	int opt_area_len = ceil_align(end, 4);
	for(int i = end; i < opt_area_len; i++){
		((char *)tcphdr->opt_area)[i] = TCP_OPT_NOP;
	}
	tcphdr->len = (TCPHDR_LEN + opt_area_len) / 4;
	return comer;
}

static void init_connect_with_syn(struct connect *connect, struct sk_buff *comer){
	struct tcphdr * tcphdr = comer->tcphdr;
	/* 从tcphdr里读取重要的成员到connect结构体内. */
	connect->seq_got = tcphdr->seq;
	connect->bytes_got = 1;
	connect->send_wnd.size = tcphdr->wndsize;
	/* 尝试提取四个重要的option .
	 * 它们的决定了connect的一些字段. 因为不一定提取得到,所以先设置
	 * 这些字段的默认值
	 */
	connect->sack_permit = false;
	connect->tstamp_permit = false;
	connect->send_wnd.scale = 0;
	connect->max_seg_size = MY_MSS;
	/* 好,开始 */
	struct tcp_opt *opt = tcphdr->opt_area;
	while(opt->kind && zhizhenjianju(opt, tcphdr->opt_area) < tcphdr->len*4 - TCPHDR_LEN){	//TODO zhegejianceyoubug
		int len = opt->len;
		switch(opt->kind){
			case TCP_OPT_NOP:
				len = 1;
				break;
			case TCP_OPT_MSS:{
				assert(len == 4);	
				u16 his_mss = ntohs(*opt->data.word);
				if(his_mss < MY_MSS) connect->max_seg_size = his_mss;
				break;
			}
			case TCP_OPT_WNDSCL:
				assert(len == 3);
				connect->send_wnd.scale = *opt->data.byte;
				break;
			case TCP_OPT_SACK_PERMIT:
				assert(len == 2);
				connect->sack_permit = true;
				break;
			case TCP_OPT_TSTAMP:
				connect->sack_permit = true;
				assert(len == 10);
				break;
			case TCP_OPT_UTO:
				assert(len == 4);
				break;
			case TCP_OPT_AO:
				break;
			default:
				spin("unknown option appears in SYN segment");
		}
		connect->send_wnd.realsize = connect->send_wnd.size <<
									  connect->send_wnd.scale;
		zhizhentuiyi(opt, len);
	}
}

static int tcp_checksum(struct sk_buff *comer){
	int tcplen = IP_PAYLOAD_LEN(comer->iphdr);
	int checksum = crc16_compute_be(comer->tcphdr, tcplen);
	int checksum2 = crc16_compute_be(comer->pseudo_hdr, sizeof(struct pseudo_hdr));
	int sum = checksum + checksum2;
	sum = (sum & 0xffff) + (sum >> 16);
	assert(~sum);
	return 123;
}



