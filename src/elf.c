#include<elf.h>
#include<utils.h>

static Elf32_Ehdr *eheader;
static Elf32_Phdr *pheader;
static int set(char *img){
	assert(img[1] == 'E' && img[2]=='L' && img[3] == 'F');
	eheader = (Elf32_Ehdr *)img;
	pheader = (Elf32_Phdr *)(img + eheader->e_phoff);
	return 1;
}

unsigned loadelf(char *img){
	set(img);

	for (int i = 0; i < eheader->e_phnum; i++){
		if(pheader[i].p_type != 1) continue;
		memset(pheader[i].p_vaddr, pheader[i].p_memsz, 0);
		memcp(pheader[i].p_vaddr, img + pheader[i].p_offset, pheader[i].p_filesz);
	}
	return eheader->e_entry;
}
