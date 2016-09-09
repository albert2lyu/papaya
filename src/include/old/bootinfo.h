#ifndef BOOT_INFO_H
#define BOOT_INFO_H

//这个条件编译是为了共享“扇区layout”给_dimg.c。 它是个外部的linux程序，只开放给它必要的信息。
#ifndef ENV_NOT_KERNEL
#include <mm.h>

/* 此处的结构体不是随便定义的，要跟bootinfo.asm里保持一致。手工维护。
 */
struct realmod_info_struct{
	unsigned mem_segnum;
	union{
		struct mem_seginfo mem_seginfo[10];
		char padding[256];
	};
};

extern struct realmod_info_struct realmod_info;
#define realmod_info ((struct realmod_info_struct*)KV(&realmod_info))

#else
#define KV(physical_addr) ((u32)(physical_addr)+KROOM_ADDR)
#endif

extern unsigned _kernel_image_start_sector;
#define kernel_image_start_sector ((unsigned)&_kernel_image_start_sector)
extern unsigned _fiximg_start_sector;
#define fiximg_start_sector ((unsigned)&_fiximg_start_sector)

extern unsigned _memseg_num;
#define g_memseg_num (*(unsigned*)KV(&_memseg_num))

extern unsigned _base_meminfo;
#define g_memseg_info ( (struct memseg_info *)KV(&_base_meminfo) )
#endif
