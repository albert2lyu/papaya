#include<unistd.h>
int main(void){
	unsigned a = 3;
	unsigned b = 4;
	int c = a-b;
	if(c < 0) printf("yes\n");
}
