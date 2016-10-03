#ifndef LD_H
#define LD_H

#include<old/valType.h>
static inline void write(char *str, int len){
   __asm__ __volatile__(
   						"push %%ebx\n\t"
						"mov %0, %%ebx\n\t"
   						"int $0x80\n\t"
						"pop %%ebx\n\t"
                        :
                        :"r"(1), "a"(4), "c"(str), "d"(len)
                        ); 
}

#endif
