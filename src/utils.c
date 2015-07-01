#include"../include/utils.h"
#include<proc.h>
#include<disp.h>
void dump_sys(){
}

int bitscan111(u32 addr, int num_111 ,int dw_cell){
	if(num_111 <= 0) return -1;
	u32 *cell = (u32*)addr;
	for(int i=0; i<dw_cell; i++){
		if((u32*)cell[i] != 0){
			int bitoffset = bitscan32(cell+i, num_111);
			if(bitoffset == -1) continue;
			return (i*32 + bitoffset);
		}
}
	return -1;
}
bool  bitsclear_long(u32 addr, int bit_off, int num){
	if(num <=0 || bit_off<0 ) return false;
	if(num <= 32){
		bitsclear(addr,bit_off,num);
		return true;
	} 
	/**adjust bit_off to 0~31*/
	addr+=4* (bit_off/32);
	bit_off%= 32;

	u32 head_addr = (bit_off == 0?0:addr);
	u32 tail_addr = ((bit_off + num)%32 == 0?0:(addr + (bit_off+num)/32*4));
	u32 body_start = (bit_off == 0?addr:(addr+4));
	u32 body_end = addr + (bit_off+num)/32*4 -4;

	if(head_addr) bitsclear(head_addr,bit_off,32-bit_off);
	if(tail_addr) bitsclear(tail_addr,0, (bit_off+num)%32);
	for(int i=body_start; i <= body_end; i+=4) *(u32*)i=0;
	return true;
}

bool  bitsset_long(u32 addr, int bit_off, int num){
	if(num <=0 || bit_off<0 ) return false;
	if(num <= 32){
		bitsset(addr,bit_off,num);
		return true;
	} 
	/**adjust bit_off to 0~31*/
	addr+=4* (bit_off/32);
	bit_off%= 32;

	u32 head_addr = (bit_off == 0?0:addr);
	u32 tail_addr = ((bit_off + num)%32 == 0?0:(addr + (bit_off+num)/32*4));
	u32 body_start = (bit_off == 0?addr:(addr+4));
	u32 body_end = addr + (bit_off+num)/32*4 -4;

	if(head_addr) bitsset(head_addr,bit_off,32-bit_off);
	if(tail_addr) bitsset(tail_addr,0, (bit_off+num)%32);
	for(int i=body_start; i <= body_end; i+=4) *(u32*)i=0xffffffff;
	return true;
}

void spin(char *msg){
	__asm__ __volatile__ ("cli");
	oprintf("%s",msg);
	while(1);
}
void assert_func(char*exp,char*file,char*base_file,int line){
//	dispStr("assert_failue:exp,file,base_file,line----",0x400);
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

void memcpy(char*dest,char*src,int bytes){
	for(int i=0;i<bytes;i++){
		dest[i]=src[i];
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








