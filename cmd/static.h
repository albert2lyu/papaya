//分离出这个头文件，只是让ld.c不那么拥挤
#include"syscall.h"
static int strlen(char*str){
	int len=0;
	while(*str!=0){
		str++;
		len++;	
	}
	return len;
}
/* the following two functions are not standardly implemented */
static int strcmp(const char *str1, const char *str2){
	int i;
	for(i = 0; str1[i] == str2[i]; i++){
		if(str1[i] == 0) return 0;
	}
	return i + 1;

}

int strncmp(const char *str1, const char *str2, int n){
	for(int i = 0; i < n; i++){
		if(str1[i] == str2[i]) {
			if(str1[i]) continue;
			else return 0;
		}
		else return i + 1;
	}
	return 0;	
}

typedef unsigned uint;
static void putch(int c){
	char str[] = {c, 0};
	write(str, 1);
}

static void puts(char *str){
	write(str, strlen(str));
}

static void printn(uint n, uint b){
	char *ntab = "0123456789ABCDEF";
	uint a, m;
	if ((a = n / b)){
		printn(a, b);
	}
	m = n % b;
	putch( ntab[m]);
}

static void print(char *fmt, ...){
 	char c;
	 uint *adx = (uint*)(void*)&fmt + 1;
_loop:
	 while((c = *fmt++) != '%'){
		if (c == '\0') return;
		putch(c);
	 }
	 c = *fmt++;
	 if (c == 'd' || c == 'l'){
	 	printn(*adx, 10);
	 }
	 if (c == 'o' || c == 'x'){
	 	printn(*adx, c=='o'? 8:16 );
	 }
	 if (c == 's'){
	 	puts((char *)*adx);
	 }
	 adx++;
 goto _loop;
}

void happy(void){
	print("happy\n");
}
static void spin(char *str){
	print(str);
	while(1);
}

