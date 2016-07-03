#include<linux/pci.h>

#define PCI_BUS_MAX 256
#define PCI_DEV_MAX 32
#define PCI_FUNC_MAX 8
#include<utils.h>
#include<linux/slab.h>
static struct list_head pcidevs_root;
static struct list_head pcidrvs_root;
void pci_init(void){
	INIT_LIST_HEAD(&pcidevs_root);	
	INIT_LIST_HEAD(&pcidrvs_root);	

	PciDevTable_Mk_Fast_Access();
	for(int bus = 0; bus < PCI_BUS_MAX; bus++){
		for(int dev = 0; dev < PCI_DEV_MAX; dev++){
			for(int func = 0; func < PCI_FUNC_MAX; func++){
				unsigned port0xcfc = get_pci_cfg_reg(bus, dev, func, 0);
				u16 vendor = (u16)port0xcfc;
				if(vendor == 0xffff) break; 
				
				struct pci_dev *pcidev = kmalloc2( sizeof(struct pci_dev), 0);
				for(int i = 0; i < 64; i++){
					((unsigned *)pcidev)[i] = get_pci_cfg_reg(bus, dev, func, i);
					pcidev->bus = bus;
					pcidev->dev = dev;
					pcidev->func = func;
				}
				list_add(&pcidev->node, &pcidevs_root);	

				#if 0
				struct pci_info_entry * info_ent = PciTable_Get(vendor, port0xcfc>>16);
				struct pci_vendor_entry * vendor_ent = PciVendorTbl_Get(vendor);
				if(vendor_ent){
					oprintf("@%s, ", vendor_ent->VenFull);
					if(info_ent) oprintf("%s, %s", info_ent->Chip, info_ent->ChipDesc);
				}
				else oprintf("@unknown(%x : %x)",  vendor, port0xcfc >> 16);
				
				port0xcfc = get_pci_cfg_reg(bus, dev, func, 2);	/* 2, not 8 */
				struct pci_classcode class = { value: port0xcfc >> 8};
				struct pci_class_entry *ent = PciClassTbl_Get(class.base, class.sub, class.prog);
				if(ent) oprintf("class(%x): %s, %s, %s\n", port0xcfc>>8, ent->BaseDesc, ent->SubDesc, ent->ProgDesc);
				else oprintf("class(%x): unknown %x %x %x\n",port0xcfc>>8, class.base, class.sub, class.prog);
				/* check bit 7 of the header type before scan all functions, 
				 * otherwise, some single-function devices will report details for
				 * function 0" for every function.  */
				 /*我在rtl8139上测的，确实有这个问题，加上这句，信息干净不少*/
				 #endif
				if(func == 0 && !(pcidev->headtype & 0x80)) break;
			}
		}
	}
	//spin(" pci spin");
}

static inline 
struct pci_device_id * 
id_table_matched(struct pci_device_id *id_table, struct pci_dev *dev){
	struct pci_device_id * id = id_table;
	while(id->vendor){
		if(id->vendor == dev->vendor && id->device == dev->device) return id;
		id++;
	}
	return false;
}

int pci_register_driver(struct pci_driver *driver){
	list_add(&driver->node, &pcidrvs_root);	
	struct list_head *curr_node = pcidevs_root.next;
	//struct pci_dev *matched;
	while(curr_node != &pcidevs_root){
		struct pci_dev *curr_dev = MB2STRU(struct pci_dev, curr_node, node);
		struct pci_device_id * id = id_table_matched( driver->id_table, curr_dev);
		if(id){
			curr_dev->driver = driver;
			driver->probe( curr_dev, id);
		};
		curr_node = curr_node->next;
	}
	return 0;
}

int pci_enable_device(struct pci_dev *pcidev){
	pci_fix_config_dword(pcidev, PCI_COMMAND, PCI_COMMAND_IO | PCI_COMMAND_MEMORY);
	return 0;
}

int pci_set_master(struct pci_dev *pcidev){
	pci_fix_config_dword(pcidev, PCI_COMMAND, PCI_COMMAND_MASTER);
	return 0;
}













