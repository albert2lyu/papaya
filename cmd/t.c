how do you deal with PCI-VENDOR-DEVICE text in your kernel?

  during the system initialization, we usually need to scan the pci bus and print all devices to screen with format like:
  Realtek 8139d Ethernet adapter
  Thus, we need a pci_vendor_device text table to record informations of all PCI device all over the world. I download such a C header file from internet:
  http://pcidatabase.com/reports.php?type=csv
  It's more than 9000 lines, and will increase the size of my kernel image by at least 128K. I feel a little uncomfortable that my little kernel(no more than 64K)  will have to adopt such a large size text information . 
 
  How do you handle it in your kernel? seperate it into a disk file and read it during initialization? I considered that, but that means i have to produce ways of accessing filesystem in a very early phase of initialization. So i give up it.
  But should we seperate it from the kernel  image? What is a kernel image in your eyes? only consisting of the core code rather than such messy text information?
  Now, i still encode it into my kernel image, because i have got used to encod everything into it. I know it's where i am uncomfortable, then i feel better ^.^ )
  
