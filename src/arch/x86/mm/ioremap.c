#include<mm.h>
#include<asm/io.h>

void * ioremap(unsigned phys_addr, int size, unsigned flags){
	if(phys_addr >> 30) {
		oprintf(" %x ", phys_addr);
		spin("too big IO physical address");
	}
	return (void *)(phys_addr + PAGE_OFFSET);
}
