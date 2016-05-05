#include<i8259.h>
#include<irq.h>
#include<utils.h>

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
	if(value) bitset((u32)&mask, bit_offset);
	else bitclear((u32)&mask, bit_offset);
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


