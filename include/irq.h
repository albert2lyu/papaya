#ifndef IRQ_H
#define IRQ_H
/**与中断控制器打交道的一套函数*/
#define NR_IRQS 16

#define IRQ_PENDING 1
#define IRQ_INPROCESS (1<<1)
#define IRQ_DISABLED (1<<2)
typedef struct{
	void (*enable)(unsigned irq);
	void (*disable)(unsigned irq);
	void (*ack)(unsigned irq);
	void (*end)(unsigned irq);
}hw_irq_controller;

typedef struct {
	unsigned status;
	struct irqaction *action;	/**interrupt service list*/
	hw_irq_controller *hw_handler;	/**觉得不放在结构体里也行，反正只有1个8259*/
}irq_desc_t;


#define SA_SHIRQ 1
#define SA_INTERRUPT (1<<1)		/**快速中断处理程序，运行时全程关中断*/
struct irqaction{
	/*linux 把这个函数写成void (*handler)(int irq, void *dev_id, pt_regs *pregs)
	 * 在papaya内核里，current->pregs是全局accessable的。至于dev_id，是为了支持
	 * 多中断源共用中断通道，遇到的不多，先不支持它*/
	void (*func) (int irq, void *dev);
	unsigned flags;
	void *dev;
	
	struct irqaction *next;
};

irq_desc_t irq_desc[NR_IRQS];



#endif
