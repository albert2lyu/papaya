#ifndef ASM_LABLE_H
#define ASM_LABLE_H
extern void restore_all(void);
extern void ret_from_intr(void);
extern void ret_from_sys_call(void);
extern void ret_with_reschedule(void);
extern void reschedule(void);
extern void page_fault(void);

extern void RAMDISK_BASE(void);
#endif
