
LXR linux/arch/x86/kernel/i8259.c
<<
>>
Prefs

   1#include <linux/linkage.h>
   2#include <linux/errno.h>
   3#include <linux/signal.h>
   4#include <linux/sched.h>
   5#include <linux/ioport.h>
   6#include <linux/interrupt.h>
   7#include <linux/timex.h>
   8#include <linux/random.h>
   9#include <linux/init.h>
  10#include <linux/kernel_stat.h>
  11#include <linux/syscore_ops.h>
  12#include <linux/bitops.h>
  13#include <linux/acpi.h>
  14#include <linux/io.h>
  15#include <linux/delay.h>
  16
  17#include <asm/atomic.h>
  18#include <asm/system.h>
  19#include <asm/timer.h>
  20#include <asm/hw_irq.h>
  21#include <asm/pgtable.h>
  22#include <asm/desc.h>
  23#include <asm/apic.h>
  24#include <asm/i8259.h>
  25
  26/*
  27 * This is the 'legacy' 8259A Programmable Interrupt Controller,
  28 * present in the majority of PC/AT boxes.
  29 * plus some generic x86 specific things if generic specifics makes
  30 * any sense at all.
  31 */
  32static void init_8259A(int auto_eoi);
  33
  34static int i8259A_auto_eoi;
  35DEFINE_RAW_SPINLOCK(i8259A_lock);
  36
  37/*
  38 * 8259A PIC functions to handle ISA devices:
  39 */
  40
  41/*
  42 * This contains the irq mask for both 8259A irq controllers,
  43 */
  44unsigned int cached_irq_mask = 0xffff;
  45
  46/*
  47 * Not all IRQs can be routed through the IO-APIC, eg. on certain (older)
  48 * boards the timer interrupt is not really connected to any IO-APIC pin,
  49 * it's fed to the master 8259A's IR0 line only.
  50 *
  51 * Any '1' bit in this mask means the IRQ is routed through the IO-APIC.
  52 * this 'mixed mode' IRQ handling costs nothing because it's only used
  53 * at IRQ setup time.
  54 */
  55unsigned long io_apic_irqs;
  56
  57static void mask_8259A_irq(unsigned int irq)
  58{
  59        unsigned int mask = 1 << irq;
  60        unsigned long flags;
  61
  62        raw_spin_lock_irqsave(&i8259A_lock, flags);
  63        cached_irq_mask |= mask;
  64        if (irq & 8)
  65                outb(cached_slave_mask, PIC_SLAVE_IMR);
  66        else
  67                outb(cached_master_mask, PIC_MASTER_IMR);
  68        raw_spin_unlock_irqrestore(&i8259A_lock, flags);
  69}
  70
  71static void disable_8259A_irq(struct irq_data *data)
  72{
  73        mask_8259A_irq(data->irq);
  74}
  75
  76static void unmask_8259A_irq(unsigned int irq)
  77{
  78        unsigned int mask = ~(1 << irq);
  79        unsigned long flags;
  80
  81        raw_spin_lock_irqsave(&i8259A_lock, flags);
  82        cached_irq_mask &= mask;
  83        if (irq & 8)
  84                outb(cached_slave_mask, PIC_SLAVE_IMR);
  85        else
  86                outb(cached_master_mask, PIC_MASTER_IMR);
  87        raw_spin_unlock_irqrestore(&i8259A_lock, flags);
  88}
  89
  90static void enable_8259A_irq(struct irq_data *data)
  91{
  92        unmask_8259A_irq(data->irq);
  93}
  94
  95static int i8259A_irq_pending(unsigned int irq)
  96{
  97        unsigned int mask = 1<<irq;
  98        unsigned long flags;
  99        int ret;
 100
 101        raw_spin_lock_irqsave(&i8259A_lock, flags);
 102        if (irq < 8)
 103                ret = inb(PIC_MASTER_CMD) & mask;
 104        else
 105                ret = inb(PIC_SLAVE_CMD) & (mask >> 8);
 106        raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 107
 108        return ret;
 109}
 110
 111static void make_8259A_irq(unsigned int irq)
 112{
 113        disable_irq_nosync(irq);
 114        io_apic_irqs &= ~(1<<irq);
 115        irq_set_chip_and_handler_name(irq, &i8259A_chip, handle_level_irq,
 116                                      i8259A_chip.name);
 117        enable_irq(irq);
 118}
 119
 120/*
 121 * This function assumes to be called rarely. Switching between
 122 * 8259A registers is slow.
 123 * This has to be protected by the irq controller spinlock
 124 * before being called.
 125 */
 126static inline int i8259A_irq_real(unsigned int irq)
 127{
 128        int value;
 129        int irqmask = 1<<irq;
 130
 131        if (irq < 8) {
 132                outb(0x0B, PIC_MASTER_CMD);     /* ISR register */
 133                value = inb(PIC_MASTER_CMD) & irqmask;
 134                outb(0x0A, PIC_MASTER_CMD);     /* back to the IRR register */
 135                return value;
 136        }
 137        outb(0x0B, PIC_SLAVE_CMD);      /* ISR register */
 138        value = inb(PIC_SLAVE_CMD) & (irqmask >> 8);
 139        outb(0x0A, PIC_SLAVE_CMD);      /* back to the IRR register */
 140        return value;
 141}
 142
 143/*
 144 * Careful! The 8259A is a fragile beast, it pretty
 145 * much _has_ to be done exactly like this (mask it
 146 * first, _then_ send the EOI, and the order of EOI
 147 * to the two 8259s is important!
 148 */
 149static void mask_and_ack_8259A(struct irq_data *data)
 150{
 151        unsigned int irq = data->irq;
 152        unsigned int irqmask = 1 << irq;
 153        unsigned long flags;
 154
 155        raw_spin_lock_irqsave(&i8259A_lock, flags);
 156        /*
 157         * Lightweight spurious IRQ detection. We do not want
 158         * to overdo spurious IRQ handling - it's usually a sign
 159         * of hardware problems, so we only do the checks we can
 160         * do without slowing down good hardware unnecessarily.
 161         *
 162         * Note that IRQ7 and IRQ15 (the two spurious IRQs
 163         * usually resulting from the 8259A-1|2 PICs) occur
 164         * even if the IRQ is masked in the 8259A. Thus we
 165         * can check spurious 8259A IRQs without doing the
 166         * quite slow i8259A_irq_real() call for every IRQ.
 167         * This does not cover 100% of spurious interrupts,
 168         * but should be enough to warn the user that there
 169         * is something bad going on ...
 170         */
 171        if (cached_irq_mask & irqmask)
 172                goto spurious_8259A_irq;
 173        cached_irq_mask |= irqmask;
 174
 175handle_real_irq:
 176        if (irq & 8) {
 177                inb(PIC_SLAVE_IMR);     /* DUMMY - (do we need this?) */
 178                outb(cached_slave_mask, PIC_SLAVE_IMR);
 179                /* 'Specific EOI' to slave */
 180                outb(0x60+(irq&7), PIC_SLAVE_CMD);
 181                 /* 'Specific EOI' to master-IRQ2 */
 182                outb(0x60+PIC_CASCADE_IR, PIC_MASTER_CMD);
 183        } else {
 184                inb(PIC_MASTER_IMR);    /* DUMMY - (do we need this?) */
 185                outb(cached_master_mask, PIC_MASTER_IMR);
 186                outb(0x60+irq, PIC_MASTER_CMD); /* 'Specific EOI to master */
 187        }
 188        raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 189        return;
 190
 191spurious_8259A_irq:
 192        /*
 193         * this is the slow path - should happen rarely.
 194         */
 195        if (i8259A_irq_real(irq))
 196                /*
 197                 * oops, the IRQ _is_ in service according to the
 198                 * 8259A - not spurious, go handle it.
 199                 */
 200                goto handle_real_irq;
 201
 202        {
 203                static int spurious_irq_mask;
 204                /*
 205                 * At this point we can be sure the IRQ is spurious,
 206                 * lets ACK and report it. [once per IRQ]
 207                 */
 208                if (!(spurious_irq_mask & irqmask)) {
 209                        printk(KERN_DEBUG
 210                               "spurious 8259A interrupt: IRQ%d.\n", irq);
 211                        spurious_irq_mask |= irqmask;
 212                }
 213                atomic_inc(&irq_err_count);
 214                /*
 215                 * Theoretically we do not have to handle this IRQ,
 216                 * but in Linux this does not cause problems and is
 217                 * simpler for us.
 218                 */
 219                goto handle_real_irq;
 220        }
 221}
 222
 223struct irq_chip i8259A_chip = {
 224        .name           = "XT-PIC",
 225        .irq_mask       = disable_8259A_irq,
 226        .irq_disable    = disable_8259A_irq,
 227        .irq_unmask     = enable_8259A_irq,
 228        .irq_mask_ack   = mask_and_ack_8259A,
 229};
 230
 231static char irq_trigger[2];
 232/**
 233 * ELCR registers (0x4d0, 0x4d1) control edge/level of IRQ
 234 */
 235static void restore_ELCR(char *trigger)
 236{
 237        outb(trigger[0], 0x4d0);
 238        outb(trigger[1], 0x4d1);
 239}
 240
 241static void save_ELCR(char *trigger)
 242{
 243        /* IRQ 0,1,2,8,13 are marked as reserved */
 244        trigger[0] = inb(0x4d0) & 0xF8;
 245        trigger[1] = inb(0x4d1) & 0xDE;
 246}
 247
 248static void i8259A_resume(void)
 249{
 250        init_8259A(i8259A_auto_eoi);
 251        restore_ELCR(irq_trigger);
 252}
 253
 254static int i8259A_suspend(void)
 255{
 256        save_ELCR(irq_trigger);
 257        return 0;
 258}
 259
 260static void i8259A_shutdown(void)
 261{
 262        /* Put the i8259A into a quiescent state that
 263         * the kernel initialization code can get it
 264         * out of.
 265         */
 266        outb(0xff, PIC_MASTER_IMR);     /* mask all of 8259A-1 */
 267        outb(0xff, PIC_SLAVE_IMR);      /* mask all of 8259A-1 */
 268}
 269
 270static struct syscore_ops i8259_syscore_ops = {
 271        .suspend = i8259A_suspend,
 272        .resume = i8259A_resume,
 273        .shutdown = i8259A_shutdown,
 274};
 275
 276static void mask_8259A(void)
 277{
 278        unsigned long flags;
 279
 280        raw_spin_lock_irqsave(&i8259A_lock, flags);
 281
 282        outb(0xff, PIC_MASTER_IMR);     /* mask all of 8259A-1 */
 283        outb(0xff, PIC_SLAVE_IMR);      /* mask all of 8259A-2 */
 284
 285        raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 286}
 287
 288static void unmask_8259A(void)
 289{
 290        unsigned long flags;
 291
 292        raw_spin_lock_irqsave(&i8259A_lock, flags);
 293
 294        outb(cached_master_mask, PIC_MASTER_IMR); /* restore master IRQ mask */
 295        outb(cached_slave_mask, PIC_SLAVE_IMR);   /* restore slave IRQ mask */
 296
 297        raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 298}
 299
 300static void init_8259A(int auto_eoi)
 301{
 302        unsigned long flags;
 303
 304        i8259A_auto_eoi = auto_eoi;
 305
 306        raw_spin_lock_irqsave(&i8259A_lock, flags);
 307
 308        outb(0xff, PIC_MASTER_IMR);     /* mask all of 8259A-1 */
 309        outb(0xff, PIC_SLAVE_IMR);      /* mask all of 8259A-2 */
 310
 311        /*
 312         * outb_pic - this has to work on a wide range of PC hardware.
 313         */
 314        outb_pic(0x11, PIC_MASTER_CMD); /* ICW1: select 8259A-1 init */
 315
 316        /* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 on x86-64,
 317           to 0x20-0x27 on i386 */
 318        outb_pic(IRQ0_VECTOR, PIC_MASTER_IMR);
 319
 320        /* 8259A-1 (the master) has a slave on IR2 */
 321        outb_pic(1U << PIC_CASCADE_IR, PIC_MASTER_IMR);
 322
 323        if (auto_eoi)   /* master does Auto EOI */
 324                outb_pic(MASTER_ICW4_DEFAULT | PIC_ICW4_AEOI, PIC_MASTER_IMR);
 325        else            /* master expects normal EOI */
 326                outb_pic(MASTER_ICW4_DEFAULT, PIC_MASTER_IMR);
 327
 328        outb_pic(0x11, PIC_SLAVE_CMD);  /* ICW1: select 8259A-2 init */
 329
 330        /* ICW2: 8259A-2 IR0-7 mapped to IRQ8_VECTOR */
 331        outb_pic(IRQ8_VECTOR, PIC_SLAVE_IMR);
 332        /* 8259A-2 is a slave on master's IR2 */
 333        outb_pic(PIC_CASCADE_IR, PIC_SLAVE_IMR);
 334        /* (slave's support for AEOI in flat mode is to be investigated) */
 335        outb_pic(SLAVE_ICW4_DEFAULT, PIC_SLAVE_IMR);
 336
 337        if (auto_eoi)
 338                /*
 339                 * In AEOI mode we just have to mask the interrupt
 340                 * when acking.
 341                 */
 342                i8259A_chip.irq_mask_ack = disable_8259A_irq;
 343        else
 344                i8259A_chip.irq_mask_ack = mask_and_ack_8259A;
 345
 346        udelay(100);            /* wait for 8259A to initialize */
 347
 348        outb(cached_master_mask, PIC_MASTER_IMR); /* restore master IRQ mask */
 349        outb(cached_slave_mask, PIC_SLAVE_IMR);   /* restore slave IRQ mask */
 350
 351        raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 352}
 353
 354/*
 355 * make i8259 a driver so that we can select pic functions at run time. the goal
 356 * is to make x86 binary compatible among pc compatible and non-pc compatible
 357 * platforms, such as x86 MID.
 358 */
 359
 360static void legacy_pic_noop(void) { };
 361static void legacy_pic_uint_noop(unsigned int unused) { };
 362static void legacy_pic_int_noop(int unused) { };
 363static int legacy_pic_irq_pending_noop(unsigned int irq)
 364{
 365        return 0;
 366}
 367
 368struct legacy_pic null_legacy_pic = {
 369        .nr_legacy_irqs = 0,
 370        .chip = &dummy_irq_chip,
 371        .mask = legacy_pic_uint_noop,
 372        .unmask = legacy_pic_uint_noop,
 373        .mask_all = legacy_pic_noop,
 374        .restore_mask = legacy_pic_noop,
 375        .init = legacy_pic_int_noop,
 376        .irq_pending = legacy_pic_irq_pending_noop,
 377        .make_irq = legacy_pic_uint_noop,
 378};
 379
 380struct legacy_pic default_legacy_pic = {
 381        .nr_legacy_irqs = NR_IRQS_LEGACY,
 382        .chip  = &i8259A_chip,
 383        .mask = mask_8259A_irq,
 384        .unmask = unmask_8259A_irq,
 385        .mask_all = mask_8259A,
 386        .restore_mask = unmask_8259A,
 387        .init = init_8259A,
 388        .irq_pending = i8259A_irq_pending,
 389        .make_irq = make_8259A_irq,
 390};
 391
 392struct legacy_pic *legacy_pic = &default_legacy_pic;
 393
 394static int __init i8259A_init_ops(void)
 395{
 396        if (legacy_pic == &default_legacy_pic)
 397                register_syscore_ops(&i8259_syscore_ops);
 398
 399        return 0;
 400}
 401
 402device_initcall(i8259A_init_ops);
 403

The original LXR software by the LXR community, this experimental version by lxr@linux.no.
lxr.linux.no kindly hosted by Redpill Linpro AS, provider of Linux consulting and operations services since 1995.

