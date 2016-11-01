#include<disp.h>
#include<utils.h>
#include<mm.h>
#include<valType.h>
#include<proc.h>
#include<bootinfo.h>
#include<elf.h>
#include<fork.h>
#include<linux/sched.h>
struct slab_head * mm_cache;
struct slab_head * vm_area_cache;
struct slab_head *fs_struct_cache;
struct slab_head *files_struct_cache;
struct slab_head *file_cache;
u32 gmemsize=0;
char testbuf[1024];
void init_memory(void){
	assert(sizeof(union cr3) == 4 && sizeof( union pte) == 4 && 
		   sizeof(union linear_addr) == 4);
	heap_init();
	/**detect pphysical memory: print memory information and init global variable 'gmemsize'*/
	int mem_segnum = realmod_info->mem_segnum;
	struct mem_seginfo *memseg =realmod_info->mem_seginfo;
	oprintf("%12s%12s%10s\n","start","len","type");
	for(int i=0; i<mem_segnum; i++){
		oprintf("%12x%12x%10s\n",memseg[i].base_low,memseg[i].len_low,\
								memseg[i].type==1?"free":"occupied");
		if(memseg[i].type == 1 && memseg[i].base_low > gmemsize) \
			gmemsize = memseg[i].base_low+memseg[i].len_low;
	}
/*	oprintf("physical memory size:%x\n",gmemsize);	*/

	/**initialize mem_map*/
	int mapsize = G_PGNUM * sizeof(struct page);
	mem_map = kmalloc0(mapsize);

	size_of_zone[0] = 16*0x100000;
	if(gmemsize > ZONE_HIGHMEM_PA){
		size_of_zone[1] = (896-16)*0x100000;
		size_of_zone[2] = gmemsize - 896*0x100000;
	}
	else{
		size_of_zone[1] = gmemsize - 16*0x100000;
		size_of_zone[2] = 0;
	}
}


void map_pg(u32*dir,int vpg,int ppg,int us,int rw){
	/**check the validation of page dir-entry. does it point to a valid page
	 * table?if not,alloc a clean page as page-table*/
	u32 *dirent = dir + PG_H10(vpg);
	if((*dirent & PG_P) == 0){
/*		oprintf("@map_pg bad entry,alloc one page as table\n");*/
		//在pgdir的entry里，不对U/S, R/W做控制，留给page table
		*dirent  =__pa(__alloc_page(__GFP_ZERO) )| PG_USU | PG_RWW | PG_P;	
	}
	u32 *tbl = (u32*)KV((*dirent)>>12<<12);/**trip attr-bit*/
/*	oprintf("@map_pg tbl at:%x\n",tbl);*/
	tbl[PG_L10(vpg)] = ppg<<12|us|rw|PG_P;
	FLUSH_TLB;
}

/* for quick test, to be removed soon
 * febd1000, febfxxxx, ...
 * 8139网卡的寄存器群是映射在1G左右的地方的，我们把它映射到4G附近的地方来访问。
 * 它是memory mapped IO, 我们访问就用mov,当然是经过MMU的。
 */
void temp_mmio_map(void){
	/* intel i3 motherboard, rtl8139, mmio base, 0x3baff0000
	 * intel pentium motherboard, rtl8139, mmio base, 0x3febxxxxx
	 * intel 945 mmio base, 0x3dbff000
	 *  we map from 0xfba00000 ==> 0xfbb00000, 0xfeb80000 ===> 0xfec00000
	 */
	oprintf(" temp mmio map begin >>>>>>>>>\n");
	unsigned *dir = (unsigned *)0xc0100000;
	//u32 start = 0xfeb80000;
	//u32 end = 0xfec00000 - 0x1000;					/* 应该减去0x1000的，无伤大雅*/
	u32 start = 0xfba00000;
	u32 end = 0xfbb00000;
	for(unsigned vaddr = start; vaddr <= end; vaddr+=1024*4){
		int vpg = (vaddr - PAGE_OFFSET) >> 12;
		int ppg = vaddr >> 12;
		map_pg(dir, vpg, ppg, 0, PG_RWW);	//equal map
		#if 1
		if(vaddr == end){		//only once
			static int done = false;
			if(done) break;
			done = true;

			end = 0xfec00000;
			vaddr = 0xfeb80000;
		}
		#endif
	}
	for(unsigned vaddr = 0xfdbf0000; vaddr <= 0xfdc00000; vaddr+=1024*4){
		int vpg = (vaddr - PAGE_OFFSET) >> 12;
		int ppg = vaddr >> 12;
		map_pg(dir, vpg, ppg, 0, PG_RWW);	//equal map
	}
	oprintf(" temp mmio map done -----\n");
}
/**
 * |---kernel(1M)---|---kernel pgdir+kernel pgtbl(1M)---|---heap(14M)---|
 */
void mm_init(void){
	init_memory();
	init_zone();
	temp_mmio_map();
	extern bool mm_available;
	mm_available = true;
}

void mm_init2(void){
	mm_cache =  kmem_cache_create("mm_cache", sizeof(struct mm), 0,
										SLAB_HWCACHE_ALIGN, 0, 0);
	vm_area_cache = kmem_cache_create("vma_cache", sizeof(struct vm_area), 0,
										SLAB_HWCACHE_ALIGN, 0, 0);
	fs_struct_cache = kmem_cache_create("fs_struct_cache", 
										sizeof(struct fs_struct), 0,
										SLAB_HWCACHE_ALIGN, 0, 0);
	files_struct_cache = kmem_cache_create("files_struct_cache", 
										sizeof(struct files_struct), 0,
										SLAB_HWCACHE_ALIGN, 0, 0);
	file_cache = kmem_cache_create("files_cache", 
										sizeof(struct file), 0,
										SLAB_HWCACHE_ALIGN, 0, 0);
}





