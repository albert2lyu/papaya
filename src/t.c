#include<assert.h>
#include<stdio.h>
struct flower{
	struct flower *prev, *next;
	struct flower *_prev, *_next;
	int age;
};

//递增环链，寻找最小姊
#define O_SCAN_UNTIL_MEET_LARGER(root, mb, value)		\
({														\
	assert( (root) );							\
	typeof(root) node = root;							\
	do{													\
		if( (node)->mb > value) break;				\
		node = node->next;								\
	}while( node != (root));							\
	node;												\
})
int insert(struct flower *root, struct flower*new){
	O_SCAN_UNTIL_MEET_LARGER(root, age, 10);
}

int main(int argc, char *argv[], char *envp[]){
	//printf("a:%x, %x, %x", VM_GROWSDOWN, VM_READ, VM_EXEC);
	struct flower red_rose;
	struct flower blue_rose;
	struct flower *red = &red_rose;
	struct flower *blue = &blue_rose;
	//printf("argc:%d, argv:%p, envc:%x, envp:%p", argc, argv, envc, envp);
	printf("%p", (unsigned *)0x1 + 4);
	//int a = insert(red, blue);
	//printf("%d", a);
	return 0;
}








