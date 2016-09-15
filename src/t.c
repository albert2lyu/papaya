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

enum{
	sys_fork = 88,
};
enum{
	NR_fork = 2,
	NR_execve = 4,
};
#define ENTRY(name) [NR_ ## name] = sys_ ## name
unsigned long func_table[255] =
{
	ENTRY(fork),
	//ENTRY(execve),
};
int main(int argc, char *argv[], char *envp[]){
	
	printf("a:%x, %x, %x", func_table[2], func_table[4], func_table[9]);
	struct flower red_rose;
	struct flower blue_rose;
	struct flower *red = &red_rose;
	struct flower *blue = &blue_rose;
	//printf("argc:%d, argv:%p, envc:%x, envp:%p", argc, argv, envc, envp);
	//printf("%p", (unsigned *)0x1 + 4);
	//int a = insert(red, blue);
	//printf("%d", a);
	return 0;
}








