#include<valType.h>

#define ATOMIC_INIT(i) {i}

inline int atomic_read(atomic_t *v){
	return v->counter;
}

inline void atomic_set(int i, atomic_t *v){
	v->counter = i;
}

inline void atomic_add(int i, atomic_t *v){
	asm volatile(
		"addl %1, %0\n\t"
		:"m"(v->counter)	/**BUG i don't want to use '+m" here,what's wrong with 'm'*/
		:"r"(i)
		:"memory"
			);
}
