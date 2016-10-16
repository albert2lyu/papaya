/* TODO 
 * 1, hash的计算是不是统一调用一个接口呢? 为了一点优化, 要冒风险
      hash不一致的bug不好调.
 * 2, wordnum这个参数不那么必要了, 因为utf8字符串里也不会出现0.
      常规的字符串函数都能用.
 */
//#define _GNU_SOURCE
#define _BSD_SOURCE
#include<stdlib.h>

#include<assert.h>
#include"vi.h"
#include"vim.h"
#include"word.h"
#include"file.h"
#include<limits.h>
#include<fcntl.h>
#include<sys/stat.h>

#define bool int
typedef unsigned char u8;
typedef unsigned int u32;
/* 操作全局变量vim*/
static bool is_utf8_leader(char c){
	bool is_leader = (c >> 4) == 0b1110 ;
	return is_leader;
}

/* 随便杂凑, 不知道会有多低效 */
static inline u32 hash_one(u32 hash, u8 c){
	return hash +  c;
}

/* 只比较中文平面的utf8, 即, 3个字节一组的. 别的不考虑 
 * return 0 when equal.
 */
static int utf8strcmp(char *words, char *words2){
	char *word = words;
	char *word2 = words2;
	bool is, is2;
	for(int i = 0; 
		(is = is_utf8_leader(*(word = words+i))) & //NOT &&
		(is2 = is_utf8_leader(*(word2 = words2+i)));
		i+=3)
	{
		if(word[0] == word2[0] && 
		   word[1] == word2[1] &&
		   word[2] == word2[2]);
		else return 1;
	}
	if(!is && !is2) return 0;	//同时遇到了边界
	return 1;					//仅其中一方遇到了边界
}
/* @hash 调用者提前计算好hash,　通常这样更能允许一些优化.
		 hash值实际上是二维数组words_hashtbl的主索引
 * @word 汉字
 */
static inline const struct interp_item * 
find_interp_item(char *words, int wordnum, u32 hash){			assert(hash < UTF8_HASHTBL_LEN);
	const struct interp_item *item;
	int *collision = utf8_hashtbl[hash];
	for(int i = 0; i < UTF8_HASHTBL_LEN2; i++){
		int index = collision[i];	//哈希表存的是interp的索引
		item = &interp[index];
		if(utf8strcmp( words, item->chinese) == 0)
			return item;
	}
	return 0;	
}

static void words2unicodes(u32 *uarray, char *words, int wordnum){
	int i;
	for( i = 0; i < wordnum; i++){
		char *utf8 = words + i * 3;
		u32 high = utf8[0];
		u32 mid = utf8[1];
		u32 low = utf8[2];									assert( (mid >> 6) == 0b10 
																&& (low >> 6) == 0b10);

		u32 unicode = (low & 0b00111111) + 
					  ((mid & 0b00111111) << 6) +
					  ((high & 0b00001111) << 12);
		uarray[i] = unicode;								
	}
	uarray[i] = 0;	//MUST
}

/* 依赖于uarray以0结尾 
 */
static bool mk_pinyin(char pinyin[], u32 *uarray){
	char *fresh = pinyin;
	u32 unicode;
	for(int i = 0; (unicode = uarray[i]); i++){
		const char *pystr = pinyin_of[unicode];					asrt(pystr);	
		fresh = stpcpy(fresh, pystr);		
	}
	return true;
}

static void convert_seg(void){								assert( VI_CURR_LENR(vim)  >= 3   &&
																	is_utf8_leader(vim->curr[0]) );
	bool ok;
	const struct interp_item *item;
	char *insrted;
	u32 hash = 0;
	char *words = vim->curr;		/* 字. 指向这段汉字*/
	int wordnum = 0;;				/* 几个字*/
	bool meet_tail = false;

	#define UARRAY_LEN 32	//unicode array
	u32 uarray[UARRAY_LEN];								
	#define PINYIN_LEN (UARRAY_LEN * 16) //一个字最长16个拼音字母
	char pinyin[PINYIN_LEN];

	vim_v();
	while(is_utf8_leader(vim->curr[0]) ){					asrt(VI_CURR_LENR(vim) >= 3);
		hash = hash_one(hash, vim->curr[0]);
		hash = hash_one(hash, vim->curr[1]);
		hash = hash_one(hash, vim->curr[2]);

		wordnum++;

		vim_l(); vim_l(); 	//我们停在这个utf8的尾字节上了,不要急着挪到下一个字
		if(VI_CURR_LENr(vim) == 0){	//看看是行尾了吗? 
			meet_tail = true;
			break;
		}
		vim_l();			//挪到下一个字
	}

	hash %= UTF8_HASHTBL_LEN;
	/* try translating into english first */
	item = find_interp_item(words, wordnum, hash);
	if(item){
		insrted = item->english;
	}
	//词典里找不到, 那就用拼音字典逐字翻译
	else{													asrt(wordnum < UARRAY_LEN);
		words2unicodes(uarray, words, wordnum);
		ok = mk_pinyin(pinyin, uarray);						if(!ok) exit(1);
		insrted = pinyin;
	}
	
	if(!meet_tail) vim_h();		//确保我们站在这串utf8的最尾字节
								//否则接下来的x操作会多删
	vim_x();	//strong order
	/* 小心上面两种情况。 curr落到末尾，可能是被约束回来的，也可能不是.
	 * abc小明s\n		==>		abcS\n
	 * abc小明\n			==>		abC\n
	 */
	 if(meet_tail){
		vim_a(insrted);
	 }
	 else{
		vim_i(insrted);
	 }
	vim_l();	//插入后, cursor停在新增内容的尾部. 要把它往右挪一下.
}

/* 不接受任何参数，用的是全局的vim,总是转换当前行*/
static void convert_line(void){
	vim_0();
	do{

		if( is_utf8_leader(vim->curr[0]) ){
			convert_seg();	//它结束时，curr总是落在这个seg后的第一个字符
							//如果seg后没有了，则被约束到改行的最后一个字符
		}
		else vim_l();
	}while( VI_CURR_LENr(vim) != 0);
}

static void init_utf8_hashtbl(void);
int main(int argc, char *argv[]){
	init_utf8_hashtbl();

	static bool in_comment = false;
	vi_library_init();
	char *cnfile = argv[1];

	char cn_path[128];
	char cc_path[128];
	printf("argument: %s\n", cnfile);
	assert( realpath(cnfile, cn_path) );
	strncpy(cc_path, cn_path, 127);
	assert( cc_path[ strlen(cc_path) - 1] == 'n');
	cc_path[strlen(cc_path) - 1] = 'c';

	//remove cc file if exists
	remove(cc_path);

	//printf("cc path:%s\n", cc_path);
	assert( filesize(cnfile) > 0 );
	assert( vim_open(cnfile) );
	//printf("%s %s", vim->filepath, vim->lines[0]);
	for(int i = 0; i <= vim->lmax; i++){
		vim_Gn(i);
		if(vim_meet_emptyline()) continue;
		if(vim_meet_spaceline()) continue;

		if(in_comment){		//当前位于注释块内
			assert(vim_orx());
			if(vim->curr[0] == '/' && vim->curr[-1] == '*'){// */注释块的结束
				in_comment = false;
			}
			continue;		/*在comment块里，直接跳过 */
		}

		//当前不处在注释块里
		assert(vim_xor());
		if(vim->curr[0] == '/' && vim->curr[1] == '*'){	// 注释块的起始
			in_comment = true;
			vim_orx();
			if(vim->curr[0] == '/' && vim->curr[-1] == '*') in_comment = false;
			continue;
		}
		else if(vim->curr[0] == '/' && vim->curr[1] == '/'){ // 单行注释，跳过
			continue;
		}
		else{	
			convert_line();
		}

		//printf("%d: %*s\n",vim->currl, 10,  vim->lines[vim->currl]);
//vim->len_of_line[vim->currl],
	}
	assert( vim_write(cc_path) );
	assert( chmod(cc_path, 0555) == 0);
	return 0;
}


/* 计算一个utf8字符串的哈希值 
 * 只要遇到非utf8 leader,就认为结束了
 */
u32 hashutf8(char *words){									assert( is_utf8_leader( words[0]) );
	char *word = words;
	u32 hash = 0;
	while( is_utf8_leader(word[0] ) ){						
		hash = hash_one(hash, word[0]);	
		hash = hash_one(hash, word[1]);	
		hash = hash_one(hash, word[2]);	

		word += 3;
	}
	return hash % UTF8_HASHTBL_LEN;							
}

//存的是interp 表的索引
static bool utf8_hashtbl_store(int value, int hash){
	int *similar = utf8_hashtbl[hash];
	int i;
	for(i = 0; i < UTF8_HASHTBL_LEN2; i++){
		if(similar[i]) continue;
		similar[i] = value;
		return true;
	}
	return false;
}

static void init_utf8_hashtbl(void){
	bool ok;
	const struct interp_item *item;
	for(int i = 0; i < INTERP_TBL_LEN; i++){
		item = &interp[i];
		u32 hash = hashutf8( item->chinese );
		ok = utf8_hashtbl_store( i, hash);					asrt(ok);
	}
}













