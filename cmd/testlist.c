#define __USER 1
#include<stdio.h>
#include"../src/include/old/list.h"
struct flower{
	int age;
	struct list_head tentacle;
};
struct flower flowers[10];
int main(void){
	struct flower one;
	INIT_LIST_HEAD(&one.tentacle);
	for( int i = 0 ; i < 10 ; i++){
		flowers[i].age = i * 10;
		list_add(&flowers[i].tentacle, &one.tentacle);
	}
	struct flower *tmp;
	//struct list_head *head;
	//head = container_of(head, __typeof__(*tmp), tentacle);
	#if 1
	for(int i = 0; i < 2; i++){
		list_for_each_safe((&one.tentacle), tmp, tentacle){
			if(tmp->age > 40){
				list_del(&tmp->tentacle);
				continue;
			}
			printf("age :%d\n", tmp->age);
		}

	}
	#endif

	int a=2,b=3;
	printf("hello world:%d, %d\n", a, b);
	return 0;
}


void foobar(void){
	goto lable;
	while(1){
		int x = 0;
		lable:
		printf("%d", x);
	}
}
