
#define gpgdir ((u32*)0xc0100000)
#define gpgtbl ((u32*)0xc0101000)
/* @tbladdr 这个宏设计的不好。 它的功能是完成paddr处（一个页）的对等映射。
 * 但需要手动给出用于映射的页表地址。
 */
#define build_equal_map(paddr,tbladdr)	/**tbladdr use physical addr*/\
	do{\
		u32 dir_ent = paddr/0x400000;\
		gpgdir[dir_ent] = tbladdr|PG_P|PG_RWW|PG_USS; /**note: gpgdir is 'int*' type,so we use dir_ent as index directly*/\
		u32 tbl_ent = (paddr%0x400000)>>12;\
		((u32*)KV(tbladdr))[tbl_ent] = paddr|PG_P|PG_RWW|PG_USS;\
	} while(0)




	mem_entity[0]='G';
	mem_entity[1]='M';
	mem_entity[2]='K';
	mem_entity[3]='B';
