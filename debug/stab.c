int gdb_break = 0;
void check_gvar_hash(void);
unsigned makecell(char *strubase, int bit_off, int bit_count);
void *format_out_value(void *addr, int _typeid);
void scan_symtab(void);
#include"stdio.h"
#include"elf.h"
#include"stab.h"
#include"stringparser.h"
#include"force.h"
#include"fooheap.h"
#include"dbgout.h"
#include"bufelf.h"
#include"twiceheap.h"

/**used by function 'printf_mem'. it seems that
 * global variable can simplify the recursive 
 * complexity to a certain greed
 */
unsigned g_addr;
static int g_bitoff = 0;
static int g_bitsize = 0;

static char *g_drifting_tsym = 0;
#define stab_getstr(s) ((s).n_strx ? g_stabstr + (s).n_strx : "null")
#define alloc_tnline(header, header_tnum) do{\
	int bytesize=header_tnum*sizeof(typenumber_t);\
	typenumber_t * l=curr_fileobj.tn_map[header] = \
	gheap::alloc(bytesize);\
	memset((void *)l, 0, bytesize);\
}while(0)
#define KERNEL_PATH "/home/wws/lab/papaya/bin/g_kernel.elf"
struct locate_line_result ll_result;
fooheap_t gheap;
twiceheap_t twheap;
strparser_t mainp;
fileobj_t *fileobjs;
int g_currfile = -1;
int gvar_limit = 0;	stringhash_t gvar_hash;
int g_filenum;
int gfunc_limit = 0;	stringhash_t gfunc_hash;

void stab_init(void){
	fooheap_init(&gheap, 0x100000);
	twiceheap_init(&twheap, 0x100000);
	stringparser_init(&mainp, "prepared");
	bufelf(KERNEL_PATH);
	printf("stabndx:%d, symtabndx:%d, stabnum:%d, symnum:%d\n",g_stabndx, g_symtabndx, g_stabnum, g_symnum);
/*	dbgout(7,"%12s%4s%8s\n", "name", "type", "value");*/
	extract_stabs_prescan();
	force(g_filenum);
	extract_stabs();
	scan_symtab();
	check_gvar_hash();
}


/**do the main job of extracting .stab section*/
void extract_stabs(void){
	/**variables used for  basic loop frame:
	 * 1, g_currfile curr_header are two key vars,
	 * they indicate the filescope that the current
	 * stab belongs to, thus, we can extract it to
	 * the corresponding fileobj in a right way.
	 * 2, 'infile' 'header_count' are two vars that 
	 * help maintain the key var below.
	 */
	int curr_header;
	int header_count;
	int curr_func;
	bool infile = false;
	stack_t hid_stk;	/**header id stack*/
	stack_init(&hid_stk);
	/**-----loop frame above------*/
	for(int i = 0; i < g_stabnum; i++){
		NLIST *s = gstabs + i;
		char *sstr = stab_getstr(*s);
		mainp::reinit(sstr);			

		if(!infile && s->n_type != N_SO) continue;
if(s->n_type == N_SO){
	infile = !infile;
	if(infile){	/**enter a file*/
		/**let 'g_currfile' incres by 1 evey time we
		 * enter a new file, that's all we need do
		 * to matain 'g_currfile'.
		 */
		g_currfile++;
		curr_header = 0;
		/**we regard .c source file as header<0>
		 * so the 'header_count' start from 1
		 */
		header_count = 1;
		curr_func = -1;
		/**-----loop frame above-------*/

		dbgout(7, "enter %d:%s\n", g_currfile, sstr);		
		curr_fileobj.saddr = s->n_value;
		for(int h = 0; h < curr_fileobj.header_num; h++){
		curr_fileobj.tn_map[h] = malloc\
								(HTYPE_MAX * 4);
		}
		char *fname = curr_fileobj.header_name[0] = gheap::allocstr(sstr);
		force(fname);
		if(g_currfile == 9){
			while(gdb_break);
		}
	}
	else{	/**leave a file*/
		/**do some safety check to ensure the
		 * extration is under right state
		 */
		force(s->n_strx == 0);
		force(curr_header == 0);
		force(hid_stk.esp == -1);	
		/**-----loop frame above-----*/

		dbgout(7, "leaving..\n");
		curr_fileobj.eaddr = s->n_value;
		for(int h = 0; h < curr_fileobj.header_num; h++){
		if((int)curr_fileobj.tn_map[h] & 1) continue;
		if(curr_fileobj.tnum_of_header[h] == 0){
			free(curr_fileobj.tn_map[h]);
			curr_fileobj.tn_map[h] = 0;
		}
		else{
			/**because the typenumber always starts
			 * from 1, so the real type count of a
			 * header is ...
			 */
			int real_tnum = curr_fileobj.tnum_of_header[h] + 1;
			force(real_tnum < HTYPE_MAX);
			force(curr_fileobj.tn_map[h] == realloc(curr_fileobj.tn_map[h], real_tnum * 4));
		}
		}
		
	}
}
else if(s->n_type == N_LCSYM || s->n_type == N_STSYM){
	varobj_t *obj = extract_varobj(&mainp);
	obj->addr = s->n_value;
	force(curr_fileobj.svar_hash::add_elem(obj->name, (void *)obj));
}
else if(s->n_type == N_FUN){
		curr_func++;
		curr_fileobj.func_info[curr_func * 2] =\
										s->n_value;
		curr_fileobj.func_info[curr_func * 2 + 1] =\
												i;
		varobj_t *obj = extract_varobj(&mainp);
		obj->addr = s->n_value;
		dbgout(7, "hash add func-symbol:%s",obj->name);
		if(obj->desc == 'F') force(gfunc_hash::add_elem(obj->name, (void *)obj));
		else if(obj->desc =='f') force(curr_fileobj.sfunc_hash::add_elem(obj->name, (void *)obj));
		else force(0);
}
else if(s->n_type  == N_GSYM){
	varobj_t *obj = extract_varobj(&mainp);
	if(!gvar_hash::add_elem(obj->name, (void *)obj)){
		dbgout(6, "hash meet a repeatedly global symble:%s\n", obj->name);
	}
	else dbgout(6, "gvar_hash suncessfully adds a symbol:%s\n", obj->name);
}

else if(s->n_type == N_PSYM || s->n_type == N_LSYM){
	if(s->n_value){		/**a local variable*/
		/**bug here, this branch is designed
		 * only N_LSYM, so, N_FUN and N_PSYM
		 * should be processed seperately
		 * in future
		 */
		varobj_t *obj= extract_varobj(&mainp);
		obj->addr = s->n_value;
		/**we produce this obj but won't use it for
		 * temporaly. and we need the code above,
		 * because 'extract_varobj' may register
		 * typenumber on tn_map
		 */
	}
	else{	/**type symbols*/
		char *sym = cp_sym_to_heap(&mainp);
		/**we set g_drifting_tsym point to the fresh
		 * type symbole, 'create_typeobj' will link
		 * obj->name to this symbol and reset 
		 * g_drifting_sym. In this way, typeobj who
		 * should own a name got it's name
		 */
		g_drifting_tsym = sym;
		mainp.current++;
		force(mainp.current[0] == 't' || mainp.current[0] == 'T');
		mainp.current++;
		typenumber_t newtn = parse_type(&mainp);
		g_drifting_tsym = 0;
		force(curr_fileobj.tsym_hash::add_elem(sym, (void *)newtn.value));
	}
}
else if(s->n_type == N_BINCL){
	hid_stk::push(curr_header);
	/**'header_count' larger than 'curr_header' by
	 * 1 forever, this is not strange, as is array
	 * [len - 1] indicates the last cell forever
	 */
	curr_header = header_count++;
	/**loop frame above*/
	dbgout(7, "enter h%d:%s\n", curr_header, sstr);
	char*hname = curr_fileobj.header_name[curr_header] = gheap::allocstr(sstr);
	force(hname);
	force(curr_fileobj.hname_hash::add_elem(hname, (void *)curr_header));
}
else if(s->n_type == N_EINCL){
	dbgout(7, "leave for h%d\n", curr_header);

	/**loop frame following*/
	force(curr_fileobj.tnum_of_header[curr_header] == curr_fileobj.tmax_of_header[curr_header]);
	curr_header = hid_stk::pop();
}
else if(s->n_type == N_EXCL){
	/**'header_count' indicates the header_id of
	 * current EXCL-type header
	 */
	force(!curr_fileobj.tnum_of_header[header_count] && !curr_fileobj.tmax_of_header[header_count]);
	free(curr_fileobj.tn_map[header_count]);
	char *hname =gheap::allocstr(sstr);
	force(hname);
	force(curr_fileobj.hname_hash::add_elem(hname, (void *)header_count));
	curr_fileobj.tn_map[header_count] = (typenumber_t *)get_excl_refer(sstr, g_currfile);

	/**loop frame following*/
	header_count++;
}
else;
}
	dbgout(7, "extract done..\n");
}
/**we can't realize the extraction within one scan-
 * ning, so, we do a prescan before scanning. this 
 * function had been able to do more jobs, but it
 * didn't,it just prepared the most basic enviroment
 * without which the 'extract_stabs' can not run.
 * ???prepare what???
 * ---to int the following important variables.
 * gvar_limit		>>>		gvar_hash
 * g_filenum		>>>		fileobjs[]
 * fileobj->header_num		>>>		tnum_of_header[]
 * 							>>>		header_name[]
 * 							>>>		hname_hash
 * fileobj->svar_num		>>>		svar_hash
 * fileobj->tsym_num		>>>		tsym_hash
 */
void extract_stabs_prescan(void){
	fileobjs = twheap::alloc(sizeof(fileobj_t) *\
									FILE_MAX);
	force(fileobjs);
	bool infile = false;
	for(int i = 0; i < g_stabnum; i++){
		NLIST *s = gstabs + i;
		if(!infile && s->n_type != N_SO) continue;
		switch(s->n_type){
	case N_SO:
		infile = !infile;
		if(infile){
			g_currfile++;
			curr_fileobj.header_num = 1;
			curr_fileobj.svar_num = \
			curr_fileobj.sfunc_num = \
			curr_fileobj.func_num = \
			curr_fileobj.tsym_num = 0;
		}
		break;
	case N_BINCL:
	case N_EXCL:
		curr_fileobj.header_num++;
		break;
	case N_LCSYM:
	case N_STSYM:
		curr_fileobj.svar_num++;
		break;
	case N_GSYM:
		gvar_limit++;
		break;
	case N_LSYM:
		if(s->n_value != 0) break;	/**local var*/
		curr_fileobj.tsym_num++;
		break;
	case N_FUN:;
		curr_fileobj.func_num++;
		char *pt = stab_getstr(*s);
		while(*pt != ':'){
			force(*pt != 0);
			pt++;
		} 
		if(pt[1] == 'f') curr_fileobj.sfunc_num++;
		else if(pt[1] == 'F') gfunc_limit++;
		else force(0);
		break;
	}
	}
	g_filenum = g_currfile + 1;
	force( fileobjs == twheap::identify(g_filenum));
	/**basic variables 'svar_num', 'tsym_num',
	 * 'header_num', 'gvar_limit' got, now we use
	 * them to initialize further data structure
	 */

	/** '+1' to avoid initialization failure*/
	stringhash_init(&gvar_hash, gvar_limit + 1);
	stringhash_init(&gfunc_hash, gfunc_limit + 1);
	/**g_currfile = 0; already done implicitly*/
	while(g_currfile >= 0){
		int hnum = curr_fileobj.header_num;
		curr_fileobj.header_name = gheap::alloc(hnum * 4);
		curr_fileobj.tnum_of_header = gheap::alloc(hnum * 4);
		curr_fileobj.tmax_of_header = gheap::alloc(hnum * 4);
		curr_fileobj.tn_map = gheap::alloc(hnum * 4);
		curr_fileobj.func_info = gheap::alloc(curr_fileobj.func_num * 2 * 4);
		memset(curr_fileobj.header_name, 0, hnum * 4);
		memset(curr_fileobj.tnum_of_header, 0, hnum * 4);
		memset(curr_fileobj.tmax_of_header, 0, hnum * 4);
		memset(curr_fileobj.tn_map, 0, hnum * 4);
		stringhash_init(&curr_fileobj.hname_hash,\
						curr_fileobj.header_num+1);
		stringhash_init(&curr_fileobj.svar_hash,\
						curr_fileobj.svar_num + 1);
		stringhash_init(&curr_fileobj.tsym_hash,\
						curr_fileobj.tsym_num + 1);
		stringhash_init(&curr_fileobj.sfunc_hash,\
						curr_fileobj.sfunc_num + 1);
		dbgout(7, "file:%d hnum:%d svar_num:%d tsym_num:%d\n sfunc_num:%d", g_currfile, curr_fileobj.header_num, curr_fileobj.svar_num, curr_fileobj.tsym_num, curr_fileobj.sfunc_num);
		g_currfile--;
	}
	dbgout(7, "gvar_limit:%d gfunc_limit:%d\n", gvar_limit, gfunc_limit);
	/**recover global variable for 'extract_stabs'*/
	/**g_currfile = -1;  already done implicitly*/
}


void print_sym(Elf32_Sym *sym, char *strtab){
	dbgout(7, "%12s%8x%4d%4d\n", &strtab[sym->st_name], sym->st_value, sym->st_info>>4, sym->st_info&0xf);
}

void print_stab(NLIST *stab, char *stabstr){
	dbgout(7, "%12s%4d%8x\n", stabstr + stab->n_strx, stab->n_type, stab->n_value);
}
void print_tn(typenumber_t tn){
	if(tn.lowest_bit) dbgout(7, "<%d %d %d> ", tn.fileid, tn.header_id, tn._typeid);
	else printf("%8x ", tn.ptmod);
}
/**this function may let parser meet '\0'*/
typenumber_t read_pairs(strparser_t *parser,\
		int currfile){
	force(parser->current[0] == '(');			
	parser->current++;
	typenumber_t x;
	x.lowest_bit = 1;
	x.header_id = parser=>eatint();
	force(parser->current[0] == ',');
	parser->current++;
	x._typeid = parser=>eatint();
	x.fileid = currfile;
	parser->current++;
	return x;
}

typeobj_t *create_typeobj(char typedesc){
	if(typedesc == '(') return 0;
	typeobj_t *typeobj = gheap::alloc(sizeof(typeobj_t));
	typeobj->name= 0;
	if(g_drifting_tsym) typeobj->name = g_drifting_tsym;
	g_drifting_tsym = 0;
	switch(typedesc){
		case 'r':
			typeobj->rbind = gheap::alloc(\
					sizeof(struct rbind));			
			break;
		case 'a':
			typeobj->abind = gheap::alloc(\
					sizeof(struct abind));
			break;
		case 's':
		case 'e':
		case 'u':
		case '*':
			/*we assign 0 to a casual union member*/
			typeobj->sbind = 0;
			break;
		default:
			force(0);
	}
	return typeobj;
}
/**1, 'parse_type()' parse a new-type-definition
 * string whose format is '(a,b)=(c,d)' or '(a,b)=
 * r(c,d);-128,127;'. it use (a,b) to locate a
 * corresponding typenumber-cell in tn_map, and fill
 * it out with the return value of analysis of part
 * following '='.
 * 2, what is a new-type-definition?
 * it's specified by '=', so parse_type() is
 * triggered by '='.
 * 3,because '=' can not nested, so this function is
 * recursive.
 */
typenumber_t parse_type(strparser_t *parser){
/*	printf("got parser pointer:%x\n", (unsigned)parser);*/
	typenumber_t new_tn = read_pairs(parser, \
								g_currfile);
	if(parser->current[0] != '=') return new_tn;
	/**we meet a new typenumber, try to update the
	 * corresponding tnum_of_header, tmax_of_header
	 */
	int hid = new_tn.header_id;
	int fid= new_tn.fileid;
	fileobjs[fid].tnum_of_header[hid]++;
	int *tmax = &fileobjs[fid].tmax_of_header[hid];
	if(*tmax < new_tn._typeid) *tmax = new_tn._typeid;

	parser->current++;
	typenumber_t cell_value;
	/*avoid crosses initialization error*/
	char typedesc; typeobj_t *typeobj;
	if(parser->current[0] == '(') {
		cell_value = parse_type(parser);
		goto got_type_description;
	}

	typedesc = parser->current[0];
	typeobj = create_typeobj(typedesc);
	typeobj->typenumber = new_tn;
	typeobj->desc = typedesc;
	parser->current++;
	if(typedesc == '*'){
		typeobj->refer_tn = parse_type(parser);
	}
	else if(typedesc == 'r'){
		typeobj->refer_tn = parse_type(parser);
		force(parser->current[0] == ';');
		parser->current++;
		typeobj->rbind->lower_bound = parser=>eatint();	
		force(parser->current[0] == ';');
		parser->current++;
		typeobj->rbind->higher_bound = parser=>eatint();
		force(parser->current[0] == ';');
		parser->current++;
	}
	else if(typedesc == 'a'){
		force(parser->current[0] == 'r');
		struct abind *bind = typeobj->abind;
		parser->current++;
		bind->index_tn = parse_type(parser);
		force(parser->current[0] == ';');
		parser->current++;
		bind->lower_bound = parser=>eatint();
		force(parser->current[0] == ';');
		parser->current++;
		bind->higher_bound = parser=>eatint();
		force(parser->current[0] == ';');
		parser->current++;
		bind->elem_tn = parse_type(parser);
		typeobj->refer_tn =bind->elem_tn;
	}
	else if(typedesc == 's' || typedesc == 'u'){
		typeobj->size = parser=>eatu32();	
		dbgout(7, "strusize:%d\n", typeobj->size);
		/**now extract member information*/
		struct subind **pbind = &typeobj->sbind;
		while(parser->current[0] != ';'){
			*pbind = gheap::alloc(sizeof(struct subind));
			parser=>mark();
			parser->current--;	/**current[0] may ':'*/	
			parser=>f(':');
			(*pbind)->name = gheap::allocstrn(\
				parser->old_location,\
				parser->current - parser->old_location);				parser->current++;
			dbgout(7, "member name:%s ", (*pbind)->name);
			(*pbind)->typenumber=parse_type(parser);
			print_tn((*pbind)->typenumber);
			force(parser->current[0] == ',');
			parser->current++;
			(*pbind)->bit_off = parser=>eatu32();
			dbgout(7, "off:%d ",(*pbind)->bit_off);
			force(parser->current[0] == ',');
			parser->current++;
			(*pbind)->bit_size = parser=>eatu32();
			dbgout(7, "size:%d\n",(*pbind)->bit_size);
			force(parser->current[0] == ';');
			parser->current++;
			pbind = &(*pbind)->next;
		}
		*pbind = 0; /**no more member*/
		parser->current++;	/**skip ';'*/
	}
	else if(typedesc == 'e'){
		struct ebind **pbind = &typeobj->ebind;
		while(parser->current[0] != ';'){
		(*pbind) = gheap::alloc(\
				sizeof(struct ebind));
		parser=>mark();
		parser=>f(':');
		(*pbind)->name = gheap::allocstrn(\
				parser->old_location,\
				parser->current - parser->old_location);
		parser->current++;
		(*pbind)->value = parser=>eatint();
		force(parser->current[0] == ',');
		parser->current++;
		pbind = &(*pbind)->next;
		}
		*pbind = 0; /**no more member*/
		parser->current++;	/**skip ';'*/
	}
	else{
		force(0);	
	}
	cell_value.ptmod = typeobj;
	/**type_description is namely 'cell_value'. it's
	 * either a typeobj reference or just refers
	 * to another cell in tn_map.
	 * Since type description got, we send it to
	 * corresponding cell in tn_map
	 */
got_type_description:
	dbgout(7, "fill cell:%d %d %d  with", g_currfile, new_tn.header_id, new_tn._typeid);
	print_tn(cell_value);
	dbgout(7, "\n");
	fileobjs[g_currfile].tn_map[new_tn.header_id]\
		[new_tn._typeid] = cell_value;
	/**register typenumber on typeobj*/
	if(!cell_value.lowest_bit) (*cell_value.ptmod).typenumber = new_tn;
	return new_tn;
}

/**parser move to ':'*/
char *cp_sym_to_heap(strparser_t *parser){
	parser=>mark();
	force(parser=>f(':'));
	int len = parser->current - parser->old_location;
	force(len < NAME_MAX);
	char *pt = gheap::allocstrn(parser->old_location, len);
	force(pt);
	return pt;

}

varobj_t *extract_varobj(strparser_t *parser){
	varobj_t *obj = gheap::alloc(sizeof(varobj_t));
	obj->name = cp_sym_to_heap(parser);
	obj->addr = 0;
	parser->current++;
	if(parser->current[0] == '('){
		dbgout(7, "meet local vars\n");
		obj->desc = 'l';
	}
	else{
		obj->desc = parser->current[0];
		parser->current++;
	}
	obj->typenumber = parse_type(parser);
	return obj;
}

/**get the fileid-header_id that the N_EXCL refers
 * to
 */
unsigned get_excl_refer(char *hname, int file){
	force(file && hname);
	for(int i = 0; i < file; i++){
		int hid = (int)fileobjs[i].hname_hash::search_elem(hname);
/*		dbgout(7, "excl %s refer to f:%d,h:%d\n",hname, i,hid);*/
		if (hid != 0){/**of course, source file has
                   		no chance referred by EXCL*/
			if((unsigned)fileobjs[i].tn_map[hid] & 1){
				force(fileobjs[i].tnum_of_header[hid] == 0);
				continue;
			}
			typenumber_t x;
			x.lowest_bit = 1;
			x.header_id = hid;
			x.fileid = i;
			x._typeid = 0;
			return x.value;
		};	
			
	}
	force(0);
}

/**give me a typenumber, i will return you the final
 * typeobj it refers to. generally, return value is
 * a pointer(lowest_bit=1). function returns a type-
 * number(lowest_bit=0) when meeting a self-refered 
 * typenumber, but remeber, the typenumber returned
 * is sure often different from what you passed
 */
typeobj_t *get_typeobj(typenumber_t tn){
	if(tn.lowest_bit == 0) return tn.ptmod;
	fileobj_t *fobj = fileobjs + tn.fileid;
	typenumber_t *pline = fobj->tn_map[tn.header_id];
/*	dbgout(7, "receive tn\n");*/
/*	print_tn(tn);*/
	/**the typenumber may locates a EXCL line, thus,
	 * we relocate it to the origin header
	 */
	if(fobj->tnum_of_header[tn.header_id] == 0){
		/**if the map-line located is a empty line,
		 * we assert it to be a EXCL-line, without
		 * any other chance
		 */
		force(((unsigned)pline & 0xffff) == 1);
/*		dbgout(7, "locate for EXCL,relocating..\n");*/
		typenumber_t refer;
		refer.value = (unsigned)pline;
		refer._typeid = tn._typeid;
/*		dbgout(7,"relocate to ");*/
/*		print_tn(refer);*/
		return get_typeobj(refer);
	}
	force(fobj->tnum_of_header[tn.header_id] >= tn._typeid);
	typenumber_t refer = pline[tn._typeid];
	if(refer.value == tn.value){
		dbgout(7, "self-loop-def typenumber: ");
		print_tn(refer);
		return tn.ptmod;
	}
	return get_typeobj(pline[tn._typeid]);

}

void print_typeobj(typenumber_t tn){
	typeobj_t *tobj = get_typeobj(tn);
/*	dbgout(7, "get typeobj addr:%x, typenumber:", tobj);*/
/*	print_tn(tobj->typenumber);*/
/*	dbgout(7, "\n");*/
	/**print out directly when tn is self-refered*/
	if((unsigned)tobj & 1){
		dbgout(7,"void");
		return;
	}
	if(tobj->name) dbgout(7, "%s ",tobj->name);
	typeobj_t *refer_tobj =0 ;/**crosses init err*/
	switch(tobj->desc){
		case 'r':
			break;
		case 'a':
			dbgout(7, "[");
			print_bind((void *)tobj->abind, 'a');
			dbgout(7, "]");
			break;
		case 's':
		case 'u':
			dbgout(7, "%d{", tobj->size);
			print_bind((void *)tobj->sbind, 's');
			dbgout(7, "}");
			break;
		case 'e':
			dbgout(7, "{");
			print_bind((void *)tobj->ebind, 'e');
			dbgout(7, "}");
			break;
		case '*':;
			refer_tobj = get_typeobj(tobj->refer_tn);
			force(refer_tobj);
			dbgout(7, "%s *",refer_tobj->name);
			break;
		default:
			force(0);
	}
	dbgout(7, ";");
}

/**
 * @brief_mod let function works under brief mode,
 * thus, only important information will be printed
 * out. When we print a structure, this will help
 * much because we need a brief view of it's member
 * layout and value.
 */
unsigned printf_mem(typenumber_t tn, bool brief_mod){
	typeobj_t *tobj = get_typeobj(tn);
	/**can not format as 'void' type*/
	force(!((unsigned)tobj & 1));
	unsigned oldaddr = g_addr;
	
	/**.eg {int x:3; char y:8}*/
	if(g_bitoff%8 || g_bitsize % 8){
		force(tobj->desc == 'r');

		unsigned cell = makecell((char *)g_addr, g_bitoff, g_bitsize);
		printrf_mem((unsigned)&cell, tn._typeid);	

		g_bitsize = 0;
		g_bitoff = 0;
		return 0;
	}

	unsigned  boffset;	/**g_addr's byte offset when
						  function ends*/
	if(tobj->desc == 'r'){
		if(!brief_mod) dbgout(5, "(%s)", \
							tobj->name);
		boffset = printrf_mem(g_addr, tobj->typenumber._typeid);
	}
	else if(tobj->desc == '*'){
		if(!brief_mod){
			typeobj_t *o = get_typeobj(tobj->refer_tn);
			force(o);
			if(!brief_mod){
				dbgout(5, "(");
				if(o->desc == 's') \
					dbgout(5, "struct");
				else if(o->desc == 'u')\
					dbgout(5, "union");
				else;
				/** BUG can not specify a poiter
				 * to pointer*/
				dbgout(5, "%s *)", o->name);
			}
		} 
		dbgout(5, "%#x", *(unsigned *)g_addr);
		boffset = 4;
	}
	else if(tobj->desc == 'a'){
		dbgout(5, "[");
		unsigned cell_size;
		unsigned cell_num = tobj->abind->higher_bound + 1;
		for(int i =0; i < cell_num; i++){
			cell_size =\
			printf_mem(tobj->abind->elem_tn, 1);
			dbgout(5, ", ");
			if(i == 15){
				dbgout(5, "...total %d cells",\
									cell_num);
				break;
			}
		}
		boffset = cell_num * cell_size;
		dbgout(5, "]");
	}
	else if(tobj->desc == 's' || tobj->desc == 'u'){
		dbgout(5, "%c{", tobj->desc);
		struct subind *bind = tobj->sbind;
		while(bind){
			dbgout(5,"%s=",bind->name);
			if(bind->bit_size%8 || bind->bit_off%8){
				g_addr = oldaddr;
				g_bitoff = bind->bit_off;
				g_bitsize = bind->bit_size;
				printf_mem(bind->typenumber, 1);
				g_bitoff = 0;
				g_bitsize = 0;/** necessary?*/
			}
			else{
				g_addr = oldaddr + bind->bit_off/8;
/*				dbgout(7, "\naddr:%x", g_addr);*/
				printf_mem(bind->typenumber, 1);
/*				dbgout(7," %x ",*(unsigned *)g_addr);*/
/*				printrf_mem(g_addr, bind->typenumber._typeid);*/
			}
			dbgout(5, "; ");
			bind = bind->next;	
		}
		dbgout(5, "}");
		boffset = tobj->size;
	}
	else if(tobj->desc == 'e'){
		dbgout(5, "e%d", *(int*)g_addr);
		boffset = 4;
	}
	else force(0);
	g_addr = oldaddr + boffset;
	return boffset;
}

/**
 * print mmeory in 'r' format, typid ranges from
 * 1 to 17.
 * return the byte-count corresponding to '_typeid'
 * , namely 2 for 'short', 4 for 'int' ...
 */
unsigned printrf_mem(unsigned addr, int _typeid){
	force(_typeid >= 1 && _typeid <=17);
	unsigned bcount;
/*	dbgout(7, "\n info mem:%x\n", *(unsigned*)addr);*/
	switch(_typeid){
		case 1:/**int*/
		case 3:/**long int*/
		case 6:/**long long int*/
			dbgout(5, "%d", *(int *)addr);
			bcount = 4;
			break;
		case 2:
		case 10:
			dbgout(5, "%d", *(char *)addr);
			bcount = 1;
			break;
		case 11:
			dbgout(5, "%#x", *(unsigned char *)addr);
			bcount =1;
			break;
		case 7:/**long long unsigned int*/
		case 5:
		case 4:
			bcount = 4;
			dbgout(5, "%#x", *(unsigned *)addr);
			break;
		case 8:
			bcount = 2;
			dbgout(5, "%d", *(short int*)addr);
			break;
		case 9:
			bcount = 2;
			dbgout(5, "%#x", *(short unsigned*)addr);
			break;
		default:
			force(0);
	}
	return bcount;
}
void print_bind(void *bind, char desc){
	/**avoid crossed initilization error of c++*/
	struct abind *b = bind;
	struct subind *sb = bind;
			
	switch(desc){
		case 'a':
			;
			print_typeobj(b->index_tn);
			dbgout(7, "%d-%d;",b->lower_bound, b->higher_bound);
			print_typeobj(b->elem_tn);
			break;
		case 's':
		case 'u':
			;
			dbgout(7, "%s:%d,%d,", sb->name, sb->bit_off, sb->bit_size);
			print_typeobj(sb->typenumber);
			if(sb->next) print_bind(sb->next, 's');
			break;
		case 'e':
			;
			struct ebind *eb = bind;
			dbgout(7, "%s:%d,", eb->name, eb->value);
			if(eb->next) print_bind(eb->next, 'e');
			break;
	}
}

/**locate the source file and line number of an
 * assemble address
 */
bool locate_line(unsigned addr){
	if(addr < fileobjs[0].saddr || addr > fileobjs[g_filenum -1].eaddr) return false;
	int i;
	fileobj_t *fobj = 0;
	for(i = 0; i < g_filenum; i++){
		if(addr >= fileobjs[i].saddr && addr < fileobjs[i].eaddr){
			ll_result.fobj = fobj = fileobjs + i;
			break;
		}	
	}	
	force(fobj);	force(fobj->func_num);
	/**now, get the coresspoding FUN-stab by looking
	 * up fobj->fun_info
	 */
	NLIST *stab = 0;
	for(i = 0; i < fobj->func_num; i++){
		unsigned *infocell = fobj->func_info + i * 2;
		if(addr >= infocell[0] && (i == fobj->func_num -1 || addr < infocell[2])){
			/**BUG i know a flow-control line
			 * may conspond to more than one
			 * assemble blocks
			 */
			stab = gstabs + infocell[1];
			break;
		}
	}
	force(stab);
	force(stab->n_type = N_FUN && stab->n_value == fobj->func_info[i*2]);
	/**now locate line in SLINE area*/
	int offset = addr - stab->n_value;
	while(stab->n_type != N_SLINE) stab++;
	while(1){
		if(stab->n_value <= offset && (stab[1].n_type != N_SLINE || stab[1].n_value > offset)){
			ll_result.stab = stab;
			ll_result.line = stab->n_desc;
			return true;
		}
		stab++;
		force(stab->n_type == N_SLINE);
	}
}










/**
void print_typeobj_old(typenumber_t tn){
	typeobj_t *tobj = get_typeobj(tn);
	if((unsigned)tobj & 1){
		dbgout(7,"%d;",(unsigned)tobj >> 1);
		return;
	}
	dbgout(7, "%c", tobj->desc);
	switch(tobj->desc){
		case 'r':
			dbgout(7, "%d", tobj->typenumber._typeid);	
			break;
		case 'a':
			dbgout(7, "[");
			print_bind((void *)tobj->abind, 'a');
			dbgout(7, "]");
			break;
		case 's':
		case 'u':
			dbgout(7, "%d{", tobj->size);
			print_bind((void *)tobj->sbind, 's');
			dbgout(7, "}");
			break;
		case 'e':
			dbgout(7, "{");
			print_bind((void *)tobj->ebind, 'e');
			dbgout(7, "}");
			break;
		case '*':
			print_typeobj(tobj->refer_tn);
			break;
		default:
			force(0);
	}
	dbgout(7, ";");
}

 */

unsigned makecell(char *strubase, int bit_off, int bit_count){
	int char_off = bit_off/8;
	unsigned *pt = (unsigned *)(strubase + char_off);
	unsigned cell = *pt;
	int right_padden = bit_off%8;
	int left_padden = 32 - bit_count - right_padden;
	int padden = 32 -bit_count;
/*	printf("right:%d,left:%d,padden:%d\n", right_padden, left_padden, padden);*/
/*	printf("get cell:%x\n",cell);*/
	cell = (cell<<left_padden)>>padden;
/*	printf("produce cell:%x\n",cell);*/
	return cell;
}

/**scan .symtab to pick up the 'value' field of 
 * global variable and reigster it in gvar_hash.
 */
void scan_symtab(void){
	Elf32_Sym *sym = g_symtab;
	int i = 0;
	while(i < g_symnum){
		unsigned info = sym->st_info;
		char *symname = g_strtab + sym->st_name;
		if((info & 0xf) == 1 && (info>>4) == 1){
/*			dbgout(7, "find global variable:%s\n", symname);*/
			varobj_t *vobj = gvar_hash::search(symname);
			if(vobj){
				vobj->addr = sym->st_value;
/*				dbgout(7, "hash got %s\n", symname);*/
			} 		
		}
		sym++;
		i++;
	}
}


/**celled after scan_symtab.
 * we must ensure all the varible-sym that gvar_hash
 * hashed corresponds to a good varobj whose 'addr'
 * field has been initialized
 */
void check_gvar_hash(void){
	int num = gvar_hash.elems_max_nr;
	for(int i = 0; i < num; i++){
		if(gvar_hash.elems[i].key)\
			force(gvar_hash.elems[i].content);
	}
}


int get_typesize(typenumber_t tn){
	char buf[4096];
	unsigned backup = g_addr;
	global_silent = 1;
	
	g_addr = (unsigned)buf;
	int offset = printf_mem(tn, 0);
	
	global_silent = 0;
	g_addr = backup;
	return offset;
}












