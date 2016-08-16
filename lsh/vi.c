#define _DEFAULT_SOURCE
//能不能让最后一个换行符合法，它之后才是文件尾，而它又不同于别的换行符，别的换行符意味着下面有新的一行开始，它却不是。
/*TODO
 * 1, Vi should handle '\0' as normal character, he should even reduce the
 * dependence of '\n' to a minium degree
 * 2, No, '\n' is necessary, otherwise, the performance of 'move' operation is
 * intolerable. An end flag is really needed.
 */
/*把这个解释器编译进lua虚拟机如何,问题还是你如何调用它*/
/*conventions:
 * @state see 'VI_SET_STATE, VI_CLEAR_STATE..' in vi.h, they operate on a local 
 * variable 'state' which is returned later. it's an array of bit flags which 
 * describes the result status of a function.
 * Note! state is not a boolean value! it's lowest bit palys as a role of 'true' or
 * 'false'. Of cource, thus, it's forward-compatible when a faile-state carry no
 * other bit-flag.
 * I don't know whether this's a good design'
 */

/*我首先要考虑(优先)普通文件的操作效率*/
/*LINUX 约定最后一行是空行，windows约定不换行*/
/*
 * 1,有lines[][], len_of_line[] 这个数组，已经能够完整，映射整个文件的每一行了。
 * 2,vim library在每个lines[]末尾添加'\n',是为了有结束标志，方便一些代码的
 * implement。用'\0'也是可以的。
 * 3,'\n'的好处是，使得lines[][]数组到文件的映射更加自然，因为这些'\n'在文件里
 * 是一一对应，存在的。
 * ４，如果按正常逻辑，最后一行是不能以'\n'结尾的，因为'\n'结尾就意味着存在新的
 * 一行。
 * 5,但是，为了编程时的方便（主要是代码的一般性），最后一行我们仍然用'\n'结尾.
 * 6,纠结的一点是：我们希望vi->curr停驻的任何位置，都对应文件的一个字符,但问题
 * 来了，如果最后一行是空行，只要vi->curr进入最后一行，它就已经越出文件范围了，
 * (它所处的那个'\n'是虚拟的)。停在了EOF处，这个逻辑是很不好的。
 * 6,我们再退一步，我们只把'\n'当作一行文本的结束标识，方便一些代码的实现，
 * 0~~'\n'之间的是有效数据，整个数据结构就很清楚了。
 * 7,而如果进一步，考虑'\n'的意义（认为它也对应文件的相应'\n')，那这个映射
 * 就更好了。但仍是最后一行的'\n'问题。
 * 8,unix下的文件默认会在结尾加一个'\n'这个'\n',是不被文本编辑器解释成换行的，
 * 所以用vi->lines[][]加载unix文件很简单，就是一行行的对应关系。
 * APPEND
 * 1,当一行为空，curr指向lines[][0],当只有一个字符时，指向的还是lines[][0],你
 * 要知道这一点。也许让curr悬空比较好。
 * 但细想，不存在空行，一个行至少有一个换行符（是只是下一个行或文件尾，乱死了
 * ），只是我们没有把这个'\n'计算在len_of_line内。
 * 
 *
 */
/*Main Bug Area:
 * 1,write out of bounds when perform insert-opertion
 * 2,expired pointer to some place of a line after vi_insert perform a realloc 
 * operation.
 *
 */
#include<ctype.h>
#include"vi.h"
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
#include<string.h>
int __silent=1;
char *vi_ops1_9 = "123456789";
char*  vi_move_ops = "hjkl0$^W%";
char*  vi_pair_str = "()[]{}<>";
char*  vi_pair_str2 = ")(][}{><";


static inline void __expand_line(int l, int size, char **lines, int *size_of_line){
	lines[l] = realloc(lines[l], size);
	size_of_line[l] = size;
}

/*we can't call this function directly. Call vi_require_llen who maintains the
 * 'vi->curr', namely, keep it's value syncronization after line-reallocation
 */
static inline void __vi_expand_line(struct vi *vi, int l, int size){
	__expand_line(l, size, vi->lines, vi->size_of_line);	
}

/*yline[][] desn't has a 'curr' to maintain, so, just invoke it directly*/
static inline void vi_expand_yline(struct vi *vi, int l, int size){
	__expand_line(l, size, vi->ylines, vi->size_of_yline);	
}

/*...memory corruption..dangerous function....., DO NOT USE THEM. use 
 * their '_safe' version*/
/*Note! cursor position not handled in this function
 * @srclen	length of source string you want to insert
 */
//这个函数要再检查。万恶之源
void vi_insert_at(struct vi *vi, int l, char *at, char *src, int srclen){
	char *line = vi->lines[l];
	char_arr_iN(line, VI_CURRL_LEN(vi), VI_CURR_OFFSET(vi), src, srclen);
//	str_shr_at(line, at-line, srclen, vi->len_of_line[l]);	
//	memcpy(at, src, srclen);

	vi->len_of_lines[l] += srclen;
}
static void vi_append_at(struct vi *vi, int l, char *at, char *src, int srclen){
	vi_insert_at(vi, l, at+1, src, srclen);
}

/* 1, only vi_insert(), vi_appedn() handle cursor position
 * 2, cursor fall over the last charcter of insertion. That is , if you insert
 * on character, cursor keeps old
 * 3, don't call this function directly
*/
static void vi_insert(struct vi*vi, char *src, int srclen){
	if(srclen == 0) return;

	vi_insert_at(vi, vi->currl, vi->curr, src, srclen);
	//danger! you must ensure this line isn't re-allocated
	vi->curr += srclen - 1;
}

bool vi_e_(struct vi *vi){
	char *oldcurr = vi->curr;
	int oldcurrl = vi->currl;

	bool ret = vi_e(vi);
	if(vi->currl != oldcurrl){
		vi->curr = oldcurr;
		vi->currl = oldcurrl;
		return false;
	}
	return ret;
}
bool vi_b_(struct vi *vi){
	char *oldcurr = vi->curr;
	int oldcurrl = vi->currl;

	bool ret = vi_b(vi);
	if(vi->currl != oldcurrl){
		vi->curr = oldcurr;
		vi->currl = oldcurrl;
		return false;
	}
	return ret;
}
bool vi_B_(struct vi *vi){
	char *oldcurr = vi->curr;
	int oldcurrl = vi->currl;

	bool ret = vi_B(vi);
	if(vi->currl != oldcurrl){
		vi->curr = oldcurr;
		vi->currl = oldcurrl;
		return false;
	}
	return ret;
}
bool vi_E_(struct vi *vi){
	char *oldcurr = vi->curr;
	int oldcurrl = vi->currl;

	bool ret = vi_E(vi);
	if(vi->currl != oldcurrl){
		vi->curr = oldcurr;
		vi->currl = oldcurrl;
		return false;
	}
	return ret;
}
bool vi_W_(struct vi *vi){
	char *oldcurr = vi->curr;
	int oldcurrl = vi->currl;

	bool ret = vi_W(vi);
	if(vi->currl != oldcurrl){
		vi->curr = oldcurr;
		vi->currl = oldcurrl;
		return false;
	}
	return ret;
}
bool vi_w_(struct vi *vi){
	char *oldcurr = vi->curr;
	int oldcurrl = vi->currl;

	bool ret = vi_w(vi);
	if(vi->currl != oldcurrl){
		vi->curr = oldcurr;
		vi->currl = oldcurrl;
		return false;
	}
	return ret;
}
Def_vi_op(w)
Def_vi_op(W)
Def_vi_op(E)
Def_vi_op(B)
Def_vi_op(b)
Def_vi_op(e)

/* preprocess实现起来很简单，因为不用考虑缓冲区溢出。只会随着处理长度减小
 * TODO 需要str_del，这样不够简洁。
 * ><CR>和<ESC>被预处理成1和2，而不是13和27，因为它们可能是匹配模式中的text内容
 *  ，而不是用户的按键。用1和2也只是暂时的决定，以后找更安全的ascii码。
 */
void preprocess(char *ops){
	int len = strlen(ops);
	char *curr  = ops;
	char *tail = ops + len - 1;
	while(*curr){
		int rightlen = tail - curr + 1 + 1;	//把最后一个\0也算进去
		switch(*curr){
			/*  \<  \>  ... */
			case '\\':{
				if(curr[1] == '<') curr[0] = '<';
				else if(curr[1] == '>') curr[0] = '>';
				else assert(0 && "unimplemented yet");
				char_arr_del(curr, rightlen, 1, 1);
				break;
			}

			/* <CR>  <ESC>  */
			case '<':{
				if( strncasecmp(curr, "<CR>", 4) == 0){
					char_arr_del(curr, rightlen,  1, 3);
					curr[0] = ASCII_CR;
				}
				else if( strncasecmp(curr, "<ESC>", 5) == 0){
					char_arr_del(curr, rightlen, 1, 4);
					curr[0] = ASCII_ESC;
				}
				else assert(0 && "unknown key");
				break;
			}
			default:
				break;
		}
		curr++;
	}
}
/*1, 一部分序列要立刻解析成函数，因为ｃ库反正需要实现相应的api，一部分序列交给通用处理,像f, $, 费组合字符要立刻失败,一部分操作只用来兼容vim就没有意义了把，像比y0，dh,是很不常用的,不如放在以后收集意见后再实现，不要迷信，可能它当初设计的就不好，你怕分裂给用户困扰，那就不实现总可以吧
 *2, 先把位移的y,d操作做成通用的，如何．剔除一些常用组合，像比yw,dw*/
/*每次最好把必要的flag信息返回给lua，ｌｕａ主动获取的话，效率低，但ｌｕａ的bitwise
 * operation is still low*/
//use f«, wø,Wø,eø,Eø,bø,Bø,
//use f|, l|, w_, e_
bool vi_normal(struct vi *vi, char *op){
/*	vi->flags = 0;*/
	preprocess(op);		/*直接处理可以吗，这可是从lua stack传过来的，const?*/
	printf("preprocess done: %s\n", op);
	vi->ops = op;
	vi->op_id = 0;

	int state = VI_FLAG(SUCCESS);	/*result state of last command*/
	int (*i_or_a)(struct vi *vi, char *piece);
	bool (*do_search)(struct vi *vi, char *pattern);
	int len;
	while(vi->ops[vi->op_id] && __TEST_STATE(SUCCESS)){
		char *currop = vi->ops + vi->op_id;
		switch(*currop){
			case 'd':
				state = vi_op_d(vi);	break;
			case 'y':
				state = vi_op_y(vi);	break;
			case 'W':		state = vi_op_W(vi);	break;
			case 'w':		state = vi_op_w(vi);	break;
			case 'B':		state = vi_op_B(vi);	break;
			case 'E':		state = vi_op_E(vi);	break;
			case 'e':		state = vi_op_e(vi);	break;
			case 'b':		state = vi_op_b(vi); 	break;

			case 'f':		state = vi_f(vi, currop[1]);	goto mv2;
			case 'F':		state = vi_F(vi, currop[1]);	goto mv2;
			case 'm':		state = vi_m(vi, currop[1]);	goto mv2;
			case '`':		state = vi_tom(vi, currop[1]); 	goto mv2;
			mv2:
							vi->op_id += 2;	
							break;

			case 'v':		vi_v(vi);		goto mv1;
			case 'G':		vi_G(vi);		goto mv1;
			case 'p':		state = vi_p(vi);	goto mv1;
			case 'x':		vi_x(vi);	goto mv1;

			case '0':		vi_0(vi);			goto mv1;
			case '$':		vi_$(vi);			goto mv1;
			case 'h':		state = vi_h(vi);	goto mv1;
			case 'j': 		state = vi_j(vi);	goto mv1;
			case 'k':		state = vi_k(vi);	goto mv1;
			case 'l':		state = vi_l(vi);	goto mv1;
			case '^':		state = vi_xor(vi);	goto mv1;
			case '%':		state = vi_percent(vi);	goto mv1;

			case 'n':		state = vi_n(vi);	goto mv1;
			case 'N':		state = vi_N(vi);	goto mv1;
			case ASCII_ESC: goto mv1;
			mv1:
							vi->op_id++;
							break;

			case 'o':		vi_o(vi);
			case 'i':		i_or_a = vi_i;
							goto insert;

			case 'a':		i_or_a = vi_a;
							goto insert;
			insert:{
							char *blink = vi->curr;		//关键句,插入长度为0时
							len = i_or_a(vi, currop + 1);
							vi->op_id += 1 + len;
								
							if(op[vi->op_id] == ASCII_CR)	//暂不支持'\n'
							{
								blink += len;
								char *break_at = blink + len;		// Bb
								int rlen = VI_CURRL_END(vi) - break_at;
								vi_o(vi);
								vi_i(vi, break_at);	
								vi_0(vi);
								op[vi->op_id] = 'i';

								*break_at = EOL;
								vi->len_of_line[vi->currl - 1] -= rlen;
							}
							break;
					}

			case '/':
							do_search = vi_search_foward;
							goto lable_search;
			case '?':
							do_search = vi_search_backward;
							goto lable_search;
			lable_search:{
							char *pattern = currop + 1;
							int len = strlen_ex(pattern, STR_CR);
							do_search(vi, pattern);

							vi->op_id += 1 + len;
							if(op[vi->op_id] == ASCII_CR) vi->op_id++;
							break;
			}
							
									
			case 0:			
			case '\n':
							assert(0);
			default:		state = 0;
		}
	}
	if(!__silent) vi_print(vi, state);
	vi->_errno = state;
	return state;
}

/*register index:'a', 'b'...*/
bool vi_tom(struct vi *vi, char rid){
	if(vi_mvalid(vi, rid)){
		struct mark_register *r = &vi->m_regs[rid];
		assert(r->currl >= 0 && r->curroff >= 0);
		vi->currl = r->currl;
		vi->curr = vi->lines[vi->currl] + r->curroff;
		return true;
	}
	assert(0);
	return false;
}

/*register index:'a', 'b'...*/
/*this 'mark' function is quite weak for temporarily, but still necessary
 * DO NOT write code like:
 * char *backup = vi->curr;
 * because realloc(caused by vi_a(), vi_i() eg.) may move the whole line to a
 * new place, leaving your backup a bad pointer.
 */
bool vi_m(struct vi *vi, char rid){
	if(rid >= 'a' && rid <= 'z'){
		vi->m_regs[rid].currl = vi->currl;
		vi->m_regs[rid].curroff = VI_CURR_OFFSET(vi);
		return true;
	}
	assert(false);
	return false;
}

void vi_$(struct vi * vi){
	if(VI_CURRL_LEN(vi)){
		vi->curr = vi->lines[vi->currl] + vi->len_of_line[vi->currl] - 1;
	} 
}
void vi_0(struct vi *vi){
	if(VI_CURRL_LEN(vi)){
		vi->curr = vi->lines[vi->currl];
	}
}

bool vi_x(struct vi *vi){
	if(!vi->v_begin){
		vi_v(vi);
	}
	vi_d(vi);
	return 1;
}


/*还要支持反向搜索BREAK*/
bool vi_percent(struct vi*vi){
	char *it = strchar(vi_pair_str, vi->curr[0]);
	if(it){
		char buddy = vi_pair_str2[ it - vi_pair_str];
		char it_nr = 0;
		char buddy_nr = 0;

		int start = VI_CURR_OFFSET(vi);
		for(int i = vi->currl; i <= vi->lmax; i++){
			char *line = vi->lines[i];
			for(int j = start; j < vi->len_of_line[i]; j++){
				if(line[j] == *it) it_nr++;
				else if(line[j] == buddy){
					buddy_nr++;
					if(buddy_nr == it_nr){
						vi->currl = i;
						vi->curr = &line[j];
						return true;
					}
				}
				else;
			}
			start = 0;
		}
	}
	return false;
}

/* A 'word' means a sequence of digits, letters and underscores, while
 * 'blank' means '\n','\t' and ' '.
 * Note! the behavior of "w" is quite different from that in  VIM-editor!
 * @Description:
 * Goto next edge of nonword|word, and the move process will be interruped(and 
 * fall over it) when encounter any (nonword && nonblank) character on the way
 *
 * eg. int a=a? b:c; 
 * suppose we are performing 'w' on it, initially at the begining, : then 'a', 
 * then '=', then 'a', then '?', then 'b', then ':', then 'c', and finally ';'
 *
 */
bool vi_w(struct vi *vi){
	char *curr = vi->curr;
	int currl = vi->currl;
	do{
		char *prev = vi->curr;
		if(!vi_L_(vi)) break;
		if(!__IS_BLANK(vi->curr[0]) && !__IS_CWORD(vi->curr[0])) return true;
		if(__IS_CWORD(vi->curr[0]) && !__IS_CWORD(*prev)) return true; 
	}while(1);
	vi->currl = currl;
	vi->curr = curr;
	return false;
}

bool vi_b(struct vi*vi){
	char *oldcurr = vi->curr;
	int oldcurrl = vi->currl;

	while(vi_H_(vi)){
		char *curr = vi->curr;
		if(!__IS_CWORD(*curr) && !__IS_BLANK(*curr)) return true;
		if(__IS_CWORD(*curr) && !__IS_CWORD( vi_smelll(vi) ) ) return true;
	}
	
	vi->currl = oldcurrl;
	vi->curr = oldcurr;
	return false;
}

bool vi_e(struct vi *vi){
	char *oldcurr = vi->curr;
	int oldcurrl = vi->currl;

	while(vi_L_(vi)){
		char *curr = vi->curr;
		if(!__IS_CWORD(*curr) && !__IS_BLANK(*curr)) return true;
		if(__IS_CWORD(*curr) && !__IS_CWORD(vi_smellr(vi))) return true;
	}
	
	vi->curr = oldcurr;
	vi->currl = oldcurrl;
	return false;
}
/*注意jmpspace_ex0,jmpspace0这些状态位的清０*/
/*是了，可以写在返回值里的*/
/*记得，W成功了还不够，要标记是否跳行了,是标记flag,还是写在返回值里呢,对，不如高１６位标记失败信息，低１６位标记成功信息，接口调用者比较一下大小就好了*/
/*返回值作为状态字节可以，但注意，保持vi库的纯净，针对lua的优化写在导出层，也不
 * 要返回过多*/
//如果你直接用vi->currl和vi->curr不断写，累加，代码会简化不少
bool vi_W(struct vi *vi){
	char *curr = vi->curr;
	int currl = vi->currl;
	do{
		char prev = vi->curr[0];
		if(vi_L_(vi) == false) break;	/*tail of the whole text*/
		if(strchar(const_vi_blankchars, prev) && strchar(const_vi_blankchars, vi->curr[0]) == 0) return true;

	}while(1);

	//failed, keep old cursor
	vi->currl = currl;
	vi->curr = curr;
	return false;
}
/*1, won't return 'meetn' on failed... do you think there is another reason?
 */
int vi_E(struct vi *vi){
	int currl = vi->currl;
	char *curr = vi->curr;
	vi_L_(vi);
	do{
		if(vi_L_(vi) == false) break;	/*already stand on tail '\n' of the whole text*/
		if(strchar(const_vi_blankchars, vi->curr[0]) && !strchar(const_vi_blankchars, vi->curr[-1])){
			vi_H_(vi);
			return true;
		}
	}while(1);
	vi->currl = currl;
	vi->curr = curr;
	return false;
}


/*@group  a collection of target character, eg. "ab$!"
 * 		Note, flag '\n' indicate the tail of this line.　
 * @flags:
 * 	
 * Note! 'ML 'not supported, we offer another API 'search'
 * 虽然有＇\n'选项',但仍不支持多行
 */
int vi_f_ex(struct vi *vi, char *group, unsigned flags){
	assert((flags & VI_FLAG(ML)) == 0);
	int state = 0;
	char *curr = (VI_FLAG(curr) & flags) ? vi->curr : vi->curr + 1;
	bool exist_flag_n = (bool)strchar(group, '\n');
	while( 1 ){
		if( *curr == '\n'){
			if(exist_flag_n && vi->currl < vi->lmax){
				vi->currl++;	/*现在是停在行末，一定要小心，不要乱改*/
				vi->curr = vi->lines[vi->currl];
				goto success;
			}
			return 0;	/*we don't return flag-meetn. Becasue, Is there another 
						  failure reason*/
		}
		if ( strchar( group, *curr ) == 0 )	curr++;
		else{	/*current character matched*/
			vi->curr = curr;
			goto success;
		}
	}
success:
		state += (((int)*vi->curr)<<8);		/*not so necessary, just a shorthand*/
		__SET_STATE(SUCCESS);
		return state;
}

struct vi* vi_new( char *str){
	struct vi *vi = malloc( sizeof( struct vi ) );
	vi_set( vi, str );
	return vi;
}

struct vi * vi_init(struct vi *vi){
	vi->lines = malloc0(1024 * sizeof(void *));	/* 1024 lines at most*/
	vi->size_of_line = malloc0(1024 * sizeof(int));
	vi->len_of_line = malloc0(1024 * sizeof(int));

	vi->ylines = malloc0(VI_YLINE_MAX * sizeof(void *));
	vi->size_of_yline = malloc0(VI_YLINE_MAX * sizeof(int));
	vi->len_of_yline = malloc0(VI_YLINE_MAX * sizeof(int));

	vi->m_regs = malloc0(128 * sizeof(struct mark_register));
	vi->clipboard_buf = malloc(1024);
	vi->clipinfo = calloc(1, sizeof(struct vi_clipinfo));
	vi->clipinfo->ylmax = -1;
	return vi;
}

/*windows is \r\n
 * linux: \n
 * mac	\r
 */
void  vi_set( struct vi* vi, const char *str ){
	vi->str = str;
	
	int currl = 0;
	char *curr = (char *)str;
	do{
		int line_len = strlen_ex(curr, "\n");	/* '\0' or '\n' as string tail*/
		VI_LINE_MK(vi, currl, curr, line_len);

		curr += line_len;
		if(*curr == 0) break;

		curr++;	/*jmp this '\n'*/
		currl++;
	}while(1);

	vi->v_begin=0;
	vi->v_beginl=-1;
	vi->clipinfo->ylmax=-1;
	vi->currl = 0;
	vi->curr=vi->lines[0];
	vi->lmax=currl;
	vi->flags=0;
	vi_reset_m_regs(vi);
}

/*@... flag
 * @return state: |SUCCESS
 */
int vi_f( struct vi *vi, char to, ... ){
	char *at = strnchar(vi->curr+1, to);
	if(at){
		vi->curr = at;
		return VI_FLAG(SUCCESS);
	}
	return 0;
}

/*@control  control information:
 * |ML		|?curr*/
/*@return state:
 * |SUCCESS		|meetn		|curr
 * do we need to offer so many options? this functon can be very simple if we don't
 * offer so many options and return complex status and pay much attention to CPU
 * performance'
 */
int vi_jmpspace_ex(struct vi *vi, int control){
	int state;
	int currl = vi->currl;
	char *curr = jmp_space(vi->curr);	/*bug: vi line don't have a '\0' tail*/
	if(*curr == '\n'){	/*we need goto next line*/
		if(VI_FLAG(ML) & control){
			do{
				if(currl == vi->lmax){
					return VI_FLAG(meet0);
				}
				curr = jmp_space(vi->lines[++currl]);
			}while(*curr == '\n');
			//state = 0;		/*fall over a word now, success*/
			vi->curr = curr;
			vi->currl = currl;
			return VI_FLAG(SUCCESS);
		}
		else{	
			state = 0;	__SET_STATE(meetn);
			return state;
		}
	}
	else if(curr != vi->curr){	/*two case left: moved ; not move	*/
		vi->curr = curr;
		return VI_FLAG(SUCCESS);
	}
	else{	/*failed because already standing on a word */
		return VI_FLAG(curr);
	}
	return __DO_NOT_COMPLAIN;
}
/*1, fail in two situation:	current is already non-empty character;  meet '\n'
 *2, Note! '\n' is not treated as an empty char but EOF, for it search within line
 *i don't know whether here is a good decision to return state-code, just return
 * true or false may be not that bad*/
int vi_jmpspace(struct vi *vi){
	char *curr = jmp_space(vi->curr);
	if(*curr == '\n'){
		return VI_FLAG(meetn);
	}
	else if(curr == vi->curr){	/*current is a non-space character*/
		return 0;
	}
	else {		/* moves */
		vi->curr = curr;
		return VI_FLAG(SUCCESS);
	}
	return __DO_NOT_COMPLAIN;
}

/*@return :
 * 1, meet '\n': stop at it bravely, return the position
 * 2, meet non-empty character, stop at it, return new position
 * 3, not stand at a space at first ,do nothing, return old position;
 * 4, 0 is treated as empty character
 * BUG:依赖于jmp_space 以'\0'结尾的调用要改，　并且，vi里从此用'\n'结尾
 */
char *jmp_space( char *str ){
//	assert(*str);
	char *curr = str;
	/*have to write like this, for strchar can't match '\0' */
	while( *curr == 0 || strchar(" \t", *curr) ){
		curr++;
		if( *curr == '\n') return curr;
	}
	return curr;
}

/*
 * a slightly different behavior in contrast of vi_jmpspace.
 * Return scussess if already stand on non-blank character.
 */
bool vi_jmpspace_r(struct vi *vi){
	if(!isspace(vi->curr[0])){
		return VI_FLAG(curr) | VI_FLAG(SUCCESS);
	}	
	while(vi->curr >= vi->lines[vi->currl]){
		if(!isspace(vi->curr[0])) return VI_FLAG(SUCCESS);
		vi->curr--;
	};
	vi->curr++;	/*land on first character if failed, TODO keep old?*/
	return 0;
}
/*supply basic security guarantee*/
bool vi_active(struct vi *v){
	if (v->mod == VI_MOD_BUSY){
		assert(0 && "active failed");
		return 0;
	}
	v->mod = VI_MOD_BUSY;
	vim = v;
	return 1;
}

bool vi_drop(struct vi *v){
	if(v->mod == VI_MOD_FREE){
		assert(0 && "already free");
		return 0;	
	}		
	vim = 0;
	v->mod = VI_MOD_FREE;
	return 1;
}

#include<regex.h>
// vi里的/xxx<CR>如果遇到当下即是 matched，那它的行为跟n一样。
// lsh不这样。 
// lsh搜索到底部了也不会回到顶部
// 暂时不支持?,它在编辑器里有用，但在编程里就不那么必要
// 反向搜索，如果正好匹配到脚下的，也会停在这儿 ---算了，还是不这样。主要是编程
// 的话，后者更自然
bool vi_search_backward(struct vi *vi, char *pattern){
	assert( strlen(pattern) < VI_REGEX_LEN);
	if(pattern != vi->last_search) strcpy( vi->last_search, pattern);

	int err;
	regex_t reg;
	int nm = 256;		//一个就够了?
	regmatch_t matchs[nm];	
	char errmsg[128] = "error buf";

	if( (err = regcomp(&reg, pattern, REG_EXTENDED)) != 0){
		regerror(err, &reg, errmsg, sizeof(errmsg));
		fprintf(stderr, "%s:pattern '%s'\n", errmsg, pattern);
		return false;
	}

	for(int l = vi->currl; l >= 0; l--){
		char *bematch = vi->lines[l];
		char *end = l == vi->currl ? vi->curr : 
										  &vi->lines[l][vi->len_of_line[l]];
		char backup = *end;
		*end = 0;
   		err = regexec(&reg, bematch, nm, matchs, 0);
		*end = backup;
		if(err) continue;
		
		//find one, stand on it
		int i;
		for(i = 0; i < nm; i++){
			if(matchs[i].rm_so == -1) 	break;
			if(l == vi->currl && matchs[i].rm_so > VI_CURR_OFFSET(vi)){
				break;
			}
		}
		i--;	//就是它了
		vi->curr = bematch + matchs[i].rm_so;
		vi->currl = l;
		return true;
	}
	return false;
}

//暂时不支持search结果缓存
bool vi_search_foward(struct vi *vi, char *pattern){
	assert( strlen(pattern) < VI_REGEX_LEN);
	if(pattern != vi->last_search) strcpy( vi->last_search, pattern);

	int err;
	regex_t reg;
	int nm = 256;		//一个就够了?
	regmatch_t matchs[nm];	
	char errmsg[128] = "error buf";

	if( (err = regcomp(&reg, pattern, REG_EXTENDED)) != 0){
		regerror(err, &reg, errmsg, sizeof(errmsg));
		fprintf(stderr, "%s:pattern '%s'\n", errmsg, pattern);
		return false;
	}

	for(int l = vi->currl; l <= vi->lmax; l++){
		char *bematch = l == vi->currl ? vi->curr : vi->lines[l];

		vi->lines[l][ vi->len_of_line[l] ] = 0;
   		err = regexec(&reg, bematch, nm, matchs, 0);
		vi->lines[l][ vi->len_of_line[l] ] = EOL;
		if(err) continue;
		
		//find one, stand on it
		vi->curr = bematch + matchs[0].rm_so;
		vi->currl = l;
		return true;
	}
	return false;
}

/* BREAK
   暂时不考虑方向随?, /改变。 到时候想实现，考虑在vim_normal里做，或者做成
 * vi_search和vi_?这样的函数
 * TODO 如果last_search为空，用户就调用了n/N。
 */
bool vi_n(struct vi *vi){
	if(vi->last_search[0] == 0) return false;

	int originl = vi->currl;
	char *origin = vi->curr;
	bool ok = vi_search_foward(vi, vi->last_search);

	if(!ok) return false;	//压根搜不到
	if(origin == vi->curr){	//搜到了，但很可惜，正在脚下，要再找下一个
		if( vi_lg(vi) == false) return false;	//已经是文末
		ok = vi_search_foward(vi, vi->last_search);
		if(!ok) {		//接下来搜不到了
			vi->currl = originl;
			vi->curr = origin;
			return false;
		}
	}

	return true;	
}

bool vi_N(struct vi *vi){
	return vi_search_backward(vi, vi->last_search);	
}
/*copy selection
 *1,copy it first, but we can not paste always correctly this version
 *@vi->v_begin, vi->v_beginl must be set before invoke it
 * 在空行上执行delete操作，行为是未定义的。
 */

/*delete within line*/
void vi_del_within(struct vi *vi){	
	assert(vi->curr == vi->v_head || vi->curr == vi->v_tail);

	//int len = Nstr_del2(vi->v_head, vi->v_tail, VI_CURRL_LEN(vi));
	int len = char_arr_del2N(vi->lines[vi->currl], VI_CURRL_LEN(vi), V_HEAD_OFFSET(vi), V_TAIL_OFFSET(vi));
	vi->len_of_lines[vi->currl] = len;

	vi->curr = vi->v_head;
	assert(VI_CURRL_LEN(vi) >= VI_CURR_OFFSET(vi));
	if(VI_CURRL_LEN(vi) == VI_CURR_OFFSET(vi)){
		vi->curr--;
	}
}

/*delete across lines*/
/*after delete, cursor stand at v_head*/
//BUG cursor may fall out of valid memory when delete last line or eg else
void vi_del_across(struct vi *vi){
	/*only consider 'v' mod, 'V' or 'Ctrl-v' ignored */
	int m = vi->v_m;
	int n = vi->v_n;
/*	char *start = vi->v_head;*/
/*	char *tail = vi->v_tail;*/

	/*看line:n拼接到line:m之后，是否会溢出*/
	vi->len_of_line[m] = V_START_OFFSET(vi);
	vi->lines[m][vi->len_of_line[m]] = '\n';	
	VI_LINE_I_SAFE(vi, m, V_START_OFFSET(vi), vi->v_tail+1, vi->len_of_line[n] - V_TAIL_LEN(vi));
	
	VI_DEL_LINES(vi, m+1, n-m);

	vi->currl = m;
	vi->curr = vi->v_start;	/*the cursor will always fall over the first byte
							  of the selection after deleted*/
}

void vi_y_within(struct vi *vi){
	VI_YLINE_MK(vi, 0, vi->v_start, vi->v_tail - vi->v_head + 1);

	vi->clipinfo->ylmax = 0;
}

void vi_y_across(struct vi* vi){
	int m = vi->v_m;
	int n = vi->v_n;
	
	int ylmax = n - m;
	VI_YLINE_MK(vi, 0, vi->v_head, vi->len_of_lines[m]-V_HEAD_LEN(vi) + 1);
	for(int i = 1; i <= ylmax-1; i++){ 
		VI_YLINE_MK(vi, i, vi->lines[m + i], vi->len_of_lines[m + i]);
	}
	/*copy selction on the last line. Note! : use V_TAIL_LEN() rather than 
	 * len_of_line[], because 'v_tail' may stand after line tail due to $0*/
	VI_YLINE_MK(vi, ylmax, vi->lines[n], V_TAIL_LEN(vi));
	
	vi->clipinfo->ylmax = ylmax;
}

void vi_paste_yy(struct vi *vi){
	assert(vi->clipinfo->yy = 1);
	/*may support multiline -yy in future*/
	VI_A_LINES(vi, vi->currl, vi->clipinfo->ylmax+1);
	for(int i = 0; i <= vi->clipinfo->ylmax; i++){
		VI_LINE_MK(vi, vi->currl+1+i, vi->ylines[i], vi->len_of_yline[i]);
	}
	//vi->lmax += (vi->ylmax+1);		VI_A_LINES did it
	//new cursor position
	vi->currl++;
	vi->curr = vi->lines[vi->currl];	
}

void vi_paste_line(struct vi *vi){
/*	int currl = vi->currl;*/
	if(VI_CURRL_LEN(vi) == 0){	//we can't do append on a empty line
		vi_insert_safe(vi, vi->ylines[0], vi->len_of_yline[0]);	
	}
	else
		vi_append_safe(vi, vi->ylines[0], vi->len_of_yline[0]);
}

void vi_paste_lines(struct vi *vi){
	int currl = vi->currl;
/*	char **lines = vi->lines;*/
	int m = vi->currl;
	int n = vi->currl + vi->clipinfo->ylmax;
	/*firstly, we append (x-1) cells to current of 'lines', that is, we tear
	 * array 'lines' to append (x-1) new lines
	 */
	VI_A_LINES(vi, currl, n-m);
	
	/*secondly, allocate space for these new lines, except the last line,
	 * we handle it later.	so we expand (x-2) lines totally this step. 
	 * */
	for(int i = 1; i <= vi->clipinfo->ylmax; i++ ){
		VI_LINE_I_SAFE(vi, m + i, 0, vi->ylines[i], vi->len_of_yline[i]);
	}

	/*handle the last line, append char serial right to current cursor to
	 * vi->line[n], namely the last new-line*/
	VI_LINE_A_SAFE(vi, n, vi->len_of_lines[n] - 1, vi->curr+1, vi->len_of_line[currl] - VI_CURR_LEN(vi) + 1);

	/*Finally, handle the first line*/
	/*append content from ylines[0]*/
	vi->len_of_lines[m] = VI_CURR_LEN(vi);	
	vi_append_at_safe(vi, vi->currl, vi->curr, vi->ylines[0], vi->len_of_yline[0]);
	
}
/*delete lines in specified range
 *@from vi->v_m to vi->v_n
 */
void vi_del_lines(struct vi * vi){
	/*can be replaced by vi_del_across*/
	assert(0);	
}

/*
 * 1, cursor is at tail, or at start
 * 删除肯定要指定v_begin的,像x,dw之类，也不例外,由上层指定
 * 删除操作的剪切版是个问题
 * ，　也许要考虑到性能，改变一些特新，或提供fast-version的函数
 * 调用该函数前，必须设置v_beginl和v_begin
 * 2, this is the only interface you can call, don't invoke it's two children
 * functions directly
 * 3, delete will terminate 'v' mode, but for this VERSION, this is done by
 * nested 'copy'.
 * TODO you fogot to perform a clipboard copy
 */
int vi_d(struct vi *vi){
	int state = vi_y(vi);
	if(__TEST_STATE(SUCCESS) == 0) return state;

	if(vi->v_m == vi->v_n){
		vi_del_within(vi);
	}
	else{
		vi_del_across(vi);
	}
	return VI_FLAG(SUCCESS);
}

/*not the only interface to copy, the other is vi_yy
 * 1, user progarmmer shouldn't call vi_y() and then append some other operations
 * like vi_f(), vi_y() shall be called in selection mod(namely, vi_v() is called.
 * Other wise, return error
 * */
int vi_y(struct vi *vi){
	if(!vi->v_begin) return 0;
	vi->clipinfo->yy = 0;
	vi_mk_head_tail(vi);
	vi_mk_mn(vi);
	if(vi->v_beginl == vi->currl){
		vi_y_within(vi);
	}
	else{
/*		vi_mk_mn(vi);*/
		vi_y_across(vi);
	}

	vi_v(vi);
	return VI_FLAG(SUCCESS);
}

/* expired comment
 * 1, paste behaves like you append a string after a character, so this function
 * doesn't move cursor directly, cursor is changed by invoking vi_append()
 * 2, special for 'yy', cursor stand at the head of new-burn line
 * 3, cursor can not locate correctly when paste multiline(this VERSION)
 */
/* 1, new cursor location is set by child functions
 */
int vi_p(struct vi *vi){
	if(vi->clipinfo->ylmax < 0 ) return 0;

	//int currl = vi->currl;
	//char *curr = vi->curr;

	if(vi->clipinfo->yy){
		vi_paste_yy(vi);
		return VI_FLAG(SUCCESS);	
	}
	if(vi->clipinfo->ylmax == 0){
		vi_paste_line(vi);
	}
	else{
		vi_paste_lines(vi);
	}
	//vi->currl = currl;	lines may be realloc
	//vi->curr = curr;
/*	vi->ylmax = -1;*/	//we can paste many times
	return VI_FLAG(SUCCESS);
}




/*if size smaller than current size, just return, otherwise, double the new size
 *Note! 'vi->curr' should be taken care of here */
void vi_require_llen(struct vi *vi, int l, int size){
	if(vi->size_of_line[l] < size){
		int curroff = VI_CURR_OFFSET(vi);
		__vi_expand_line(vi, l, size * 2);
		if(l == vi->currl) vi->curr = vi->lines[l] + curroff;
	}
}


/*additional API, may be it's more friendly
 *Here a whole line may be moved to anohter place by realloc 
 TODO forgot to handle vi->v_begin, vi->v_end..*/
void vi_insert_safe(struct vi*vi, char *src, int srclen){
	vi_require_llen(vi, vi->currl, VI_CURRL_LEN(vi) + srclen + 1);
	vi_insert(vi, src, srclen);	
}

/*append after '\n' undefined behavior, may crack
 */
void vi_append_safe(struct vi*vi, char *src, int srclen){
	assert(VI_CURR_LEN(vi) <= VI_CURRL_LEN(vi));
	vi->curr++;	/*TODO not so simple*/
	vi_insert_safe(vi, src, srclen);
}

#if 0
static void vi_append(struct vi *vi, char *src, int srclen){
	vi->curr++;	/*TODO not so simple*/
	vi_insert(vi, src, srclen);
}
#endif


void vi_mk_mn(struct vi *vi){
	assert(vi->v_beginl != -1);

	vi->v_m = vi->v_beginl;
	vi->v_n = vi->currl;
	if(vi->v_m > vi->v_n) EXCHG_INT(vi->v_m, vi->v_n);
}

void vi_mk_head_tail(struct  vi *vi){
	assert(vi->v_begin != 0);

	vi->v_head = vi->v_begin ;
	vi->v_tail = vi->curr;
	if(vi->v_beginl > vi->currl) EXCHG_PTR(vi->v_head, vi->v_tail);
	else if(vi->v_beginl == vi->currl){
		if(vi->v_head > vi->v_tail) EXCHG_PTR(vi->v_head, vi->v_tail);
	}
	else;
}


/*1, another version of vi_insert_at_safe(/append), the only difference is :
 * 'at' is an offset.
 * I want to see which version is more friendly
 * Note! these functions rely on a legal original line length, namely, array
 * vi->len_of_line[] should be initialized and matained preperly.
 */
void VI_LINE_A_SAFE(struct vi *vi, int l, int  at, char *src, int srclen){
	vi_require_llen(vi, l, vi->len_of_line[l] + srclen+1);
	vi_append_at(vi, l, vi->lines[l] + at, src, srclen);
}

/*void vi_insert_at(struct vi *vi, int l, char *at, char *src, int srclen){*/
void VI_LINE_I_SAFE(struct vi *vi, int l, int at, char *src, int srclen){
	vi_require_llen(vi, l, vi->len_of_line[l] + srclen+1);
	vi_insert_at(vi, l, vi->lines[l] + at, src, srclen);
}

void vi_append_at_safe(struct vi *vi, int l, char *at, char *src, int srclen){
	vi_require_llen(vi, l, vi->len_of_line[l]+srclen+1);
	vi_append_at(vi, l,  at, src, srclen);
}

void vi_insert_at_safe(struct vi *vi, int l, char *at, char *src, int srclen){
	vi_require_llen(vi, l, vi->len_of_line[l]+srclen+1);
	vi_insert_at(vi, l,  at, src, srclen);
}
/*每个函数都要做yline和lines的两个版本，要作死*/
/*realloc necessary? compare to the performance of free+malloc ?*/
void VI_YLINE_MK(struct vi *vi, int l, char *src, int srclen){
	int size = srclen + 1;
	if(vi->size_of_yline[l] < size){
		vi->ylines[l] = realloc(vi->ylines[l], size);
		vi->size_of_yline[l] = size;
	}	
	strncpy(vi->ylines[l], src, srclen);
	vi->ylines[l][srclen] = '\n';
	vi->len_of_yline[l] = srclen;
}

void VI_LINE_MK(struct vi *vi, int l, char *src, int srclen){
	int size = srclen + 1;
	if(vi->size_of_line[l] < size){
		vi->lines[l] = realloc(vi->lines[l], size);
		vi->size_of_line[l] = size;
	}	
	strncpy(vi->lines[l], src, srclen);
	vi->lines[l][srclen] = '\n';
	vi->len_of_line[l] = srclen;
}


void vi_print2(struct vi*vi){
	for(int i = 0; i <= vi->lmax; i++){
		printf("%.*s", vi->len_of_line[i], vi->lines[i]);
		if(vi->lmax != i) putchar('\n');
	}
}
void vi_print(struct vi*vi, int normal_ret){
	/*			l   line 	curr 	normal*/
	int w[16] = {7, 13, 	13, 	8};
	printf("\n%-*s%-*s%-*s%-*s%-*s\n", w[0], "currl", w[1], "line", w[2], "curr",w[3], "normal", w[4], "op_id");
	printf("%-*d%-*p%-*p%-*d%-*d\n", w[0], vi->currl,w[1], vi->lines[vi->currl], w[2], vi->curr, w[3], normal_ret,w[4], vi->op_id);
	printf("%-*d%-*p%-*d%-*d%-*s\n", w[0], VI_CURRL_LEN(vi),w[1], vi->lines[vi->currl], w[2], vi->curr[0], w[3], normal_ret, w[4], vi->ops+vi->op_id);
	printf("%-*d%-*p%-*.*s%-*d|%-*s\n", w[0], VI_CURRL_LEN(vi),w[1], vi->lines[vi->currl], w[2], strlen_ex(vi->curr, "\n"), vi->curr, w[3], normal_ret, w[4], vi->ops);
	putchar('\n');
	for(int i = 0; i <= vi->lmax; i++){
		char *prefix = i == vi->currl ? "@" : ">";
		printf("%s", prefix);
		
		if(vi->currl == i){
			print_ink_nstr(vi->lines[i], vi->curr - vi->lines[i]);
		}
		else printf("%.*s", vi->len_of_line[i], vi->lines[i]);
		putchar('\n');
	}
}

void vi_v(struct vi * vi){
	if(vi->v_begin == 0){
		vi->v_begin = vi->curr;
		vi->v_beginl = vi->currl;
		return;
	}
	vi->v_begin = 0;
	vi->v_beginl = -1;
}
void vi_endv(struct vi *vi){
	vi->v_begin = 0;
	vi->v_beginl = -1;
}

/* play tricks on 'clipboard' */
void vi_yy(struct vi*vi){
	vi->clipinfo->yy = 1;

	VI_YLINE_MK(vi, 0, vi->lines[vi->currl], vi->len_of_lines[vi->currl]);
/*	vi->len_of_yline[0] = 0;*/

	vi->clipinfo->ylmax = 0;
}

/*TODO crack when delete the first line(or a empty line ?)
 */
void vi_dd(struct vi *vi){
	vi_yy(vi);
	VI_DEL_LINES(vi, vi->currl, 1);

	if(vi->currl > vi->lmax) vi->currl = vi->lmax;
	vi->curr = vi->lines[vi->currl];
}
int vi_dW(struct vi *vi){		
	vi_v(vi);
	int state = vi_E(vi);
	if(__TEST_STATE(SUCCESS)){
		vi_d(vi);
		return VI_FLAG(SUCCESS);
	}
	return 0;
}
int vi_yW(struct vi *vi){
	assert(0);
}

void vi_cc(struct vi *vi){

}
void vi_cw(struct vi *vi){

}

/*search the next pattern [blank|word]
 */
bool vi_B(struct vi *vi){
	char *oldcurr = vi->curr;
	int oldcurrl = vi->currl;
	if(!vi_H_(vi)) return false;/*we may already on the head of a word, skip it*/

	char *behind = vi->curr;
	while(vi_H_(vi)){
		if(__IS_BLANK(vi->curr[0]) && !__IS_BLANK(*behind)){
			vi_L_(vi);
			return true;
		}
		behind = vi->curr;
	}

	/*the last chance: a word is at the very begining of the whole text */
	if(!__IS_BLANK(vi->curr[0])) return true;

	vi->curr = oldcurr;
	vi->currl = oldcurrl;
	return false;
}

//break:你确定要支持这么多操作吗，不如把已有的写的健壮和简洁，毕竟要给别人用的,小心你这周都发布出去了


void vi_d0(struct vi *vi){
	vi_v(vi);
	vi_0(vi);
	vi_d(vi);
}
void vi_y0(struct vi *vi){
	vi_v(vi);
	vi_0(vi);
	vi_y(vi);
}
void vi_d$(struct vi *vi){
	vi_v(vi);
	vi_$(vi);
	vi_d(vi);
}
void vi_y$(struct vi *vi){
	vi_v(vi);
	vi_$(vi);
	vi_y(vi);
}
int vi_df(struct vi *vi, char target){
	vi_v(vi);
	int state = vi_f(vi, target);
	if(__TEST_STATE(SUCCESS)){
		vi_d(vi);
		return VI_FLAG(SUCCESS);
	}
	else{
		vi_v(vi);
		return 0;
	} 

	return __DO_NOT_COMPLAIN;
}
int vi_yf(struct vi *vi, char target){
	vi_v(vi);
	int state = vi_f(vi, target);
	if(__TEST_STATE(SUCCESS)){
		vi_y(vi);
		return VI_FLAG(SUCCESS);
	}
	else{
		vi_v(vi);
		return 0;
	}
	return __DO_NOT_COMPLAIN;
}

int vi_op_d(struct vi *vi){
	if(vi->v_begin){
		vi->op_id++;
		return vi_d(vi);
	}
	char op = vi->ops[vi->op_id + 1];
	int state = VI_FLAG(SUCCESS);	/*surely success op(e.g. void) won't touch it */
	switch(op){
		case 'd':	vi_dd(vi);	goto mv2;
		case 'W':	state = vi_dW(vi);	goto mv2;
		case 'w':	assert(0);	goto mv2;
		case '0':	vi_d0(vi);	goto mv2;
		case '$':	vi_d$(vi);	goto mv2;
		mv2:		vi->op_id += 2;
					break;
		case 'f':	state = vi_df(vi, vi->ops[vi->op_id+2]);
					vi->op_id += 3;
					break;
		case 0:	
					state = 0;
					break;
		default:	
					state = 0;
	}
	return state;
}

int vi_op_y(struct vi *vi){
	if(vi->v_begin){
		vi->op_id++;
		return vi_y(vi);
	}
	char op = vi->ops[vi->op_id + 1];
	int state = VI_FLAG(SUCCESS);	/*surely success op(e.g. void) won't touch it */
	switch(op){
		case 'y':	vi_yy(vi);	goto mv2;
		case 'W':	state = vi_yW(vi);goto mv2;
		case 'w':	assert(0);goto mv2;
		case '0':	vi_y0(vi);goto mv2;
		case '$':	vi_y$(vi);goto mv2;
		mv2:		vi->op_id += 2;
					break;
		case 'f':	state = vi_yf(vi, vi->ops[vi->op_id+2]);
					vi->op_id += 3;
		case 0:	
					state = 0;
					break;
		default:	
					state = 0;
	}
	return state;
}

int vi_filesize(struct vi* vi){
	int filesize = 0;
	for(int l = 0; l <= vi->lmax; l++){
		filesize += (vi->len_of_line[l] + 1);
	}
	//filesize--;	/*trip the tail '\n' */
	//text tail '\n' is calcuted into filesize
	return filesize;
}

char *vi_clipboard(struct vi *vi, char *buf){
	if(!buf) buf = vi->clipboard_buf;

	char *curr = buf;
	for(int l = 0; l <= vi->clipinfo->ylmax; l++){
		memcpy(curr, vi->ylines[l], vi->len_of_yline[l]+1);
		curr += (vi->len_of_yline[l] + 1);
	}
	if(curr > buf){
		curr[-1] = 0;
	}
	return buf;
		
}

//TODO should emit '\n'　in last line?
char *vi_out(struct vi * vi, char *buf){
	int filesize = vi_filesize(vi);
	if(!buf){
		buf = malloc(filesize);	/*we may append '\0' to buf*/
	}
	char *curr = buf;
	for(int l = 0; l <= vi->lmax; l++){
		memcpy(curr, vi->lines[l], vi->len_of_line[l]+1);
		curr += (vi->len_of_line[l] + 1);
	}
	assert(curr - buf == filesize);
	if(curr > buf){
		curr[-1] = 0;	//vi_open already erase the text-tail '\n'
	}
	return buf;
}

/*烦死了，就用bool把*/
bool vi_open(struct vi *vi, char *filepath){
	int fd = open(filepath, O_RDONLY);
							if(fd == -1){
								return false;
							}	assert(fd != -1);
	int filesize =	lseek(fd, 0, SEEK_END);
	lseek(fd, 0, SEEK_SET);
	char *buf = malloc(filesize );
	int bytes = read(fd, buf, filesize);
	close(fd);
							if(bytes != filesize){
								return false;
							}
	assert(buf[filesize-1] == '\n');
	buf[filesize-1] = 0;		/*erase text-tail '\n', vi_set need this flag*/
	vi_set(vi, buf);	
	//vi->lmax--;		/*erase the last virtual line caused by text tail '\n'*/
	free(buf);
	vi->filepath = filepath;

	return true;
}

/*only support generate unix-stype file for temporary. Mac-os, Windows stype file
 * not supported. Because copy whole content to a buffer and write it to disk is 
 * not a permanent solution. The memory occupation would be intolerable when 
 * processing big size file.
 * I don't like write code to be rewritten soon
 */
bool vi_write(struct vi*vi, char *filepath){
	if(!filepath) filepath = vi->filepath;
	if(!filepath) return false;
	int fd = open(filepath, O_RDWR|O_CREAT|O_TRUNC, 0777);	if(fd == -1)	return 0;
	int filesize = vi_filesize(vi);
	char *buf = vi_out(vi, 0);		assert(buf);
	/*TODO -1, 只是为了去除末尾的0,但这个0是你自己添上的 */
	int bytes = write(fd, buf, filesize-1);	
	close(fd);
	free(buf);
	
	if(bytes != filesize - 1){
		return false;
	}
	return true;
}

void vi_library_init(void){
	vim = malloc(sizeof(struct vi));
	vi_init(vim);
	vi_set(vim, "");
}

int vi_taste_digit(struct vi*vi){
	return taste_digit(vi->curr);
}
bool vi_F(struct vi *vi, char c){
	char *curr = vi->curr - 1;
	while(curr >= vi->lines[vi->currl]){
		if(*curr == c){
			vi->curr = curr;
			return true;
		} 
		curr--;
	}
	return false;
}

/*a simplify version of vi_search, can only search simple string, rather than
 * Regular Expression,
 * 1, this is a piece of deligate code, more delegate than fast
 * 2, when you search a "\", pass "\\" rather than "\", the reason is C, not this
 * function requires. "vi_find" is a quite simple function, he doesn't know or
 * parse esape charater, he takes "\"(i.e. ascii 92) as a common character. But the
 * problem is, C compiler does esape, only if we write "\\" in source code will we
 * get "₉₂"(ascii) in the binary file. 
 * So is Lua.
 * Er, i am explaining a basic thing.
 * */

bool vi_find(struct vi *vi, char* str, unsigned flags){
	char *oldcurr = vi->curr;
	int oldcurrl = vi->currl;	
search_from_foot:
	vi->curr = strnstr(vi->curr, str, vi->len_of_line[vi->currl] - VI_CURR_LEN(vi) + 1);
	while(!vi->curr){
		vi->currl++;
		if(vi->currl > vi->lmax){	//we failed
			vi->curr = oldcurr;
			vi->currl = oldcurrl;
			return 0;
		}
		vi->curr = strnstr( vi->lines[vi->currl], str, vi->len_of_line[vi->currl] );
	}	
	/*support for VI_FLAG_cword*/
	if(VI_FLAG(cword) & flags){
		char *goodcurr  =vim->curr;
		bool l_bad = __IS_CWORD(vi_smelll(vi));
		vim->curr += strlen(str) - 1;
		bool r_bad = __IS_CWORD(vi_smellr(vi));
		if(l_bad || r_bad){
			vi_L_(vi);
			goto search_from_foot;
		}	
		vim->curr = goodcurr;
	}	
	/*check that whether within quotes, the user programmer don't want it a
	 * part of string*/
	if(VI_FLAG(noquote) & flags){
		if(vi_inquote(vi)){
			vi_L_(vi);
			goto search_from_foot;
		}
	}

	if(VI_FLAG(lazy) & flags){
		vi->curr = oldcurr;
		vi->currl = oldcurrl;
	}
	return true;
}

/* smell the chacter left side of current
 * @return
 * -1 when at start of the whole text
 *  '\n' when at head of a line
 * asscii value otherwise, infact '\n' belongs to this case
 */
int vi_smelll(struct vi *vi){
	if(vi->curr == vi->lines[vi->currl] ){
		if(vi->currl == 0) return -1;
		else	return '\n';
	}
	return vi->curr[-1];
}

/* smell chacter  right side of current
 * return
 * -1 when EOF on right side or already stand on EOF
 */
int vi_smellr(struct vi *vi){
	if(VI_CURRL_LEN(vi) + 1 == VI_CURR_LEN(vi)){	
		if(vi->currl == vi->lmax) return -1;
		else return vi->lines[vi->currl + 1][0];//at line tail '\n', but within lines
	}
	//very safe, we are within a line
	return vi->curr[1];	/*here may return a '\n', even for the last line*/
}

void vi_gg(struct vi *vi){
	vi->currl = 0;
	vi->curr = vi->lines[vi->currl];
}

void vi_G(struct vi *vi){
	vi->currl = vi->lmax;
	vi->curr = vi->lines[vi->currl];
}

/*@destl destination line number
 */
bool vi_Gn(struct vi *vi, unsigned destl){
	if(destl < 0 || destl > vi->lmax) return false;	//TODO trip >=

	vi->currl = destl;
	vi->curr = vi->lines[vi->currl];
	return 1;
}

/*test if vi->curr is surrounded by ""
 * */
bool vi_inquote(struct vi *vi){
	int dq_complete = 1;
	int q_complete = 1;
	for(char *curr = vi->lines[vi->currl]; curr < vi->curr; curr++){
		if(*curr == '"') dq_complete = !dq_complete;
		else if(*curr == '\'') q_complete = !q_complete;
	}
	return !(dq_complete && q_complete);
}

void vi_reset_m_regs(struct vi *vi){
	for(int i = 'a'; i <= 'z'; i++){
		vi->m_regs[i].currl = -1;
		vi->m_regs[i].curroff = -1;
	}
}

//let vi2 use vi's clipboard
void vi_share_clipboard(struct vi *vi, struct vi *vi2){
	vi2->ylines_fix = vi2->ylines;
	vi2->len_of_yline_fix = vi2->len_of_yline;
	vi2->size_of_yline_fix = vi2->size_of_yline;
	vi2->clipinfo_fix = vi2->clipinfo;

	vi2->ylines = vi->ylines;
	vi2->len_of_yline = vi->len_of_yline;
	vi2->size_of_yline = vi->size_of_yline;
	vi2->clipinfo = vi->clipinfo;
}

bool vi_meet_emptyline(struct vi *vi){
	return vi->len_of_line[vi->currl] == 0;
}

bool vi_meet_spaceline(struct vi *vi){
	for(int i = 0; i < vi->len_of_line[vi->currl]; i++){
		if(!isspace( vi->lines[vi->currl][i])) return false;
	}
	return true;
}











