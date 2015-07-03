#define I_AM_PDB
#include"pdb_bochs_connect.h"

#include<stdio.h>
#include"stab.h"
#include"stringparser.h"
#include"fooheap.h"
#include"twiceheap.h"
#include"force.h"
#include"dbgout.h"
#include"string.h"
#include"kernel/t.h"
#include"looparr.h"
/**when pdb judge the cmd as matched format but 
 * meet error on parsing, return 1 ot bochs but
 * throw a error message before new prompt
 */
#define end_say(i, ...) do{\
	dbgout(5, __VA_ARGS__);\
	reti = i;\
	goto ret;\
}while(0)

unsigned lookup_sym(char *sstring, char sdesc);
fileobj_t *get_fobj(char *fname);
void print_varobj(varobj_t *obj);
void print_type(char *name);
static void pdb_init(void);
#define DONE  1
static bool pdb_not_inited = true;
static looparr_t larr;
static char g_databuf[1024] = {1,2,3,4,5,6,7,8};
int try_parse_cmd(char *cmd){
	if(pdb_not_inited){
		pdb_not_inited = false;
		stab_init();	
		pdb_init();
	} 
	mainp::reinit(cmd);
	force(*(cmd + strlen(cmd) - 1) == '\n');
	*(cmd + strlen(cmd) - 1) = 0;
	int reti;
	/**support '$ variable' in command*/
	while(mainp::f('$')){
		mainp::del(1);
		mainp::mark();
		int i = mainp::eatint();
		if(i<0 || i>99) end_say(DONE, "bad $var");
		char hexstr[12];
		mainp.current--;
		mainp::v();
		mainp::back();
		mainp::d();
		sprintf(hexstr, "%#x", larr.l[i]);
		mainp::i(hexstr);
		dbgout(7, "now cmd:%s\n", cmd);
		mainp.current = mainp.string;
	}
	/**support '>' specifier:-3G to make a paddr*/
	while(mainp::f('>')){
		mainp::v();
		char *pt = mainp.current;
		while((pt[-1] >= '0' && pt[-1] <= '9') || (pt[-1] >='a' && pt[-1] <= 'f')) pt--;
		force(pt[-1] =='x' && pt[-2] == '0');
		pt-=2;
		unsigned addr;
		if(sscanf(pt, "%x", &addr) !=1 ) end_say(1, "bad hex foramt before '>'");
		if((addr>>30) != 3) end_say(1, "address preceding '>' smaller than 3G");
		addr&= 0x3fffffff;
		char hex[12];
		sprintf(hex, "%#x", addr);
		mainp.current = pt;
		mainp::d();
		mainp::i(hex);
		mainp.current = mainp.string;
	}
	/**pdb captures any command as it likes, and 
	 * lets bochs parse-path continue or end
	 * as it likes
	 */
if(mainp::strncmp("p ") == 0){
	mainp::w();
	char *content = mainp.current;
	if(mainp.current[0] == ' ') end_say(DONE, "?");
	else if(mainp.current[0] == '*'){
		mainp.current++;
		if(mainp.current[0] != '(') \
			end_say(DONE, "'(' expected");
		mainp.current++;
		/**we must find the exact symbol start*/
		if(mainp::strncmp("struct") == 0)\
			mainp::w();
		else if(mainp::strncmp("union") == 0)\
			mainp::w();
		else;
		mainp::jmp_charset(1, (unsigned)CSREG_SPACE);
		dbgout(7, "jmp space already:%s\n", mainp.current);
		mainp::mark();
		if(!mainp::f('*'))\
			end_say(DONE, "'*' expected");
		while(mainp.current[-1] == ' ') mainp.current--;
		mainp.current[0] = 0;
		dbgout(7, "typename:%s\n", mainp.marker);
		if(!mainp::f(')'))\
			end_say(DONE, "')' expected");
		mainp.current++;
		int addr;
		int err =sscanf(mainp.current, "%x", &addr);
		if(err != 1) end_say(DONE, "invalid addr format");
		typenumber_t tn = {lookup_sym\
				(mainp.marker, 't')};
		if(!tn.value) end_say(DONE, "unknow type symbol");
		varobj_t vobj;
		vobj.name = "assume";
		vobj.typenumber = tn;
		vobj.desc = 'G';
		vobj.addr = addr;
		print_varobj(&vobj);
	}
	else if(mainp::f('[')){
		mainp.current++;
		int i = mainp::eatint();
		force(mainp.current[0]== ']');
		mainp::percent();
		mainp.current[0] = 0;
		varobj_t *vobj = (varobj_t *)lookup_sym(content, 'v');
		if(!vobj) end_say(1, "unknown pointer '%s'", content);
		typeobj_t *tobj = get_typeobj(vobj->typenumber);
		unsigned point_to;
		if(tobj->desc == 'a'){
			point_to = vobj->addr;
		}
		else if(tobj->desc == '*'){
			/**we have to derefer the pointer*/
			unsigned here_store_the_pointer = vobj->addr<<2>>2;
			read_paddr(0, here_store_the_pointer, 4, &point_to);
		}
		else end_say(1, "sym '%s' not a pointer", content);
#ifdef TESTMOD
		point_to = (unsigned)g_databuf;
#endif
		typenumber_t refer_tn = tobj->refer_tn;
		int size = get_typesize(refer_tn);
		point_to += i*size;
		dbgout(7, "i:%d size:%d ponit_to:%x",i,size,point_to);
		varobj_t vobj0;
		vobj0.name = "refer";
		vobj0.desc = 'G';
		vobj0.typenumber = refer_tn;
		vobj0.addr = point_to;
		print_varobj(&vobj0);
	}
	else{
		varobj_t *vobj = (varobj_t *)(lookup_sym\
				(mainp.current, 0));
		if(!vobj) end_say(DONE, "unknown symbol");
		print_varobj(vobj);
	}
	reti = 1;
}	
else if(strcmp(cmd, "ptn") == 0){
	int fid,hid,tid;
	scanf("%d %d %d",&fid, &hid, &tid);
	typenumber_t t;
	t.fileid = fid;
	t.header_id = hid;
	t._typeid = tid;
	t.lowest_bit = 1;
	print_typeobj(t);

	reti = 1;
}
else if(strcmp(cmd, "pt") == 0){
	char name[64];
	scanf("%s",name);
	print_type(name);

	reti = 1;
}
else if(mainp::strncmp("trace") == 0){
	mainp::w();
	unsigned addr;
	int err = sscanf(mainp.current, "%x", &addr);
	if(err != 1) end_say(DONE, "invalid address");
	if(locate_line(addr)){
		char *fname = ll_result.fobj->header_name[0];
		dbgout(5, "<%s> %d\n", fname, ll_result.line);
		char cmd[128];
		sprintf(cmd, "pdb-display-source %s %d", fname, ll_result.line);
		system(cmd);
	}
	else dbgout(5, "can not locate address %x", addr);
	reti = 1;
}
else{
	reti = 0;
}
ret:;
	char *eof = cmd + strlen(cmd);
	*eof = '\n';
	eof[1] = 0;
	if(reti == 1) dbgout(5, "\n");
	return reti;
}

void print_type(char *name){
	for( g_currfile = 0; g_currfile < g_filenum; g_currfile++){
		typenumber_t tn;
		if((tn.value = (unsigned)curr_fileobj.tsym_hash::search_elem(name))){
				print_typeobj(tn);
				return;
		}
	}
	dbgout(7, "symbol '%s' not found\n", name);
}


void print_varobj(varobj_t *obj){
	int size;
	if(!obj) return;
	larr::set(obj->addr);
	int vari= larr.i;
	switch(obj->desc){
		case 'f':
		case 'F':
/*			read_paddr(0, obj->addr, 4, g_databuf);*/
			dbgout(5, " $%d=@%#x ", vari, obj->addr);
			dbgout(5, " %s(){}", obj->name);
			break;
		case 'G':
		case 'S':	
/*			print_typeobj(obj->typenumber);*/
			size = get_typesize(obj->typenumber);
			dbgout(7, "size:%d\n", size);
			read_paddr(0, obj->addr<<2>>2, size, g_databuf);
			g_addr = (unsigned)g_databuf;
			printf_mem(obj->typenumber, 0);
			dbgout(5, " $%d=@%#x ", vari, obj->addr);
			dbgout(5, " %s  ", obj->name);
			break;
		default:
			force(0);
	}
}

/**give me a symbol, i will search in the following
 * hash-table in turn(if you don't specify one):
 * tsym_hash, gvar_hash, gfunc_hash, svar_hash,
 * sfunc_hash,and return you symbol's information.
 * @arg	<sstring>	symbol string
 * <sdesc>	specify the symbol's type. 't' for type
 * -symbol, 'v' for 'variable-symbol', 'f' for 
 *  'function-symbol'. if you don't know it, leave 0
 * @return
 * !0	a typenumber or 'varobj_t *' pointer
 * 0	lookup failed
 * @NOTE sstring will be destroyed
 */
unsigned lookup_sym(char *sstring, char sdesc){
	/**the symbol has file scope or global scope.
	 * in the former case, 'sstring' comes with a
	 * file-name-prefix like xxx:symbol
	 */
	fileobj_t  *fobj = 0;
	char *sym = sstring;
	while(*sym != 0){
		if(*sym == ':'){
			*sym = 0;
			/**check the validation of file name*/
			fobj = get_fobj(sstring);
			if(!fobj) return 0;
			sym = sym + 1;	/**the real symbol start*/
			break;
		}
		sym++;
	}
	if(!fobj) sym =sstring;
/*	dbgout(7, "fobj:%s sym:%s\n", fobj, sym);*/
	if(sdesc == 't'){
		typenumber_t tn;
		for(int i = 0; i < g_filenum; i++){
			tn.value = (unsigned)fileobjs[i].tsym_hash::search_elem(sstring);
			if(tn.value) return tn.value;
		}
	}

	 if(!sdesc || sdesc == 'v'){
/*		 dbgout(7, "enter v\n");*/
		varobj_t *vobj = 0;
		if(fobj)\
			vobj = fobj->svar_hash::search(sym);
		else vobj = gvar_hash::search(sym);
		
		if(vobj) return (unsigned)vobj;
	}
	
	 if(!sdesc || sdesc == 'f'){
/*		 dbgout(7, "enter f\n");*/
		varobj_t *vobj = 0;
		if(fobj)\
			vobj = fobj->sfunc_hash::search(sym);
		else vobj = gfunc_hash::search(sym);
		if(vobj) return (unsigned)vobj;
	 }
	return 0;
}

fileobj_t *get_fobj(char *fname){
	for(int i = 0; i < g_filenum; i++){
		if(strcmp(fileobjs[i].header_name[0], fname) == 0) return fileobjs+i;	
	}
	return 0;
}

#ifdef TESTMOD
int main(void){
	char cmd[128];
	while(1){
		scanf("%[^\n]", cmd);
		getchar();
		char *eof = cmd + strlen(cmd);
		*eof = '\n';
		eof[1] = 0;

		if(!try_parse_cmd(cmd)){
			dbgout(5, "submit to bochs..\n");
		}
	}
	return 0;
}
#endif

void pdb_init(void){
	looparr_init(&larr, 5);

}

#ifdef TESTMOD
void read_paddr(int cpu, unsigned addr, unsigned len, void *data){

}
#endif




