#ifndef BOOT_INFO_H
#define BOOT_INFO_H

#ifndef ENV_NOT_KERNEL
#include <mm.h>
/**i think operating a structure is better*/
struct realmod_info{
	unsigned memseg_num;
	union{
		struct memseg_info memseg_info[10];
		char pad[256];
	};
};

extern unsigned base_realmod_info;
#define realinfo ((struct realmod_info*)KV(&base_realmod_info))

#else
#define KV(physical_addr) ((u32)(physical_addr)+KROOM_ADDR)
#endif

extern unsigned _kernel_image_start_sector;
#define kernel_image_start_sector ((unsigned)&_kernel_image_start_sector)

extern unsigned _memseg_num;
#define g_memseg_num (*(unsigned*)KV(&_memseg_num))

extern unsigned _base_meminfo;
#define g_memseg_info ( (struct memseg_info *)KV(&_base_meminfo) )
#endif
