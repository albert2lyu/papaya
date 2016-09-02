#define ABC(x, y) do{				\
	int a = x;				\
	int b = y;				\
	printf("%d ", a + b);				\
}while(0)

int main(void){
	ABC(2, 4);
}
