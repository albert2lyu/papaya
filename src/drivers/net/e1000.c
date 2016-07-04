#include<linux/pci.h>
#include<asm/io.h>
#include<linux/netdevice.h>
#include<irq.h>
#include<linux/slab.h>
#include<mm.h>
#include<linux/skbuff.h>

#define INTEL_VEND     0x8086  // Vendor ID for Intel 
#define E1000_DEV      0x100E  // Device ID for the e1000 Qemu, Bochs, and VirtualBox emmulated NICs
#define E1000_I217     0x153A  // Device ID for Intel I217
#define E1000_82577LM  0x10EA  // Device ID for Intel 82577LM
 
 
// He has gathered those from different Hobby online operating systems instead of getting them one by one from the manual (osdev. wiki i217)
#define REG_CTRL        0x0000
#define REG_STATUS      0x0008
#define REG_EEPROM      0x0014
#define REG_CTRL_EXT    0x0018
#define REG_IMASK       0x00D0
#define REG_RCTRL       0x0100
#define REG_RXDESCLO    0x2800
#define REG_RXDESCHI    0x2804
#define REG_RXDESCLEN   0x2808
#define REG_RXDESCHEAD  0x2810
#define REG_RXDESCTAIL  0x2818
 
#define REG_TCTRL       0x0400
#define REG_TXDESCLO    0x3800
#define REG_TXDESCHI    0x3804
#define REG_TXDESCLEN   0x3808
#define REG_TXDESCHEAD  0x3810
#define REG_TXDESCTAIL  0x3818
 
#define REG_RDTR         0x2820 // RX Delay Timer Register
#define REG_RXDCTL       0x3828 // RX Descriptor Control
#define REG_RADV         0x282C // RX Int. Absolute Delay Timer
#define REG_RSRPD        0x2C00 // RX Small Packet Detect Interrupt
 
#define REG_TIPG         0x0410      // Transmit Inter Packet Gap
#define ECTRL_SLU        0x40        //set link up
 
#define RCTL_EN                (1 << 1)    // Receiver Enable
#define RCTL_SBP               (1 << 2)    // Store Bad Packets
#define RCTL_UPE               (1 << 3)    // Unicast Promiscuous Enabled
#define RCTL_MPE               (1 << 4)    // Multicast Promiscuous Enabled
#define RCTL_LPE               (1 << 5)    // Long Packet Reception Enable
#define RCTL_LBM_NONE          (0 << 6)    // No Loopback
#define RCTL_LBM_PHY           (3 << 6)    // PHY or external SerDesc loopback
#define RTCL_RDMTS_HALF        (0 << 8)    // Free Buffer Threshold is 1/2 of RDLEN
#define RTCL_RDMTS_QUARTER     (1 << 8)    // Free Buffer Threshold is 1/4 of RDLEN
#define RTCL_RDMTS_EIGHTH      (2 << 8)    // Free Buffer Threshold is 1/8 of RDLEN
#define RCTL_MO_36             (0 << 12)   // Multicast Offset - bits 47:36
#define RCTL_MO_35             (1 << 12)   // Multicast Offset - bits 46:35
#define RCTL_MO_34             (2 << 12)   // Multicast Offset - bits 45:34
#define RCTL_MO_32             (3 << 12)   // Multicast Offset - bits 43:32
#define RCTL_BAM               (1 << 15)   // Broadcast Accept Mode
#define RCTL_VFE               (1 << 18)   // VLAN Filter Enable
#define RCTL_CFIEN             (1 << 19)   // Canonical Form Indicator Enable
#define RCTL_CFI               (1 << 20)   // Canonical Form Indicator Bit Value
#define RCTL_DPF               (1 << 22)   // Discard Pause Frames
#define RCTL_PMCF              (1 << 23)   // Pass MAC Control Frames
#define RCTL_SECRC             (1 << 26)   // Strip Ethernet CRC
 
// Buffer Sizes
#define RCTL_BSIZE_256         (3 << 16)
#define RCTL_BSIZE_512         (2 << 16)
#define RCTL_BSIZE_1024        (1 << 16)
#define RCTL_BSIZE_2048        (0 << 16)
#define RCTL_BSIZE_4096        ((3 << 16) | (1 << 25))
#define RCTL_BSIZE_8192        ((2 << 16) | (1 << 25))
#define RCTL_BSIZE_16384       ((1 << 16) | (1 << 25))
 
// Transmit Command
#define CMD_EOP                (1 << 0)    // End of Packet
#define CMD_IFCS               (1 << 1)    // Insert FCS
#define CMD_IC                 (1 << 2)    // Insert Checksum
#define CMD_RS                 (1 << 3)    // Report Status
#define CMD_RPS                (1 << 4)    // Report Packet Sent
#define CMD_VLE                (1 << 6)    // VLAN Packet Enable
#define CMD_IDE                (1 << 7)    // Interrupt Delay Enable
 
 
// TCTL Register
#define TCTL_EN                (1 << 1)    // Transmit Enable
#define TCTL_PSP               (1 << 3)    // Pad Short Packets
#define TCTL_CT_SHIFT          4           // Collision Threshold
#define TCTL_COLD_SHIFT        12          // Collision Distance
#define TCTL_SWXOFF            (1 << 22)   // Software XOFF Transmission
#define TCTL_RTLC              (1 << 24)   // Re-transmit on Late Collision
 
#define TSTA_DD                (1 << 0)    // Descriptor Done
#define TSTA_EC                (1 << 1)    // Excess Collisions
#define TSTA_LC                (1 << 2)    // Late Collision
#define LSTA_TU                (1 << 3)    // Transmit Underrun

#define E1000_NUM_RX_DESC 32
#define E1000_NUM_TX_DESC 8
 
struct e1000_private{
	struct pci_dev *pcidev;
	void *mmio_addr;			/* memory mapped I/O addr */
	unsigned long regs_len;		/*length of I/O or MMI/O region */
};

/* vendor 和 device就能唯一的指定设备类型*/
static struct pci_device_id e1000_id_tbl[] = {
	{0x8086, 0x1000 },
	{0x8086, 0x1001 },
	{0x8086, 0x1004 },
	{0x8086, 0x1008 },
	{0x8086, 0x1009 },
	{0x8086, 0x100C },
	{0x8086, 0x100D },
	{0x8086, 0x100E },
	{0x8086, 0x100F },
	{0x8086, 0x1010 },
	{0x8086, 0x1011 },
	{0x8086, 0x1012 },
	{0x8086, 0x1013 },
	{0x8086, 0x1014 },
	{0x8086, 0x1015 },
	{0x8086, 0x1016 },
	{0x8086, 0x1017 },
	{0x8086, 0x1018 },
	{0x8086, 0x1019 },
	{0x8086, 0x101A },
	{0x8086, 0x101D },
	{0x8086, 0x101E },
	{0x8086, 0x1026 },
	{0x8086, 0x1027 },
	{0x8086, 0x1028 },
	{0x8086, 0x1075 },
	{0x8086, 0x1076 },
	{0x8086, 0x1077 },
	{0x8086, 0x1078 },
	{0x8086, 0x1079 },
	{0x8086, 0x107A },
	{0x8086, 0x107B },
	{0x8086, 0x107C },
	{0x8086, 0x108A },
	{0x8086, 0x1099 },
	{0x8086, 0x10B5 },
};


static int tx_bottomhalf( void *_netdev){
	return 0;
    //
}

static void on_tx(struct net_device *netdev){
}


static int rx_bottomhalf( void *_netdev){
	return 0;
}
static void on_rx(struct net_device *netdev){
}
static void on_intr(int irq, void *dev, void *regs){
}
static int e1000_open(struct net_device *netdev){
	return 0;
}

static int e1000_stop(struct net_device *netdev){
	return 0;
}
static int e1000_start_xmit(struct sk_buff *skb, struct net_device *netdev){
	return 0;
}

static bool e1000_tx_busy(struct net_device *netdev){
	assert(0);
	return 0;
}

int e1000_init_one(struct pci_dev *pcidev, const struct pci_device_id *id){
	pci_enable_device(pcidev);
	pci_set_master(pcidev);	/*多数BIOS会清除PCI网卡的master位，导致板卡不能往主存拷数据*/
	struct net_device *netdev = kmalloc2( sizeof(struct net_device), 0 );
	register_nic(netdev);
	netdev->pcidev = pcidev;
	pcidev->core = netdev;

	netdev->open = e1000_open;
	netdev->stop = e1000_stop;
	netdev->tx_busy = e1000_tx_busy;
	netdev->start_xmit = e1000_start_xmit;

	oprintf("irq pin: %u , line: %u\n", pcidev->irqpin, pcidev->irqline);
	/* TODO ioremap, remove hard code */
	netdev->base_addr = (unsigned)( pcidev->address[1] & ~0xf) - PAGE_OFFSET;
	#if 0
	//assert((netdev->base_addr >> 20) == 0xfeb);
	netdev->irq = pcidev->irqline;
	//oprintf("base_addr:%x\n", netdev->base_addr);
	int mac[2] = {0};
	mac[0] = RTL_readl(netdev, 0);
	mac[1] = RTL_readl(netdev, 4);
	memcpy(netdev->mac, (char *)mac, 6);
	oprintf("MAC:%x %x\n", mac[0], mac[1]);

	struct rtl8139_private *private = kmalloc2( sizeof(struct rtl8139_private), 0);
	private->pcidev = pcidev;
	netdev->private = private;
	netdev->ipmask = ~0xff;
	netdev->gateway_ip = MAKE_IP(192, 168, 1, 1);
	extern u32 __local_ip;
	netdev->ip = __local_ip;
	/*TODO how we pick out the right bar */
	//assert(!(pcidev->address[0] & 1));	/* port mapped address */
	//assert( pcidev->address[0] & 1);	/* memory mapped address */
	testnd = netdev;
	#endif
	return 0;
}

static struct pci_driver e1000_driver = {
	id_table: e1000_id_tbl,
	probe:e1000_init_one,
};

void register_e1000_driver(void){
	pci_register_driver(&e1000_driver);
}
