/**1 you must compile it in debug mod as assert() contaion valid code
 * 2 you can only run dimg under 'cmd','src','bin'..
 * 3, 为了确保boot时，每个扇区都从硬盘加载到内存。我们在将kernel.elf写入硬盘
 *    之前，每隔512个字节，设置一个magic number，最后以0xcc结尾。 magic number 
 *    排挤出的byte搜集到一个扇区（所以暂时只支持512(511, in fact)个扇区）,内
 *    核加载时，一方面check magic number确保完整性，一方面把这些byte填回每个
 *    扇区。 magic number 在每个扇区的第一个字节。
 **/
#define ENV_NOT_KERNEL
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
#include<stdio.h>
#include<unistd.h>
#include<assert.h>
#include<errno.h>
#include "../include/bootinfo.h"
static int kernel_img_size;
/* we avoid change R/W cursor of fd*/
static int fdsize(int fd){
	int pos = lseek(fd, 0, SEEK_CUR);	
	int size = lseek(fd, 0, SEEK_END);
	lseek(fd, pos, SEEK_SET);
	return size;
}

static int filesize(char *name){
	int fd = open(name, 1+1, 0);
	if(fd == -1) return -1;
	int size = fdsize(fd);
	close(fd);
	return size;
}

/* the color byte must be the first byte, because we color image file ,not disk 
 * , otherwise, we can not handle the last sector properly.
 */
void magic_color(void){
	assert(kernel_img_size > 0 && kernel_img_size < 511 * 512 &&
			"for currently, we use a sector to store data byte, so we can\
			only color 512 sectors. not really, it's 511, because the last\
			byte is used for indicating 'colored sector count'");
	char byte;
	int fd_kernel = open("../bin/kernel.elf", O_RDWR);
	assert(fd_kernel != -1);
	int fd_fix = open("./fix.img", O_RDWR);
	assert( fd_fix != -1 && "you should create 'fix.img' manually");
	assert( fdsize(fd_fix) == 512 );	

	int i;
	for(i = 0; i < 511; i++){
		char magic_x = i;
		int color_pos = i * 512;
		if(i == kernel_img_size / 512) magic_x = 0xcc;
		if(color_pos > kernel_img_size){
			printf(">>>>>>>>>>>>>>>>>>>>>>>>%d sectors colored\n", i);
			break;
		}

		lseek(fd_kernel, color_pos, SEEK_SET);
		assert( read(fd_kernel, &byte, 1) == 1 );	// fetch byte data
		if(byte == 0 && i == 0) assert(0 && "kernel.elf seems old, try 'make'\n");
		lseek(fd_kernel, color_pos, SEEK_SET);		//rewind for writing
		assert( 
		write(fd_kernel, &magic_x, 1) == 1 );//write magic number
		assert( write(fd_fix, &byte, 1) == 1 );		//send byte data to fix.img
	}
	assert( write(fd_fix, (char *)&i, 2) == 2);	//结尾的sector nr只用1个byte可
												//装不下。　得两个.
	fsync(fd_kernel);
	fsync(fd_fix);
	close(fd_kernel);
	close(fd_fix);
}
int main(int argc, char *argv[]){
	char cmd[100];
	assert(argc == 2);
	char *filepath = argv[1];
	kernel_img_size = filesize("../bin/kernel.elf");
	printf("source elf size:%d\n", kernel_img_size);
	printf("target device :%s\n", filepath);
	assert(kernel_img_size < 250 * 1024 && 
			"kernel.elf firstly loaded at 0x60000, take care of 0xA0000, and \
			boot.asm only read ~250 sectors.");
	/* Note, MUST be executed before @dd */
	magic_color();

	sprintf(cmd,"dd if=../bin/kernel.elf of=%s bs=512 conv=notrunc seek=%u", filepath, kernel_image_start_sector-1);
	printf("%s\n", cmd);
	system(cmd);
	sprintf(cmd,"dd if=./fix.img of=%s bs=512 conv=notrunc seek=%u", filepath, fiximg_start_sector - 1);
	printf("%s\n", cmd);
	system(cmd);

	unsigned char boot_flag[]={0x55,0xaa};
	int fd_sys=open(filepath,1+1,0);
	if(fd_sys==-1){
		printf("open %s error:%d",filepath, errno);
		return 1;
	}
	char dpt[48];
	lseek(fd_sys,446,0);
	assert(read(fd_sys,dpt,48) == 48);
	/**dpt already buffered,we can write boot.bin to 400m.img now*/
	sprintf(cmd, "dd if=../bin/boot.bin of=%s bs=512 conv=notrunc seek=0", filepath);
	system(cmd);
	/**write back dpt*/
	lseek(fd_sys,446,0);
	assert(write(fd_sys,dpt,48)==48);

	/**set boot flags*/
	lseek(fd_sys,510,0);
	assert(write(fd_sys,boot_flag,2)==2);

	fsync(fd_sys);
	assert(close(fd_sys)!=-1);
	printf("dimg done..");
	return 0;
}
