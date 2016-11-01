/*
 * This file contains various random system calls that
 * have a non-standard calling sequence on the Linux/i386
 * platform.
 */
//　上面的话什么意思？sys_mmap2就传了6个参数，哪里不标准了？


/*可以实现sys_mmap函数，一层包装而已
 */

/*
 * 不实现old_mmap()函数，它是用寄存器传递arguments block的指针. 还有什么不一样?
 * 用户传入的低12位会被
 */

int sys_mmap2()
