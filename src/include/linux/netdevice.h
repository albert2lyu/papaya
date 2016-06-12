#ifndef NETDEVICE_H
#define NETDEVICE_H
#include<linux/skbuff.h>

struct net_device{
	int		(*open)(struct net_device *dev);
	int		(*stop)(struct net_device *dev);
	int		(*start_xmit) (struct sk_buff *skb, struct net_device *dev);
	char MAC[6];

	unsigned base_addr;
	char irq;
	void *priv;
};
#endif
