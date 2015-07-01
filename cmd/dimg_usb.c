/**1 you must compile it in debug mod as assert() contaion valid code
 * 2 you can only run dimg under 'cmd','src','bin'..
 **/
#define ENV_NOT_KERNEL
#include<stdio.h>
#include<unistd.h>
#include<assert.h>
#include<errno.h>
#include "../include/bootinfo.h"
int main(void){
	int fd_sys=open("/dev/sdb",1+1,0);
	if(fd_sys==-1){
		printf("can not open sdb:%d",errno);
		return 1;
	}

	char cmd[100];
	sprintf(cmd,"dd if=../bin/kernel.elf of=/dev/sdb bs=512 conv=notrunc seek=%u",kernel_image_start_sector-1);
	system(cmd);

	unsigned char boot_flag[]={0x55,0xaa};
	char dpt[48];
	lseek(fd_sys,446,0);
	assert(read(fd_sys,dpt,48) == 48);
	/**dpt already buffered,we can write boot.bin to 400m.img now*/
	system("dd if=../bin/boot.bin of=/dev/sdb bs=512 conv=notrunc seek=0");
	/**write back dpt*/
	lseek(fd_sys,446,0);
	assert(write(fd_sys,dpt,48)==48);

	/**set boot flags*/
	lseek(fd_sys,510,0);
	assert(write(fd_sys,boot_flag,2)==2);
	assert(close(fd_sys)!=-1);

	printf("dimg done..");
	return 0;
}
