//PIC的代码用ld -staci链接，不报错，但是不生成文件.. 呃。。因为makefile删除了非目标文件
//ld可以加fPIC选项，它不报错，但是生成的代码不是PIC的。本来就不可挽回了。只是它为什么不报错?
int a;
void boot_strap(int arg){
	while(1);
	a = 0;
}

void __start(void){

}
