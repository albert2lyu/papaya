#include<utils.h>
#include<proc.h>
#include<disp.h>
#include<linux/byteorder/generic.h>
#include<linux/printf.h>
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

#if 0
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

#endif
void memcpy(void* dest,void *src,int bytes){
	for(int i=0;i<bytes;i++){
		((char *)dest)[i] = ((char *)src)[i];
	}
}


int memcmp(void *_s1, void *_s2, int len){
	char *s1 = _s1;
	char *s2 = _s2;
	for(int i = 0; i < len; i++){
		if(s1[i] == s2[i]) continue;
		return 1;
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
	return sum;
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

static char ipstr_buf[128];
static char *ipstr = ipstr_buf;
char * mk_ipstr(u32 ip){
	char *result = ipstr;
	struct __eax *eax = (void *)&ip;
	int len = sprintf(ipstr, "%u.%u.%u.%u",  eax->AH, eax->AL, eax->ah, eax->al);	
	ipstr[len] = 0;
	ipstr += len + 2;
	if(ipstr - ipstr_buf > 110)	ipstr = ipstr_buf;
	return result;
}



