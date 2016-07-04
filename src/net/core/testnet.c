#include<linux/skbuff.h>
#include<linux/netdevice.h>
#include<utils.h>

#include<net/arp.h>
void send_data(char *data){
	int total = 1;
	for(int i = 0; i < total; i++){
		//struct sk_buff * skb = dev_alloc_skb( ARP_PACK_SIZE );	
		//skb->len = ARP_PACK_SIZE;
		//waiting_for_transmit(skbarr[i]);
		u32 yourip = MAKE_IP(192, 168, 0, 22);
		arp_inquire(yourip, 0, 0);
	}
	//nic_wake_queue(testnd);	
}

void testnet(void){
	//register_e1000_driver();
	register_rtl8139_driver();
	//pci_register_driver(&rtl8139_driver);
	//spin("before testnd open");
	//oprintf("testnd:%x", testnd);
	struct net_device *netdev = pick_nic();
	netdev->open(netdev);
	//spin("after testnd open");
//	__asm__ __volatile__("sti");
	//info_regs(testnd);
	//oprintf("@8259  @before IMR %x\n", read_imr_of8259());	
	char data[] = "this line come from papaya kernel";
	//mdelay(1000 * 60);
	send_data(data);
	return;

}
