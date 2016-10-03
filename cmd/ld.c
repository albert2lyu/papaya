#include"ld.h"
#include<sys/mman.h>
#include<old/elf.h>
#include"syscall.h"
#define ERRNO_BASE 0xfffff000
static unsigned LD_BASE;
#define ERRNO(x) (-(int)x)

static int ld_staic_var1 = 0x123;
int ld_var1 = 0x111;
int ld_var2 = 0x222;
int ld_var3 = 0x333;

extern int global_var1, global_var2, global_var3;
//必须用静态函数，普通函数会被作为plt处理。不然调用本模块的函数前，还得处理plt
//TODO  ugly
static int strlen(char*str){
	int len=0;
	while(*str!=0){
		str++;
		len++;	
	}
	return len;
}

//PIC的代码用ld -staci链接，不报错，但是不生成文件.. 呃。。因为makefile删除了非目标文件
//ld可以加fPIC选项，它不报错，但是生成的代码不是PIC的。本来就不可挽回了。只是它为什么不报错?
static int a;
void boot_strap(int arg){
	while(1);
	a = 0;
}


/* the following two functions are not standardly implemented */
static int strcmp(const char *str1, const char *str2){
	int i;
	for(i = 0; str1[i] == str2[i]; i++){
		if(str1[i] == 0) return 0;
	}
	return i + 1;

}

int strncmp(const char *str1, const char *str2, int n){
	for(int i = 0; i < n; i++){
		if(str1[i] == str2[i]) {
			if(str1[i]) continue;
			else return 0;
		}
		else return i + 1;
	}
	return 0;	
}

typedef unsigned uint;
static void putch(int c){
	char str[] = {c, 0};
	write(str, 1);
}

static void puts(char *str){
	write(str, strlen(str));
}

static void printn(uint n, uint b){
	char *ntab = "0123456789ABCDEF";
	uint a, m;
	if ((a = n / b)){
		printn(a, b);
	}
	m = n % b;
	putch( ntab[m]);
}

static void print(char *fmt, ...){
 	char c;
	 uint *adx = (uint*)(void*)&fmt + 1;
_loop:
	 while((c = *fmt++) != '%'){
		if (c == '\0') return;
		putch(c);
	 }
	 c = *fmt++;
	 if (c == 'd' || c == 'l'){
	 	printn(*adx, 10);
	 }
	 if (c == 'o' || c == 'x'){
	 	printn(*adx, c=='o'? 8:16 );
	 }
	 if (c == 's'){
	 	puts((char *)*adx);
	 }
	 adx++;
 goto _loop;
}

void happy(void){
	print("happy");
}
static void spin(char *str){
	print(str);
	while(1);
}

//__attribute__((noinline)) 怎么加
static unsigned geteip(unsigned x) {
	return *(&x - 1);
}

struct elf_mmap{
	int id;
	Elf32_Ehdr *eheader;	//同时也是这段mmap的起始基址
	//Elf32_Shdr *shdr;
	//char *shstr;		//段表字符串表
	int shnum;
	Elf32_Phdr *phdr;
	int phnum;
	char *symstr;		//常规字符串表
	char *dynstr;
	Elf32_Sym *dynsym;
	int dynsym_nr;
	unsigned *var_tbl;		//变量地址表。是不是叫var_addr_tbl好一些，太长了。
	unsigned *func_tbl;		//.got.plt 函数地址表。
	int vtbl_len;			//变量地址表的entry num
	int ftbl_len;			//函数地址表的entry num
	Elf32_Rel *vtbl_fix;	//.rel.dyn
	Elf32_Rel *ftbl_fix;	//.rel.plt
	int vtbl_fix_len;
	int ftbl_fix_len;
};

static struct elf_mmap ldmmap;
#define MAX_SO 1024
static struct elf_mmap *mmap_of_so[MAX_SO];
/* [0]: 动态连接器
 * [1]: 可执行文件
 * [2,3,..]: 常规so
 */


//不要用PTR_FORWARD这个宏，它有改变“那个指针”的含义。
//pointer add some bytes
#define ptr_addb(ptr, bytes) ((void *)( (unsigned long)ptr + (bytes) ) )

/* 因为内核没有映射section header，所以我自己mmap了ld.so来获取section header 
 * 尾巴上的section header区和shstr(段表字符串)区要另行映射，传进来。
 * 不要保留这两个指针，因为parse完，补偿映射就被解除。
 * 虽然我们补偿映射了整个文件，但不要触碰这两片区域以外的地方。为了干净。
 * 
 */
static void parse_elf_mmap(Elf32_Ehdr *eheader, struct elf_mmap *mmap, Elf32_Shdr *sheader, char *shstr){
	Elf32_Sym *dynsym = 0;
	char *dynstr = 0;
	//Elf32_Shdr *sheader = ptr_addb(eheader, eheader->e_shoff);
	Elf32_Phdr *pheader = ptr_addb(eheader, eheader->e_phoff);
	int shnum = eheader->e_shnum;
	int phnum = eheader->e_phnum;
	//shstr= ptr_addb(eheader, sheader[eheader->e_shstrndx].sh_offset);

	for(int i = 0; i < shnum; i++){
		Elf32_Shdr 	*this = sheader + i;
		if(this->sh_addr == 0) continue;	

		char *sec_name = shstr + this->sh_name;
		//print("sh_type:%d, name:%s\n", this->sh_type, sec_name);	
		if( strcmp(".dynstr", sec_name) == 0 ){
			//dynstr  = ptr_addb(eheader, this->sh_offset);	
		}

		else if(strcmp(".dynsym", sec_name) == 0){
			
		}
		/*TODO 可以简化赋值*/
		else if(strcmp(".got", sec_name) == 0){
			mmap->var_tbl = (void *)(LD_BASE + this->sh_addr);
			mmap->vtbl_len = this->sh_size / this->sh_entsize;
		}
		else if(strcmp(".got.plt", sec_name) == 0){
			mmap->func_tbl = (void *)(LD_BASE + this->sh_addr);
			mmap->ftbl_len = this->sh_size / this->sh_entsize;
		}
		else if(strcmp(".rel.dyn", sec_name) == 0){
			mmap->vtbl_fix = (void *)(LD_BASE + this->sh_addr);
			mmap->vtbl_fix_len = this->sh_size / this->sh_entsize;
		}
		else if(strcmp(".rel.plt", sec_name) == 0){
			mmap->ftbl_fix = (void *)(LD_BASE + this->sh_addr);
			mmap->ftbl_fix_len = this->sh_size / this->sh_entsize;
		}
		//过滤未被load的section。
		//这保证我们接下来能用sh_type来识别段，否则一个sh_type可能有多个段实例
		switch(this->sh_type){
			case SHT_DYNSYM:
				dynsym = (void *)(LD_BASE + this->sh_addr);	
				mmap->dynsym_nr = this->sh_size / this->sh_entsize;
				break;
			case SHT_STRTAB:
				dynstr = (void *)(LD_BASE + this->sh_addr);	
				break;
			default:
				break;
		}
}

	mmap->eheader = eheader;
	mmap->phdr = pheader;

	mmap->phnum = phnum;
	mmap->shnum = shnum;

	//mmap->symstr = symstr;
	mmap->dynstr = dynstr;
	mmap->dynsym = dynsym;
}


static char const_symbol_type[5][8] = {
	[0] = "NOTYPE",
	[1] = "OBJECT",
	[2] = "FUNC",
	[3] = "SECTION",
	[4] = "FILE"
};

static void info_dynsym(Elf32_Sym *sym, struct elf_mmap *mmap){
	print("symbol name:%s, value:%x, type:%s\n", 
			mmap->dynstr + sym->st_name, sym->st_value, 
			//sym->st_type);
			const_symbol_type[sym->st_type]);
}

static void info_rel(Elf32_Rel *rel, struct elf_mmap *mmap){
	print("I want to fix area:%x, rel-type:%d, symbol reference =>\n",
			rel->r_offset, rel->r_type);
	info_dynsym(mmap->dynsym + rel->r_symndx, mmap);
}

/* 返回一个符号rebase之后的虚存地址
 * 只是返回。不会修改。
 */
static unsigned now_its_address(Elf32_Sym *sym, struct elf_mmap *mmap){
	return (unsigned)ptr_addb(mmap->eheader,  sym->st_value);
}

static unsigned *area_of_rel(Elf32_Rel *rel, struct elf_mmap *mmap){
	unsigned base = (unsigned)mmap->eheader;
	return (unsigned *)(base + rel->r_offset);
}
struct symbol_origin{
	struct elf_mmap *mmap;
	Elf32_Sym *symbol;
};

//下面这些函数，将来往要查找静态符号，是能提取出不少通用部分的。
static char *nameof_dynsym(Elf32_Sym *sym, struct elf_mmap *mmap){
	return mmap->dynstr + sym->st_name;
}

//一个重定位想修正该模块内的哪个符号
static Elf32_Sym *symof_rel(Elf32_Rel *rel, struct elf_mmap *mmap){
	return mmap->dynsym + rel->r_symndx;
}

static Elf32_Sym *
search_in_dynsym( char *name, struct elf_mmap *so){
	Elf32_Sym *sym;
	Elf32_Sym *match = 0;
	int i;

	for(i = 0; i < so->dynsym_nr; i++){
		sym = so->dynsym + i;
		//if(sym->st_bind != STB_GLOBAL) continue;
		if(strcmp(name, nameof_dynsym(sym, so)) == 0) {
			match = sym;
			break;
		}
	}

	return match;
}

/* 查找符号出处
 * 只返回symbol指针是不够的，还要知道在哪个mmap,所以打包返回
 */
static struct symbol_origin find_symbol(char *name){
	struct symbol_origin origin = {0};
	struct elf_mmap *so;
	Elf32_Sym *match;

	for(int i = 0; i < MAX_SO; i++){
		so = mmap_of_so[i];
		if(!so) continue;
		
		 match = search_in_dynsym(name, so);
		 if(match){
		 	origin.mmap = so;
			origin.symbol = match;
			break;
		 }
	}

	return origin;
}

/* 填写变量/函数地址表的一个entry。
 * 也就是，让一个重定位项生效。
 */
static struct symbol_origin
apply_rel(Elf32_Rel *rel, struct elf_mmap *mmap){
	struct symbol_origin origin;
	//要重定位哪个符号
	Elf32_Sym *inner = symof_rel(rel, mmap);
	char *name = nameof_dynsym(inner, mmap);
	//要修正的符号的真身在哪儿
	origin = find_symbol(name);
	if(origin.mmap){
		unsigned *area = area_of_rel(rel, mmap);	//要修正哪片区域(4个字节)
		unsigned address = now_its_address(origin.symbol, origin.mmap);
		*area = address;
	}
	return origin;
}


/* 注意，_dl_runtime_resolve被调用，是push n, push module_id后jmp过来的。没有eip。
            +----------+
            | ...      |
  ebp  =>   +----------+
            | ebp      |
  eip  =>   +----------+
            | module id|
  arg0 =>   +----------+
            | relndx   |
            +----------+
            |  user eip|
            +----------+
            | user arg0|
            +----------+
            | user arg1|
            +----------+
            |   ...    |
            +----------+
*/
/* @module_id 要修正的符号位于哪个模块
 * @relndx    要修正的是一个怎样的符号(它在.rel.plt中的下标),怎样修正
 */
static void _dl_runtime_resolve(unsigned arg){
	struct symbol_origin origin;
	//Elf32_Sym *relsym;
	Elf32_Rel *rel;
	struct elf_mmap *so;

	//这儿用内联汇编其实还清晰一些
	unsigned *ebp = &arg - 2;	//ebp指针所指是ebp，往下走一个cell是eip，再走
								//一个cell是arg。
	int module_id = ebp[1];
	int relndx = ebp[2];

	so = mmap_of_so[module_id];		//要修正的函数所在模块
	rel = so->ftbl_fix + relndx;		//要修正的是一个怎样的符号，怎么修正
	origin = apply_rel(rel, so);

	if(origin.mmap == 0) {
		print("can not find symbol");
		info_dynsym(origin.symbol, origin.mmap);
		spin("");
	}
	unsigned address = now_its_address(origin.symbol, origin.mmap);
	__asm__ __volatile__("mov %%ebp, %%esp\n\t"
						 "pop %%ebp\n\t"
						 "add $8, %%esp\n\t"
						 "jmp *%0\n\t"
						 :
						 :"r"(address)
						 );	
}
/* 这是核心的函数
 * 填写got表格。也就是重定位了。
 */
static int register_got(int so_id){
	int i,j;
	struct elf_mmap *so;
	Elf32_Rel *rel;
	//Elf32_Sym *relsym;
	struct symbol_origin origin;

	for( i = 0; i < MAX_SO; i++){
		if(mmap_of_so[i] == 0) continue;

		so=  mmap_of_so[i];	
		for(j = 0; j < so->vtbl_fix_len; j++){
			rel = &so->vtbl_fix[j];
											if(rel->r_type != R_386_GLOB_DAT) 
											spin("not R_386_GLOB_DAT");
			origin = apply_rel(rel, so);
			if(origin.mmap == 0) {
				spin("find symbol failed");
			}
		}
		/*.rel.plt不需要再一开始就take it into effect,　有延迟绑定*/
		//for (j = 0; j < so->ftbl_fix_len; j++){}
		so->func_tbl[1] = so->id;
		so->func_tbl[2] = (unsigned)_dl_runtime_resolve;

		/*.got.plt的所有表项，在最一开始，需要统一rebase */
		for(i = 3; i < so->ftbl_len; i++){
			so->func_tbl[i] += (unsigned)so->eheader;
		}
	}

	return 0;
}


/*
        +--------+                           +--------+
        +--------+                           +--------+
        |        |                           |  ebp   |
        +--------+                           +--------+
        |  ebp   |                           |  eip   |
        +--------+                           +--------+
        | argc   |                           | argc   |
        +--------+                           +--------+
        | argv0  |                           | argv0  |
        +--------+                           +--------+
        | argv1  |                           | argv1  |
        +--------+                           +--------+
        | argv2  |                           | argv2  |
        +--------+                           +--------+
        | ...    |                           | ...    |
        +--------+                           +--------+
*/
/* 控制权交给ld后，进程堆栈的布局是左侧，因为内核是直接把eip指针设置到__start
   并不是call过来的。ebp下方没有一个eip。
 * 但是，gcc在编译__start是当做一个普通函数被编译的。所以它还是按照右侧来的。
 * 它眼中的第一个参数，还是[ebp + 8]
 */
void __start(char *arg0){
	Elf32_Ehdr *eheader = 0, *eheader2 = 0; 
	unsigned program_entry = 0;

	/* 即使直接运行ld.so，内核加载它的地址也是不确定的。(very strange )
	   所以我们先要看看自己被加载到哪儿去了
	 */
	char *page = (void *) (geteip(0) & ~0xfff) ;
	while(!(page[0] == 127 	
			&& page[1] == 'E' && page[2] == 'L' && page[3] == 'F')){
		page -= 0x1000;
	}
	
	LD_BASE = (unsigned)page;
	eheader = (void *)LD_BASE;

	char **argv = &arg0;
    int argc =  (unsigned)argv[-1];
    char **envp = argv + argc + 1;
	ld_staic_var1 = 0x4455;
	//ld_var1 = 0x5555;
	int i;
	for(i = 0; envp[i]; i++){
		//print("%d\n", i);
	}
	Elf32_auxv_t *aux = (void *)(envp + i + 1);
	while(aux->a_type){
		//print("type:%d, value:%x\n", aux->a_type, aux->a_val);
		switch(aux->a_type){
			case AT_SYSINFO_EHDR:
				//eheader = (void *)aux->a_val;
				break;
			case AT_ENTRY:
				program_entry = aux->a_val;
			default:
				break;
		}
		aux++;
	}


	char filepath[] = "./ld.so";
	int ldfd = open(filepath, 0, 0);
	if(ldfd <= 0) spin("open ld.so failed");
	//print("open ld.so success, got fd: %d\n", ldfd);
	eheader2 = mmap2(0,  0x10000, PROT_READ, MAP_PRIVATE, ldfd, 0);
	if(eheader2 > (Elf32_Ehdr*)ERRNO_BASE){
		//上面若不启用MAP_PRIVATE标志，会得到16号errno.　设备忙？
		print("errno:%x\n", ERRNO(eheader));
		spin("mmap2 failed");
	}
	//print("eheader at :%x\n", eheader2);

	if(program_entry == LD_BASE + eheader->e_entry){
		print("I am the program itself !\n");
	}
	else{
		print("I am ld, invoked by kernel..\n");
		print("program entry:%x\n", program_entry);
	}


	//并没有一个sheader或sheader1
	Elf32_Shdr *sheader2 = ptr_addb(eheader2,  eheader->e_shoff);
	char *shstr2 =  ptr_addb(eheader2, sheader2[eheader->e_shstrndx].sh_offset);
	parse_elf_mmap(eheader, &ldmmap,  sheader2, shstr2);
		
		#if 0
	print("dynsym: %x,num: %d, dynstr:%x\n", ldmmap.dynsym, ldmmap.dynsym_nr, ldmmap.dynstr);
	for(i = 0; i < ldmmap.dynsym_nr; i++){
		Elf32_Sym *sym = ldmmap.dynsym + i;
		print("%s\n", ldmmap.dynstr + sym->st_name);
	}
	#endif
	ldmmap.id = 0;
	mmap_of_so[0] = &ldmmap;
	register_got(0);
	print("ld_var1:%x, ld_var3:%x\n", ld_var1, ld_var3);
	happy();

	print("exit normally\n");
	global_var1 = 0x9999;
	extern void global_func1();
	global_func1();
	boot_strap(0);

}
