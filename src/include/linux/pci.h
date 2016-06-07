#ifndef PCI_H
#define PCI_H
#include<linux/pci_regs.h>
#include<linux/pci_vendor.h>
struct pci_config_addr{
	int always:2 ;		/* 0 ~ 1 */
	unsigned reg: 6;	/* 2 ~ 7 */
	unsigned func: 3;	/* 8 ~ 10 */
	unsigned dev: 5;	/* 11 ~ 15 */
	unsigned bus: 8;	/* 16 ~ 23 */
	unsigned reserved:	7;
	int enabled:	1;
};
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

static inline unsigned get_pci_cfg_info(int bus, int dev, int func, int reg){
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

void pci_init(void);
#endif
