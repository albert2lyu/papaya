#include<assert.h>
#include"vi.h"
#include"vim.h"
#include"word.h"
#include"file.h"
#include<stdlib.h>
#include<limits.h>

#define bool int
typedef unsigned char u8;
typedef unsigned int u32;
/* 操作全局变量vim*/
static bool is_utf8_leader(char c){
	bool is_leader = (c >> 4) == 0b1110 ;
	return is_leader;
}
static void convert_seg(void){
	assert( 	VI_CURR_LENR(vim)  >= 3   &&
				is_utf8_leader(vim->curr[0]) );

	while(is_utf8_leader(vim->curr[0]) && VI_CURR_LENR(vim) >= 3){
		u32 high = vim->curr[0];
		u32 mid = vim->curr[1];
		u32 low = vim->curr[2];
		assert( (mid >> 6) == 0b10 && (low >> 6) == 0b10);
		u32 unicode = (low & 0b00111111) + 
					  ((mid & 0b00111111) << 6) +
					  ((high & 0b00001111) << 12);
		char *pinyin = pinyin_of[unicode];
		assert(pinyin && "can not find a word in dictionary");

		/* 删除一个汉字，并插入相应的拼音 */
		vim_v();
		vim_l();
		vim_l();
		bool meet_tail = VI_CURR_LENr(vim) == 0 ;
		vim_x();	/*abc小明s\n		==>		abcS\n
					 *abc小明\n			==>		abC\n
					 *小心上面两种情况。 curr落到末尾，可能是被约束回来的，
					 * 也可能不是，像比case 1。
					 */
		if(meet_tail){
			vim_a(pinyin);
		}
		else{
			vim_i(pinyin);
		}
		vim_l();

	}
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
int main(int argc, char *argv[]){
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
	return 0;
}
