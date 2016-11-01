#include<linux/netdevice.h>
#include<linux/mylist.h>
#include<utils.h>
#include<linux/if_ether.h>
#include<linux/byteorder/generic.h>
#include<net/arp.h>
#include<net/ip.h>
#include<net/tcp.h>
#define IN_WAKE_QUEUE 1

#define YOUR_NIC_CNT 4
static struct net_device *__all_your_nic[YOUR_NIC_CNT];

struct net_device * who_am_i(u8 *mac){
	struct net_device *this;
	for(int i = 0; i < YOUR_NIC_CNT; i++){
		if( (this = __all_your_nic[i]) && 
			 memcmp(this->mac, mac, 6) == 0 )
		{
			return this;
		}
	}
	return 0;
}

void info_nic(struct net_device *netdev){
	//oprintf("IN DEV, sizeof = %u", sizeof(struct net_device));
	u8 *mac = netdev->mac;
	struct eax { u8 al; u8 ah; u8 AL; u8 AH;};
	struct eax *ip = (void *)&netdev->ip;
	oprintf("mac: %x%x%x%x%x%x    << *%x >>ip:%u.%u.%u.%u \n",  mac[0], mac[1], mac[2], mac[3], mac[4], mac[5], 
													  &netdev->ip,
													  ip->AH, ip->AL, ip->ah, ip->al);	
	return;
}
void list_nic(void){
	struct net_device *this;
	for(int i = 0; i < YOUR_NIC_CNT; i++){
		if( (this = __all_your_nic[i]) ){
			oprintf("nic[%u]: ", i);
			info_nic(this);
		}
	}
}

/* 发送一个package之前，通过目标ip和源ip挑选合适的网卡
 * case 1: dest_ip = 0, src_ip有效。
 *  	   这是最常见的情况，根据source ip匹配网卡。
 * case 2: src_ip = 0, dest_ip有效。
 *		   当你想跟一个局域网里的peer通信时，可以只给出目的ip,内核会认为你想
 		   在局域网内通信，并挑选跟他同一网段的网卡。
 */
struct net_device *pick_nic(u32 dest_ip, u32 src_ip){
	assert(dest_ip || src_ip);
	struct net_device *this;
	for(int i = 0; i < YOUR_NIC_CNT; i++){
		if((this = __all_your_nic[i])){
			if(this->ip == src_ip) return this;	//先通过src_ip挑选网卡
			//尝试找跟dest_ip同一子网的网卡
			//这是最简单的实现，有bug
			if((dest_ip & this->ipmask) == (this->ip & this->ipmask)){
				return this;
			}
		}
	}
	//TODO 取消assert， 有一种情况，程序要访问的ip是公网，而且它设置source ip 
	//     为0 或者伪造ip。那一定找不到对应的网卡。就随便挑一个算了。
	struct __eax *eax = (void *)&dest_ip;
	oprintf("want to %u.%u.%u.%u\n", eax->AH, eax->AL, eax->ah, eax->al);	
	eax = (void *)&src_ip;
	oprintf("from %u.%u.%u.%u\n", eax->AH, eax->AL, eax->ah, eax->al);	

	//oprintf("wanna dest: %u, source: %u\n", dest_ip, src_ip);
	assert(0 && "pic nic failed");
	return 0;
}

void register_nic(struct net_device *netdev){
	for(int i = 0; i < YOUR_NIC_CNT; i++){
		if(!__all_your_nic[i]){
			__all_your_nic[i] = netdev;
			return;
		}
	}
	assert(0);
}

void net_init(void){
	skbuff_init();
	arp_init();
	ip_layer_init();
	init_tcp();
}

/* 必须在sti()的外环境调用它
 * 这个函数可能被用户通过sys_call调用，也可能在bottom half里被调用。 像比，
 * 收到一个ARP inquiry包，bottom half里就要回传ARP reply包。
 */
void waiting_for_transmit(struct sk_buff *skb){
	/* 必须关中断， 因为硬中断带来的bottom half可能会访问skb_queue */
	assert( sti_already() );
	cli();
	bool tx_queue_empty = !(bool)skb->dev->tx_queue.root;
	LL2_A( &skb->dev->tx_queue, skb);
	sti();
	/* 如果tx_queue是空的，我们手动启动它。 这并不是最优雅的方案，因为很可能
	 * tx_queue的最后一个包刚出去，待会儿就有一个发包中断上来。 我是说，我们 
	 * 本不必须在这里唤醒发包队列。 但这样无疑是最清晰的，代码很简单。
	 * 另外，只要队列不为空，我们认为这个队列就是被发包中断“驱动”着的，
	 * 即，待会儿肯定会有发包中断上来。
	 */
	if(tx_queue_empty)		nic_wake_queue(skb->dev);
	else{
		skb->dev->debug.quick_insert++;
		/*
		oprintf(" quick_insert:%u/%u", skb->dev->debug.quick_insert, 
										skb->dev->tx_count);

		cli();		//Necessary! or mdelay will be interrupted !then no delay
		mdelay(2000);
		sti();
		*/
	}
}

/* FIXME consider race conditions with skb_queue 
 * 1, we are safe, TxIntr routine don't touch netdev->skb_queue
 * 2, we process one by one, from root to tail.
 * 1, 如果我们在sti()环境下(非bottom half)主动调用它，那硬中断带来的bottom half
 *    可能会导致这个函数的重入。我们在最开始关中断检测运行状态，避免重入。
 * 2, 硬中断的action不会触碰netdev->skb_queue
 * 3, netdev->flags会被中断访问（例如，收包中断里，会清除 ND_QUEUE_STOOPED位。
 *    所以必须关中断访问它。
 * 4, 调用这个函数前，不需要手动的start_queue(),否则，队列会永久的停掉。
 * 5, 假如在整个发包过程（xmit)过程都关中断，那就可以保证稳定的返回值。
 * 6, 缺点是关中断的时间有点儿长，while循环里只用一次cli/sti,是整理了代码的， 
 *    不然在while()结束后还得一对。
 */
void nic_wake_queue(struct net_device *netdev){
	assert( sti_already() );
	/*必须从这里关中断，因为用户调用它的话，会被硬中断的bootom half重入，如果
	 *推迟一行关中断，可能你用户routine顺利通过这一行，但随之被bottom half重
	 * 入，并开启queue，并执行。等从bottom half回来之后，这个queue可能已经空
	 × 了。 
	 */
	cli();
	/* 这一句似乎可以在关中断之前，因为此函数重入只可能发生在用户调用被硬中断
	 * 的bottom half重入。
	 */
	 //avoid re-entered
	if( (netdev->flags & IN_WAKE_QUEUE) == 1) return sti();
	//if(!nic_queue_stooped(netdev)) return;	/*already running */
	if(!netdev->tx_queue.root) return sti();		/* queue is empty, just return */
	if(netdev->tx_busy(netdev)) {
		//oprintf("desc busy, you see ");
		//mdelay(2000);
		//info_regs(netdev);
		return sti();
	}
	netdev->flags |= IN_WAKE_QUEUE;
	sti();
	
	struct skb_queue *list = &netdev->tx_queue;
	struct sk_buff * one;
	//oprintf("[ nic_wake_queue invoked    ");
	//oprintf("root:%x, tail:%x\n", list->root, list->tail);
	int code = 0;
	while(1){
		netdev->tx_count++;
		//oprintf(" %u done  ", netdev->tx_count);
		one = list->root;
		//info_skb(one);
		LL2_POP(list);
		cli();
		code = netdev->start_xmit(one, netdev);
		if(code == -1 || list->root == 0){
			netdev->flags &= ~IN_WAKE_QUEUE;
			break;
		}
		sti();
	}

	sti();		
	//oprintf(" nic_wake_queue quit  ]  ");
	//下面这行跟不上代码了，因为从这儿出去，队列必是stooped状态。
	//无网卡DESC，或者队列为空，都会导致队列stop
}

/* only invoked in bottom half */
void process_rx_queue( struct net_device *netdev){
	static int count = 0;
	assert(count == 0);
	count++;

	struct skb_queue *rx_queue = &netdev->rx_queue;
	cli();
	while(rx_queue->root){
		struct sk_buff *one = rx_queue->root;
		LL2_POP(rx_queue);
		sti();
		switch( ntohs(one->ethhdr->protocol) ){
			case PROTOCOL_ARP:
				arp_layer_receive(one);
				break;
			case PROTOCOL_IP:
				ip_layer_receive(one);
				break;
			case 0x86dd:
				spin("ipv6 message");
			default:
				oprintf("protocol id:%x , IGNORE It\n", ntohs(one->ethhdr->protocol) );
				//spin("unknown protocol");
		}
		cli();
	}
	sti();
	count--;
}







