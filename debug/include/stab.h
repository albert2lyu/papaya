#ifndef STAB_H
#define STAB_H
#include"stringhash.h"
#include"fooheap.h"
#include"stringparser.h"
#include"gstab.h"
#include<elf.h>

#define HEADER_MAX 255
#define FILE_MAX 255
#define NAME_MAX 64
#define TYPE_MAX 1000
/**the maxium number of type a header file may contain*/
#define HTYPE_MAX 1000


#define  mapcell(tn) (gileobj[(tn).fileid].tn_map[(tn).header_id][(tn)._typeid])
typedef union typenumber{
	unsigned value;		/**common value mode*/
	struct{
		unsigned lowest_bit:1;
		unsigned _typeid:15;
		unsigned char header_id;	/**the first header(id=0) means .c file*/
		unsigned char fileid;
	};					/**composition mode*/
	struct typeobj *ptmod;	/**pointer mode*/
}typenumber_t;

struct rbind{
	int lower_bound;
	int higher_bound;
};
struct abind{
	typenumber_t index_tn;
	int lower_bound;
	int higher_bound;
	typenumber_t elem_tn;
};
struct subind{	/**sbind and ubind has same structure*/
	char *name;
	typenumber_t typenumber;
	int bit_off;
	int bit_size;
	struct subind *next;
};
struct ebind{
	char *name;
	int value;	
	struct ebind *next;
};

typedef struct typeobj{
	char desc;		/**'r','a','*','e','u','s'...*/
	char *name;
	typenumber_t typenumber;	/**record the type-
								  number who points
								  directly to me*/
	union{
		typenumber_t refer_tn;	/**for int, char... for pt*/
		unsigned size;	/**for structure*/
	};
	union{
		struct abind *abind;
		struct rbind *rbind;
		struct subind *sbind, *ubind;
		struct ebind *ebind;
	};
}typeobj_t;

typedef struct fileobj{
	int header_num;
	typenumber_t* *tn_map;
	int *tnum_of_header;
	int *tmax_of_header;
	char* *header_name;

	unsigned saddr;		/**start address of file*/
	unsigned eaddr;		/**end address*/
	int sfunc_num;	/**static function count*/
	stringhash_t sfunc_hash;
	int func_num;	/**function count*/
	unsigned *func_info;	/**info:function address
							  and corresponding stab
							  index*/

	int fileid;
	int svar_num;
	int tsym_num;
	stringhash_t svar_hash;
	stringhash_t tsym_hash;
	stringhash_t hname_hash;
}fileobj_t;

typedef struct{
	char *name;
	char desc;
	typenumber_t typenumber;
	unsigned addr;
}varobj_t;
extern int gvar_limit,gfunc_limit;
extern fooheap_t gheap;
extern fileobj_t *fileobjs;
extern int g_currfile;
extern strparser_t mainp;
extern int g_filenum;
extern stringhash_t gvar_hash;
extern stringhash_t gfunc_hash;
extern strparser_t mainp;
extern unsigned g_addr;
#define curr_fileobj (fileobjs[g_currfile])
struct locate_line_result{
	fileobj_t *fobj;
	NLIST *stab;
	int line;
};
extern struct locate_line_result ll_result;
typenumber_t parse_type(strparser_t *parser);
typenumber_t read_pairs(strparser_t *parser,\
		int currfile);
void print_stab(NLIST *stab, char *stabstr);
void print_sym(Elf32_Sym *sym, char *strtab);
void stab_init(void);
void print_typeobj(typenumber_t tn);
void print_tn(typenumber_t tn);
void print_bind(void *bind, char desc);
typeobj_t *get_typeobj(typenumber_t tn);
varobj_t *extract_varobj(strparser_t *parser);
unsigned get_excl_refer(char *hname, int file);
char *cp_sym_to_heap(strparser_t *parser);
void extract_stabs(void);
void extract_stabs_prescan(void);
unsigned printf_mem(typenumber_t tn, bool brief_mod);
bool locate_line(unsigned addr);
unsigned printrf_mem(unsigned addr, int _typeid);
int get_typesize(typenumber_t tn);
#endif














