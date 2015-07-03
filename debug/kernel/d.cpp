#include<stdio.h>
int get_addr(void);
int c_func();
int main(void){
	printf("%d\n",get_addr());

}
int get_addr(void){
	int x = c_func();
	return x;
}
