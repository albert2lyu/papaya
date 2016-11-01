#ifndef I8259_H
#define I8259_H

#include<valType.h>
void init_ISA_irqs(void);
u16 pic_get_isr(void);

#endif
