#ifndef VIM_H
#define VIM_H
static inline int vim_f_ex(char *group, unsigned flags){
	return vi_f_ex(vim,   group, flags);
}
static inline int vim_find(char *str, unsigned flags){
	return vi_find(vim,   str, flags);
}

static inline void vim_tom(char rid){
	vi_tom(vim, rid);
}
static inline void  vim_set(char *str ){
	vi_set(  vim, str );
}

static inline bool vim_jmpspace(void){
	return vi_jmpspace(vim);
}
static inline void vim_gg(void){
	vi_gg(vim);
}
static inline bool vim_w(void){
	return vi_w(vim);
}
static inline bool vim_W(void){
	return vi_W(vim);
}
static inline bool vim_l(void){
	return vi_l(vim);
}

static inline bool vim_j(void){
	return vi_j(vim);
}

static inline bool vim_h(void){
	return vi_h(vim);
}

static inline bool vim_percent(void){
	return vi_percent(vim);
}

static inline bool vim_xor(void){
	return vi_xor(vim);
}

static inline void vim_0(void){
	return vi_0(vim);
}

static inline bool vim_orx(void){
	return vi_orx(vim);
}
static inline void vim_$(void){
	vi_$(vim);
}


static inline int vim_jmpspace_ex( int control){
	return vi_jmpspace_ex(vim, control);
}

static inline bool vim_m( char rid){
	return vi_m(vim, rid);
}

static inline void vim_r( char new){
	vi_r(vim, new);
}

static inline int vim_f( char target){
	return	vi_f(vim, target);
}

static inline void vim_i(char *str){
	vi_i(vim, str);
}

static inline void vim_a(char *str){
	vi_a(vim, str);
}

static inline void vim_normal(char *ops){
	vi_normal(vim, ops);
}

static inline void vim_out(char *buf){
	vi_out(vim, buf);
}

static inline bool vim_write(char *filename){
	return vi_write(vim, filename);
}

static inline bool vim_open(char *filepath){
	return vi_open(vim, filepath);
}

static inline void vim_x(){
	vi_x(vim);
}

static inline void vim_G(){
	vi_G(vim);
}

static inline bool vim_Gn(unsigned destl){
	return vi_Gn(vim, destl);
}

static inline void vim_v(){
	vi_v(vim);
}

static inline bool vim_meet_emptyline(){
	return vi_meet_emptyline(vim);
}

static inline bool vim_meet_spaceline(){
	return vi_meet_spaceline(vim);
}

static inline bool vim_p(){
	return vi_p(vim);
}

static inline bool vim_d(){
	return vi_d(vim);
}

static inline bool vim_y(){
	return vi_y(vim);
}

#endif
