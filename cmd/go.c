extern int foobar1(void);
extern int a;
int nomain(void){
	a=0x123;
	foobar1();
	void print(char *fmt, ...);
	print("\nI am  go!!\n");
	while(1);
	return 0;
}
