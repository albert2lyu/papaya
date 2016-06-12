#ifndef PCI_H
#define PCI_H
#include<linux/pci_regs.h>
#include<linux/pci_vendor.h>
#include<list.h>

struct pci_device_id{
	u16 vendor, device;
	u16 subvendor, subdevice;
	//__u32 class, class_mask;	//(class, subclass, prog-if)triplet
};


/*	PCI configuration space. 256 bytes.
DW |    Byte3    |    Byte2    |    Byte1    |     Byte0     | Addr
---+---------------------------------------------------------+-----
 0 | 　　　　Device ID 　　　　| 　　　　Vendor ID 　　　　　|　00
---+---------------------------------------------------------+-----
 1 | 　　　　　Status　　　　　| 　　　　 Command　　　　　　|　04
---+---------------------------------------------------------+-----
 2 | 　　　　　　　Class Code　　　　　　　　|　Revision ID　|　08
---+---------------------------------------------------------+-----
 3 | 　　BIST　　| Header Type | Latency Timer | Cache Line  |　0C
---+---------------------------------------------------------+-----
 4 | 　　　　　　　　　　Base Address 0　　　　　　　　　　　|　10
---+---------------------------------------------------------+-----
 5 | 　　　　　　　　　　Base Address 1　　　　　　　　　　　|　14
---+---------------------------------------------------------+-----
 6 | 　　　　　　　　　　Base Address 2　　　　　　　　　　　|　18
---+---------------------------------------------------------+-----
 7 | 　　　　　　　　　　Base Address 3　　　　　　　　　　　|　1C
---+---------------------------------------------------------+-----
 8 | 　　　　　　　　　　Base Address 4　　　　　　　　　　　|　20
---+---------------------------------------------------------+-----
 9 | 　　　　　　　　　　Base Address 5　　　　　　　　　　　|　24
---+---------------------------------------------------------+-----
10 | 　　　　　　　　　CardBus CIS pointer　　　　　　　　　 |　28
---+---------------------------------------------------------+-----
11 |　　Subsystem Device ID　　| 　　Subsystem Vendor ID　　 |　2C
---+---------------------------------------------------------+-----
12 | 　　　　　　　Expansion ROM Base Address　　　　　　　　|　30
---+---------------------------------------------------------+-----
13 | 　　　　　　　Reserved(Capability List)　　　　　　　　 |　34
---+---------------------------------------------------------+-----
14 | 　　　　　　　　　　　Reserved　　　　　　　　　　　　　|　38
---+---------------------------------------------------------+-----
15 | 　Max_Lat　 | 　Min_Gnt　 | 　IRQ Pin　 | 　IRQ Line　　|　3C
-------------------------------------------------------------------
*/

/* 记住，调试的时候，list_head可能不是4字节对齐的，kmalloc2没问题。是这儿的pack(1)导致*/
#pragma pack(push)
#pragma pack(1)
struct pci_config_addr{
	int always:2 ;		/* 0 ~ 1 */
	unsigned reg: 6;	/* 2 ~ 7 */
	union{
		struct{
			unsigned func: 3;	/* 8 ~ 10 */
			unsigned dev: 5;	/* 11 ~ 15 */
			unsigned bus: 8;	/* 16 ~ 23 */
		};
		u16 value;
	};
	unsigned reserved:	7;
	int enabled:	1;
};
#pragma pack (pop)

#pragma pack (push)
#pragma pack (1)
struct pci_dev{
	u16 vendor;
	u16 device;
	u16 command;
	u16 status;
	char revision;
	unsigned class: 28;
	u8 cacheline;
	u8 timer;
	u8 headtype;
	u8 bist;
	unsigned address[6];
	unsigned cis;
	u16 sub_vendor;
	u16 sub_device;
	unsigned romaddr;
	unsigned reserved1;
	unsigned reserved2;
	char irqline;
	char irqpin;
	char mingnt;
	char maxlat;
	//don't touch members above... the standard header of PCI configuration room */

	struct list_head node;
	struct pci_driver *driver;
	unsigned vaddress[6];
	u8 bus;
	unsigned dev: 5;
	unsigned func: 3;
};
#pragma pack (pop)

struct pci_driver{
	struct list_head node;
	char *name;
	struct pci_device_id *id_table;	/* the driver use this field to tell kernel the 
									 * device-list supported, i think. one driver may 
									 * support several device, like rtl8139C, rtl8139D */
	int (*probe)(struct pci_dev *dev, const struct pci_device_id *id);
	//void remove;
	//int suspend;
	//int resume;
};

/* @reg  1 reg = 4 bytes, so 64 at most.
 */
static inline unsigned MK_PCI_CFG_ADDR(int bus, int dev, int func, int reg){
	struct pci_config_addr addr_stru = {
		always: 0,
		reg: reg,
		func: func,
		dev: dev,
		bus: bus,
		reserved: 0,
		enabled: 1
	};
	return *(unsigned *)&addr_stru;
}

static inline unsigned get_pci_cfg_reg(int bus, int dev, int func, int reg){
	unsigned addr = MK_PCI_CFG_ADDR(bus, dev, func, reg);
	unsigned port0xcfc = 0;
	__asm__ __volatile__ ("out %%eax, %%dx\n\t"
						  "mov $0xCFC, %%dx\n\t"
						  "in %%dx, %%eax\n\t"
						  :"=a"(port0xcfc)
						  :"a"(addr), "d"(PCI_CONFIG_ADDR)
						  );	
	return port0xcfc;	
}

static inline void set_pci_cfg_reg(int bus, int dev, int func, int reg, unsigned value){
	unsigned addr = MK_PCI_CFG_ADDR(bus, dev, func, reg);
	__asm__ __volatile__ ("out %%eax, %%dx\n\t"
						  "mov $0xCFC, %%dx\n\t"
						  "mov %%ebx, %%eax\n\t"
						  "out %%eax, %%dx\n\t"
						  :
						  :"a"(addr), "d"(PCI_CONFIG_ADDR), "b"(value)
						  );	
}

static inline unsigned pci_read_config_dword(struct pci_dev *pcidev, int offset){
	return 	get_pci_cfg_reg(pcidev->bus, pcidev->dev, pcidev->func, offset>>2);
}

static inline void pci_write_config_dword(struct pci_dev *pcidev, int offset, unsigned value){
	set_pci_cfg_reg(pcidev->bus, pcidev->dev, pcidev->dev, offset>>2, value);
}

/* Note! this function can only set a bit, can not clear a bit 
 * fix: read out first, and write back after operation
 */
static inline void pci_fix_config_dword(struct pci_dev *pcidev, int offset, unsigned value){
	unsigned origin = pci_read_config_dword(pcidev, offset);
	origin |= value;
	pci_write_config_dword(pcidev, offset, origin);
}

void pci_init(void);
int pci_register_driver(struct pci_driver *driver);
#endif
