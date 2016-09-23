	.file	"time.c"
	.text
.Ltext0:
	.comm	irq_desc,192,64
	.comm	bh_flags,4,4
	.local	time_bh
	.comm	time_bh,4,4
	.type	timer_interrupt, @function
timer_interrupt:
.LFB13:
	.file 1 "time.c"
	.loc 1 7 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 9 0
	subl	$12, %esp
	pushl	16(%ebp)
	call	do_timer
	addl	$16, %esp
	.loc 1 10 0
	movl	time_bh, %eax
	subl	$12, %esp
	pushl	%eax
	call	mark_bh
	addl	$16, %esp
	.loc 1 11 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE13:
	.size	timer_interrupt, .-timer_interrupt
	.globl	time_bottomhalf
	.type	time_bottomhalf, @function
time_bottomhalf:
.LFB14:
	.loc 1 13 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 14 0
	call	my_timerlist_dida
	.loc 1 15 0
	movl	$0, %eax
	.loc 1 16 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE14:
	.size	time_bottomhalf, .-time_bottomhalf
	.globl	init_time
	.type	init_time, @function
init_time:
.LFB15:
	.loc 1 17 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 19 0
	pushl	$0
	pushl	$2
	pushl	$timer_interrupt
	pushl	$0
	call	request_irq
	addl	$16, %esp
	.loc 1 21 0
	movl	irq_desc, %eax
	andl	$-5, %eax
	movl	%eax, irq_desc
	.loc 1 22 0
	subl	$8, %esp
	pushl	$0
	pushl	$time_bottomhalf
	call	alloc_bh
	addl	$16, %esp
	movl	%eax, time_bh
	.loc 1 23 0
	call	init_mytimer
	.loc 1 24 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE15:
	.size	init_time, .-init_time
.Letext0:
	.file 2 "./include/old/irq.h"
	.file 3 "./include/linux/bh.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x226
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.long	.LASF306
	.byte	0x1
	.long	.LASF307
	.long	.LASF308
	.long	.Ltext0
	.long	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.long	.Ldebug_macro0
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF283
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF284
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.long	.LASF285
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.long	.LASF286
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF287
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF288
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.long	.LASF289
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.long	.LASF290
	.uleb128 0x4
	.byte	0x4
	.uleb128 0x5
	.byte	0x10
	.byte	0x2
	.byte	0xc
	.long	0xa3
	.uleb128 0x6
	.long	.LASF291
	.byte	0x2
	.byte	0xd
	.long	0xae
	.byte	0
	.uleb128 0x6
	.long	.LASF292
	.byte	0x2
	.byte	0xe
	.long	0xae
	.byte	0x4
	.uleb128 0x7
	.string	"ack"
	.byte	0x2
	.byte	0xf
	.long	0xae
	.byte	0x8
	.uleb128 0x7
	.string	"end"
	.byte	0x2
	.byte	0x10
	.long	0xae
	.byte	0xc
	.byte	0
	.uleb128 0x8
	.long	0xae
	.uleb128 0x9
	.long	0x45
	.byte	0
	.uleb128 0xa
	.byte	0x4
	.long	0xa3
	.uleb128 0xb
	.long	.LASF299
	.byte	0x2
	.byte	0x11
	.long	0x6a
	.uleb128 0x5
	.byte	0xc
	.byte	0x2
	.byte	0x13
	.long	0xec
	.uleb128 0x6
	.long	.LASF293
	.byte	0x2
	.byte	0x14
	.long	0x45
	.byte	0
	.uleb128 0x6
	.long	.LASF294
	.byte	0x2
	.byte	0x15
	.long	0x129
	.byte	0x4
	.uleb128 0x6
	.long	.LASF295
	.byte	0x2
	.byte	0x16
	.long	0x12f
	.byte	0x8
	.byte	0
	.uleb128 0xc
	.long	.LASF309
	.byte	0x10
	.byte	0x2
	.byte	0x1c
	.long	0x129
	.uleb128 0x6
	.long	.LASF296
	.byte	0x2
	.byte	0x20
	.long	0x160
	.byte	0
	.uleb128 0x6
	.long	.LASF297
	.byte	0x2
	.byte	0x21
	.long	0x45
	.byte	0x4
	.uleb128 0x7
	.string	"dev"
	.byte	0x2
	.byte	0x22
	.long	0x68
	.byte	0x8
	.uleb128 0x6
	.long	.LASF298
	.byte	0x2
	.byte	0x24
	.long	0x129
	.byte	0xc
	.byte	0
	.uleb128 0xa
	.byte	0x4
	.long	0xec
	.uleb128 0xa
	.byte	0x4
	.long	0xb4
	.uleb128 0xb
	.long	.LASF300
	.byte	0x2
	.byte	0x17
	.long	0xbf
	.uleb128 0x8
	.long	0x155
	.uleb128 0x9
	.long	0x5a
	.uleb128 0x9
	.long	0x68
	.uleb128 0x9
	.long	0x155
	.byte	0
	.uleb128 0xa
	.byte	0x4
	.long	0x15b
	.uleb128 0xd
	.long	.LASF310
	.uleb128 0xa
	.byte	0x4
	.long	0x140
	.uleb128 0xe
	.long	.LASF311
	.byte	0x1
	.byte	0x7
	.long	.LFB13
	.long	.LFE13-.LFB13
	.uleb128 0x1
	.byte	0x9c
	.long	0x1a6
	.uleb128 0xf
	.string	"irq"
	.byte	0x1
	.byte	0x7
	.long	0x5a
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xf
	.string	"dev"
	.byte	0x1
	.byte	0x7
	.long	0x68
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x10
	.long	.LASF301
	.byte	0x1
	.byte	0x7
	.long	0x155
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.byte	0
	.uleb128 0x11
	.long	.LASF312
	.byte	0x1
	.byte	0xd
	.long	0x5a
	.long	.LFB14
	.long	.LFE14-.LFB14
	.uleb128 0x1
	.byte	0x9c
	.long	0x1ce
	.uleb128 0x10
	.long	.LASF302
	.byte	0x1
	.byte	0xd
	.long	0x68
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x12
	.long	.LASF313
	.byte	0x1
	.byte	0x11
	.long	.LFB15
	.long	.LFE15-.LFB15
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x13
	.long	.LASF314
	.byte	0x1
	.byte	0x6
	.long	0x5a
	.uleb128 0x5
	.byte	0x3
	.long	time_bh
	.uleb128 0x14
	.long	0x135
	.long	0x200
	.uleb128 0x15
	.long	0x200
	.byte	0xf
	.byte	0
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF303
	.uleb128 0x16
	.long	.LASF304
	.byte	0x2
	.byte	0x27
	.long	0x1f0
	.uleb128 0x5
	.byte	0x3
	.long	irq_desc
	.uleb128 0x16
	.long	.LASF305
	.byte	0x3
	.byte	0x6
	.long	0x45
	.uleb128 0x5
	.byte	0x3
	.long	bh_flags
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x10
	.uleb128 0x17
	.uleb128 0x2119
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x13
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x13
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.long	0x1c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x4
	.byte	0
	.value	0
	.value	0
	.long	.Ltext0
	.long	.Letext0-.Ltext0
	.long	0
	.long	0
	.section	.debug_macro,"",@progbits
.Ldebug_macro0:
	.value	0x4
	.byte	0x2
	.long	.Ldebug_line0
	.byte	0x3
	.uleb128 0
	.uleb128 0x1
	.byte	0x5
	.uleb128 0x1
	.long	.LASF0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF1
	.byte	0x5
	.uleb128 0x3
	.long	.LASF2
	.byte	0x5
	.uleb128 0x4
	.long	.LASF3
	.byte	0x5
	.uleb128 0x5
	.long	.LASF4
	.byte	0x5
	.uleb128 0x6
	.long	.LASF5
	.byte	0x5
	.uleb128 0x7
	.long	.LASF6
	.byte	0x5
	.uleb128 0x8
	.long	.LASF7
	.byte	0x5
	.uleb128 0x9
	.long	.LASF8
	.byte	0x5
	.uleb128 0xa
	.long	.LASF9
	.byte	0x5
	.uleb128 0xb
	.long	.LASF10
	.byte	0x5
	.uleb128 0xc
	.long	.LASF11
	.byte	0x5
	.uleb128 0xd
	.long	.LASF12
	.byte	0x5
	.uleb128 0xe
	.long	.LASF13
	.byte	0x5
	.uleb128 0xf
	.long	.LASF14
	.byte	0x5
	.uleb128 0x10
	.long	.LASF15
	.byte	0x5
	.uleb128 0x11
	.long	.LASF16
	.byte	0x5
	.uleb128 0x12
	.long	.LASF17
	.byte	0x5
	.uleb128 0x13
	.long	.LASF18
	.byte	0x5
	.uleb128 0x14
	.long	.LASF19
	.byte	0x5
	.uleb128 0x15
	.long	.LASF20
	.byte	0x5
	.uleb128 0x16
	.long	.LASF21
	.byte	0x5
	.uleb128 0x17
	.long	.LASF22
	.byte	0x5
	.uleb128 0x18
	.long	.LASF23
	.byte	0x5
	.uleb128 0x19
	.long	.LASF24
	.byte	0x5
	.uleb128 0x1a
	.long	.LASF25
	.byte	0x5
	.uleb128 0x1b
	.long	.LASF26
	.byte	0x5
	.uleb128 0x1c
	.long	.LASF27
	.byte	0x5
	.uleb128 0x1d
	.long	.LASF28
	.byte	0x5
	.uleb128 0x1e
	.long	.LASF29
	.byte	0x5
	.uleb128 0x1f
	.long	.LASF30
	.byte	0x5
	.uleb128 0x20
	.long	.LASF31
	.byte	0x5
	.uleb128 0x21
	.long	.LASF32
	.byte	0x5
	.uleb128 0x22
	.long	.LASF33
	.byte	0x5
	.uleb128 0x23
	.long	.LASF34
	.byte	0x5
	.uleb128 0x24
	.long	.LASF35
	.byte	0x5
	.uleb128 0x25
	.long	.LASF36
	.byte	0x5
	.uleb128 0x26
	.long	.LASF37
	.byte	0x5
	.uleb128 0x27
	.long	.LASF38
	.byte	0x5
	.uleb128 0x28
	.long	.LASF39
	.byte	0x5
	.uleb128 0x29
	.long	.LASF40
	.byte	0x5
	.uleb128 0x2a
	.long	.LASF41
	.byte	0x5
	.uleb128 0x2b
	.long	.LASF42
	.byte	0x5
	.uleb128 0x2c
	.long	.LASF43
	.byte	0x5
	.uleb128 0x2d
	.long	.LASF44
	.byte	0x5
	.uleb128 0x2e
	.long	.LASF45
	.byte	0x5
	.uleb128 0x2f
	.long	.LASF46
	.byte	0x5
	.uleb128 0x30
	.long	.LASF47
	.byte	0x5
	.uleb128 0x31
	.long	.LASF48
	.byte	0x5
	.uleb128 0x32
	.long	.LASF49
	.byte	0x5
	.uleb128 0x33
	.long	.LASF50
	.byte	0x5
	.uleb128 0x34
	.long	.LASF51
	.byte	0x5
	.uleb128 0x35
	.long	.LASF52
	.byte	0x5
	.uleb128 0x36
	.long	.LASF53
	.byte	0x5
	.uleb128 0x37
	.long	.LASF54
	.byte	0x5
	.uleb128 0x38
	.long	.LASF55
	.byte	0x5
	.uleb128 0x39
	.long	.LASF56
	.byte	0x5
	.uleb128 0x3a
	.long	.LASF57
	.byte	0x5
	.uleb128 0x3b
	.long	.LASF58
	.byte	0x5
	.uleb128 0x3c
	.long	.LASF59
	.byte	0x5
	.uleb128 0x3d
	.long	.LASF60
	.byte	0x5
	.uleb128 0x3e
	.long	.LASF61
	.byte	0x5
	.uleb128 0x3f
	.long	.LASF62
	.byte	0x5
	.uleb128 0x40
	.long	.LASF63
	.byte	0x5
	.uleb128 0x41
	.long	.LASF64
	.byte	0x5
	.uleb128 0x42
	.long	.LASF65
	.byte	0x5
	.uleb128 0x43
	.long	.LASF66
	.byte	0x5
	.uleb128 0x44
	.long	.LASF67
	.byte	0x5
	.uleb128 0x45
	.long	.LASF68
	.byte	0x5
	.uleb128 0x46
	.long	.LASF69
	.byte	0x5
	.uleb128 0x47
	.long	.LASF70
	.byte	0x5
	.uleb128 0x48
	.long	.LASF71
	.byte	0x5
	.uleb128 0x49
	.long	.LASF72
	.byte	0x5
	.uleb128 0x4a
	.long	.LASF73
	.byte	0x5
	.uleb128 0x4b
	.long	.LASF74
	.byte	0x5
	.uleb128 0x4c
	.long	.LASF75
	.byte	0x5
	.uleb128 0x4d
	.long	.LASF76
	.byte	0x5
	.uleb128 0x4e
	.long	.LASF77
	.byte	0x5
	.uleb128 0x4f
	.long	.LASF78
	.byte	0x5
	.uleb128 0x50
	.long	.LASF79
	.byte	0x5
	.uleb128 0x51
	.long	.LASF80
	.byte	0x5
	.uleb128 0x52
	.long	.LASF81
	.byte	0x5
	.uleb128 0x53
	.long	.LASF82
	.byte	0x5
	.uleb128 0x54
	.long	.LASF83
	.byte	0x5
	.uleb128 0x55
	.long	.LASF84
	.byte	0x5
	.uleb128 0x56
	.long	.LASF85
	.byte	0x5
	.uleb128 0x57
	.long	.LASF86
	.byte	0x5
	.uleb128 0x58
	.long	.LASF87
	.byte	0x5
	.uleb128 0x59
	.long	.LASF88
	.byte	0x5
	.uleb128 0x5a
	.long	.LASF89
	.byte	0x5
	.uleb128 0x5b
	.long	.LASF90
	.byte	0x5
	.uleb128 0x5c
	.long	.LASF91
	.byte	0x5
	.uleb128 0x5d
	.long	.LASF92
	.byte	0x5
	.uleb128 0x5e
	.long	.LASF93
	.byte	0x5
	.uleb128 0x5f
	.long	.LASF94
	.byte	0x5
	.uleb128 0x60
	.long	.LASF95
	.byte	0x5
	.uleb128 0x61
	.long	.LASF96
	.byte	0x5
	.uleb128 0x62
	.long	.LASF97
	.byte	0x5
	.uleb128 0x63
	.long	.LASF98
	.byte	0x5
	.uleb128 0x64
	.long	.LASF99
	.byte	0x5
	.uleb128 0x65
	.long	.LASF100
	.byte	0x5
	.uleb128 0x66
	.long	.LASF101
	.byte	0x5
	.uleb128 0x67
	.long	.LASF102
	.byte	0x5
	.uleb128 0x68
	.long	.LASF103
	.byte	0x5
	.uleb128 0x69
	.long	.LASF104
	.byte	0x5
	.uleb128 0x6a
	.long	.LASF105
	.byte	0x5
	.uleb128 0x6b
	.long	.LASF106
	.byte	0x5
	.uleb128 0x6c
	.long	.LASF107
	.byte	0x5
	.uleb128 0x6d
	.long	.LASF108
	.byte	0x5
	.uleb128 0x6e
	.long	.LASF109
	.byte	0x5
	.uleb128 0x6f
	.long	.LASF110
	.byte	0x5
	.uleb128 0x70
	.long	.LASF111
	.byte	0x5
	.uleb128 0x71
	.long	.LASF112
	.byte	0x5
	.uleb128 0x72
	.long	.LASF113
	.byte	0x5
	.uleb128 0x73
	.long	.LASF114
	.byte	0x5
	.uleb128 0x74
	.long	.LASF115
	.byte	0x5
	.uleb128 0x75
	.long	.LASF116
	.byte	0x5
	.uleb128 0x76
	.long	.LASF117
	.byte	0x5
	.uleb128 0x77
	.long	.LASF118
	.byte	0x5
	.uleb128 0x78
	.long	.LASF119
	.byte	0x5
	.uleb128 0x79
	.long	.LASF120
	.byte	0x5
	.uleb128 0x7a
	.long	.LASF121
	.byte	0x5
	.uleb128 0x7b
	.long	.LASF122
	.byte	0x5
	.uleb128 0x7c
	.long	.LASF123
	.byte	0x5
	.uleb128 0x7d
	.long	.LASF124
	.byte	0x5
	.uleb128 0x7e
	.long	.LASF125
	.byte	0x5
	.uleb128 0x7f
	.long	.LASF126
	.byte	0x5
	.uleb128 0x80
	.long	.LASF127
	.byte	0x5
	.uleb128 0x81
	.long	.LASF128
	.byte	0x5
	.uleb128 0x82
	.long	.LASF129
	.byte	0x5
	.uleb128 0x83
	.long	.LASF130
	.byte	0x5
	.uleb128 0x84
	.long	.LASF131
	.byte	0x5
	.uleb128 0x85
	.long	.LASF132
	.byte	0x5
	.uleb128 0x86
	.long	.LASF133
	.byte	0x5
	.uleb128 0x87
	.long	.LASF134
	.byte	0x5
	.uleb128 0x88
	.long	.LASF135
	.byte	0x5
	.uleb128 0x89
	.long	.LASF136
	.byte	0x5
	.uleb128 0x8a
	.long	.LASF137
	.byte	0x5
	.uleb128 0x8b
	.long	.LASF138
	.byte	0x5
	.uleb128 0x8c
	.long	.LASF139
	.byte	0x5
	.uleb128 0x8d
	.long	.LASF140
	.byte	0x5
	.uleb128 0x8e
	.long	.LASF141
	.byte	0x5
	.uleb128 0x8f
	.long	.LASF142
	.byte	0x5
	.uleb128 0x90
	.long	.LASF143
	.byte	0x5
	.uleb128 0x91
	.long	.LASF144
	.byte	0x5
	.uleb128 0x92
	.long	.LASF145
	.byte	0x5
	.uleb128 0x93
	.long	.LASF146
	.byte	0x5
	.uleb128 0x94
	.long	.LASF147
	.byte	0x5
	.uleb128 0x95
	.long	.LASF148
	.byte	0x5
	.uleb128 0x96
	.long	.LASF149
	.byte	0x5
	.uleb128 0x97
	.long	.LASF150
	.byte	0x5
	.uleb128 0x98
	.long	.LASF151
	.byte	0x5
	.uleb128 0x99
	.long	.LASF152
	.byte	0x5
	.uleb128 0x9a
	.long	.LASF153
	.byte	0x5
	.uleb128 0x9b
	.long	.LASF154
	.byte	0x5
	.uleb128 0x9c
	.long	.LASF155
	.byte	0x5
	.uleb128 0x9d
	.long	.LASF156
	.byte	0x5
	.uleb128 0x9e
	.long	.LASF157
	.byte	0x5
	.uleb128 0x9f
	.long	.LASF158
	.byte	0x5
	.uleb128 0xa0
	.long	.LASF159
	.byte	0x5
	.uleb128 0xa1
	.long	.LASF160
	.byte	0x5
	.uleb128 0xa2
	.long	.LASF161
	.byte	0x5
	.uleb128 0xa3
	.long	.LASF162
	.byte	0x5
	.uleb128 0xa4
	.long	.LASF163
	.byte	0x5
	.uleb128 0xa5
	.long	.LASF164
	.byte	0x5
	.uleb128 0xa6
	.long	.LASF165
	.byte	0x5
	.uleb128 0xa7
	.long	.LASF166
	.byte	0x5
	.uleb128 0xa8
	.long	.LASF167
	.byte	0x5
	.uleb128 0xa9
	.long	.LASF168
	.byte	0x5
	.uleb128 0xaa
	.long	.LASF169
	.byte	0x5
	.uleb128 0xab
	.long	.LASF170
	.byte	0x5
	.uleb128 0xac
	.long	.LASF171
	.byte	0x5
	.uleb128 0xad
	.long	.LASF172
	.byte	0x5
	.uleb128 0xae
	.long	.LASF173
	.byte	0x5
	.uleb128 0xaf
	.long	.LASF174
	.byte	0x5
	.uleb128 0xb0
	.long	.LASF175
	.byte	0x5
	.uleb128 0xb1
	.long	.LASF176
	.byte	0x5
	.uleb128 0xb2
	.long	.LASF177
	.byte	0x5
	.uleb128 0xb3
	.long	.LASF178
	.byte	0x5
	.uleb128 0xb4
	.long	.LASF179
	.byte	0x5
	.uleb128 0xb5
	.long	.LASF180
	.byte	0x5
	.uleb128 0xb6
	.long	.LASF181
	.byte	0x5
	.uleb128 0xb7
	.long	.LASF182
	.byte	0x5
	.uleb128 0xb8
	.long	.LASF183
	.byte	0x5
	.uleb128 0xb9
	.long	.LASF184
	.byte	0x5
	.uleb128 0xba
	.long	.LASF185
	.byte	0x5
	.uleb128 0xbb
	.long	.LASF186
	.byte	0x5
	.uleb128 0xbc
	.long	.LASF187
	.byte	0x5
	.uleb128 0xbd
	.long	.LASF188
	.byte	0x5
	.uleb128 0xbe
	.long	.LASF189
	.byte	0x5
	.uleb128 0xbf
	.long	.LASF190
	.byte	0x5
	.uleb128 0xc0
	.long	.LASF191
	.byte	0x5
	.uleb128 0xc1
	.long	.LASF192
	.byte	0x5
	.uleb128 0xc2
	.long	.LASF193
	.byte	0x5
	.uleb128 0xc3
	.long	.LASF194
	.byte	0x5
	.uleb128 0xc4
	.long	.LASF195
	.byte	0x5
	.uleb128 0xc5
	.long	.LASF196
	.byte	0x5
	.uleb128 0xc6
	.long	.LASF197
	.byte	0x5
	.uleb128 0xc7
	.long	.LASF198
	.byte	0x5
	.uleb128 0xc8
	.long	.LASF199
	.byte	0x5
	.uleb128 0xc9
	.long	.LASF200
	.byte	0x5
	.uleb128 0xca
	.long	.LASF201
	.byte	0x5
	.uleb128 0xcb
	.long	.LASF202
	.byte	0x5
	.uleb128 0xcc
	.long	.LASF203
	.byte	0x5
	.uleb128 0xcd
	.long	.LASF204
	.byte	0x5
	.uleb128 0xce
	.long	.LASF205
	.byte	0x5
	.uleb128 0xcf
	.long	.LASF206
	.byte	0x5
	.uleb128 0xd0
	.long	.LASF207
	.byte	0x5
	.uleb128 0xd1
	.long	.LASF208
	.byte	0x5
	.uleb128 0xd2
	.long	.LASF209
	.byte	0x5
	.uleb128 0xd3
	.long	.LASF210
	.byte	0x5
	.uleb128 0xd4
	.long	.LASF211
	.byte	0x5
	.uleb128 0xd5
	.long	.LASF212
	.byte	0x5
	.uleb128 0xd6
	.long	.LASF213
	.byte	0x5
	.uleb128 0xd7
	.long	.LASF214
	.byte	0x5
	.uleb128 0xd8
	.long	.LASF215
	.byte	0x5
	.uleb128 0xd9
	.long	.LASF216
	.byte	0x5
	.uleb128 0xda
	.long	.LASF217
	.byte	0x5
	.uleb128 0xdb
	.long	.LASF218
	.byte	0x5
	.uleb128 0xdc
	.long	.LASF219
	.byte	0x5
	.uleb128 0xdd
	.long	.LASF220
	.byte	0x5
	.uleb128 0xde
	.long	.LASF221
	.byte	0x5
	.uleb128 0xdf
	.long	.LASF222
	.byte	0x5
	.uleb128 0xe0
	.long	.LASF223
	.byte	0x5
	.uleb128 0xe1
	.long	.LASF224
	.byte	0x5
	.uleb128 0xe2
	.long	.LASF225
	.byte	0x5
	.uleb128 0xe3
	.long	.LASF226
	.byte	0x5
	.uleb128 0xe4
	.long	.LASF227
	.file 4 "./include/linux/timer.h"
	.byte	0x3
	.uleb128 0x1
	.uleb128 0x4
	.byte	0x5
	.uleb128 0x2
	.long	.LASF228
	.file 5 "./include/old/valType.h"
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x5
	.byte	0x7
	.long	.Ldebug_macro1
	.byte	0x4
	.file 6 "./include/old/list.h"
	.byte	0x3
	.uleb128 0x4
	.uleb128 0x6
	.byte	0x5
	.uleb128 0x2
	.long	.LASF242
	.file 7 "./include/linux/assert.h"
	.byte	0x3
	.uleb128 0x5
	.uleb128 0x7
	.byte	0x7
	.long	.Ldebug_macro2
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro3
	.byte	0x4
	.byte	0x4
	.file 8 "./include/old/time.h"
	.byte	0x3
	.uleb128 0x2
	.uleb128 0x8
	.byte	0x5
	.uleb128 0x2
	.long	.LASF248
	.byte	0x4
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x2
	.byte	0x7
	.long	.Ldebug_macro4
	.byte	0x4
	.file 9 "./include/linux/sched.h"
	.byte	0x3
	.uleb128 0x4
	.uleb128 0x9
	.byte	0x5
	.uleb128 0x2
	.long	.LASF256
	.file 10 "./arch/x86/include/asm/page.h"
	.byte	0x3
	.uleb128 0x5
	.uleb128 0xa
	.byte	0x7
	.long	.Ldebug_macro5
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro6
	.byte	0x4
	.byte	0x3
	.uleb128 0x5
	.uleb128 0x3
	.byte	0x7
	.long	.Ldebug_macro7
	.byte	0x4
	.byte	0x4
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.valType.h.3.7c3190cc3f15c77f186fd44ab736eede,comdat
.Ldebug_macro1:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x3
	.long	.LASF229
	.byte	0x5
	.uleb128 0x5
	.long	.LASF230
	.byte	0x5
	.uleb128 0x6
	.long	.LASF231
	.byte	0x5
	.uleb128 0x7
	.long	.LASF232
	.byte	0x5
	.uleb128 0x8
	.long	.LASF233
	.byte	0x5
	.uleb128 0x9
	.long	.LASF234
	.byte	0x5
	.uleb128 0xb
	.long	.LASF235
	.byte	0x5
	.uleb128 0x39
	.long	.LASF236
	.byte	0x5
	.uleb128 0x3a
	.long	.LASF237
	.byte	0x5
	.uleb128 0x3b
	.long	.LASF238
	.byte	0x5
	.uleb128 0x3c
	.long	.LASF239
	.byte	0x5
	.uleb128 0x3d
	.long	.LASF240
	.byte	0x5
	.uleb128 0x3e
	.long	.LASF241
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.assert.h.2.04d8cd0d4ab92c4edaf5ee8e3da38922,comdat
.Ldebug_macro2:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF243
	.byte	0x5
	.uleb128 0x6
	.long	.LASF244
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.list.h.11.14b8b11cd281772ad6d5a70018d2cfae,comdat
.Ldebug_macro3:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0xb
	.long	.LASF245
	.byte	0x5
	.uleb128 0x46
	.long	.LASF246
	.byte	0x5
	.uleb128 0x57
	.long	.LASF247
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.irq.h.2.0465ec3a878e7f9adbbe1cb8e65ad97f,comdat
.Ldebug_macro4:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF249
	.byte	0x5
	.uleb128 0x7
	.long	.LASF250
	.byte	0x5
	.uleb128 0x9
	.long	.LASF251
	.byte	0x5
	.uleb128 0xa
	.long	.LASF252
	.byte	0x5
	.uleb128 0xb
	.long	.LASF253
	.byte	0x5
	.uleb128 0x1a
	.long	.LASF254
	.byte	0x5
	.uleb128 0x1b
	.long	.LASF255
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.page.h.2.207eb50c0e81a8bc7de8e22e9a0f0426,comdat
.Ldebug_macro5:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF257
	.byte	0x5
	.uleb128 0x5
	.long	.LASF258
	.byte	0x5
	.uleb128 0x6
	.long	.LASF259
	.byte	0x5
	.uleb128 0x7
	.long	.LASF260
	.byte	0x5
	.uleb128 0x8
	.long	.LASF261
	.byte	0x5
	.uleb128 0x9
	.long	.LASF262
	.byte	0x5
	.uleb128 0xb
	.long	.LASF263
	.byte	0x5
	.uleb128 0xc
	.long	.LASF264
	.byte	0x5
	.uleb128 0xd
	.long	.LASF265
	.byte	0x5
	.uleb128 0xf
	.long	.LASF266
	.byte	0x5
	.uleb128 0x10
	.long	.LASF267
	.byte	0x5
	.uleb128 0x16
	.long	.LASF268
	.byte	0x5
	.uleb128 0x1c
	.long	.LASF269
	.byte	0x5
	.uleb128 0x1d
	.long	.LASF270
	.byte	0x5
	.uleb128 0x20
	.long	.LASF271
	.byte	0x5
	.uleb128 0x21
	.long	.LASF272
	.byte	0x5
	.uleb128 0x64
	.long	.LASF273
	.byte	0x5
	.uleb128 0x65
	.long	.LASF274
	.byte	0x5
	.uleb128 0x66
	.long	.LASF275
	.byte	0x5
	.uleb128 0x6f
	.long	.LASF276
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.sched.h.10.6a50c6495627d3a31697267fc44c1817,comdat
.Ldebug_macro6:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0xa
	.long	.LASF277
	.byte	0x5
	.uleb128 0xb
	.long	.LASF278
	.byte	0x5
	.uleb128 0xc
	.long	.LASF279
	.byte	0x5
	.uleb128 0xd
	.long	.LASF280
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.bh.h.2.b0a2b86dcd29ad39fa95392a181fa23d,comdat
.Ldebug_macro7:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF281
	.byte	0x5
	.uleb128 0x5
	.long	.LASF282
	.byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF88:
	.string	"__INT64_MAX__ 9223372036854775807LL"
.LASF108:
	.string	"__UINT64_C(c) c ## ULL"
.LASF21:
	.string	"__SIZEOF_SIZE_T__ 4"
.LASF222:
	.string	"__linux 1"
.LASF263:
	.string	"PG_P 1"
.LASF99:
	.string	"__INT_LEAST64_MAX__ 9223372036854775807LL"
.LASF29:
	.string	"__SIZEOF_POINTER__ 4"
.LASF298:
	.string	"next"
.LASF259:
	.string	"PAGE_SIZE 0x1000"
.LASF89:
	.string	"__UINT8_MAX__ 255"
.LASF181:
	.string	"__DEC128_MIN_EXP__ (-6142)"
.LASF173:
	.string	"__DEC64_MANT_DIG__ 16"
.LASF101:
	.string	"__UINT_LEAST8_MAX__ 255"
.LASF82:
	.string	"__UINTMAX_C(c) c ## ULL"
.LASF66:
	.string	"__has_include_next(STR) __has_include_next__(STR)"
.LASF46:
	.string	"__UINT64_TYPE__ long long unsigned int"
.LASF225:
	.string	"__unix__ 1"
.LASF157:
	.string	"__LDBL_MAX_10_EXP__ 4932"
.LASF268:
	.string	"FLUSH_TLB __asm__ __volatile__(\"mov %%cr3, %0\\n\\t\" \"mov %0, %%cr3\\n\\t\" : :\"r\"(0))"
.LASF210:
	.string	"__SIZEOF_WINT_T__ 4"
.LASF309:
	.string	"irqaction"
.LASF251:
	.string	"IRQ_PENDING 1"
.LASF290:
	.string	"long long unsigned int"
.LASF160:
	.string	"__LDBL_MIN__ 3.36210314311209350626e-4932L"
.LASF307:
	.string	"time.c"
.LASF262:
	.string	"pa_pg pa_idx"
.LASF230:
	.string	"bool _Bool"
.LASF150:
	.string	"__DBL_HAS_INFINITY__ 1"
.LASF282:
	.string	"BH_FLAG_DISABLE 1"
.LASF272:
	.string	"pte2page_t(pte) ( mem_map + (pte).physical )"
.LASF45:
	.string	"__UINT32_TYPE__ unsigned int"
.LASF223:
	.string	"__linux__ 1"
.LASF219:
	.string	"__pentiumpro__ 1"
.LASF2:
	.string	"__STDC_HOSTED__ 1"
.LASF314:
	.string	"time_bh"
.LASF234:
	.string	"__DEBUG "
.LASF284:
	.string	"long long int"
.LASF288:
	.string	"signed char"
.LASF30:
	.string	"__SIZE_TYPE__ unsigned int"
.LASF304:
	.string	"irq_desc"
.LASF131:
	.string	"__FLT_MAX__ 3.40282346638528859812e+38F"
.LASF283:
	.string	"long unsigned int"
.LASF300:
	.string	"irq_desc_t"
.LASF54:
	.string	"__UINT_LEAST64_TYPE__ long long unsigned int"
.LASF229:
	.string	"VALTYPE_H "
.LASF63:
	.string	"__INTPTR_TYPE__ int"
.LASF138:
	.string	"__DBL_MANT_DIG__ 53"
.LASF256:
	.string	"LINUX_SCHED_H "
.LASF43:
	.string	"__UINT8_TYPE__ unsigned char"
.LASF168:
	.string	"__DEC32_MAX_EXP__ 97"
.LASF41:
	.string	"__INT32_TYPE__ int"
.LASF38:
	.string	"__SIG_ATOMIC_TYPE__ int"
.LASF299:
	.string	"hw_irq_controller"
.LASF140:
	.string	"__DBL_MIN_EXP__ (-1021)"
.LASF277:
	.string	"CSIGNAL 0xff"
.LASF15:
	.string	"__SIZEOF_LONG__ 4"
.LASF253:
	.string	"IRQ_DISABLED (1<<2)"
.LASF205:
	.string	"__GCC_ATOMIC_TEST_AND_SET_TRUEVAL 1"
.LASF305:
	.string	"bh_flags"
.LASF313:
	.string	"init_time"
.LASF221:
	.string	"__gnu_linux__ 1"
.LASF264:
	.string	"PG_USU 4"
.LASF200:
	.string	"__GCC_ATOMIC_WCHAR_T_LOCK_FREE 2"
.LASF39:
	.string	"__INT8_TYPE__ signed char"
.LASF27:
	.string	"__BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__"
.LASF271:
	.string	"pte2page(pte) ((void *)__va((pte).value & PAGE_MASK))"
.LASF291:
	.string	"enable"
.LASF90:
	.string	"__UINT16_MAX__ 65535"
.LASF28:
	.string	"__FLOAT_WORD_ORDER__ __ORDER_LITTLE_ENDIAN__"
.LASF231:
	.string	"boolean _Bool"
.LASF208:
	.string	"__PRAGMA_REDEFINE_EXTNAME 1"
.LASF48:
	.string	"__INT_LEAST16_TYPE__ short int"
.LASF56:
	.string	"__INT_FAST16_TYPE__ int"
.LASF158:
	.string	"__DECIMAL_DIG__ 21"
.LASF278:
	.string	"CLONE_VM 0x100"
.LASF212:
	.string	"__i386 1"
.LASF145:
	.string	"__DBL_MAX__ ((double)1.79769313486231570815e+308L)"
.LASF40:
	.string	"__INT16_TYPE__ short int"
.LASF165:
	.string	"__LDBL_HAS_QUIET_NAN__ 1"
.LASF19:
	.string	"__SIZEOF_DOUBLE__ 8"
.LASF265:
	.string	"PG_RWW 2"
.LASF116:
	.string	"__UINT_FAST64_MAX__ 18446744073709551615ULL"
.LASF172:
	.string	"__DEC32_SUBNORMAL_MIN__ 0.000001E-95DF"
.LASF8:
	.string	"__ATOMIC_SEQ_CST 5"
.LASF203:
	.string	"__GCC_ATOMIC_LONG_LOCK_FREE 2"
.LASF294:
	.string	"action"
.LASF292:
	.string	"disable"
.LASF227:
	.string	"__DECIMAL_BID_FORMAT__ 1"
.LASF199:
	.string	"__GCC_ATOMIC_CHAR32_T_LOCK_FREE 2"
.LASF109:
	.string	"__INT_FAST8_MAX__ 127"
.LASF35:
	.string	"__UINTMAX_TYPE__ long long unsigned int"
.LASF190:
	.string	"__NO_INLINE__ 1"
.LASF169:
	.string	"__DEC32_MIN__ 1E-95DF"
.LASF306:
	.string	"GNU C 4.9.2 -mtune=generic -march=i686 -g3 -std=c99 -fno-builtin -fno-stack-protector"
.LASF16:
	.string	"__SIZEOF_LONG_LONG__ 8"
.LASF125:
	.string	"__FLT_DIG__ 6"
.LASF73:
	.string	"__WCHAR_MAX__ 2147483647L"
.LASF209:
	.string	"__SIZEOF_WCHAR_T__ 4"
.LASF10:
	.string	"__ATOMIC_RELEASE 3"
.LASF261:
	.string	"pa_idx(paddr) ((paddr)>>PAGE_SHIFT)"
.LASF129:
	.string	"__FLT_MAX_10_EXP__ 38"
.LASF287:
	.string	"unsigned int"
.LASF76:
	.string	"__WINT_MIN__ 0U"
.LASF273:
	.string	"PAGE_OFFSET 0XC0000000"
.LASF70:
	.string	"__INT_MAX__ 2147483647"
.LASF94:
	.string	"__INT8_C(c) c"
.LASF217:
	.string	"__i686__ 1"
.LASF267:
	.string	"PG_L10(pg_id) (pg_id&(0x400-1))"
.LASF122:
	.string	"__DEC_EVAL_METHOD__ 2"
.LASF170:
	.string	"__DEC32_MAX__ 9.999999E96DF"
.LASF275:
	.string	"__va(paddr) ((unsigned)(paddr) + PAGE_OFFSET)"
.LASF4:
	.string	"__GNUC_MINOR__ 9"
.LASF102:
	.string	"__UINT8_C(c) c"
.LASF85:
	.string	"__INT8_MAX__ 127"
.LASF154:
	.string	"__LDBL_MIN_EXP__ (-16381)"
.LASF238:
	.string	"__1M 0x100000"
.LASF215:
	.string	"__ATOMIC_HLE_RELEASE 131072"
.LASF83:
	.string	"__SIG_ATOMIC_MAX__ 2147483647"
.LASF92:
	.string	"__UINT64_MAX__ 18446744073709551615ULL"
.LASF137:
	.string	"__FLT_HAS_QUIET_NAN__ 1"
.LASF147:
	.string	"__DBL_EPSILON__ ((double)2.22044604925031308085e-16L)"
.LASF126:
	.string	"__FLT_MIN_EXP__ (-125)"
.LASF240:
	.string	"__1G 0x40000000"
.LASF302:
	.string	"data"
.LASF93:
	.string	"__INT_LEAST8_MAX__ 127"
.LASF286:
	.string	"short unsigned int"
.LASF20:
	.string	"__SIZEOF_LONG_DOUBLE__ 12"
.LASF112:
	.string	"__INT_FAST64_MAX__ 9223372036854775807LL"
.LASF25:
	.string	"__ORDER_BIG_ENDIAN__ 4321"
.LASF36:
	.string	"__CHAR16_TYPE__ short unsigned int"
.LASF155:
	.string	"__LDBL_MIN_10_EXP__ (-4931)"
.LASF206:
	.string	"__GCC_ATOMIC_POINTER_LOCK_FREE 2"
.LASF218:
	.string	"__pentiumpro 1"
.LASF34:
	.string	"__INTMAX_TYPE__ long long int"
.LASF17:
	.string	"__SIZEOF_SHORT__ 2"
.LASF237:
	.string	"__8K 0x2000"
.LASF1:
	.string	"__STDC_VERSION__ 199901L"
.LASF310:
	.string	"pt_regs"
.LASF96:
	.string	"__INT16_C(c) c"
.LASF128:
	.string	"__FLT_MAX_EXP__ 128"
.LASF149:
	.string	"__DBL_HAS_DENORM__ 1"
.LASF133:
	.string	"__FLT_EPSILON__ 1.19209289550781250000e-7F"
.LASF311:
	.string	"timer_interrupt"
.LASF216:
	.string	"__i686 1"
.LASF204:
	.string	"__GCC_ATOMIC_LLONG_LOCK_FREE 2"
.LASF276:
	.string	"KV __va"
.LASF266:
	.string	"PG_H10(pg_id) (pg_id>>10)"
.LASF72:
	.string	"__LONG_LONG_MAX__ 9223372036854775807LL"
.LASF5:
	.string	"__GNUC_PATCHLEVEL__ 2"
.LASF235:
	.string	"NULL 0"
.LASF144:
	.string	"__DBL_DECIMAL_DIG__ 17"
.LASF139:
	.string	"__DBL_DIG__ 15"
.LASF295:
	.string	"hw_handler"
.LASF124:
	.string	"__FLT_MANT_DIG__ 24"
.LASF130:
	.string	"__FLT_DECIMAL_DIG__ 9"
.LASF86:
	.string	"__INT16_MAX__ 32767"
.LASF183:
	.string	"__DEC128_MIN__ 1E-6143DL"
.LASF23:
	.string	"__BIGGEST_ALIGNMENT__ 16"
.LASF14:
	.string	"__SIZEOF_INT__ 4"
.LASF42:
	.string	"__INT64_TYPE__ long long int"
.LASF202:
	.string	"__GCC_ATOMIC_INT_LOCK_FREE 2"
.LASF182:
	.string	"__DEC128_MAX_EXP__ 6145"
.LASF33:
	.string	"__WINT_TYPE__ unsigned int"
.LASF194:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 1"
.LASF303:
	.string	"sizetype"
.LASF175:
	.string	"__DEC64_MAX_EXP__ 385"
.LASF115:
	.string	"__UINT_FAST32_MAX__ 4294967295U"
.LASF103:
	.string	"__UINT_LEAST16_MAX__ 65535"
.LASF113:
	.string	"__UINT_FAST8_MAX__ 255"
.LASF32:
	.string	"__WCHAR_TYPE__ long int"
.LASF161:
	.string	"__LDBL_EPSILON__ 1.08420217248550443401e-19L"
.LASF201:
	.string	"__GCC_ATOMIC_SHORT_LOCK_FREE 2"
.LASF177:
	.string	"__DEC64_MAX__ 9.999999999999999E384DD"
.LASF97:
	.string	"__INT_LEAST32_MAX__ 2147483647"
.LASF220:
	.string	"__code_model_32__ 1"
.LASF110:
	.string	"__INT_FAST16_MAX__ 2147483647"
.LASF52:
	.string	"__UINT_LEAST16_TYPE__ short unsigned int"
.LASF55:
	.string	"__INT_FAST8_TYPE__ signed char"
.LASF142:
	.string	"__DBL_MAX_EXP__ 1024"
.LASF258:
	.string	"PAGE_SHIFT 12"
.LASF226:
	.string	"__ELF__ 1"
.LASF257:
	.string	"X86_PAGE_H "
.LASF241:
	.string	"__3G 0xc0000000"
.LASF120:
	.string	"__GCC_IEC_559_COMPLEX 2"
.LASF178:
	.string	"__DEC64_EPSILON__ 1E-15DD"
.LASF87:
	.string	"__INT32_MAX__ 2147483647"
.LASF248:
	.string	"TIME_H "
.LASF270:
	.string	"__pa2page_t(paddr) (mem_map + ((paddr) >> 12))"
.LASF197:
	.string	"__GCC_ATOMIC_CHAR_LOCK_FREE 2"
.LASF185:
	.string	"__DEC128_EPSILON__ 1E-33DL"
.LASF166:
	.string	"__DEC32_MANT_DIG__ 7"
.LASF244:
	.string	"assert(exp) do{ if(!(exp)) assert_func(#exp,__FILE__,__BASE_FILE__,__LINE__); } while(0)"
.LASF167:
	.string	"__DEC32_MIN_EXP__ (-94)"
.LASF61:
	.string	"__UINT_FAST32_TYPE__ unsigned int"
.LASF233:
	.string	"false 0"
.LASF280:
	.string	"CLONE_FD 0x400"
.LASF59:
	.string	"__UINT_FAST8_TYPE__ unsigned char"
.LASF91:
	.string	"__UINT32_MAX__ 4294967295U"
.LASF281:
	.string	"BH_H "
.LASF243:
	.string	"ASSERT_H "
.LASF214:
	.string	"__ATOMIC_HLE_ACQUIRE 65536"
.LASF179:
	.string	"__DEC64_SUBNORMAL_MIN__ 0.000000000000001E-383DD"
.LASF213:
	.string	"__i386__ 1"
.LASF159:
	.string	"__LDBL_MAX__ 1.18973149535723176502e+4932L"
.LASF146:
	.string	"__DBL_MIN__ ((double)2.22507385850720138309e-308L)"
.LASF180:
	.string	"__DEC128_MANT_DIG__ 34"
.LASF98:
	.string	"__INT32_C(c) c"
.LASF174:
	.string	"__DEC64_MIN_EXP__ (-382)"
.LASF228:
	.string	"LINUX_TIMER_H "
.LASF74:
	.string	"__WCHAR_MIN__ (-__WCHAR_MAX__ - 1)"
.LASF254:
	.string	"SA_SHIRQ 1"
.LASF77:
	.string	"__PTRDIFF_MAX__ 2147483647"
.LASF78:
	.string	"__SIZE_MAX__ 4294967295U"
.LASF105:
	.string	"__UINT_LEAST32_MAX__ 4294967295U"
.LASF164:
	.string	"__LDBL_HAS_INFINITY__ 1"
.LASF184:
	.string	"__DEC128_MAX__ 9.999999999999999999999999999999999E6144DL"
.LASF37:
	.string	"__CHAR32_TYPE__ unsigned int"
.LASF255:
	.string	"SA_INTERRUPT (1<<1)"
.LASF80:
	.string	"__INTMAX_C(c) c ## LL"
.LASF289:
	.string	"short int"
.LASF100:
	.string	"__INT64_C(c) c ## LL"
.LASF279:
	.string	"CLONE_FS 0x200"
.LASF47:
	.string	"__INT_LEAST8_TYPE__ signed char"
.LASF104:
	.string	"__UINT16_C(c) c"
.LASF196:
	.string	"__GCC_ATOMIC_BOOL_LOCK_FREE 2"
.LASF121:
	.string	"__FLT_EVAL_METHOD__ 2"
.LASF18:
	.string	"__SIZEOF_FLOAT__ 4"
.LASF195:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 1"
.LASF143:
	.string	"__DBL_MAX_10_EXP__ 308"
.LASF0:
	.string	"__STDC__ 1"
.LASF26:
	.string	"__ORDER_PDP_ENDIAN__ 3412"
.LASF24:
	.string	"__ORDER_LITTLE_ENDIAN__ 1234"
.LASF312:
	.string	"time_bottomhalf"
.LASF224:
	.string	"__unix 1"
.LASF50:
	.string	"__INT_LEAST64_TYPE__ long long int"
.LASF7:
	.string	"__ATOMIC_RELAXED 0"
.LASF308:
	.string	"/home/wws/lab/yanqi/src"
.LASF119:
	.string	"__GCC_IEC_559 2"
.LASF79:
	.string	"__INTMAX_MAX__ 9223372036854775807LL"
.LASF67:
	.string	"__GXX_ABI_VERSION 1002"
.LASF247:
	.string	"MB2STRU(stru_type,mb_addr,mb_name) (stru_type *)( (u32)(mb_addr)- (u32)&((stru_type *)0)->mb_name )"
.LASF242:
	.string	"LIST_H "
.LASF6:
	.string	"__VERSION__ \"4.9.2\""
.LASF296:
	.string	"func"
.LASF156:
	.string	"__LDBL_MAX_EXP__ 16384"
.LASF64:
	.string	"__UINTPTR_TYPE__ unsigned int"
.LASF132:
	.string	"__FLT_MIN__ 1.17549435082228750797e-38F"
.LASF123:
	.string	"__FLT_RADIX__ 2"
.LASF75:
	.string	"__WINT_MAX__ 4294967295U"
.LASF136:
	.string	"__FLT_HAS_INFINITY__ 1"
.LASF69:
	.string	"__SHRT_MAX__ 32767"
.LASF107:
	.string	"__UINT_LEAST64_MAX__ 18446744073709551615ULL"
.LASF9:
	.string	"__ATOMIC_ACQUIRE 2"
.LASF95:
	.string	"__INT_LEAST16_MAX__ 32767"
.LASF246:
	.ascii	"LIST_FIND2(stru"
	.string	"_t,mb_t,root,key,value,result) do{ struct list_head * node = root->next; stru_t *obj; while(node != root){ *obj = MB2STRU(stru_t, node, mb_t); if( (obj)->key == value ) break; node = node->next; } if(node == root) result = 0; else result = obj; } while(0);"
.LASF111:
	.string	"__INT_FAST32_MAX__ 2147483647"
.LASF260:
	.string	"PAGE_MASK (~0xfff)"
.LASF301:
	.string	"pregs"
.LASF31:
	.string	"__PTRDIFF_TYPE__ int"
.LASF163:
	.string	"__LDBL_HAS_DENORM__ 1"
.LASF152:
	.string	"__LDBL_MANT_DIG__ 64"
.LASF65:
	.string	"__has_include(STR) __has_include__(STR)"
.LASF198:
	.string	"__GCC_ATOMIC_CHAR16_T_LOCK_FREE 2"
.LASF285:
	.string	"unsigned char"
.LASF187:
	.string	"__REGISTER_PREFIX__ "
.LASF12:
	.string	"__ATOMIC_CONSUME 1"
.LASF186:
	.string	"__DEC128_SUBNORMAL_MIN__ 0.000000000000000000000000000000001E-6143DL"
.LASF3:
	.string	"__GNUC__ 4"
.LASF44:
	.string	"__UINT16_TYPE__ short unsigned int"
.LASF114:
	.string	"__UINT_FAST16_MAX__ 4294967295U"
.LASF106:
	.string	"__UINT32_C(c) c ## U"
.LASF211:
	.string	"__SIZEOF_PTRDIFF_T__ 4"
.LASF193:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 1"
.LASF176:
	.string	"__DEC64_MIN__ 1E-383DD"
.LASF236:
	.string	"__4K 0x1000"
.LASF22:
	.string	"__CHAR_BIT__ 8"
.LASF84:
	.string	"__SIG_ATOMIC_MIN__ (-__SIG_ATOMIC_MAX__ - 1)"
.LASF293:
	.string	"status"
.LASF57:
	.string	"__INT_FAST32_TYPE__ int"
.LASF60:
	.string	"__UINT_FAST16_TYPE__ unsigned int"
.LASF117:
	.string	"__INTPTR_MAX__ 2147483647"
.LASF192:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 1"
.LASF245:
	.string	"INIT_LIST_HEAD(l) do{ (l)->prev = (l)->next = l; } while(0)"
.LASF148:
	.string	"__DBL_DENORM_MIN__ ((double)4.94065645841246544177e-324L)"
.LASF151:
	.string	"__DBL_HAS_QUIET_NAN__ 1"
.LASF127:
	.string	"__FLT_MIN_10_EXP__ (-37)"
.LASF297:
	.string	"flags"
.LASF11:
	.string	"__ATOMIC_ACQ_REL 4"
.LASF274:
	.string	"__pa(vaddr) ((unsigned)(vaddr) - PAGE_OFFSET)"
.LASF81:
	.string	"__UINTMAX_MAX__ 18446744073709551615ULL"
.LASF249:
	.string	"IRQ_H "
.LASF191:
	.string	"__STRICT_ANSI__ 1"
.LASF239:
	.string	"__4M 0x400000"
.LASF13:
	.string	"__FINITE_MATH_ONLY__ 0"
.LASF232:
	.string	"true 1"
.LASF252:
	.string	"IRQ_INPROCESS (1<<1)"
.LASF188:
	.string	"__USER_LABEL_PREFIX__ "
.LASF269:
	.string	"__va2page_t(vaddr) (mem_map + (((vaddr) - PAGE_OFFSET) >> 12))"
.LASF53:
	.string	"__UINT_LEAST32_TYPE__ unsigned int"
.LASF62:
	.string	"__UINT_FAST64_TYPE__ long long unsigned int"
.LASF58:
	.string	"__INT_FAST64_TYPE__ long long int"
.LASF51:
	.string	"__UINT_LEAST8_TYPE__ unsigned char"
.LASF171:
	.string	"__DEC32_EPSILON__ 1E-6DF"
.LASF250:
	.string	"NR_IRQS 16"
.LASF153:
	.string	"__LDBL_DIG__ 18"
.LASF49:
	.string	"__INT_LEAST32_TYPE__ int"
.LASF207:
	.string	"__GCC_HAVE_DWARF2_CFI_ASM 1"
.LASF118:
	.string	"__UINTPTR_MAX__ 4294967295U"
.LASF135:
	.string	"__FLT_HAS_DENORM__ 1"
.LASF71:
	.string	"__LONG_MAX__ 2147483647L"
.LASF162:
	.string	"__LDBL_DENORM_MIN__ 3.64519953188247460253e-4951L"
.LASF141:
	.string	"__DBL_MIN_10_EXP__ (-307)"
.LASF134:
	.string	"__FLT_DENORM_MIN__ 1.40129846432481707092e-45F"
.LASF189:
	.string	"__GNUC_STDC_INLINE__ 1"
.LASF68:
	.string	"__SCHAR_MAX__ 127"
	.ident	"GCC: (Ubuntu 4.9.2-10ubuntu13) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
