#include"string.h"
#include"printf.h"
//#include"syscall.h"
void write(char *str, int len){
   __asm__ __volatile__(
   						"push %%ebx\n\t"
						"mov %0, %%ebx\n\t"
   						"int $0x80\n\t"
						"pop %%ebx\n\t"
                        :
                        :"r"(1), "a"(4), "c"(str), "d"(len)
                        ); 
}

void putch(int c){
	char str[] = {c, 0};
	write(str, 1);
}

void puts(char *str){
	write(str, strlen(str));
}

void printn(uint n, uint b){
	char *ntab = "0123456789ABCDEF";
	uint a, m;
	if ((a = n / b)){
		printn(a, b);
	}
	m = n % b;
	putch( ntab[m]);
}

void print(char *fmt, ...){
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
