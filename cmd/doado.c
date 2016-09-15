#include "../src/include/linux/NR_syscall.h"
void doado(void){
	int x;
	__asm__ __volatile__(
						"int $0x80\n\t"
						:
						:"a"(NR_printf), "b"("user space from kernel: %u"), "c"(1234)
						);
	while(x++){
	}
}
