#ifndef UTILS_H
#define UTILS_H
#undef bool
#define bool int
#define false 0
#define true 1
/* Note!! YOU MUST RETURN THE newnewlength. That's relied by some folowing functions.
 */
#define Def_arr_del(type)\
	int type##_arr_del(type *arr,int N,  int at, int len){\
		int copy_len = N - (at+1) - (len-1);\
		for(int i = at; i < at+copy_len; i++){\
			arr[i] = arr[i + len];\
		}\
		return N - len;\
	}
#define  Def_arr_del2(type)\
	int type##_arr_del2(type *arr, int N, int m, int n){\
		int copy_len = N - (n+1);\
		type *dest = arr + m;\
		type *src = arr + n + 1;\
		for(int i = 0; i < copy_len; i++){\
			dest[i] = src[i];\
		}	\
		return N - (n - m + 1);\
	}
//Note, this function doesn't generate a string tail !!
#define Def_arr_a(type)\
	static inline int __##type##_arr_a(type *arr,int N, int at, int len){\
		for(int i = N-1; i > at; i--){\
			arr[i + len] = arr[i];\
		}\
		return N + len;\
	}




/*we don't define a 'ptr_arr_del'. C pointer size always = sizeof(int), so we use 
 * int_arr_del to handle pointer array
 */
int int_arr_del(int *arr, int N, int at, int len);
int int_arr_del2(int *arr, int N, int m, int n);

Def_arr_a(int)
int int_arr_a(int *arr, int N, int at, int len);

static inline int pchar_arr_del(char **arr, int N, int at, int len){
	return int_arr_del((int*)arr, N, at, len);
}
static inline int pchar_arr_del2(char **arr, int N, int m, int n)
{	return int_arr_del2((int *)arr, N, m, n);	}

static inline int pchar_arr_a(char **arr, int N, int at, int len)
{	return	int_arr_a((int *)arr, N, at, len);	}


int char_arr_del(char *arr, int N, int at, int len);
int char_arr_del2(char *arr, int N, int m, int n);
Def_arr_a(char)
int char_arr_a(char *arr, int N, int at, char *snippet, int snippet_len);
int char_arr_i(char *arr, int N, int at, char *snippet, int snippet_len);

/*'N' means '\n', the only sense of following wrapper is to ensure a string tail,
 * VI library need this. the cost when forgot adding a '\n' in "vi.c" is really expensive*/
static inline int char_arr_delN(char *arr, int N, int at, int len){
	int newlen =  char_arr_del(arr, N, at, len);
	arr[newlen] = '\n';
	return newlen;
}

static inline int char_arr_del2N(char *arr, int N, int m, int n){
	int newlen = char_arr_del2(arr, N, m, n);
	arr[newlen] = '\n';
	return newlen;
}

static inline int char_arr_aN(char *arr, int N, int at, char *snippet, int snippet_len){
	int newlen =  char_arr_a(arr, N ,at, snippet, snippet_len);
	arr[newlen] = '\n';
	return newlen;
}

static inline int char_arr_iN(char *arr, int N, int at, char *snippet, int snippet_len){
	int newlen =  char_arr_i(arr, N ,at, snippet, snippet_len);
	arr[newlen] = '\n';
	return newlen;
}

void *malloc0(int size);	//TODO calloc
char *strchar( char *haystack, char needle);
char *strnchar( char *haystack, char needle);
int strlen_ex(char *str, char *group);
#define __CC_N "\033[0m"
#define CC_RED(s) "\033[0;31m" #s __CC_N
#define CC_BG_RED(s) "\033[42m" #s __CC_N











void print_ink_nstr(char *str, int colorat);
int taste_digit(char *at);
char * strnstr (char *haystack, char *needle, int haystack_len);
char *nice_ascii_serial(char *str, char replacer);

#endif
