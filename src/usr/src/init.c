int abc;
int init(void){
	while(1){
		show_chars("goto fork now\n", 0);
		if(fork() == 0){
			show_chars("i am child", 0);
			int a=1;
			*(&a) =2;
		}
		else{
/*			*(char *)(0xc0000000-128) = 0xcc;*/
/*			*(char *)(0x8048001) = 0xff;*/
			show_chars("i am parent", 0);
			*(char *)(0x8049001) = 0xdd;
			int b=1;
			*(&b)=2;
			abc=0xaa;
		}
		while(1);
	}
}
