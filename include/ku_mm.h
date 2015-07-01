#ifndef KU_MM_H
#define KU_MM_H
#include<pmm.h>
//memory infomation between 6M~16M~20M
#define USR_PSP_LEN (64)
#define USR_PSP_BASE (PAGE_OFFSET-USR_PSP_LEN)
#define USR_STACK_BASE (USR_PSP_BASE - 4)
struct usr_psp_struct{
	unsigned pid;
	unsigned _errno;
};
#define errno (__usr_psp->_errno)
#define __usr_psp ((struct usr_psp_struct *)USR_PSP_BASE)
#endif
