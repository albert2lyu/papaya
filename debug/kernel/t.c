unsigned makecell(char *strubase, int bit_off, int bit_count);
#include"a.h"
#include"c.h"
#include"t.h"
char un_g_var;
static char s_char_t = 1;
static int un_s_int_t;
enum jar{cpu = 8, pint =16,quart =32};
enum jar jar_var = 1000;
char *pchar = &un_g_var;
static char *s_pchar = &un_g_var;
static int arr[100];
static char chararr[14];
static struct c_stru sarr[10];
static struct c_stru cstru = {.a=1,.b=2,.c=3};
static struct arrstru{
	int a[1000];
	char b[3];
	struct c_stru next;
}strange;
int main(int argc, char *argv[]){
	struct {
		int x:3;
		int y:4;
		unsigned z:1;
		int a:17;
		int b:19;
	}bitx = {.x = 1, .y =2, .z=1, .a=1<<16,.b='b'};
	
	printf("x:%d  %x\n", bitx.x, *(unsigned char *)&bitx);
	unsigned member_x = makecell((char*)&bitx, 3, 4);
	printf("%d\n",member_x);
	return 0;
	unsigned a;
	scanf("%x", &a);
	printf("%x\n",a);
	return 0;
	int x,y=3;
	while(1){
		int mm;
		int nn;
		while(mm && nn){
			int xx= x * nn;
			x+= y+= 1;
			nn++;
			mm =x;
		}
		printf("%d %d\n", mm, nn);
		if(1) break;
	}
	printf("%d %d\n", x, y);
	printf("%d %d\n", x, y);

}

unsigned makecell(char *strubase, int bit_off, int bit_count){
	int char_off = bit_off/8;
	unsigned *pt = (unsigned *)(strubase + char_off);
	unsigned cell = *pt;
	int right_padden = bit_off%8;
	int left_padden = 32 - bit_count - right_padden;
	int padden = 32 -bit_count;
/*	printf("right:%d,left:%d,padden:%d\n", right_padden, left_padden, padden);*/
/*	printf("get cell:%x\n",cell);*/
	cell = (cell<<left_padden)>>padden;
/*	printf("produce cell:%x\n",cell);*/
	return cell;
}










