/* tips for transplant 
 * 几处mmap()的使用可能需要papaya增强mmap()的实现．
 */

/*TODO 
 * 运行对象是ld.so时，brk的行为?
 * 你只是加载了所有的so，但是没有给他们重定位
 * 记得测试bss区，data区交界的地方
 * 像malloc,memset这样的函数，ld.so里有导出，如果它的正经库里也导出
   那重定位时，可能会出错？
 * 共享模块(和可执行文件中)的重复全局变量的问题
 */

#include"ld.h"
#include<old/elf.h>
#include"syscall.h"
#include"static.h"	
#include<linux/kit.h>
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

static int fdsize(int fd){
	int pos = lseek(fd, 0, 1);	
	int size = lseek(fd, 0, 2);
	lseek(fd, pos, 0);
	return size;
}

//此处实现一个小的malloc
unsigned heap_bottom;	//总是等于brk(0)，是真正的"底线"+1
unsigned goodarea;		//一旦碰到heap_bottom，就要继续brk
void init_heap(void){
	heap_bottom = brk(0);
	goodarea = heap_bottom;	//初始时就让他碰到底
}
void *malloc(int size){
	unsigned newarea = goodarea + size;
	if(newarea >= heap_bottom){
		int brksize = ceil_align(size, __4K);
		heap_bottom = brk(heap_bottom + brksize);	
															if(heap_bottom >= ERRNO_BASE) spin("brk failed");
	}
	unsigned area = goodarea;
	goodarea = newarea;
	return (void *)area;
}

void * memset(void *start, int value, int len){
	for(int i = 0; i < len; i++){
		((char *)start)[i] = value;
	}
	return start;
}

//__attribute__((noinline)) 怎么加
static unsigned geteip(unsigned x) {
	return *(&x - 1);
}

struct elf_mmap{
	void *text;			/*realtime address of text section, for gdb */
	char *filename;
	int id;
	Elf32_Ehdr *eheader;	//同时也是这段mmap的起始基址
	u32 rebase;
	//Elf32_Shdr *shdr;
	//char *shstr;		//段表字符串表
	int shnum;
	Elf32_Phdr *pheader;
	int phnum;
	Elf32_Dyn *dynamic;
	int dynlen;
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
static int right;		//shared object at the most right side currently
/* [0]: 动态连接器
 * [1]: 可执行文件
 * [2,3,..]: 常规so
 */


//不要用PTR_FORWARD这个宏，它有改变“那个指针”的含义。
//pointer add some bytes

/* 
 * 因为内核没有映射section header，所以我自己mmap了ld.so来获取section header 
 * 尾巴上的section header区和shstr(段表字符串)区要另行映射，传进来。
 * 不要保留这两个指针，因为parse完，补偿映射就被解除。
 * 虽然我们补偿映射了整个文件，但不要触碰这两片区域以外的地方。为了干净。
 * 
 * @fd 不用filepath，是为了节省多处open/close的开销
 *
 *
 */
static bool 
parse_elf_mmap(Elf32_Ehdr *eheader, struct elf_mmap *mmap, int fd){
	//小心addr,len 4K对齐
	Elf32_Ehdr *eheader2;
	Elf32_Shdr *sheader2;
	char *shstr2;
	int space = ceil_align( fdsize(fd), __4K );
	eheader2 = mmap2(0,  space, PROT_READ, MAP_PRIVATE, fd, 0);
															if(eheader2 > (Elf32_Ehdr*)ERRNO_BASE)
																return false;
	sheader2 = ptr_offset(eheader2,  eheader2->e_shoff);
	/* 接下来必须用sh_offset定位,不能用sh_addr，原因有二:
	 * 1, 这可能是个可执行elf
	 * 2, 即使是DYN类型也不能．因我们采用的线性映射，vaddr是不准的．
	 */
	shstr2 =  ptr_offset(eheader2, sheader2[eheader->e_shstrndx].sh_offset);
	/*------done-----*/

	Elf32_Phdr *pheader = ptr_offset(eheader, eheader->e_phoff);
	u32 rebase;
	if(eheader->e_type == ET_EXEC){							/*做一些额外的检查*/
															u32 load_at = pheader[2].p_vaddr;
															/*第一个段一定在第一页*/
															load_at = floor_align(load_at, __4K); 
															if(load_at != (u32)eheader) 
															spin("executable loaded at wrong location");
		rebase = 0;		
	}
	else if(eheader->e_type == ET_DYN){
		rebase = (u32)eheader;	
	}
	else spin("bad e_type");

	for(int i = 0; i < eheader->e_shnum; i++){
		void **sec_area = 0;	/* 这个段在内存中的位置 */
		int *sec_entnum = 0;		/*entry num, not total length*/
		Elf32_Shdr 	*this = sheader2 + i;
		if(this->sh_addr == 0) continue;	

		char *sec_name = shstr2 + this->sh_name;
		//print("sh_type:%d, name:%s\n", this->sh_type, sec_name);	
		if( strcmp(".dynstr", sec_name) == 0 ){
			sec_area = (void *)&mmap->dynstr;
		}
		else if(strcmp(".dynsym", sec_name) == 0){
			sec_area = (void *)&mmap->dynsym;
			sec_entnum = (void *)&mmap->dynsym_nr;
		}
		else if(strcmp(".text", sec_name) == 0){
			sec_area = (void *)&mmap->text;
		}
		/*TODO 可以简化赋值*/
		else if(strcmp(".dynamic", sec_name) == 0){
			sec_area = (void *)&mmap->dynamic;
			sec_entnum = &mmap->dynlen;
		}
		else if(strcmp(".got", sec_name) == 0){
			sec_area = (void *)&mmap->var_tbl;
			sec_entnum = &mmap->vtbl_len;
		}
		else if(strcmp(".got.plt", sec_name) == 0){
			sec_area = (void *)&mmap->func_tbl;
			sec_entnum = &mmap->ftbl_len;
		}
		else if(strcmp(".rel.dyn", sec_name) == 0){
			sec_area = (void *)&mmap->vtbl_fix;
			sec_entnum = &mmap->vtbl_fix_len;
		}
		else if(strcmp(".rel.plt", sec_name) == 0){
			sec_area = (void *)&mmap->ftbl_fix;
			sec_entnum = &mmap->ftbl_fix_len;
		}
		else;

		//错了，TODO EXEC呢
		if(sec_area) *sec_area = (void *)(rebase + this->sh_addr);
		if(sec_entnum) *sec_entnum = this->sh_size / this->sh_entsize;
	}

	mmap->eheader = eheader;
	mmap->shnum = eheader->e_shnum;
	mmap->phnum = eheader->e_phnum;
	mmap->pheader = pheader;
	mmap->rebase = rebase;

	void *ret = munmap(eheader2, space);					
															if(ret != 0) return false;
	return true;
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
	return mmap->rebase + sym->st_value;
}

static unsigned *area_of_rel(Elf32_Rel *rel, struct elf_mmap *mmap){
	return (unsigned *)(mmap->rebase + rel->r_offset);
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

/* 专门用来搜索符号"真身"的．所以对非GLOBAL类型跳过
 */
static Elf32_Sym *
search_in_dynsym( char *name, struct elf_mmap *so){
	Elf32_Sym *sym;
	Elf32_Sym *match = 0;
	int i;

	for(i = 0; i < so->dynsym_nr; i++){
		sym = so->dynsym + i;
		if(sym->st_shndx == SHN_UNDEF) continue;	//这是引用外部的符号
		//if(sym->st_bind != STB_GLOBAL) continue;
		if(strcmp(name, nameof_dynsym(sym, so)) == 0) {
															if(sym->st_shndx != SHN_COMMON 
																&& sym->st_shndx >= SHN_LORESERVE)
																spin("strange capture");
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
   也就是，让一个重定位项生效。
 * 返回origin类型是不是不恰当．因为RELATIVE类型．   
 * @return 如果失败，返回的origin.mmap是０
 */
static struct symbol_origin
apply_rel(Elf32_Rel *rel, struct elf_mmap *mmap){
	struct symbol_origin origin; //要重定位哪个符号 

	//其实对于RELATIVE类型来说，它的symbol指示是０
	//压根就不需要下面两行．返回的origin里的mmap指向本身也是牵强的
	Elf32_Sym *inner = symof_rel(rel, mmap);	//要修正的符号
	char *name = nameof_dynsym(inner, mmap);
	unsigned *area = area_of_rel(rel, mmap);	//要修正哪片区域(4个字节)
	unsigned address = 0;
	switch(rel->r_type){
		case R_386_RELATIVE:
			origin.mmap = mmap;	//相对修正，是内部操作，填写自己
			origin.symbol = 0;	//没有符号．TODO　一定没有符号吗
			address = (u32)ptr_offset(mmap->rebase, *area);
			break;
		case R_386_GLOB_DAT:
		case R_386_JMP_SLOT:
			origin = find_symbol(name); //要修正的符号的真身在哪儿
			if(origin.mmap)
				address = now_its_address(origin.symbol, origin.mmap);
			break;	
		default:
			origin.mmap = 0;	//标识失败
	}
	if(origin.mmap)		*area = address;

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
	int relndx = ebp[2];	//注意，是以字节为偏移

	so = mmap_of_so[module_id];		//要修正的函数所在模块
	rel = ptr_offset(so->ftbl_fix, relndx);		//要修正的是一个怎样的符号，怎么修正
	origin = apply_rel(rel, so);

	if(origin.mmap == 0) {
		info_dynsym(origin.symbol, origin.mmap);
		spin("can not find the symbol above");
	}
	unsigned address = now_its_address(origin.symbol, origin.mmap);
	__asm__ __volatile__("mov %%ebp, %%esp\n\t"
						 "mov -4(%%ebp), %%ebx\n\t"
						 "pop %%ebp\n\t"
						 "add $8, %%esp\n\t"
						 "jmp *%0\n\t"
						 :
						 :"r"(address)
						 );	
}
/* 这是核心的函数
 * 填写变量地址表。这是程序启动时就该做的．
 * 顺便对.got.plt表做一些处理．
 */
static int register_got(int so_id){
	int i,j;
	struct elf_mmap *so;
	Elf32_Rel *rel;
	//Elf32_Sym *relsym;
	struct symbol_origin origin;

	so=  mmap_of_so[so_id];	
	if(so->var_tbl == NULL) goto ignore_got; //没有.got段，也就用不着修正
	for(j = 0; j < so->vtbl_fix_len; j++){
		rel = &so->vtbl_fix[j];
		//if(rel->r_type != R_386_GLOB_DAT) 
			//info_rel(rel, so);
		origin = apply_rel(rel, so);
		if(origin.mmap == 0) {
			spin("find symbol failed");
		}
	}
	ignore_got:	//ok, we have skiped the code above.

	if(so->func_tbl == NULL) goto ignore_got_plt;	//没有.got.plt段
	//.got.plt的前三项存放的不是函数地址	
	so->func_tbl[1] = so->id;
	so->func_tbl[2] = (unsigned)_dl_runtime_resolve;

	/*.got.plt的所有表项，在最一开始，需要统一rebase */
	for(i = 3; i < so->ftbl_len; i++){
		so->func_tbl[i] += (unsigned)so->rebase;
	}
	ignore_got_plt:

	return 0;
}

/* 其实这个函数,内核的execve()也用的着，但不要想共用了，内
   核跟用户态的代码肯定不一样，不能太不讲究...我也省得费心..
 * HACKs
   1, HACKs表示不符合规范的编程行为，但通常不会出错．
   	   ---为了代码更简单．
   2, 认为pheader[0]总是LOAD类型的，且是地址最靠前的segment.
   3, 默认mmap()的区域，不会跟常规可执行文件区冲撞．
 * 为什么不顺便parse_mmap()?
   加载完一个elf,通常都要parse_mmap，但我还是想把这两个功能
   分开．
 */
static void *loadelf(int fd){
	void *ret;
	void *load_at = 0;	/*执行文件里有指定，so没有*/
	Elf32_Ehdr *eheader;
	Elf32_Phdr *pheader;
	int fsize = fdsize(fd);
	//不行，这儿还要给bss预留空间．看来还是先read一个page为好
	//先分配多一个page当bss，这儿要赶紧改
	int space = ceil_align( fsize + __4K + __4K, __4K);
	/* 如果是可执行文件，不能随便加载，要加载到指定的地址去.
	   但这一步加载是必要的，我们总得读到eheader和pheader才
	   知道下文
	 */
	int map_flags = MAP_SHARED;
	do_load:
	eheader = mmap2(load_at, space,
					PROT_READ | PROT_EXEC,
					map_flags, fd, 0);
															if((u32)eheader > ERRNO_BASE)	return 0;
	pheader = ptr_offset(eheader, eheader->e_phoff);
	//看是不是一个executable...把它送到它想去的位置
	int x,w;	/*code segment id, data segment id */
	unsigned rebase;	/*重定位基址*/
	if(eheader->e_type == ET_EXEC){
		x = 2; w = 3;	//[0]和[1]分别是PHDR和INTERP
		if((u32)eheader != pheader[x].p_vaddr){	
			load_at = (void *)pheader[x].p_vaddr;	
			//map_flags |= MAP_FIXED;
			ret = munmap(eheader, space);				
															if(ret != 0)	return 0;
			goto do_load;
		}
		rebase = 0;
	}
	else if(eheader->e_type == ET_DYN){
		x = 0; w = 1;
		rebase = (u32)eheader;
	}
	else spin("bad");
															if(pheader[x].p_type != PT_LOAD||
															   pheader[x].p_vaddr %__4K != 0) 
															spin("hack failed");

	//BSS区要专门处理,不能简单的加大mmap size
	//BSS不光要mmap,还要清0
	u32 data_start = rebase + pheader[w].p_vaddr;
	u32 data_end = data_start + pheader[w].p_filesz - 1;
	u32 bss_end = data_start + pheader[w].p_memsz - 1;

	//4K对齐之~
	data_start = floor_align(data_start, __4K);		//start page address
	data_end = floor_align(data_end, __4K);			//final page address
	bss_end = floor_align(bss_end, __4K);
	
	int code_len = data_start - (u32)eheader;
	ret = munmap((void *)data_start, space - code_len);	//代码区被勾勒出来了
															if(ret != 0) return 0;
	ret = mmap2((void *)data_start, data_end - data_start + __4K,
				PROT_READ|PROT_WRITE, 
				//MAP_PRIVATE | MAP_FIXED, 	//非常奇怪，加上MAP_FIXED参数就失败．但空间明明够用．
				MAP_PRIVATE, 
				fd, pheader[w].p_offset / __4K);
															if((u32)ret != data_start) return 0;	
	int bss_size = bss_end - data_end;	//这个变量取名不严谨
										//别忘了还有data区尾部的边角料
	if(bss_size > 0){
		u32 bss_start = data_end + __4K;	//这个变量取名也不严谨
		ret = mmap2((void *)bss_start, bss_end - data_end,
					PROT_READ | PROT_WRITE, 
					MAP_ANONYMOUS | MAP_FIXED,
					-1, 0);
															if((u32)ret != bss_start)	return 0;
		memset((void *)bss_start, 0, bss_size );
	}

	return eheader;
}

/* 加载很多so，链接器必然要接手管理虚存空间．
	我们用最简单的管理方式，每次都为一个共享对象mmap filesize+4K的空间．
	(4K是考虑到双重映射)
	这样总是够用．等于不用管理．
 * @return 	0 if failed
 */
struct elf_mmap *loadso(char *name){
	bool ok;
	struct elf_mmap *mmap;
	Elf32_Ehdr *eheader;

	/*step1: do loader job*/
	int fd = open(name, 0, 0);
															if(fd > ERRNO_BASE) return 0;
	eheader = loadelf(fd);
															if(eheader == 0) return 0;
	/*step2: parse elf*/
	mmap  = malloc(sizeof(struct elf_mmap));
	memset(mmap, 0, sizeof(struct elf_mmap));
	ok = parse_elf_mmap(eheader, mmap, fd);					
															if(!ok) return 0;
	mmap->filename = name;	/*会指到dynstr段里*/
	return mmap;	
}
/* @return 
 *  if find one loaded already into mmap_of_so[], return the array index.
    otherwise, try load it.  return a structure pointer on success.
    return 0 on failed.
 *  解决一个tag needed,　一个so往往有多个tag needed.
 * BUG 如果返回的shndx为0呢？
 */
static struct elf_mmap *resolve_needed(char *filename){
	for(int i = 0; i <= right; i++){
		struct elf_mmap *so = mmap_of_so[i];
		if(strcmp(so->filename, filename) == 0){			if(i == 0) spin("you rely on ld.so ?");
			return (void *)i;
		}
	}
	struct elf_mmap *mmap = loadso(filename);
															if(!mmap) return 0;
	mmap_of_so[++right] = mmap;
	mmap->id = right;
	return mmap;
}

/* 解决一个elf对象所有的"直接依赖"*/
static bool resolve_dependence(struct elf_mmap *mmap){
	Elf32_Dyn *dyn;
	struct elf_mmap *new;
	for(dyn = mmap->dynamic; dyn->d_tag != DT_NULL; dyn++){
		if(dyn->d_tag != DT_NEEDED) continue;
		char *soname = mmap->dynstr + dyn->d_val;
															if(strcmp(soname, "libc.so.6") == 0) 
																continue;
		new = resolve_needed(soname);
															if(!new) return false;
	}
	return true;	
}

/* 解决一个elf对象的所有＂直接和间接依赖＂．递归．
 */
static bool  resolve_dependenceR(void){
	bool ok;
	//随着循环，right也会右移
	for(int i = 0; i <= right; i++){
		struct elf_mmap *so = mmap_of_so[i];
		ok = resolve_dependence(so);	
															if(!ok) return false;
	}
	return true;
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
	bool ok;
	Elf32_Ehdr *eheader = 0; 
	u32 starter_phdr;
	Elf32_Ehdr *exec_ehdr;
	u32 starter_entry = 0;

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
				starter_entry = aux->a_val;
			case AT_PHDR:
				starter_phdr = aux->a_val;
			default:
				break;
		}
		aux++;
	}

	int ldfd = open("./ld.so", 0, 0);
															if(ldfd > ERRNO_BASE) 
																spin("open ld.so failed");
	ok = parse_elf_mmap(eheader, &ldmmap, ldfd);
															if(!ok) spin("pase mmap of ld.so failed");	
	ldmmap.id = 0;
	ldmmap.filename = "ld.so";
	mmap_of_so[0] = &ldmmap;
	register_got(0);
	init_heap();		//尽快初始化heap,之后才可以loadso

	//ld.so自举完成，赶紧加载主程序(if needed)
	//用户是不是直接敲命令运行我了？那太荣幸了...
	int me_starter = starter_entry == LD_BASE + eheader->e_entry
						? 1 : false;
	char *exec_path = argv[me_starter];
	int execfd = open(exec_path, 0, 0);						if(execfd > ERRNO_BASE) spin("open exec failed"); 
	if(me_starter){
		print("I am the program itself !\n");
		exec_ehdr = loadelf(execfd);						if(!exec_ehdr)	spin("load exec failed");
	}
	else{
		print("I am ld, invoked by kernel..\n");
		//print("program entry:%x\n", exec_entry);
		exec_ehdr = (void *)floor_align(starter_phdr, __4K);
	}
	struct elf_mmap *exec_mmap = malloc(sizeof(struct elf_mmap));	if(!exec_mmap)	spin("bad");
	ok = parse_elf_mmap(exec_ehdr, exec_mmap, execfd);			if(!ok) spin("parse exec mmap failed");
	exec_mmap->id = 1;
	exec_mmap->filename = exec_path;	
	mmap_of_so[++right] = exec_mmap;						if(right != 1) spin("exec should be at slot 1");

	ok = resolve_dependenceR();
															if(!ok) spin("resolve dependenceR failed");
	for(int i = 1; i <= right; i++){
		register_got(i);
	}
	__asm__ __volatile__(
						"mov %%ebp, %%esp\n\t"
						"pop %%ebp\n\t"
						"jmp *%0\n\t"
						:
						: "r"(exec_mmap->eheader->e_entry)
						);
	spin("you should see me");
}
