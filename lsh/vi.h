#ifndef VI_H
#define VI_H

#include<stdio.h>
#include<assert.h>
#include<stdlib.h>
#include<string.h>
#include"utils.h"

#define VI_CURRL_LEN(vi) (vi->len_of_line[vi->currl])
#define VI_CURRL_LIMIT(vi) (vi->len_of_line[vi->currl] - 1)	//BUG empty line ?
#define VI_CURR_OFFSET(vi) (vi->curr - vi->lines[vi->currl])
#define VI_CURR_LEN(vi) (VI_CURR_OFFSET(vi) + 1)
#define VI_CURR_LENr(vi) (vi->len_of_line[vi->currl] - VI_CURR_LEN(vi))
#define VI_CURR_LENR(vi) (vi->len_of_line[vi->currl] - VI_CURR_LEN(vi) + 1)
/*dangerous macro! you must ensure vi->v_m, v_n, v_head, v_tail valid*/
#define V_HEAD_OFFSET(vi) (vi->v_head - vi->lines[vi->v_m])
#define V_HEAD_LEN(vi) (V_HEAD_OFFSET(vi) + 1)
#define V_TAIL_OFFSET(vi) (vi->v_tail - vi->lines[vi->v_n])
#define V_TAIL_LEN(vi) (V_TAIL_OFFSET(vi) + 1)
#define V_START_OFFSET(vi) V_HEAD_OFFSET(vi)
#define V_START_LEN(vi)	V_HEAD_LEN(vi)

#define __DO_NOT_COMPLAIN 0x123
#define EXCHG_PTR(a, b) do{void *tmp = a; a = (void*)b; b = tmp;} while(0)
#define EXCHG_INT(a, b) do{int tmp = a; a = b; b = tmp;} while(0)

#define Def_vi_op(x)\
	static inline bool vi_op_##x (struct vi*vi){\
		vi->op_id++;\
		if(vi->ops[vi->op_id] == '_'){\
			vi->op_id++;\
			return vi_##x##_(vi);\
		}\
		return vi_##x(vi);\
	}
/*
 * here is a balance:
 * 1, I want to write brief code: i hate writing code like "vi_f(vi, ' ')"
 * , it should be vi->f()
 * 2, However, C don't support 'this', so emulation of 'vi->f()' is expensive
 * using function pointer as structure member
 * So, we use this library in such way:
 * vi_active(vi);	
 * vi_f(' ');
 * ...	
 *
 * It's breif, and light-weight. Usually we don't call vi_active very often
 */

//#define VI_FLAG_SUCC (1<<15)			/*success*/
//#define VI_FLAG_ML	(1<<14)
#define VI_F_CURR 1
#define VI_YLINE_MAX 1024
enum{
	__VI_FLAG_SUCCESS,
	__VI_FLAG_W0,
	__VI_FLAG_meet0,
	__VI_FLAG_meetn,	/*vi里不存在meet0的说法,vi buf里不许出现'\0'*/
	__VI_FLAG_curr,
	__VI_FLAG_ML,
	__VI_FLAG_yy,
	__VI_FLAG_lazy,
	__VI_FLAG_cword,
	__VI_FLAG_noquote
};
#define VI_SET_FLAG(x, vi) (vi->flags |= VI_FLAG(x))
#define VI_CLEAR_FLAG(x, vi) (vi->flags &= (~VI_FLAG(x)))
#define VI_TEST_FLAG(x, vi) (vi->flags & VI_FLAG(x))
#define VI_FLAG(x) VI_MK_FLAG(x, 1)
#define VI_MK_FLAG(x, b) ((b) << (__VI_FLAG_##x)) 

#define __SET_STATE(x) (state |= VI_FLAG(x))
#define __CLEAR_STATE(x) (state &= (~VI_FLAG(x)))
#define __TEST_STATE(x) (state & VI_FLAG(x))
#define __WR_STATE(x, b) (state |= VI_MK_FLAG(x, b))
enum{
	VI_MOD_FREE,
	VI_MOD_BUSY
};
struct mark_register{
	int currl;
	int curroff;
};
struct vi_clipinfo{
	char yy;
	int ylmax;
};
struct vi{
	char *clipboard_buf;
	char *filepath;
	const char *str;
	int currl;
	char *curr;
	int v_beginl;	/* -1 on reset*/
	char *v_begin;	/* 0 on reset */
	int v_m; int v_n;	/*buffer smaller/bigger line for mod 'v'*/
	union{char *v_head; char *v_start;};
	char *v_tail;	/*buffer smaller/bigger anchor for mod 'v',
									to avoid frequent comparing*/


	char **lines;
	union{int *len_of_line; int *len_of_lines;};
	union{int *size_of_line;int *size_of_lines;};
	int lmax;		/*index of the last line*/

	char mod;		/*free=0, busy=1*/
	unsigned flags;

	char **ylines;
	union{int *size_of_yline;int *size_of_ylines;};
	union{int *len_of_yline;int *len_of_ylines;};	
	struct mark_register *m_regs;
	int rep;
	char *ops;	/*op serial buffer for normal operation*/
	unsigned char op_id;			/*when processing, current hot op offset */
	int _errno;
	struct vi_clipinfo * clipinfo;
	char **ylines_fix;
	int *len_of_yline_fix;
	int *size_of_yline_fix;
	struct vi_clipinfo *clipinfo_fix;
};
void VI_LINE_MK(struct vi *vi, int l, char *src, int srclen);
/*i use staic inline in two situation: that function is light enough;  that function is mainly called by library itself, and only in a few occasion*/
static void VI_A_LINES(struct vi *vi, int l, int lnum){
	pchar_arr_a(vi->lines, vi->lmax+1, l, lnum);
	int_arr_a(vi->size_of_line, vi->lmax+1, l, lnum);
	int_arr_a(vi->len_of_line, vi->lmax+1, l, lnum);
	
	for(int i = l+1; i<=l+lnum; i++){
		VI_LINE_MK(vi, i, "", 0);
	}
	vi->lmax += lnum;
}
static inline void vi_o(struct vi*vi){
	VI_A_LINES(vi, vi->currl, 1);
}
void vi_$(struct vi * vi);
void vi_0(struct vi *vi);
bool vi_percent(struct vi*vi);

int vi_y(struct vi *vi);
bool vi_normal(struct vi *vi, char *op);
bool vi_tomark(struct vi *vi, char rid);
bool vi_mark(struct vi *vi, char rid);
struct vi* vi_new( char *str);
struct vi * vi_init(struct vi *vi);
void  vi_set( struct vi* vi, const char *str );
int vi_f( struct vi *vi, char to, ... );
bool vi_jmpspace(struct vi *vi);
bool vi_jmpspace_r(struct vi *vi);
char *jmp_space( char *str );
bool vi_active(struct vi *v);
bool vi_drop(struct vi *v);
void vi_del_within(struct vi *vi);
void vi_del_across(struct vi *vi);
void vi_copy_within(struct vi *vi);
void vi_copy_across(struct vi* vi);
void vi_paste_line(struct vi *vi);
void vi_paste_lines(struct vi *vi);
void vi_del_lines(struct vi * vi);
void vi_delete(struct vi *vi);
void vi_copy(struct vi *vi);
int vi_p(struct vi *vi);
void vi_mk_mn(struct vi *vi);
void VI_LINE_A_SAFE(struct vi *vi, int l, int  at, char *src, int srclen);
void VI_LINE_I_SAFE(struct vi *vi, int l, int at, char *src, int srclen);
void vi_append_at_safe(struct vi *vi, int l, char *at, char *src, int srclen);
void vi_insert_at_safe(struct vi *vi, int l, char *at, char *src, int srclen);
void VI_YLINE_MK(struct vi *vi, int l, char *src, int srclen);
bool vi_x(struct vi *vi);
void vi_mk_head_tail(struct  vi *vi);
struct vi *vim;
char *vi_ops1_9 ;
char*  vi_move_ops;
char*  vi_pair_str;
char*  vi_pair_str2 ;
void vi_insert_safe(struct vi*vi, char *src, int srclen);
void vi_append_safe(struct vi*vi, char *src, int srclen);
int vi_jmpspace_ex(struct vi *vi, int control);
int vi_f_ex(struct vi*vi,   char *group, unsigned flags);
void vi_print(struct vi*vi, int);
static inline void vi_r(struct vi *vi, char new){
	vi->curr[0] = new;		
}
static inline bool vi_h(struct vi *vi){
	if(VI_CURR_OFFSET(vi) >= 1){
		vi->curr--;
		return true;
	}
	return false;
}
static inline bool vi_l(struct vi *vi){
	if(VI_CURR_LEN(vi) < VI_CURRL_LEN(vi)){
		vi->curr++;
		return true;
	}
	return false;
}

static inline void __vi_jk_chgcurr(struct vi *vi,  int newl){
	int nextlen = vi->len_of_lines[newl];
	int newoffset;
	if(nextlen >= VI_CURR_LEN(vi)) newoffset = VI_CURR_LEN(vi) - 1;
	else if(nextlen) newoffset = nextlen - 1;
	else newoffset = 0;

	vi->curr = vi->lines[newl] + newoffset;
}
static inline bool vi_j(struct vi *vi){
	if(vi->currl < vi->lmax){
		__vi_jk_chgcurr(vi, vi->currl + 1);
		vi->currl++;
		return true;
	}
	return false;
}
static inline bool vi_k(struct vi *vi){
	if(vi->currl > 0){
		__vi_jk_chgcurr(vi, vi->currl - 1);
		vi->currl--;
		return true;
	}
	return false;
}
void vi_yy(struct vi*vi);
static void VI_DEL_LINES(struct vi *vi, int l, int lnum){
	assert(l + lnum -1 <= vi->lmax);
	for(int i = l; i < l + lnum; i++){
		if(vi->lines[i]) free(vi->lines[i]);
	}

	pchar_arr_del(vi->lines, vi->lmax + 1, l, lnum);
	int_arr_del(vi->size_of_line, vi->lmax+1, l, lnum);
	int_arr_del(vi->len_of_line, vi->lmax+1, l, lnum);
	vi->lmax -= lnum;
}
void vi_dd(struct vi *vi);






int vi_E(struct vi *vi);
void vi_d$(struct vi *vi);
void vi_d0(struct vi *vi);
bool vi_tom(struct vi *vi, char rid);
bool vi_m(struct vi *vi, char rid);
int vi_d(struct vi *vi);
int vi_op_d(struct vi *vi);
int vi_op_y(struct vi *vi);
void vi_v(struct vi * vi);
 /*Take Care!
  * Here a whole line may be moved to anohter place by realloc, you should know
  * what you are doing :)
  */
static inline void vi_i(struct vi*vi, char *content){
	vi_insert_safe(vi, content, strlen(content));
}
static inline void vi_a(struct vi *vi, char *content){
	vi_append_safe(vi, content, strlen(content));
}
static inline void vi_$0(struct vi *vi){
	vi->curr = vi->lines[vi->currl] + VI_CURRL_LEN(vi);
}
int vi_yW(struct vi *vi);
bool vi_W(struct vi *vi);

bool vi_write(struct vi*vi, char *filepath);
bool vi_open(struct vi *vi, char *filepath);
char *vi_out(struct vi * vi, char *buf);
int vi_filesize(struct vi* vi);
void vi_library_init(void);
int __silent;
//dangerous 'move-to-next-char' operation, it may stop on '\n' in line tail
static inline char * __VI_NEXT(struct vi *vi, int currl, char *curr){
	if(curr[0] != '\n'){	//very safe, we a within a line
		return curr + 1;
	}
	if(currl < vi->lmax) 	//we are standing on line tail, but not the last
		return vi->lines[currl + 1];
	return 0;
}

/*move cursor left by one character*/
static inline void __VI_NEXT_SET(struct vi *vi, int *pcurrl, char **pcurr){
	int currl = *pcurrl;
	char *curr = *pcurr;
	if(curr[0] != '\n'){	//very safe, we a within a line
		(*pcurr) ++;
	}
	else if(currl < vi->lmax) 	//we are standing on line tail, but not the last
	{
		*pcurrl = currl + 1;
		(*pcurr) = vi->lines[currl + 1];
	}	
	else assert(0);
}
static inline char* __vi_next(struct vi *vi, int currl, char *curr){
	if(curr[1] != '\n') return curr + 1;
	else if (currl < vi->lmax) return vi->lines[currl + 1];
	else return 0;
	return (void *)__DO_NOT_COMPLAIN;
}
static inline bool vi_lg(struct vi *vi){
	assert(0);
	return 0;
}
static inline bool vi_H_(struct vi *vi){
	if(vi->curr > vi->lines[vi->currl]){
		vi->curr--;
		return true;
	}
	if(vi->currl > 0){
		vi->currl--;
		vi->curr = vi->lines[vi->currl] + vi->len_of_line[vi->currl];
		return true;
	}
	return false;
}
/*纠结的地方在空行，如果line的长度为０，vim->curr停在哪儿？
 * －－停在换行符上。就是停在line length外面。
 * 当如果最后一行是空行，再停在哪儿？
 * －－停在虚拟的换行符上？　最后一行到底要不要换行符？
 * 最后一个换行符许不许停？但事实上最后一行就没有换行符？这样的话，再停在哪儿？
 *
 *
 *
 * 所以明确最后一行有换行符吧！　并且允许curr停在那儿!
 * 在vim library里，换行符并不表示换行，而是标识一个行的结尾。
 * LG是不会主动挪到最后一个\n的,LG之所以挪到中间行的结尾，是因为那些'\n'可以
 * 认为是文件的一部分。
 * 但LG可能会“不知觉“的挪到最后一行的'\n',如果最后一行的长度是０的话
 * 1,会落到最后一个'\n',认为最后一个'\n'的右侧的EOF
 */
static inline bool vi_L_(struct vi *vi){
	if(vi->curr[0] == '\n'){
		if(vi->lmax == vi->currl){
			return false;
		}
		//we are standing on a line tail, but not the last line
		vi->currl++;
		vi->curr = vi->lines[vi->currl];
		return true;
	} 
	//very safe, we are within a line
	vi->curr++;
	return true;
}

static char *const_vi_blankchars = "\t \n";
static inline bool vi_is_at_blank(struct vi *vi){
	return (int)strchar(const_vi_blankchars, vi->curr[0]);
}
int vi_taste_digit(struct vi*vi);


char *vi_clipboard(struct vi *vi, char *buf);
static inline bool vi_xor(struct vi*vi){
	vi_0(vi);
	int state = vi_jmpspace(vi);
	return !__TEST_STATE(meetn);
}
static inline bool vi_orx(struct vi*vi){
	vi_$(vi);
	return vi_jmpspace_r(vi);
}
static inline bool __IS_BLANK(char c){
	return (int)strchar(const_vi_blankchars, c);
}
/*a c-word is a squene of letters, digit, or underscore
 * this function should be named '__IS_CWORD_ELEMENT'
 * TODO: there should be a faster implementation
 */
static inline bool __IS_CWORD(char c){
	if( (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c<= '9') || (c == '_')) return true;
	return false;
}
static inline bool vi_mvalid(struct vi *vi, char rid){
	if(rid < 'a' || rid > 'z') return 0;
	return vi->m_regs[rid].currl >= 0;
}
static inline char *vi_mcurr(struct vi *vi, char rid){
	if(!vi_mvalid(vi, rid)){
		assert(false);
		return 0;
	} 
	struct mark_register *r = vi->m_regs + rid;
	assert(r->currl <= vi->lmax && r->curroff <= vi->len_of_line[r->currl]);
	return vi->lines[r->currl] + r->curroff;
}

bool vi_B(struct vi *vi);



bool vi_F(struct vi *vi, char c);
void vi_endv(struct vi *vi);
int vi_find(struct vi *vi, char* str, unsigned flags);
void vi_gg(struct vi *vi);
bool vi_instr(struct vi *vi);
bool vi_w(struct vi *vi);
int vi_smelll(struct vi *vi);
int vi_smellr(struct vi *vi);
bool vi_inquote(struct vi *vi);
void vi_reset_m_regs(struct vi *vi);
void vi_G(struct vi *vi);
bool vi_Gn(struct vi *vi, unsigned destl);
void vi_share_clipboard(struct vi *vi, struct vi *vi2);
bool vi_b_(struct vi *vi);
bool vi_B_(struct vi *vi);
bool vi_E_(struct vi *vi);
bool vi_W_(struct vi *vi);
bool vi_w_(struct vi *vi);
bool vi_b(struct vi*vi);
bool vi_e_(struct vi *vi);
bool vi_e(struct vi *vi);
bool vi_meet_emptyline(struct vi *vi);
bool vi_meet_spaceline(struct vi *vi);

#endif
