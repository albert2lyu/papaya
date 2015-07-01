int main(void){
	__asm__ __volatile__(
			"push %cs\n\t"
			"push %eax\n\t"
			);
	return 0;
}
