/* 1, 在include/asm-generic/目录下，存放着errno-base.h和errno.h。分别define了1~34, 35~132,
 * 并且后者include了前者。
 * 2, 剩余的errno.h都分布在arch/?/include/asm/目录下。 像比x86下面的include/asm目录里的
 * errno.h, 没有内容，只是include了asm-generic/errno.h。
 * 3, 下面所include的asm/errno.h，其”asm“应该就是指向某个arch/下的asm,这应该就是内核的
 * 条件编译。在编译时指定include的搜索path。
 * 4, 总的来说，errno.h应该是被认为与architecture相关的，所以每个arch目录都有一份，但
 * 很多architecture可能并无差别，于是有了个asm-generic目录，x86下的errno.h就引用那儿的。
 */
#ifndef LINUX_ERRNO_H
#define LINUX_ERRNO_H
#include<asm/errno.h>

#endif
