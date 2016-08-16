#ifndef LSH_H
#define LSH_H
#include"utils.h"
#include"lua.h"
#include"lauxlib.h"
#include"lualib.h"

enum{
	LSH_MOD_LUA,
	LSH_MOD_CMD,
	LSH_MOD_VI
};

#ifdef PATH_MAX
#undef PATH_MAX
#define PATH_MAX 255
#endif

#define PATH_ITEM_MAX 64
char gpath[PATH_ITEM_MAX][PATH_MAX];

#define ARGC_MAX 32
struct lsh_cmd{
	char *argv[ARGC_MAX];
	int argc;
};
#define LSH_CMD_MAX 16
struct lsh_cmd lshcmds[LSH_CMD_MAX];

void prepare_args( char *aftercmd);
int lsh_run_cmd( lua_State *L );
#define __ASSIGN_FATTR(attr) lua_pushcfunction(L, __call_vi_##attr);\
							lua_setmetatable(L, -2,  #attr)
#define _ASSIGN_VATTR(attr) lua_pushcfunction(L, __get_vi_##attr);\
							lua_setmetatable(L, -2, #attr)

void register_vi(lua_State *L);
bool get_cmd_fullpath(char *fullpath, char *cmd);
bool run_cmdline(char *input);
bool mix2lua(char *mixbuf, char *luabuf);
//#include"lsh_utils.h"
#endif
