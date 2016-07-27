#ifndef NETDEVICE_H
#define NETDEVICE_H
#include<linux/skbuff.h>
#include<valType.h>

//#define ND_QUEUE_STOOPED 0x1
struct skb_queue{
	struct sk_buff *root;
	struct sk_buff *tail;
};

struct pci_dev;
struct net_device{
	int		(*open)(struct net_device *dev);
	int		(*stop)(struct net_device *dev);
	int		(*start_xmit) (struct sk_buff *skb, struct net_device *dev);
	bool 	(*tx_busy) (struct net_device *dev);
	u8 mac[7];

	unsigned base_addr;
	char irq;
	unsigned flags;
	void *private;
	struct skb_queue tx_queue;
	struct skb_queue rx_queue;
	char on_tx_bh;
	char on_rx_bh;

	u32 ipmask;
	u32 ip;
	u32 gateway_ip;
	u32 tx_count;
	u32 rx_count;
	struct {
		u32 quick_insert;
		u32 count_drop_tok;
	}debug;
	struct pci_dev *pcidev;
	u32 ip_identifier;
};


/* 因为 ND_QUEUE_STOOPED这个bit只会在nic_wake_queue()里修改，而且它修改的时候
 * 会cli(),所以在中断代码里访问这个变量是安全的。 但是，在别处要访问，就要关
 * 中断访问。 不过几乎不用在别处访问。
 */
//static inline bool nic_queue_stooped(struct net_device *netdev){
	//return netdev->flags & ND_QUEUE_STOOPED;
//}

void nic_wake_queue(struct net_device *netdev);
struct net_device *pick_nic(u32 dest_ip, u32 src_ip);
void register_nic(struct net_device *netdev);
void list_nic(void);
struct net_device * who_am_i(u8 *mac);
#endif
