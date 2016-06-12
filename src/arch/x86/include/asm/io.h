#ifndef X86_IO_H
#define X86_IO_H

/* linux上的包含关系把我看晕了 */
void *ioremap(unsigned phys_addr,  int size, unsigned flags);

static inline void writeb(unsigned addr, u8 value){
	__asm__ __volatile__("mov %%al, (%%ebx)\n\t"
						 :
						 :"b"(addr), "a"(value));
}

static inline void writew(unsigned addr, u16 value){
	__asm__ __volatile__("mov %%ax, (%%ebx)\n\t"
						 :
						 :"b"(addr), "a"(value));
}

static inline void writel(unsigned addr, unsigned value){
	__asm__ __volatile__("mov %%eax, (%%ebx)\n\t"
						 :
						 :"b"(addr), "a"(value));
}

static inline unsigned readb(unsigned addr){
	unsigned value;
	__asm__ __volatile__("xor %0, %0 \n\t"
						 "mov (%%ebx), %%al\n\t"
						 :"=r"(value)
						 :"b"(addr)
						 );
	return value;
}


static inline unsigned readw(unsigned addr){
	unsigned value;
	__asm__ __volatile__("xor %0, %0 \n\t"
						 "mov (%%ebx), %%ax\n\t"
						 :"=r"(value)
						 :"b"(addr)
						 );
	return value;
}


static inline unsigned readl(unsigned addr){
	unsigned value;
	__asm__ __volatile__("xor %0, %0 \n\t"
						 "mov (%%ebx), %%eax\n\t"
						 :"=r"(value)
						 :"b"(addr)
						 );
	return value;
}

static inline void maskb(unsigned addr, u8 mask){
	unsigned value = readb(addr);
	value |= mask;
	writeb(addr, value);
}

static inline void unmaskb(unsigned addr, u8 mask){
	unsigned value = readb(addr);
	value &= ~mask;
	writeb(addr, value);
}


static inline void maskw(unsigned addr, u16 mask){
	unsigned value = readw(addr);
	value |= mask;
	writew(addr, value);
}

static inline void unmaskw(unsigned addr, u16 mask){
	unsigned value = readw(addr);
	value &= ~mask;
	writew(addr, value);
}

static inline void maskl(unsigned addr, unsigned mask){
	unsigned value = readl(addr);
	value |= mask;
	writel(addr, value);
}

static inline void unmaskl(unsigned addr, unsigned mask){
	unsigned value = readl(addr);
	value &= ~mask;
	writel(addr, value);
}

#endif
