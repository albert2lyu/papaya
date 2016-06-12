//注意mmio时的gcc的寄存器缓冲和eliminate优化和硬件的cache缓冲。
#include<linux/pci.h>
#include<asm/io.h>
#include<linux/netdevice.h>
#include<irq.h>
#include<linux/slab.h>
#include<mm.h>
#define __priv(netdev) ((struct rtl8139_private *)netdev->priv)
#define NUM_TX_DESC 4
struct rtl8139_private{
	struct pci_dev *pcidev;
	void *mmio_addr;			/* memory mapped I/O addr */
	unsigned long regs_len;		/*length of I/O or MMI/O region */
	unsigned tx_flags;
	unsigned cur_tx;
	unsigned dirty_tx;
	unsigned char *tx_buf[NUM_TX_DESC];	
	unsigned char *tx_bufs;

	u8 *rx_ring;
	void *rx_ring_dma;
	unsigned cursor_toread;		/* a copy of cursor_toread */
};

static inline void RTL_maskb(struct net_device *netdev, int offset, unsigned mask){
	maskb(netdev->base_addr + offset, mask);
}
static inline void RTL_maskw(struct net_device *netdev, int offset, unsigned mask){
	maskw(netdev->base_addr + offset, mask);
}
static inline void RTL_maskl(struct net_device *netdev, int offset, unsigned mask){
	maskl(netdev->base_addr + offset, mask);
}


static inline unsigned RTL_readb(struct net_device *netdev, int offset){
	return readb(netdev->base_addr + offset);
}
static inline unsigned RTL_readw(struct net_device *netdev, int offset){
	return readw(netdev->base_addr + offset);
}
static inline unsigned RTL_readl(struct net_device *netdev, int offset){
	return readl(netdev->base_addr + offset);
}



static inline void RTL_writeb(struct net_device *netdev, int offset, unsigned value){
	writeb(netdev->base_addr + offset, value);
}
static inline void RTL_writew(struct net_device *netdev, int offset, unsigned value){
	writew(netdev->base_addr + offset, value);
}
static inline void RTL_writel(struct net_device *netdev, int offset, unsigned value){
	writel(netdev->base_addr + offset, value);
}


/* vendor 和 device就能唯一的指定设备类型*/
static struct pci_device_id rtl8139_id_tbl[] = {
	{0x10ec, 0x8139,  },
	{0x10ec, 0x8138,  },
	{0x1113, 0x1211,  },
	{0x1500, 0x1360,  },
	{0x4033, 0x1360,  },
	{0x1186, 0x1300,  },
	{0x1186, 0x1340,  },
	{0x13d1, 0xab06,  },
	{0x1259, 0xa117,  },
	{0x1259, 0xa11e,  },
	{0x14ea, 0xab06,  },
	{0x14ea, 0xab07,  },
	{0x11db, 0x1234,  },
	{0x1432, 0x9130,  },
	{0x02ac, 0x1012,  },
	{0x018a, 0x0106,  },
	{0x126c, 0x1211,  },
	{0x1743, 0x8139,  },
	{0x021b, 0x8139,  },
	{0, 0},
};


/* Symbolic offsets to registers. */
enum RTL8139_registers {
	MAC0		= 0,	 /* Ethernet hardware address. */
	MAR0		= 8,	 /* Multicast filter. */
	TxStatus0	= 0x10,	 /* Transmit status (Four 32bit registers). */
	TxAddr0		= 0x20,	 /* Tx descriptors (also four 32bit). */
	RBSTART		= 0x30,
	ChipCmd		= 0x37,
	cursor_toread	= 0x38,
	cursor_torecv	= 0x3A,
	IMR	= 0x3C,
	ISR	= 0x3E,
	TxConfig	= 0x40,
	RxConfig	= 0x44,
	Timer		= 0x48,	 /* A general-purpose counter. */
	RxMissed	= 0x4C,  /* 24 bits valid, write clears. */
	Cfg9346		= 0x50,
	Config0		= 0x51,
	Config1		= 0x52,
	TimerInt	= 0x54,
	MediaStatus	= 0x58,
	Config3		= 0x59,
	Config4		= 0x5A,	 /* absent on RTL-8139A */
	HltClk		= 0x5B,
	MultiIntr	= 0x5C,
	TxSummary	= 0x60,
	BasicModeCtrl	= 0x62,
	BasicModeStatus	= 0x64,
	NWayAdvert	= 0x66,
	NWayLPAR	= 0x68,
	NWayExpansion	= 0x6A,
	/* Undocumented registers, but required for proper operation. */
	FIFOTMS		= 0x70,	 /* FIFO Control and test. */
	CSCR		= 0x74,	 /* Chip Status and Configuration Register. */
	PARA78		= 0x78,
	FlashReg	= 0xD4,	/* Communication with Flash ROM, four bytes. */
	PARA7c		= 0x7c,	 /* Magic transceiver parameter register. */
	Config5		= 0xD8,	 /* absent on RTL-8139A */
};

enum ChipCmdBits {
	CmdReset	= 0x10,
	CmdRxEnb	= 0x08,
	CmdTxEnb	= 0x04,
	RxBufEmpty	= 0x01,
};


/* Interrupt register bits, using my own meaningful names. */
enum IntrStatusBits {
	PCIErr		= 0x8000,
	PCSTimeout	= 0x4000,
	RxFIFOOver	= 0x40,
	RxUnderrun	= 0x20,
	RxOverflow	= 0x10,
	TxErr		= 0x08,
	TxOK		= 0x04,
	RxErr		= 0x02,
	RxOK		= 0x01,

	RxAckBits	= RxFIFOOver | RxOverflow | RxOK,
};

enum TxStatusBits {
	TxHostOwns	= 0x2000,
	TxUnderrun	= 0x4000,
	TxStatOK	= 0x8000,
	TxOutOfWindow	= 0x20000000,
	TxAborted	= 0x40000000,
	TxCarrierLost	= 0x80000000,
};
enum RxStatusBits {
	RxMulticast	= 0x8000,
	RxPhysical	= 0x4000,
	RxBroadcast	= 0x2000,
	RxBadSymbol	= 0x0020,
	RxRunt		= 0x0010,
	RxTooLong	= 0x0008,
	RxCRCErr	= 0x0004,
	RxBadAlign	= 0x0002,
	RxStatusOK	= 0x0001,
};

/* Bits in RxConfig. */
enum rx_mode_bits {
	AcceptErr	= 0x20,
	AcceptRunt	= 0x10,
	AcceptBroadcast	= 0x08,
	AcceptMulticast	= 0x04,
	AcceptMyPhys	= 0x02,
	AcceptAllPhys	= 0x01,
};

/* Bits in TxConfig. */
enum tx_config_bits {
        /* Interframe Gap Time. Only TxIFG96 doesn't violate IEEE 802.3 */
        TxIFGShift	= 24,
        TxIFG84		= (0 << TxIFGShift), /* 8.4us / 840ns (10 / 100Mbps) */
        TxIFG88		= (1 << TxIFGShift), /* 8.8us / 880ns (10 / 100Mbps) */
        TxIFG92		= (2 << TxIFGShift), /* 9.2us / 920ns (10 / 100Mbps) */
        TxIFG96		= (3 << TxIFGShift), /* 9.6us / 960ns (10 / 100Mbps) */

	TxLoopBack	= (1 << 18) | (1 << 17), /* enable loopback test mode */
	TxCRC		= (1 << 16),	/* DISABLE Tx pkt CRC append */
	TxClearAbt	= (1 << 0),	/* Clear abort (WO) */
	TxDMAShift	= 8, /* DMA burst value (0-7) is shifted X many bits */
	TxRetryShift	= 4, /* TXRR value (0-15) is shifted X many bits */

	TxVersionMask	= 0x7C800000, /* mask out version bits 30-26, 23 */
};

enum RxConfigBits {
	/* rx fifo threshold */
	RxCfgFIFOShift	= 13,
	RxCfgFIFONone	= (7 << RxCfgFIFOShift),

	/* Max DMA burst */
	RxCfgDMAShift	= 8,
	RxCfgDMAUnlimited = (7 << RxCfgDMAShift),

	/* rx ring buffer length */
	RxCfgRcv8K	= 0,
	RxCfgRcv16K	= (1 << 11),
	RxCfgRcv32K	= (1 << 12),
	RxCfgRcv64K	= (1 << 11) | (1 << 12),

	/* Disable packet wrap at end of Rx buffer. (not possible with 64k) */
	RxNoWrap	= (1 << 7),
};
static inline void rtl8139_reset(struct net_device *netdev){
	RTL_writeb(netdev, ChipCmd, CmdReset);
	for(int i = 0; i < 1000; i++){
		if((RTL_readb(netdev, ChipCmd) & CmdReset)) return;
		udelay(10);
	}
	spin("8139 reset failed");
	return;
}


void on_recv(int a, void *b){
	spin(" WE GOT A PACKAGE!\n");
}
int rtl8139_open(struct net_device *netdev){
	rtl8139_reset(netdev);
	RTL_writeb(netdev, ChipCmd, CmdRxEnb | CmdTxEnb);
	RTL_writel(netdev, RBSTART, (unsigned)__priv(netdev)->rx_ring_dma);
	RTL_writel(netdev, RxConfig, AcceptAllPhys | AcceptMyPhys | AcceptBroadcast | AcceptMulticast
	  					 |RxNoWrap | RxCfgRcv32K);
	/*register IRQ handler, open IMR */
	request_irq(netdev->irq, on_recv, SA_INTERRUPT, 0);	
	irq_desc[(int)netdev->irq].status &= ~IRQ_DISABLED;
	enable_8259A_irq(netdev->irq);
	RTL_writeb(netdev, IMR, 1 | 4);
	return 0;
}

int rtl8139_stop(struct net_device *netdev){
	return 0;
}

int rt18139_start_xmit(struct sk_buff *skbuff, struct net_device *netdev){
	return 0;	
}


static struct net_device *onend;
int rtl8139_init_one(struct pci_dev *pcidev, const struct pci_device_id *id){
	pci_enable_device(pcidev);
	pci_set_master(pcidev);	/*多数BIOS会清除PCI网卡的master位，导致板卡不能往主存拷数据*/
	struct net_device *netdev = kmalloc2( sizeof(struct net_device), 0 );
	netdev->open = rtl8139_open;
	netdev->stop = rtl8139_stop;
	netdev->start_xmit = rt18139_start_xmit;

	netdev->base_addr = (unsigned)ioremap( pcidev->address[1] & ~0xf, 256, 0);
	netdev->irq = pcidev->irqline;
	oprintf("irq pin: %u , line: %u\n", pcidev->irqpin, pcidev->irqline);
	oprintf("base_addr:%x\n", netdev->base_addr);
	int mac[2] = {0};
	mac[0] = RTL_readl(netdev, 0);
	mac[1] = RTL_readl(netdev, 4);
	oprintf("MAC:%x %x\n", mac[0], mac[1]);

	struct rtl8139_private *private = kmalloc2( sizeof(struct rtl8139_private), 0);
	private->rx_ring = kmalloc2((32 + 2) * 1024, __GFP_DMA);	/* 32K + 2K */	
	private->rx_ring_dma = private->rx_ring - PAGE_OFFSET;
	private->pcidev = pcidev;
	
	netdev->priv = private;

	/*TODO how we pick out the right bar */
	//assert(!(pcidev->address[0] & 1));	/* port mapped address */
	//assert( pcidev->address[0] & 1);	/* memory mapped address */
	onend = netdev;
	return 0;
}



struct pci_driver rtl8139_driver = {
	id_table: rtl8139_id_tbl,
	probe:rtl8139_init_one,
};
/* The rest of these values should never change. */

void rtl8139_test(void){
	pci_register_driver(&rtl8139_driver);
	onend->open(onend);
}





