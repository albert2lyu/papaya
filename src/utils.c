#include"../include/utils.h"
#include<proc.h>
#include<disp.h>
#include<linux/byteorder/generic.h>
void dump_sys(){
}

char *MAKE_IP_STR(u32 ip){
	return 0;	
}

void spin(char *msg){
	__asm__ __volatile__ ("cli");
	oprintf("%s",msg);
	while(1);
}
void assert_func(char*exp,char*file,char*base_file,int line){
//	dispStr("assert_failue:exp,file,base_file,line----",0x400);
	cli();
	oprintf("assert failure>>>exp:%s,file:%s,base_file:%s,line:%u\n",exp,file,base_file,line);
	while(1);
}

int bit1_count(char*addr,int bytes){
	int count=0;
	for(int offset=0;offset<bytes;offset++){
//		oprintf("addr[offset]:%u\n",addr[offset]);
		for(int x=0;x<8;x++){
//				oprintf("1<<x:%u\n",1<<x);
			if(((1<<x)&addr[offset])!=0){
				count++;
			}	
		}
	}
	return count;
}

void memcpy(void* dest,void *src,int bytes){
	for(int i=0;i<bytes;i++){
		((char *)dest)[i] = ((char *)src)[i];
	}
}

int strlen(char*str){
	int len=0;
	while(*str!=0){
		str++;
		len++;	
	}
	return len;
}

boolean strmatch(char*seg,char*whole){
	for(int i=0;i<strlen(seg);i++){
		if(seg[i]!=whole[i]) return false;
	}
	return true;
}

char*strcpy(char*dest,char*src){
	char*d=dest;
	while((*dest++=*src++));
	return d;
}
/*
  Warning:  
  1, If there is no null byte among the first n bytes of src, the
  string placed in dest will not be null-terminated.
  2, If the length of src is less than n, strncpy() writes additional null  bytes  to
  dest to ensure that a total of n bytes are written.
  */
char *strncpy(char *dest, const char *src, int n){
	int i;
	for(i = 0; i < n && src[i]; i++){
		dest[i] = src[i];	
	}
	for (; i<n; i++) dest[i] = 0;
	return dest;
}

/* the following two functions are not standardly implemented */
int strcmp(const char *str1, const char *str2){
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

/* 测试一段内存是否全为0. 因为内存是上电清零的，很多时候我不想再”为保险起见而再次清零”，
 * 但我会为保险起见确认一下是否全为0. 读比写快.
 * BTW 这个函数不一定更快，有时间用汇编写。 我是决心不做二次清零的。
 */
void memtest(void *start, int len){
	int n = len / 4;
	int l = len % 4;
	int i;
	for(i = 0; i < n; i++){
		if(((unsigned *)start)[i] != 0) spin("memtest failed");
	}
	for(i = 0; i < l; i++){
		if(((char *)start)[i] != 0) spin("memtest failed");
	}
}



#define LPJ 0x242000
#define HZ 100
static int x_udelay;
void udelay(unsigned long usecs)
{
	for(int i = 0; i < usecs; i++){
		for(unsigned j = 0; j < 0x10000; j++){
			__asm__ __volatile__("add %1, %1\n\t"
								 "movl %1, %0\n\t"
								 : "=m"(x_udelay)
								 :"r"(123) );
		}
	}
}


/* crc16 for big endian memory area*/
u16 crc16_compute_be(void *area, int len){
	u16 *_area = area;
	u32 sum = 0;
	for(int i = 0; i < len/2; i++){
		//oprintf("%u: %x\n", i, ntohs(_area[i]));
		u16 field = ntohs(_area[i]);
		sum += field;
	}

	struct{ u16 ax, carry; } *eax = (void *)&sum;
	while(eax->carry){
		sum = eax->ax + eax->carry;	
	}
	//oprintf(" sum:%x\n",   sum);
	return ~sum;
}

int __less_go = 1;
void __less(void *buf, int len){
	char *str = buf;
	int pressnum = 80*12;
	for(int i = 0; i < len; i += pressnum){
		int left = len - i;
		oprintf(" %*s ",   pressnum < left ? pressnum : left, str + i);
		__less_go = false;
		while(!__less_go);
	}
}





