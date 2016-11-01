#include<i8259.h>
#include<irq.h>
#include<utils.h>
#include<asm/bit.h>

#define PIC1		0x20		/* IO base address for master PIC */
#define PIC2		0xA0		/* IO base address for slave PIC */
#define PIC1_CMD	PIC1
#define PIC1_DATA	(PIC1+1)
#define PIC2_CMD	PIC2
#define PIC2_DATA	(PIC2+1)

/* reinitialize the PIC controllers, giving them specified vector offsets
   rather than 8h and 70h, as configured by default */
 
#define ICW1_ICW4	0x01		/* ICW4 (not) needed */
#define ICW1_SINGLE	0x02		/* Single (cascade) mode */
#define ICW1_INTERVAL4	0x04		/* Call address interval 4 (8) */
#define ICW1_LEVEL	0x08		/* Level triggered (edge) mode */
#define ICW1_INIT	0x10		/* Initialization - required! */
 
#define ICW4_8086	0x01		/* 8086/88 (MCS-80/85) mode */
#define ICW4_AUTO	0x02		/* Auto (normal) EOI */
#define ICW4_BUF_SLAVE	0x08		/* Buffered mode/slave */
#define ICW4_BUF_MASTER	0x0C		/* Buffered mode/master */
#define ICW4_SFNM	0x10		/* Special fully nested (not) */
 
void i8259_mask(unsigned char IRQline) {
    u16 port;
    u8 value;
 
    if(IRQline < 8) {
        port = PIC1_DATA;
    } else {
        port = PIC2_DATA;
        IRQline -= 8;
    }
    value = in_byte(port) | (1 << IRQline);
    out_byte(port, value);        
}
 
void i8259_unmask(unsigned char IRQline) {
    u16 port;
    u8 value;
 
    if(IRQline < 8) {
        port = PIC1_DATA;
    } else {
        port = PIC2_DATA;
        IRQline -= 8;
    }
    value = in_byte(port) & ~(1 << IRQline);
    out_byte(port, value);        
}

#define PIC_READ_IRR                0x0a    /* OCW3 irq ready next CMD read */
#define PIC_READ_ISR                0x0b    /* OCW3 irq service next CMD read */
 
/* Helper func */
static u16 __pic_get_irq_reg(int ocw3)
{
    /* OCW3 to PIC CMD to get the register values.  PIC2 is chained, and
     * represents IRQs 8-15.  PIC1 is IRQs 0-7, with 2 being the chain */
    out_byte(PIC1_CMD, ocw3);
    out_byte(PIC2_CMD, ocw3);
    return (in_byte(PIC2_CMD) << 8) | in_byte(PIC1_CMD);
}
 
/* Returns the combined value of the cascaded PICs irq request register */
u16 pic_get_irr(void)
{
    return __pic_get_irq_reg(PIC_READ_IRR);
}
 
/* Returns the combined value of the cascaded PICs in-service register */
u16 pic_get_isr(void)
{
    return __pic_get_irq_reg(PIC_READ_ISR);
}
static void end_8259A(u32 irq){

}

/**1, 往两片8259A写入EOI的顺序（if slave needed）是先从后主，顺序不能错
 * 2, EOI分两种，linux上用的是特殊EOI，我们用的是普通EOI。
 * 3, 两种EOI都是用OCW2发出,不过，特殊EOI的低三位，能指定要被复位的ISR的优先级。
 * 4, 暂时不依照函数名做mask操作，<<Careful! The 8259A is a fragile beast,
 * it pretty much _has_ to be done exactly like this (mask it firstly....)>>
 */
void mask_and_ack_8259A(u32 irq){
	if(irq >= 8) out_byte(0xa0, 0x20);
	out_byte(0x20, 0x20);
}

static void write_imr_bit(bool master, int bit_offset, int value){
	unsigned port = master ? 0x21 :0xa1;
	unsigned mask = in_byte(port);
	if(value) __bt(&mask, bit_offset);
	else __btr(&mask, bit_offset);
	out_byte(port, mask);	
}

static void write_imr_by_irq(int irq, int value){
	assert(irq != 2 && irq >= 0 && irq < NR_IRQS);
		
	if(irq >= 8){
		irq -= 8;
		write_imr_bit(false, irq, value);	
	}
	else write_imr_bit(true, irq, value);
}

void enable_8259A_irq(u32 irq){
	write_imr_by_irq(irq, 0);
}

void disable_8259A_irq(u32 irq){
	write_imr_by_irq(irq, 1);
}

void init_8259A(int x){

}

static hw_irq_controller i8259A_irq_type = {
	enable_8259A_irq,
	disable_8259A_irq,
	mask_and_ack_8259A,
	end_8259A
};

void init_ISA_irqs(void){
	init_8259A(0);

	for(int i = 0; i < NR_IRQS; i++){
		irq_desc[i].status = IRQ_DISABLED;
		irq_desc[i].status += (1<<31);		/**debug flag*/
		irq_desc[i].action = 0;
		if(i < 16) irq_desc[i].hw_handler = &i8259A_irq_type;
		else spin("irq channel number > 16 !");
	}
}


