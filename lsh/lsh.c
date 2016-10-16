/* 在ubuntu15.04 上，孤儿进程被交给upstart进程，不再是init进程了。
 * 这是lighgdm的一个子进程。杀了它会导致桌面重启。
 */
/* TASK:
 * TODO  
 * 1, wildcard character: *
 *
 * CURRENT 
 * 1, solid script syntax parsing, 
 * 2, vim library
 */

#define _BSD_SOURCE
#include<errno.h>
#include"lsh.h"
#include"vi.h"
#include"vim.h"
#include"file.h"
#include<stdio.h>
//#define _POSIX_C_SOURCE 200112L
//#define _XOPEN_SOURCE 600
#include<stdlib.h>
#include<assert.h>
#include<string.h>
#include<unistd.h>
#include<sys/wait.h>
#include<sys/types.h>
#include<sys/time.h>
#include<sys/resource.h>
#include<sys/wait.h>
//#include"preprocess.h"
#include<readline/readline.h>
#include<readline/history.h>
#include<setjmp.h>
static struct{
	bool active;
	int fds[2];
	char *text;
	int textlen;
}tail_pipe;

static bool __hide_prompt = false;

static int __call_run_cmdline(lua_State *L);
static int process_if();
static int process_colon();

const char const  *history_file  = ".lsh.history";
int __cmdcount;
int _argc;
char* _argv[128];	/*for usr process*/
int __lshmod = LSH_MOD_LUA;
char *__lshprefixArr[]={
	[LSH_MOD_LUA] = "$ ",
	[LSH_MOD_CMD] = "$` ",
	[LSH_MOD_VI] = "$@ "
};
char input_head[64];
struct vi __luavi;
struct vi *luavi = &__luavi;
lua_State *L;
char *readline_buf = 0;/*write to key-buffer of 'readline ' is dangerous*/
/* linux对signal的处理比较奇怪。
 * 一个signal响应之后，它会清除原先注册的handler。所以要再注册一次。
 */
sigjmp_buf new_prompt;
void  sighandler_ctrl(int x){
	printf("\nto quit lsh, type 'exit'\n");
	signal(SIGINT, sighandler_ctrl);
	siglongjmp(new_prompt, 1);
}
/*1, will keep lua's main stack balanced, no footprint leaved
 */
static bool lsh_sync_env(){
	int esp_backup = lua_gettop(L);
	lua_getglobal(L, "Env");	/*stack: Env*/
	lua_pushnil(L);		/*stack: Env  nil */
	while(lua_next(L, -2)){	//stack: Env key value
		const char *name = lua_tostring(L, -2);
		const char *value = lua_tostring(L, -1);
		if(!value) goto next;
			
		/* don't use putenv here,for  we need make a memory copy  of 'name', 'value'
		 * , we can't store a pointer returned by lua_tostring() outside a function 
		 */
		if( setenv(name ,value, 1) != 0 ) {
			lua_settop(L, esp_backup);
			return false;
		}
		next:
		lua_pop(L, 1);	/*stack: Env key */
	}

	lua_settop(L, esp_backup);
	return true;
}

static bool lsh_cd(char *path){
	int err = chdir(path);
	if(err){
		fprintf(stderr, "%s\n", strerror(errno));
	}
	return !err;
}
static char *homedir;
char lshdir[128];

static char *get_dirfile_danger(char *dir, char *filename){
	char fullpath[128];
	return get_dirfile(dir, filename, fullpath);
}

static char *get_lshfile(char *filename){
	return 0;
}

static char *get_homefile(){
	return 0;
}
int open_editor(int a, int b){
	printf("hello world\n\n");
	system("vim");
	printf("vim return !!");
	return 0;
}
static bool you_throw_me_a_script(int argc, char **argv){
	if(argc >= 2){
		char *filepath = argv[1];	
		if( file_exists(filepath) ) return true;
	}
	return false;
}

//暂时假设lsh有两个命令行选项，-s 和 -d。
static bool is_lsh_option(char *name){
	if(strcmp(name, "-s") == 0	||
	   strcmp(name, "-d") == 0 ) 
		return true;
	
	return false;

}

//argv of lsh: /bin/lsh  ./test.lua arg1 arg2
//pass to script as: ./test.lua arg1 arg2
static void prepare_lua_args(struct lua_State *L, int argc, char *argv[]){
	lua_pushinteger(L, argc - 1);
	lua_setglobal(L, "argc");
	lua_newtable(L);
	for(int i = 1; i < argc; i++){
		lua_pushinteger(L, i - 1);
		lua_pushstring(L, argv[i]);
		lua_rawset(L, -3);
	}
	lua_setglobal(L, "argv");
}

int main(int argc, char *argv[]){
	char input[1024]={0};
	char purelua[1024] = {0};
	homedir = getenv("HOME");
	get_dirfile(homedir, "lsh/", lshdir);
	char historyfile[128];
	get_dirfile(lshdir, (char *)history_file, historyfile);
	//printf("%s\n", homedir);
	signal(SIGINT, sighandler_ctrl);
	rl_bind_keyseq("\\C-J", open_editor);
	tail_pipe.active = false;
	vi_library_init();
	L = luaL_newstate(  );	/*opens Lua*/
	luaL_openlibs( L );					/* opens the standard libraries */
	lua_pushcfunction(L, __call_run_cmdline);
	lua_setglobal(L, "run_cmdline");
	register_vi(L);
	/*load config file to prepare usr enviroment and lsh state itself*/
	char initfile[128];
	get_dirfile(lshdir, "init.lua", initfile);
	//fprintf(stderr, "%s\n", initfile);
	int err = luaL_loadfile(L, initfile); assert(!err);
	err = lua_pcall(L, 0, LUA_MULTRET, 0);
	if(err){
		fprintf( stderr, "%s\n", lua_tostring( L, -1 ) );
		assert(0);
	}
	lua_getglobal(L, "Env");	/*stack: env*/
	lua_getfield(L, -1, "lshmod");	/*stack: env lshmod */
	lua_getfield(L, -1, "default");	/*stack: env lshmod .default*/
	__lshmod = lua_tointeger(L, -1);
	/* config end */

	read_history(historyfile);
	//如果是以bash xxx运行的，xxx如果不是一个命令行参数，那就认为它是脚本名字
	//脚本名字必须写在第一个参数
	bool script_mode = false;
	if(argc >= 2){
		if(is_lsh_option( argv[1] )) ;
		else if( file_exists( argv[1] ) == false ){
			fprintf(stderr, "lsh: %s: no such file or directory\n", argv[1] );
			return 3;
		}
		else script_mode = true;
	}

	if(script_mode ){
		readline_buf = malloc(PATH_MAX + strlen("source ") );	//必须用malloc
		strcpy(readline_buf, "source ");
		strcat(readline_buf, argv[1]);
	}

	while( 1 ){
		char prompt[64];
		char *curr_input = input;
		
		//if, and only if..
		//只有当svaesigs flag不为0时，行为才是正常的。
		//否则响应一次ctrl-c之后，就再不响应了。再看。
		//memset(&new_prompt, 0, sizeof(new_prompt));
		sigsetjmp(new_prompt, 1);
		while(!readline_buf ){
			char empty[32] = {0};
			readline_buf = readline(
							strcat(__hide_prompt ? empty : getcwd(prompt, 64), 
									__lshprefixArr[__lshmod]) 
						   );
			if(readline_buf[0] == 0){	//用户没输入内容就按了Enter
				free(readline_buf);
				readline_buf = 0;
			}
		}
		//printf("got realine_buf:%p\n", readline_buf);
		//printf("and it contains data\n");
		strcpy(input, readline_buf);
		add_history( readline_buf );	//TODO 脚本不该污染历史命令
		write_history(historyfile);
		free(readline_buf);
		readline_buf = 0;

		if (strncmp(input, "source ", strlen("source ")) == 0){
			vim_open(input+strlen("source "));
			curr_input=0;
		}
		else if (strncmp(input, "cd ", strlen("cd ")) == 0){
			lsh_cd(input + strlen("cd "));
			continue;
		}
		else if(strcmp(input, "mod vi") == 0){
			__lshmod = LSH_MOD_VI;
			continue;
		}
		else if(strcmp(input, "mod lua") == 0)	{
			__lshmod = LSH_MOD_LUA;
			continue;
		}
		else if(strcmp(input, "mod cmd") == 0){
			__lshmod = LSH_MOD_CMD;
			continue;
		}
		else if(strcmp(input, "hide prompt") == 0){
			__hide_prompt = !__hide_prompt;
			continue;
		}
		else if(strcmp(input, "exit") == 0)
			exit(0);
		else if(strcmp(input ,"silent") == 0){
			__silent = !__silent;
			continue;
		}
		else;

		if(__lshmod == LSH_MOD_VI){
			//printf("processing vim script\n");
			char buf[64];
			sprintf(buf, "vim:normal(\"%s\")", input);
			strcpy(input, buf);
		}
		else if(__lshmod == LSH_MOD_LUA){
		//	strcpy(purelua, input);
		}
		else if(__lshmod == LSH_MOD_CMD){
			memmove(input+1, input, strlen(input) + 1);
			input[0] = '`';
		}
		else assert(0);

		if( !mix2lua(curr_input, purelua) ){
			printf("\npreprocess failed\n");
			if(script_mode) return -1;
			else	continue;	
		}
		if(!__silent) printf("purelua: >>>%s<<<", purelua);

		if(script_mode) prepare_lua_args(L, argc, argv);

		int error = luaL_loadstring( L, purelua ) || lua_pcall( L, 0, 0, 0 );
		if( error ){
			fprintf( stderr, "%s\n", lua_tostring( L, -1 ) );
			lua_pop( L, 1 ); 

			if(script_mode) return -1;
		}
		if(script_mode) return 0;
	}
}
/*break:userdata的问题已经解决了，挺绕的，进ｃ时，ｌｕａ压栈的不是userdata,而是userdata的地址，二userdata存储的又是struct vi的地址．虽然解决了，但realloc还是除错．估计跟lua层无关，应该是malloc　init vi引发的．
１，用malloc0试试．
２，解决了１之后，一定要让userdata直接存struct vi,这样很＂美"．*/
int __call_vi_new(lua_State *L){
	struct vi*vi = lua_newuserdata(L, sizeof(struct vi));	/*stack: ud */
	vi_init(vi);

	lua_getglobal(L, "Vi");		/*ud Vi*/
	assert(!lua_isnil(L, -1));
/*	luaL_newmetatable(L, "Vi");*/
	lua_setmetatable(L, -2);	/*ud */

	return 1;
}

int __call_vi_share_clipboard(lua_State *L){
	struct vi*vi = lua_touserdata(L, 1);
	struct vi * vi2 = lua_touserdata(L, 2);

	vi_share_clipboard(vi, vi2);
	return 0;
}
/*break:先把set导出到lua里,别的照样子做就行了 不需要getter,setter表，通通注册成函数，暂时不考虑__newindex*/
/*caller stack: R["lmax"], userdata, "max"*/
int __onindex_vi_lmax(lua_State *L){	/*stack: ud "lmax" */
	/*how to guarantee this userdata valid: it's possible, since this function
	 * invoked as a metemethod */
	struct vi *vi = lua_touserdata(L, 1);
	
	lua_pushinteger(L, vi->lmax);
	return 1;
}
int __onindex_vi_errno(lua_State *L){	/*stack: ud "lmax" */
	/*how to guarantee this userdata valid: it's possible, since this function
	 * invoked as a metemethod */
	struct vi *vi = lua_touserdata(L, 1);
	
	lua_pushboolean(L, vi->_errno);
	return 1;
}
int __onindex_vi_currc(lua_State *L){	/*stack: ud "currc" */
	struct vi *vi = lua_touserdata(L, 1);
	
	lua_pushinteger(L, vi->curr[0]);
	return 1;
}

int __onindex_vi_currl(lua_State *L){	/*stack: ud "lmax" */
	/*how to guarantee this userdata valid: it's possible, since this function
	 * invoked as a metemethod */
	struct vi *vi = lua_touserdata(L, 1);
	lua_pushinteger(L, vi->currl);
	return 1;
}

/*invoked by: vim:set("sdf") */
/*注意，这不是通过__index触发的方法，这个方法它是在元表里找到的，名字都一样,
 *　c函数得到的userdata,也是人家通过":"语法糖传递的self*/
/*caller stack:registry[set] userdata str */
int __call_vi_set(lua_State *L){	/*stack: self str */
	struct vi*vi = lua_touserdata(L, 1);
	const char *str = lua_tostring(L, 2);
	assert(str);
	/*we can do safety check here*/
/*	unsigned ud = *(unsigned *)ud_addr;*/
/*	struct vi *vi = (void *)ud;*/
	vi_set(vi, str);
	return 0;
}
int __call_vi_find(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);	
	char *pattern = (char *)lua_tostring(L, 2);
	unsigned flags = lua_tointeger(L, 3);

	bool ret = vi_find(vi, pattern, flags);

	lua_pushboolean(L, ret);
	return 1;
}

int __call_vi_Gn(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);	
	int lnumber = lua_tointeger(L, 2);

	bool ret = vi_Gn(vi, lnumber);

	lua_pushboolean(L, ret);
	return 1;
}
int __call_vi_v(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);	
	vi_v(vi);
	return 0;
}
int __call_vi_x(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);	
	vi_x(vi);
	return 0;
}

int __call_vi_endv(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);	
	vi_endv(vi);
	return 0;
}

int __call_vi_E(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);	
	int ret = vi_E(vi);
	lua_pushboolean(L, ret);
	return 1;
}
int __call_vi_B(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);	
	int ret = vi_B(vi);
	lua_pushboolean(L, ret);
	return 1;
}
int __call_vi_W(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);	
	int ret = vi_W(vi);
	lua_pushboolean(L, ret);
	return 1;
}

int __call_vi_h(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);	
	int ret = vi_h(vi);
	lua_pushboolean(L, ret);
	return 1;
}
int __call_vi_j(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);	
	int ret = vi_j(vi);
	lua_pushboolean(L, ret);
	return 1;
}
int __call_vi_k(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);	
	int ret = vi_k(vi);
	lua_pushboolean(L, ret);
	return 1;
}
int __call_vi_l(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);	
	int ret = vi_l(vi);
	lua_pushboolean(L, ret);
	return 1;
}
int __call_vi_clipboard(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);	
	lua_pushstring(L, vi_clipboard(vi, 0));
	return 1;
}
int __call_vi_normal(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);
	char *str = (char *)lua_tostring(L, 2);
	
	int ret = vi_normal(vi, str);
	lua_pushboolean(L, ret);
	return 1;
}

/*因为__index方法只有一个，而缺失的属性很多，__index就负责在getter表里找到对应的注册
 * 函数并调用它*/
/*stack: ud, key */
int __onindex(lua_State *L){
/*	struct vi *vi = lua_touserdata(L, 1);*/
	char *key = (char *)lua_tostring(L, 2);
	lua_getmetatable(L, 1);	/*ud key mt*/
	lua_pushstring(L, "getter");	/*ud key mt "getter" */
	lua_rawget(L, -2);	/*ud key mt mt.getter  */	assert(!lua_isnil(L, -1));
	lua_getfield(L, -1, key);	/*ud key mt mt.getter getter.key */
	if(lua_isnil(L, -1)){
		/*turn to search as a function */
		lua_pop(L, 2);	/*ud key mt */
		lua_getfield(L, -1, key);	/*ud key mt mt.key*/
		return 1;
	}
	lua_pushvalue(L, 1);	/*ud key getter getter.key ud*/
	lua_pushvalue(L, 2);	/*ud key getter getter.key ud key */
	int err = lua_pcall(L, 2, 1, 0);	/*ud key getter ret */
	if(err){
		fprintf(stderr, "terrible: C library of Vi goes wrong:%s\n",lua_tostring(L, -1));
	}	
	return 1;
}
static int __call_vi_open(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);	
	char *filepath = (char *)lua_tostring(L, 2);
	bool ret = vi_open(vi, filepath);
	lua_pushboolean(L, ret);
	return 1;
}

static int __call_vi_out(lua_State *L){
	char buf[1024];	//这儿会有bug,你不知道out多少?
	struct vi *vi = lua_touserdata(L, 1);	
	//char *filepath = (char *)lua_tostring(L, 2);
	char *b = vi_out(vi, buf);								assert(b);
	lua_pushstring(L, buf);
	return 1;
}

static int __call_vi_write(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);	
	char *filepath = (char *)lua_tostring(L, 2);
	bool ret = vi_write(vi, filepath);
	lua_pushboolean(L, ret);
	return 1;
}
static int __call_vi_taste_digit(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);	
	lua_pushinteger(L, vi_taste_digit(vi));
	return 1;
}
static int __call_vi_print(lua_State *L){
	struct vi *vi = lua_touserdata(L, 1);	
	for(int i = 0; i <= vi->lmax; i++){
		printf("%.*s", vi->len_of_line[i], vi->lines[i]);
	putchar('\n');
	}
	return 0;
}
static int __call_run_cmdline(lua_State *L){
	char *cmdline = (char *)lua_tostring(L, -1);
	int ret = run_cmdline(cmdline);
	int nr_ret = 0;
	if(tail_pipe.active){
		nr_ret++;
		lua_pushlstring(L, tail_pipe.text, tail_pipe.textlen-1);	
		//if(ret != 0) lua_pushnil(L);
		//else{
			//lua_pushlstring(L, tail_pipe.text, tail_pipe.textlen-1);	
			//TODO i want to trip off the final '\n', so change [textlen ]
			// to [textlen -1 ] for temporary.
		//}

		tail_pipe.active = false;
		close(tail_pipe.fds[0]);
		free(tail_pipe.text);
	} 

	lua_pushinteger(L, ret);
	lua_setglobal(L, "errno");
	
	//lua_pushvalue(L, -1);
	return nr_ret;
}
/*break:__onindex做好了，接下来往getter里注册__onindex_xx，并把getter表注册到ｍｔ里*/
void register_vi(lua_State *L){
	luaL_newmetatable(L, "Vi");	/*mt */	
	luaL_newmetatable(L, "Vi");	/*mt mt*/	
	lua_pushcfunction(L, __onindex);	/*mt mt __onindex */
	lua_setfield(L, -2, "__index");	/*mt mt*/	//assign mt.__index = __onindex

	lua_setglobal(L, "Vi");	/*mt */			//assign GLOBAL["Vi"] = mt
	lua_newtable(L);	/*mt getter*/
	lua_pushvalue(L, -1);	/*mt getter getter */
	lua_setfield(L, -3, "getter");	/*mt getter */	//assign mt.getter=new tbl

	lua_pushcfunction(L, __onindex_vi_lmax);
	lua_setfield(L, -2, "lmax");

	lua_pushcfunction(L, __onindex_vi_errno);
	lua_setfield(L, -2, "errno");

	lua_pushcfunction(L, __onindex_vi_currc);
	lua_setfield(L, -2, "currc");

	lua_pushcfunction(L, __onindex_vi_currl);
	lua_setfield(L, -2, "currl");

	lua_pop(L, 1);		/*mt */
	lua_pushcfunction(L, __call_vi_new);
	lua_setfield(L,  -2, "new");

	lua_pushcfunction(L, __call_vi_set);
	lua_setfield(L, -2, "set");

	lua_pushcfunction(L, __call_vi_set);
	lua_setfield(L, -2, "load");

	lua_pushcfunction(L, __call_vi_normal);
	lua_setfield(L, -2, "normal");

	lua_pushcfunction(L, __call_vi_open);
	lua_setfield(L, -2, "open");

	lua_pushcfunction(L, __call_vi_out);
	lua_setfield(L, -2, "out");

	lua_pushcfunction(L, __call_vi_write);
	lua_setfield(L, -2, "write");

	lua_pushcfunction(L, __call_vi_taste_digit);
	lua_setfield(L, -2, "atoi");

	lua_pushcfunction(L, __call_vi_clipboard);
	lua_setfield(L, -2, "clipboard");

	lua_pushcfunction(L, __call_vi_h);
	lua_setfield(L, -2, "h");

	lua_pushcfunction(L, __call_vi_k);
	lua_setfield(L, -2, "k");

	lua_pushcfunction(L, __call_vi_l);
	lua_setfield(L, -2, "l");

	lua_pushcfunction(L, __call_vi_j);
	lua_setfield(L, -2, "j");

	lua_pushcfunction(L, __call_vi_W);
	lua_setfield(L, -2, "W");

	lua_pushcfunction(L, __call_vi_B);
	lua_setfield(L, -2, "B");

	lua_pushcfunction(L, __call_vi_E);
	lua_setfield(L, -2, "E");

	lua_pushcfunction(L, __call_vi_v);
	lua_setfield(L, -2, "v");
	lua_pushcfunction(L, __call_vi_x);
	lua_setfield(L, -2, "x");

	lua_pushcfunction(L, __call_vi_endv);
	lua_setfield(L, -2, "endv");

	lua_pushcfunction(L, __call_vi_find);
	lua_setfield(L, -2, "find");

	lua_pushcfunction(L, __call_vi_print);
	lua_setfield(L, -2, "print");

	lua_pushcfunction(L, __call_vi_Gn);
	lua_setfield(L, -2, "Gn");

	lua_pushcfunction(L, __call_vi_share_clipboard);
	lua_setfield(L, -2, "share_clipboard");
}

void export_vi(lua_State *L){
	/*export vim later*/
/*	vi_init(luavi);*/
}

void process$(char lineflag){
	assert(vim->curr[0] == '$');
	vim_x();		/*make right side double-quotation */
	vim_i("]]..");

	//vim_a("..tostring");		//boolean无法隐式的被..连接。但number可以。
								//所以暂时就不用tostring了
	vim_f('(');		vim_m('l');
	vim_percent();  vim_m('r');
	vim_a("..[[");
	
	if(lineflag == '@'){
		//TODO 既然支持表达式变量，就帮用户加个()。以免and or的时候语法歧义
		//vim_normal("F)hvl%lyh%");
		vim_normal("`llv`rhy");		//拷贝变量表达式到剪贴板
		vim_a(" == 0 and '\\127' or ");	//TODO　若i是字符串０呢？
		vim_p();
	}
	return;
}
/*关键是怎么执行script文件，./test.lsh，是交给操作系统，还是lsh自己处理.
 * 参考./test.sh的执行方式．　bash是把./test.sh当cmd,让系统fork出来一个
 * 新的bash进程执行, 把./test/sh当参数传给它，相当于执行bash ./test.sh
 * 2, source ./test.sh则是当前bash进程直接执行test.sh
 * 3,如果不用source，./test.sh怎么改变Env呢
 * 这句话讲的很好：子进程仅会继承父进程的环境变量，不会继承自定义变量，
 * export就是将自动能够已变量转化称环境变量*/

/*用户在cmd模式下执行echo $var，可见不管在什么模式下，都要先转化成pure lua,
 * 再让lua传给命令执行部件*/
/*support user write C-style code like:
 * if(a > b)		|	if a > b then
 * 		a=123       |		a=123
 * 		b=123       |		b=123
 * 	elseif(a == b)  |	elseif a == b then 
 * 		a=123       |		a=123
 * 		b=123       |		b=123
 * 	else a=123;     |	else a=123	end  		
 */
/*@ initial vim state required: shall stand on '(' of "if/for(xxx)"
 */
static int trip_pairs_core(char *replacer){
		/*process begin*/
		vim_m('a');
		vim_percent();
		vim_r(' ');
		vim_a(replacer);
		vim_tom('a');
		vim_r(' ');
		return 1;
}
/* let vim goto next pattern 'if ('.
 * @control can be 'if', 'while', 'for'
 * @cursor fall over '(' if success, keep old otherwise
 * 
 * well, if we had implemented vim_search already,  things would be easy now
 */
static bool goto_control_pair(char *control){
	char *curr = vim->curr;
	int currl = vim->currl;
	while(vim_find(control, VI_FLAG(cword) | VI_FLAG(noquote))){
		vim_w();
		if(vim->curr[0] != '(') continue;
		return true;
	}
	vim->curr = curr;
	vim->currl = currl;
	return false;
}
/*@control  'if', 'for', 'while'
 *@replacer 'do ', 'then '		Note, tail space required.
 *@return how many 'control' we  processed in total?
 */
static int process_if(){
	while(goto_control_pair("if")){

		trip_pairs_core("then ");	/*generate: if xxx then*/
		vim_m('p');		/*necessary, because we may go out of this if-block*/
		if(goto_control_pair("elseif")){
			trip_pairs_core("then ");	//convert: elseif(xx) => elseif xx then
			vim_tom('p');
		}
		if(!vim_find(";", VI_FLAG(noquote))){
			//这个地方的报错很不准确，这里该写专门的函数定位错误，反正
			//已经除错退出了，就不在乎性能了
			fprintf(stderr, "';' missed for block:%.*s\n",vim->len_of_line[vim->currl], vim->lines[vim->currl]);
			return 0;
		}
		vim_r(' ');
		vim_a("end");	//convert: xx;  => 	xx end
	}
	return 1;
}

#if 0
/*@argument none. Here use default global variable 'vim'
 * 1, TODO ":" appeared in [[]] will be wrong parsed
 */
static int process_colon(){
	vim_gg();
	for(int i = 0; i <= vim->lmax; i++){
		vim_Gn(i);
		vim_xor();
		if(vim->curr[0] != '@') continue;
		//suppose this line appear like this: "< hjkl> --here is commentary"

		vim_x();				// hjkl> --here is commentary
		vim_i("vim:normal(\"");//vim:noraml("  hjkl > --here is commentary

		int end_pair = 0;
		while(vim_f(':')) end_pair++;
		if(end_pair){
			vim_r(' ');			//vim:normal("  hjkl  --here is commentary
			vim_h();			
		}
		else{
			vim_$();				
		}
		vim_a("\")");			//vim:normal("  hjkl")  --here is commentary
	}
	return 1;
}
#endif

#if 0
static void do_escape(void){
	while( vim_f_ex(STR_QUOT"\\", 0) ){
		vim_i("\\");
		vim_l();
		vim_l();
	}
}
#endif
/* The core preprocess: convert mixed-lua-cmd code to pure luacode 
 * @mixbuf	0: pass 0 if vim already adopt mix-code
 * TODO 1, $ in a string
 * 2,BUG mix末尾如果有空格，会崩溃 source ssdfX, X不能是空个
 *> TODO 现在不支持`和@行的行尾注释。以后做。　这很有用。
 */
int mix2lua(char *mixbuf, char *luabuf){
	if(mixbuf){
		vim_set(mixbuf);
	}
	if(vim->curr[0] == '#' && vim->curr[1] == '!'){
		vim->curr[0] = vim->curr[1] = '-' ;
		vim_j();
	}
	
	char lineflag = 0;
	do{
		vim_xor();
		if( (lineflag = vim->curr[0]) != '`' && lineflag != '@')
		{
			vim_orx();
			if( (lineflag = vim->curr[0])!= '`' && lineflag != '@') continue;
			else{
				if(lineflag == '`')		vim_r('|');
				else if(lineflag == '@') vi_d$(vim);
				else assert(0);

				vim_0();
				bool ok = vim_f('=');	assert(ok);
				vim_l();	vim_jmpspace();
				assert(vim->curr[0] = lineflag);
			}
		}
		/*we stand on ` or @ now */
		if(lineflag == '`')  vim_i("run_cmdline(");	
		else if(lineflag == '@') vim_i("vim:normal(");
		else assert(0);		//TODO 太胆小了?

		vim_l();
		vim_x();	vim_i("[[");
		while(vim_f('$')){
			if(vim->curr[1] != '(') continue;
			process$(lineflag);
		}
		vim_$();
		vim_a("]]");
		/*core operation finished */
		vim_normal("$a)");
	}while(vim_j());
	vim_gg();
	if( !process_if() ) return false;
	//process_colon();
	vim_out(luabuf);
	char tmpbuf[128];
	get_dirfile(lshdir, "volatile.lua", tmpbuf);
	vim_write(tmpbuf);
	return true;
}
/* 
 * ignore this comment line:@vi vi->curr is a pointer to the first character of command string:
 * eg. cp test.txt test.txt.cp | ..  then,tail flag is '|'
 * eg. cp test.txt test.txt.cp 		then,tail flag is '\0'
 *
 * @return 0:failed;	>=0		成功解析一段命令。返回命令结束标志
 						-2		解析失败（命令格式语法错误)
						-1		解析失败（遇到行尾了且都是空白字符)
 						
 * @OLD after process a command 'line', this function set vi->curr at the tail of
 * this command 'line', namely a '|' or '\n', and convert it to '\0';  he does
 * not tell the parent whether exist another command 'line' behind.
 * */
// TODO 这个函数该增强一些，遇到裸|之类的语法错误该标识出来，提示语法错误
// @退出状态
// 成功解析一个命令。  退出时一定落在“命令行结束标志”: 管道符| 或者 EOL。
// 这对调用它的build_lsh_commands很重要。
// !! 放低对错误语法的检测。 先写最清晰的流程，只考虑正常的语法。对错误的语法
// !! 能基本定位，并避免异常就行了。
#define EMPTY_UNTIL_EOL -1
#define CMD_SYNTAX_BAD  -2
int  build_lsh_cmd(//struct vi *vi,
					struct lsh_cmd *command){
	command->argc = 0;
	bool ok;
	ok = vim_jmpspace();
	if(!ok && vim->_errno == E_meetn)	return EMPTY_UNTIL_EOL;
	// 现在可以确定跳过命令行最前面的空白了。而且是落在一个实在的命令上。
	// 当然，如果用户最开始输入一个"|"，此处是检查不出来的。

	while(1){
		//每一个loop开始，都是停留在有效命令的起始非空字符上
		char *seghead;
		char *segtail;
		if( strchar(STR_QUOT, vim->curr[0]) ){	//若有引号，一定在seg首
			seghead = vim->curr+1;
			ok = vim_f( vim->curr[0] );
			//一定有匹配的右引号； 右引号右面一定是空白或结束字符(单词边界)
			assert(ok);	assert( strchar(" \t|"STR_EOL, vim->curr[1]) );
			segtail = vim->curr;

			vim->curr++;	//推进到右引号右侧，一变接下来统一跳过空白
		}
		else{
			seghead = vim->curr;
			vim_f_ex("\t |"STR_EOL, 0);		//1,一定会成功；2，需要curr标志吗
			segtail = vim->curr;
		}
		command->argv[command->argc++] = seghead;

		//如果停在空白字符上，看看是不是紧邻着管道符| 或者EOL了。
		//如果是，推进到上面去，及早的结束，别等到下一个loop了。
		while(*vim->curr == ' ' || *vim->curr == '\t')	vim->curr++;		
		//现在停在非空白字符上了
		char standon = *vim->curr;
		*segtail = 0;		//这一句可能改写vim->curr，所以备份*curr到standon

		if(standon == '|' || standon == EOL){
			command->argv[command->argc] = 0;	
			return standon;
		}

		//现在停在空白字符上，但该命令行可能已经读完了。
		//几种情形: (.表示现在的落脚点)
		//  ps. -e  \n					常规情形
		//	ls.     \n					一段空格之后，是EOL
		//	ps -e.   | grep xxx  \n 	一段空格之后，是管道|
	}
	return 12345;
}
/*@return (command count): build how many lsh-cmd structure*/
/* eg.  cat * -R | grep 'debug'|wc -l	*/
int build_lsh_cmds(char *input, struct lsh_cmd *lsh_cmds){
	vim_set(input);

	vim_orx();
	if(vim->curr[0] == '|'){
		assert(tail_pipe.active == false);
		pipe(tail_pipe.fds);	//TODO when will a pipe closed ? manually?
		tail_pipe.active = true;
		tail_pipe.text = malloc(0x100000 * 10);
		if(!tail_pipe.text) fprintf(stderr, "malloc tail pipe failed\n");
		tail_pipe.text[0] = 0;
		vim->curr[0] = ' ';
	}
	vim_0();

	int i = 0;
	while(1){
		bool ret = build_lsh_cmd(lsh_cmds + i);
		if(ret == '|') i++;			//管道右方还有一个
		else if(ret == EOL) {		//最后一个命令段
			i++;
			break;
		}
		else if(ret == EMPTY_UNTIL_EOL) break;	
		else assert(0 && "what ? ");
		assert(i != LSH_CMD_MAX);
		vim_l();
	}
	return i;
}

//不一定要反向创建，只要有晚些关闭父进程的read端就行了 .
int run_cmdline(char *input){
	int fork_ret;
	int ret;
	int free_pipefd[LSH_CMD_MAX * 2];	/*bug 'char' here?*/
	int *l_pipefds =0;
	int *r_pipefds = 0;
	int cmdnr = build_lsh_cmds(input, lshcmds);	
	if(cmdnr < 1) return 1;	//here should removed outside this function

	int cmd_id_max = cmdnr - 1;

	for (int cmd_id = cmd_id_max; cmd_id >= 0; cmd_id--){
		struct lsh_cmd *cmd  = lshcmds + cmd_id;
		/*如果只有一个进程(或者现在就是最右边的进程)，就不要dup2 rpipefd到
			  １了,所以检查一下右侧害有没有进程*/
		if(cmd_id != 0){
			int *pipefds = free_pipefd + cmd_id * 2;/*alloc pipe fd[2]*/
			pipe(pipefds);	/*syscall pipe() create a file in memory, and let
							  two fd point it, one read, one write([0],[1])*/
			l_pipefds = pipefds;
		}
		if((fork_ret = fork()) == 0){	/*child process 1*/
			/*try link to left pipe*/
			if(l_pipefds){		/*read from left pipe*/
				close(l_pipefds[1]);
				dup2(l_pipefds[0], 0);	/*fd 0 automatically closed by dup2*/
				close(l_pipefds[0]);
			}
			if(r_pipefds){	/*write to right pipe*/
				close(r_pipefds[0]);
				dup2(r_pipefds[1], 1);
				close(r_pipefds[1]);
			}
			else{
				if(tail_pipe.active){
					dup2(tail_pipe.fds[1], 1);
				}
			}
			/*good bye... new life*/
			//if(!__silent) fprintf(stderr, "%d> run:%s ", getpid(), fullpath);
			#if 0
			for(int i = 0; i < cmd->argc; i++){
				if(!__silent) fprintf(stderr, "%d:<%s>  ",i, cmd->argv[i]);
			}
			#endif
			if(!__silent) fprintf(stderr, "\n");
			/* execvp
			 * we save much effort, this interface can search command using current
			 * enviroment's PATH, and let the new process inherit current environ-
			 * ment.  But we need keep 'environ' sychronized with lua firstly.
			*/
			lsh_sync_env();
			ret = execvp(cmd->argv[0], cmd->argv);
			fprintf(stderr, "%s\n", strerror(errno));
			exit(ret);	/*shouldn't flow to here*/
		}
		if(l_pipefds) close(l_pipefds[0]);
		if(r_pipefds) close(r_pipefds[1]);

		r_pipefds = l_pipefds;
		l_pipefds = 0;
	}
	if(tail_pipe.active){
		int bytes = read(tail_pipe.fds[0], tail_pipe.text, 0x100000*10);
		if(bytes == -1){
			fprintf(stderr, "%s\n", strerror(errno));
		}
		tail_pipe.textlen = bytes;
		tail_pipe.text[bytes] = 0;
	}
	signal(SIGINT, SIG_IGN);
	int status;
	int errcode = 0;
	while( wait4(-1, &status, 0, 0) != -1){
		int exit_code;
		if(WIFEXITED(status)){	//exit normally
			exit_code = WEXITSTATUS(status);
		}
		else exit_code = -1;

		errcode |= exit_code;		//只要有一个进程失败，就返回非0状态码
	}
	signal(SIGINT, sighandler_ctrl);
	return errcode;	/*TODO 要返回命令的状态码*/
}

//lua端的Env被修改之后，马上通过C语言让它生效。应该有setenv的函数。
//TODO 所以这个函数就不需要了? execve是搜索哪些环境变量？只有标准的几个目录?
//这一块儿还没有做。但决定lua里的环境变量就用Env，所有用户界面的shell级别变量
//都是大写。　
/*@fullpath  if success, store result in fullpath*/
bool get_cmd_fullpath(char *fullpath, char *cmd){
	if(cmd[0] == '/'){
		if (access(cmd, F_OK) == 0){
			strcpy(fullpath, cmd);
			return true;
		}
		else goto failed;
	}

	/*get Env from lua*/
	int esp_backup = lua_gettop(L);
	lua_getglobal(L, "Env");	/*stack: Env*/
	lua_getfield(L, -1, "Path");	/*stack: Env path*/
	lua_pushnil(L);		/*stack: Env PATH nil */
	while(lua_next(L, -2) != 0){	/*stack: Env PATH key value*/
		const char *path = lua_tostring(L, -1);
		if(!path) continue;		//XXX
		strcpy(fullpath, path);
		int len = strlen(fullpath);
		if(fullpath[len - 1] != '/'){
			fullpath[len] = '/';
			fullpath[len+1] = 0;
		}
		strcat(fullpath, cmd);
		if(access(fullpath, F_OK) == 0){
			lua_settop(L, esp_backup);
			return true;
		}
		lua_pop(L, 1);		/*stack:Env PATH key */
	}

failed:
	fullpath[0] = 0;
	return false;
}
int lsh_run_cmd( lua_State *L ){	
	const char *cmd = lua_tostring( L, -1 );
	run_cmdline((char *)cmd);
	//printf( "%s done\n", cmd );
	lua_pushstring( L, "success" );
	return 1;
}


/*
第一，defunct进程产生的原因就是父进程先于子进程退出了。所以这个说法没有任何根据
第二，defunct进程已经是死掉的了。除了在kernel进程表里占用了记录以外，不占用任何系统资源
第三，即使是kernel的mail list也只是建议reboot来解决这个问题
*/


#if 0
	for (int cmd_id = 0; cmd_id <= cmd_id_max; cmd_id++){
		struct lsh_cmd *cmd  = lshcmds + cmd_id;
		/*如果只有一个进程(或者现在就是最右边的进程)，就不要dup2 rpipefd到
			  １了,所以检查一下右侧害有没有进程*/
		if(cmd_id != cmd_id_max){
			int *pipefds = free_pipefd + cmd_id * 2;/*alloc pipe fd[2]*/
			pipe(pipefds);	/*syscall pipe() create a file in memory, and let
							  two fd point it, one read, one write([0],[1])*/
			r_pipefds = pipefds;
		}
		if((fork_ret = fork()) == 0){	/*child process 1*/
			/*try link to left pipe*/
			if(l_pipefds){		/*read from left pipe*/
				dup2(l_pipefds[0], 0);	/*fd 0 automatically closed by dup2*/
			}
			if(r_pipefds){	/*write to right pipe*/
				dup2(r_pipefds[1], 1);
			}
			else{
				if(tail_pipe.active){
					dup2(tail_pipe.fds[1], 1);
				}
			}
			/*good bye... new life*/
			//if(!__silent) fprintf(stderr, "%d> run:%s ", getpid(), fullpath);
			for(int i = 0; i < cmd->argc; i++){
				if(!__silent) fprintf(stderr, "%d:<%s>  ",i, cmd->argv[i]);
			}
			if(!__silent) fprintf(stderr, "\n");
			/* execvp
			 * we save much effort, this interface can search command using current
			 * enviroment's PATH, and let the new process inherit current environ-
			 * ment.  But we need keep 'environ' sychronized with lua firstly.
			*/
			lsh_sync_env();
			ret = execvp(cmd->argv[0], cmd->argv);
			fprintf(stderr, "%s\n", strerror(errno));
			exit(ret);	/*shouldn't flow to here*/
		}
		l_pipefds = r_pipefds;
		r_pipefds = 0;
	}
#endif
