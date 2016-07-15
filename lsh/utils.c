#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"utils.h"
#include<ctype.h>
Def_arr_del(int)
Def_arr_del2(int)

Def_arr_del(char)
Def_arr_del2(char)

int int_arr_a(int *arr, int N, int at, int len){
	int newlen = __int_arr_a(arr, N, at, len);
	int *newarea = arr + at + 1;
	for( int i = 0; i < len; i++) newarea[i] = 0;
	return newlen;
}

int char_arr_a(char *arr, int N, int at, char *snippet, int snippet_len){
	int newlen = __char_arr_a(arr, N, at, snippet_len);
	strncpy(arr + at + 1, snippet, snippet_len);		
	return newlen;
}

int char_arr_i(char *arr, int N, int at, char *snippet, int snippet_len){
	return char_arr_a(arr, N, at-1, snippet, snippet_len);
}

void print_ink_nstr(char *str, int colorat){
	char *curr = str;
	while(*curr && *curr!= '\n'){
		char *format = "%c";
		if(curr - str == colorat) format = CC_BG_RED(%c);
		printf(format, *curr);
		curr++;
	}
	return;
}

void *malloc0(int size){
	char *ptr = malloc(size);
	memset(ptr, 0, size);
	return ptr;
}

/*不提供trial flag选项，这应该是一个纯净的函数,不是vi_x函数*/
/* if meet '\0' before match the 'needle', return 0*/
char *strchar( char *haystack, char needle){
	while( *haystack != 0){
		if( *haystack == needle ) return haystack;
		haystack++;
	}
	return 0;
}

char *strnchar( char *haystack, char needle){
	while( *haystack != '\n'){
		if( *haystack == needle ) return haystack;
		haystack++;
	}
	return 0;
}
int strlen_ex(char *str, char *group){
	char *curr = str;
	/*search forward only when current not '\0' and not among 'group'*/
	while(*curr != 0 && strchar(group, *curr) == 0){
		curr++;
	}
	return curr - str;
}

/*leave normal ascii as it is, replace control chracter with 'replacer'
 */
char *nice_ascii_serial(char *str, char replacer){
	char *curr = str-1;
	while(*++curr){
		if(!isspace(*curr)) continue;
		*curr = replacer;
	}
	return str;
}


#if 0
/*	append 'cellnr' cells to index 'after' of array 'arr', new cells are cleared
 */
void ptr_arr_a(void *_lines, int after, int cellnr){
	void **lines = _lines;
	void **curr = lines + after + 1;
	while(*curr){
		curr++;
	}
	while(curr  > &lines[after]){
		curr[cellnr] = curr[0];	
		curr--;
	}
	curr++;
	while(curr <= &lines[after + cellnr]){
		*curr = 0;
		curr++;
	}
}

void int_arr_a(int *arr, int after, int cellnr){
	int i = after + 1;
	while(arr[i]) i++;
	while(i > after){
		arr[i+cellnr] = arr[i];
		i--;
	}
	i++;
	while(i <= after + cellnr){
		arr[i] = 0;
		i++;
	}
}
void ptr_arr_del(void *_arr, int m, int n){
	void **arr = arr;
	for(int i = m; i <=n; i++){
		arr[m] = arr[n+1];
	}	
}
void int_arr_del(int *arr, int m, int n){
	for(int i = m; i <=n; i++){
		arr[m] = arr[n+1];
	}	
}
#endif

int taste_digit(char *at){
	char *l = at;
	while( *l >= '0' && *l <= '9') l--;
	l++;
	return atoi(l);
}

/*the following group of functions: return 0 if can not find suitable result*/
//'sister' means smaller one, 'brother' meaner lager one.
//'left', 'right' is used for ascending/decending order array
void *get_right_sister();
void *get_left_brother();
void *get_right_brother();
//ascending array
void * get_left_sister(unsigned *arr, unsigned x, int len){
	if(x < arr[0]) return 0;
	for(int i = 0; i < len; i++){
		if(arr[i] > x) return (void *)&arr[i-1];
	}
	return (void *)&arr[len-1];
}

char *strnstr(char* s1, char* s2, int n)  
{  
	char backup = s1[n];
	s1[n] = 0;
	char *at = strstr(s1, s2);
	s1[n] = backup;
	return at;
}  

#if 0
void str_shl(char *str, int offset){
	char * to = str - offset;
	int i = 0;
	while(str[i]){
		to[i] = str[i];
		i++;
	}
	to[i] = 0;
}
int  str_del2(char *a, char *b){
	str_shl(b + 1, b - a + 1);				
	return b-a+1;
}


/*@N  the length of this string: how many bytes contained?
 *1, the caller is responsible to set the string tail.
 */
static void Nstr_shl(char *at, int offset, int N){
	char * to =at - offset;
	for(int i = 0; i < N; i++){
		to[i] = at[i];
	}
	
}

/*del range from ptr-a to ptr-b 
 * @2 receive two pointers
 * a MUST <= b
 * @Description  delete from a(inclued) to b(included)
 * @return len
 */
static int  Nstr_del2(char *str, char *a, char *b, int N){
	Nstr_shl(b + 1, b - a + 1, N);
	return b-a+1;
}

/*@length, if you know length, things will be faster, otherwise, pass strlen()
 * eg:(as following, here initially  'str' point to second 'b', offset = 2;)
 * aaabbbcccddd			==>
 * aaab  bbcccddd 
 */
void Nstr_shr(char *str, int offset, int length){
	char *tail = str + length /*- 1*/;	//copy '\0' by the way
	for(char *curr = tail; curr >= str; curr--){
		curr[offset] = curr[0];
	}
}
/* this is a more friendly function
 * @str this 'str' differs from 'str' in function 'str_shr'
 * @length  the length of the whole string, not from 'at'
 */
void Nstr_shr_at(char *str, int at, int offset, int whole_len){
	char *s = str + at;
	Nstr_shr(s, offset, whole_len - at);
}

#endif
