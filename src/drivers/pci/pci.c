#include<linux/pci.h>

#define PCI_BUS_MAX 256
#define PCI_DEV_MAX 32
#define PCI_FUNC_MAX 8
#include<utils.h>

void pci_init(void){
	PciDevTable_Mk_Fast_Access();
	for(int bus = 0; bus < PCI_BUS_MAX; bus++){
		for(int dev = 0; dev < PCI_DEV_MAX; dev++){
			for(int func = 0; func < PCI_FUNC_MAX; func++){
				unsigned port0xcfc = get_pci_cfg_info(bus, dev, func, 0);
				u16 vendor = (u16)port0xcfc;
				if(vendor == 0xffff) break; 
				struct pci_info_entry * info_ent = PciTable_Get(vendor, port0xcfc>>16);
				struct pci_vendor_entry * vendor_ent = PciVendorTbl_Get(vendor);
				if(vendor_ent){
					oprintf("@%s, ", vendor_ent->VenFull);
					if(info_ent) oprintf("%s, %s", info_ent->Chip, info_ent->ChipDesc);
				}
				else oprintf("@unknown(%x : %x)",  vendor, port0xcfc >> 16);
				
				port0xcfc = get_pci_cfg_info(bus, dev, func, 8);
				struct pci_classcode *class = (void *)&port0xcfc;
				struct pci_class_entry *ent = PciClassTbl_Get(class->base, class->sub, class->prog);
				if(ent) oprintf("classcode: %s, %s, %s\n", ent->BaseDesc, ent->SubDesc, ent->ProgDesc);
				else oprintf("classcode: unknown %x %x %x\n", class->base, class->sub, class->prog);
			}
		}
	}
}
