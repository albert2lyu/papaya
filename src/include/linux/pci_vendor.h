#ifndef PCI_VENDOR_H
#define PCI_VENDOR_H
#include<valType.h>


//  NOTE that the 0xFFFF of 0xFF entries at the end of some tables below are
//  not properly list terminators, but are actually the printable definitions
//  of values that are legitimately found on the PCI bus.  The size
//  definitions should be used for loop control when the table is searched.
typedef struct pci_vendor_entry
{
	unsigned short	VenId ;
	char *	VenShort ;
	char *	VenFull ;
}  PCI_VENTABLE, *PPCI_VENTABLE ;




typedef struct pci_info_entry
{
	unsigned short	VenId ;
	unsigned short	DevId ;
	char *	Chip ;
	char *	ChipDesc ;
}  PCI_DEVTABLE ;




typedef struct pci_class_entry
{
	unsigned char	BaseClass ;
	unsigned char	SubClass ;
	unsigned char	ProgIf ;
	char *		BaseDesc ;
	char *		SubDesc ;
	char *		ProgDesc ;
}  PCI_CLASSCODETABLE, *PPCI_CLASSCODETABLE ;



struct pci_classcode{
	u8 base;
	u8 sub;
	u8 prog;
};

struct pci_info_entry * PciTable_Get(unsigned short vendor, unsigned short device);
struct pci_vendor_entry *PciVendorTbl_Get(u16 vendor);
void PciDevTable_Mk_Fast_Access(void);
struct pci_class_entry *PciClassTbl_Get(u8 class, u8 sub, u8 prog);
#endif
