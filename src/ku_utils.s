	.file	"ku_utils.c"
	.text
.Ltext0:
	.comm	mem_entity,4,1
	.globl	hex_int
	.type	hex_int, @function
hex_int:
.LFB0:
	.file 1 "ku_utils.c"
	.loc 1 12 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$4, %esp
	movl	8(%ebp), %eax
	movb	%al, -4(%ebp)
	.loc 1 13 0
	cmpb	$47, -4(%ebp)
	jle	.L2
	.loc 1 13 0 is_stmt 0 discriminator 1
	cmpb	$57, -4(%ebp)
	jg	.L2
	.loc 1 13 0 discriminator 2
	movsbl	-4(%ebp), %eax
	subl	$48, %eax
	jmp	.L3
.L2:
	.loc 1 14 0 is_stmt 1
	cmpb	$96, -4(%ebp)
	jle	.L4
	.loc 1 14 0 is_stmt 0 discriminator 1
	cmpb	$102, -4(%ebp)
	jg	.L4
	.loc 1 14 0 discriminator 2
	movsbl	-4(%ebp), %eax
	subl	$87, %eax
	jmp	.L3
.L4:
	.loc 1 15 0 is_stmt 1
	movl	$-1, %eax
.L3:
	.loc 1 16 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	hex_int, .-hex_int
	.globl	memset
	.type	memset, @function
memset:
.LFB1:
	.loc 1 17 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	.loc 1 18 0
	movl	12(%ebp), %eax
	sall	$8, %eax
	movl	%eax, %edx
	movl	12(%ebp), %eax
	addl	%eax, %edx
	movl	12(%ebp), %eax
	sall	$16, %eax
	addl	%eax, %edx
	movl	12(%ebp), %eax
	sall	$24, %eax
	addl	%edx, %eax
	movl	%eax, -12(%ebp)
	.loc 1 19 0
	movl	16(%ebp), %eax
	shrl	$2, %eax
	movl	%eax, -16(%ebp)
	.loc 1 20 0
	movl	16(%ebp), %eax
	andl	$3, %eax
	movl	%eax, -4(%ebp)
.LBB2:
	.loc 1 21 0
	movl	$0, -8(%ebp)
	jmp	.L6
.L7:
	.loc 1 22 0 discriminator 3
	movl	-8(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	8(%ebp), %eax
	addl	%eax, %edx
	movl	-12(%ebp), %eax
	movl	%eax, (%edx)
	.loc 1 21 0 discriminator 3
	addl	$1, -8(%ebp)
.L6:
	.loc 1 21 0 is_stmt 0 discriminator 1
	movl	-8(%ebp), %eax
	cmpl	-16(%ebp), %eax
	jl	.L7
.LBE2:
	.loc 1 24 0 is_stmt 1
	jmp	.L8
.L9:
	.loc 1 25 0
	movl	-4(%ebp), %eax
	movl	16(%ebp), %edx
	subl	%eax, %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movl	12(%ebp), %edx
	movb	%dl, (%eax)
.L8:
	.loc 1 24 0
	movl	-4(%ebp), %eax
	leal	-1(%eax), %edx
	movl	%edx, -4(%ebp)
	testl	%eax, %eax
	jne	.L9
	.loc 1 27 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	memset, .-memset
	.globl	human_memsize
	.type	human_memsize, @function
human_memsize:
.LFB2:
	.loc 1 30 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 32 0
	subl	$4, %esp
	pushl	12(%ebp)
	pushl	8(%ebp)
	pushl	$gmkb.1028
	call	human_memsize_into
	addl	$16, %esp
	.loc 1 33 0
	movl	$gmkb.1028, %eax
	.loc 1 34 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	human_memsize, .-human_memsize
	.globl	human_memsize_into
	.type	human_memsize_into, @function
human_memsize_into:
.LFB3:
	.loc 1 35 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	.loc 1 36 0
	pushl	$16
	pushl	$0
	pushl	8(%ebp)
	call	memset
	addl	$12, %esp
.LBB3:
	.loc 1 37 0
	movl	$3, %eax
	subl	16(%ebp), %eax
	movl	%eax, -4(%ebp)
	jmp	.L13
.L14:
	.loc 1 38 0 discriminator 3
	movl	-4(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	8(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	12(%ebp), %eax
	cltd
	shrl	$22, %edx
	addl	%edx, %eax
	andl	$1023, %eax
	subl	%edx, %eax
	movl	%eax, (%ecx)
	.loc 1 39 0 discriminator 3
	movl	12(%ebp), %eax
	leal	1023(%eax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$10, %eax
	movl	%eax, 12(%ebp)
	.loc 1 37 0 discriminator 3
	subl	$1, -4(%ebp)
.L13:
	.loc 1 37 0 is_stmt 0 discriminator 1
	cmpl	$0, -4(%ebp)
	jns	.L14
.LBE3:
	.loc 1 41 0 is_stmt 1
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE3:
	.size	human_memsize_into, .-human_memsize_into
	.globl	pow_int
	.type	pow_int, @function
pow_int:
.LFB4:
	.loc 1 42 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	.loc 1 43 0
	cmpl	$0, 12(%ebp)
	jne	.L16
	.loc 1 43 0 is_stmt 0 discriminator 1
	movl	$1, %eax
	jmp	.L17
.L16:
	.loc 1 44 0 is_stmt 1
	movl	$1, -4(%ebp)
.LBB4:
	.loc 1 45 0
	movl	$0, -8(%ebp)
	jmp	.L18
.L19:
	.loc 1 46 0 discriminator 3
	movl	-4(%ebp), %eax
	imull	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	.loc 1 45 0 discriminator 3
	addl	$1, -8(%ebp)
.L18:
	.loc 1 45 0 is_stmt 0 discriminator 1
	movl	-8(%ebp), %eax
	cmpl	12(%ebp), %eax
	jl	.L19
.LBE4:
	.loc 1 48 0 is_stmt 1
	movl	-4(%ebp), %eax
.L17:
	.loc 1 49 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE4:
	.size	pow_int, .-pow_int
	.globl	ceil_divide
	.type	ceil_divide, @function
ceil_divide:
.LFB5:
	.loc 1 50 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	.loc 1 51 0
	movl	8(%ebp), %eax
	cltd
	idivl	12(%ebp)
	movl	%eax, -4(%ebp)
	.loc 1 52 0
	movl	8(%ebp), %eax
	cltd
	idivl	12(%ebp)
	movl	%edx, -8(%ebp)
	.loc 1 53 0
	cmpl	$0, -8(%ebp)
	je	.L21
	.loc 1 53 0 is_stmt 0 discriminator 1
	movl	-4(%ebp), %eax
	addl	$1, %eax
	jmp	.L22
.L21:
	.loc 1 53 0 discriminator 2
	movl	-4(%ebp), %eax
.L22:
	.loc 1 54 0 is_stmt 1 discriminator 4
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE5:
	.size	ceil_divide, .-ceil_divide
	.globl	chars_to_str
	.type	chars_to_str, @function
chars_to_str:
.LFB6:
	.loc 1 55 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	.loc 1 56 0
	jmp	.L25
.L27:
	.loc 1 57 0
	movl	12(%ebp), %eax
	movzbl	(%eax), %edx
	movl	8(%ebp), %eax
	movb	%dl, (%eax)
	.loc 1 58 0
	addl	$1, 8(%ebp)
	.loc 1 59 0
	addl	$1, 12(%ebp)
.L25:
	.loc 1 56 0
	movl	12(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$32, %al
	je	.L26
	.loc 1 56 0 is_stmt 0 discriminator 1
	movl	12(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L27
.L26:
	.loc 1 61 0 is_stmt 1
	movl	8(%ebp), %eax
	movb	$0, (%eax)
	.loc 1 62 0
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE6:
	.size	chars_to_str, .-chars_to_str
	.globl	memcp
	.type	memcp, @function
memcp:
.LFB7:
	.loc 1 64 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	.loc 1 65 0
	jmp	.L29
.L30:
	.loc 1 66 0
	movl	12(%ebp), %eax
	movzbl	(%eax), %edx
	movl	8(%ebp), %eax
	movb	%dl, (%eax)
	.loc 1 67 0
	addl	$1, 8(%ebp)
	.loc 1 68 0
	addl	$1, 12(%ebp)
	.loc 1 69 0
	subl	$1, 16(%ebp)
.L29:
	.loc 1 65 0
	cmpl	$0, 16(%ebp)
	jg	.L30
	.loc 1 71 0
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE7:
	.size	memcp, .-memcp
	.globl	memsetw
	.type	memsetw, @function
memsetw:
.LFB8:
	.loc 1 73 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$4, %esp
	movl	16(%ebp), %eax
	movw	%ax, -4(%ebp)
	.loc 1 74 0
	jmp	.L32
.L33:
	.loc 1 75 0
	movl	12(%ebp), %eax
	addl	$2147483647, %eax
	leal	(%eax,%eax), %edx
	movl	8(%ebp), %eax
	addl	%eax, %edx
	movzwl	-4(%ebp), %eax
	movw	%ax, (%edx)
	.loc 1 76 0
	subl	$1, 12(%ebp)
.L32:
	.loc 1 74 0
	cmpl	$0, 12(%ebp)
	jg	.L33
	.loc 1 78 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE8:
	.size	memsetw, .-memsetw
	.globl	charscmp
	.type	charscmp, @function
charscmp:
.LFB9:
	.loc 1 80 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	.loc 1 81 0
	movl	16(%ebp), %eax
	testl	%eax, %eax
	je	.L38
	cmpl	$1, %eax
	je	.L43
	jmp	.L35
.L42:
	.loc 1 83 0 discriminator 6
	movl	8(%ebp), %eax
	movzbl	(%eax), %edx
	movl	12(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	%al, %dl
	je	.L39
	.loc 1 83 0 is_stmt 0 discriminator 1
	movl	$0, %eax
	jmp	.L40
.L39:
	.loc 1 83 0 discriminator 2
	addl	$1, 8(%ebp)
	addl	$1, 12(%ebp)
.L38:
	.loc 1 83 0 discriminator 3
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L41
	.loc 1 83 0 discriminator 4
	movl	12(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L42
.L41:
	.loc 1 83 0 discriminator 7
	movl	$1, %eax
	jmp	.L40
.L46:
	.loc 1 86 0 is_stmt 1 discriminator 10
	movl	8(%ebp), %eax
	movzbl	(%eax), %edx
	movl	12(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	%al, %dl
	je	.L44
	.loc 1 86 0 is_stmt 0 discriminator 1
	movl	$0, %eax
	jmp	.L40
.L44:
	.loc 1 86 0 discriminator 2
	addl	$1, 8(%ebp)
	addl	$1, 12(%ebp)
.L43:
	.loc 1 86 0 discriminator 3
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L45
	.loc 1 86 0 discriminator 4
	movl	12(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L45
	.loc 1 86 0 discriminator 6
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$32, %al
	je	.L45
	.loc 1 86 0 discriminator 8
	movl	12(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$32, %al
	jne	.L46
.L45:
	.loc 1 86 0 discriminator 11
	movl	$1, %eax
	jmp	.L40
.L35:
	.loc 1 89 0 is_stmt 1 discriminator 1
	jmp	.L35
.L40:
	.loc 1 91 0
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE9:
	.size	charscmp, .-charscmp
	.local	gmkb.1028
	.comm	gmkb.1028,16,4
.Letext0:
	.file 2 "./include/old/valType.h"
	.file 3 "./include/old/ku_utils.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x3a0
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.long	.LASF283
	.byte	0x1
	.long	.LASF284
	.long	.LASF285
	.long	.Ltext0
	.long	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.long	.Ldebug_macro0
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF248
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF249
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.long	.LASF250
	.uleb128 0x3
	.string	"u16"
	.byte	0x2
	.byte	0x10
	.long	0x49
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.long	.LASF251
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF252
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF253
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.long	.LASF254
	.uleb128 0x4
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.long	.LASF255
	.uleb128 0x5
	.long	.LASF261
	.byte	0x1
	.byte	0xc
	.long	0x65
	.long	.LFB0
	.long	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.long	0x99
	.uleb128 0x6
	.string	"x"
	.byte	0x1
	.byte	0xc
	.long	0x99
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF256
	.uleb128 0x7
	.long	.LASF267
	.byte	0x1
	.byte	0x11
	.long	.LFB1
	.long	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.long	0x11c
	.uleb128 0x8
	.long	.LASF257
	.byte	0x1
	.byte	0x11
	.long	0x11c
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x8
	.long	.LASF258
	.byte	0x1
	.byte	0x11
	.long	0x50
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x6
	.string	"n"
	.byte	0x1
	.byte	0x11
	.long	0x50
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0x9
	.long	.LASF259
	.byte	0x1
	.byte	0x12
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x9
	.long	.LASF260
	.byte	0x1
	.byte	0x13
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0xa
	.string	"l"
	.byte	0x1
	.byte	0x14
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.uleb128 0xb
	.long	.LBB2
	.long	.LBE2-.LBB2
	.uleb128 0xa
	.string	"i"
	.byte	0x1
	.byte	0x15
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.byte	0
	.byte	0
	.uleb128 0xc
	.byte	0x4
	.uleb128 0xd
	.long	.LASF262
	.byte	0x1
	.byte	0x1e
	.long	0x165
	.long	.LFB2
	.long	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.long	0x165
	.uleb128 0x8
	.long	.LASF263
	.byte	0x1
	.byte	0x1e
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x8
	.long	.LASF264
	.byte	0x1
	.byte	0x1e
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x9
	.long	.LASF265
	.byte	0x1
	.byte	0x1f
	.long	0x16b
	.uleb128 0x5
	.byte	0x3
	.long	gmkb.1028
	.byte	0
	.uleb128 0xe
	.byte	0x4
	.long	0x65
	.uleb128 0xf
	.long	0x65
	.long	0x17b
	.uleb128 0x10
	.long	0x17b
	.byte	0x3
	.byte	0
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF266
	.uleb128 0x11
	.long	.LASF268
	.byte	0x1
	.byte	0x23
	.long	.LFB3
	.long	.LFE3-.LFB3
	.uleb128 0x1
	.byte	0x9c
	.long	0x1d8
	.uleb128 0x8
	.long	.LASF265
	.byte	0x1
	.byte	0x23
	.long	0x165
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x8
	.long	.LASF263
	.byte	0x1
	.byte	0x23
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x8
	.long	.LASF264
	.byte	0x1
	.byte	0x23
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0xb
	.long	.LBB3
	.long	.LBE3-.LBB3
	.uleb128 0xa
	.string	"i"
	.byte	0x1
	.byte	0x25
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.byte	0
	.uleb128 0x5
	.long	.LASF269
	.byte	0x1
	.byte	0x2a
	.long	0x65
	.long	.LFB4
	.long	.LFE4-.LFB4
	.uleb128 0x1
	.byte	0x9c
	.long	0x232
	.uleb128 0x8
	.long	.LASF270
	.byte	0x1
	.byte	0x2a
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x6
	.string	"exp"
	.byte	0x1
	.byte	0x2a
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x9
	.long	.LASF271
	.byte	0x1
	.byte	0x2c
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.uleb128 0xb
	.long	.LBB4
	.long	.LBE4-.LBB4
	.uleb128 0xa
	.string	"i"
	.byte	0x1
	.byte	0x2d
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.byte	0
	.byte	0
	.uleb128 0x5
	.long	.LASF272
	.byte	0x1
	.byte	0x32
	.long	0x65
	.long	.LFB5
	.long	.LFE5-.LFB5
	.uleb128 0x1
	.byte	0x9c
	.long	0x280
	.uleb128 0x6
	.string	"a"
	.byte	0x1
	.byte	0x32
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x6
	.string	"b"
	.byte	0x1
	.byte	0x32
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x9
	.long	.LASF273
	.byte	0x1
	.byte	0x33
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.uleb128 0x9
	.long	.LASF274
	.byte	0x1
	.byte	0x34
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.byte	0
	.uleb128 0x7
	.long	.LASF275
	.byte	0x1
	.byte	0x37
	.long	.LFB6
	.long	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.long	0x2b2
	.uleb128 0x6
	.string	"str"
	.byte	0x1
	.byte	0x37
	.long	0x2b2
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x8
	.long	.LASF276
	.byte	0x1
	.byte	0x37
	.long	0x2b2
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.byte	0
	.uleb128 0xe
	.byte	0x4
	.long	0x99
	.uleb128 0x7
	.long	.LASF277
	.byte	0x1
	.byte	0x40
	.long	.LFB7
	.long	.LFE7-.LFB7
	.uleb128 0x1
	.byte	0x9c
	.long	0x2f8
	.uleb128 0x8
	.long	.LASF257
	.byte	0x1
	.byte	0x40
	.long	0x2b2
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x6
	.string	"src"
	.byte	0x1
	.byte	0x40
	.long	0x2b2
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x8
	.long	.LASF278
	.byte	0x1
	.byte	0x40
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.byte	0
	.uleb128 0x7
	.long	.LASF279
	.byte	0x1
	.byte	0x49
	.long	.LFB8
	.long	.LFE8-.LFB8
	.uleb128 0x1
	.byte	0x9c
	.long	0x338
	.uleb128 0x8
	.long	.LASF257
	.byte	0x1
	.byte	0x49
	.long	0x338
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x8
	.long	.LASF280
	.byte	0x1
	.byte	0x49
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x8
	.long	.LASF258
	.byte	0x1
	.byte	0x49
	.long	0x3e
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0xe
	.byte	0x4
	.long	0x3e
	.uleb128 0x5
	.long	.LASF281
	.byte	0x1
	.byte	0x50
	.long	0x65
	.long	.LFB9
	.long	.LFE9-.LFB9
	.uleb128 0x1
	.byte	0x9c
	.long	0x382
	.uleb128 0x6
	.string	"pt1"
	.byte	0x1
	.byte	0x50
	.long	0x2b2
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x6
	.string	"pt2"
	.byte	0x1
	.byte	0x50
	.long	0x2b2
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x8
	.long	.LASF282
	.byte	0x1
	.byte	0x50
	.long	0x65
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.byte	0
	.uleb128 0xf
	.long	0x99
	.long	0x392
	.uleb128 0x10
	.long	0x17b
	.byte	0x3
	.byte	0
	.uleb128 0x12
	.long	.LASF286
	.byte	0x3
	.byte	0x35
	.long	0x382
	.uleb128 0x5
	.byte	0x3
	.long	mem_entity
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
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4
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
	.uleb128 0x5
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
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
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
	.uleb128 0x7
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
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
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
	.uleb128 0x9
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
	.uleb128 0xa
	.uleb128 0x34
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
	.uleb128 0xb
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xd
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
	.uleb128 0xe
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
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
	.byte	0x3
	.uleb128 0x1
	.uleb128 0x3
	.byte	0x5
	.uleb128 0x2
	.long	.LASF228
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x2
	.byte	0x7
	.long	.Ldebug_macro1
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro2
	.byte	0x4
	.byte	0x5
	.uleb128 0x4
	.long	.LASF247
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
	.section	.debug_macro,"G",@progbits,wm4.ku_utils.h.4.65f3e6564a5123768a74f8d300528221,comdat
.Ldebug_macro2:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x4
	.long	.LASF242
	.byte	0x5
	.uleb128 0x5
	.long	.LASF243
	.byte	0x5
	.uleb128 0x8
	.long	.LASF244
	.byte	0x5
	.uleb128 0x1f
	.long	.LASF245
	.byte	0x5
	.uleb128 0x2c
	.long	.LASF246
	.byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF88:
	.string	"__INT64_MAX__ 9223372036854775807LL"
.LASF212:
	.string	"__i386 1"
.LASF108:
	.string	"__UINT64_C(c) c ## ULL"
.LASF273:
	.string	"quot"
.LASF99:
	.string	"__INT_LEAST64_MAX__ 9223372036854775807LL"
.LASF29:
	.string	"__SIZEOF_POINTER__ 4"
.LASF246:
	.string	"eat_dec_with_len(pt,x,x_len) char*__pt=(pt); while(*(__pt+1)>='0'&&*(__pt+1)<='9') __pt++; len=__pt-(pt)+1; for(int __i=0;__i<x_len;__i++){ x+=(*__pt-48)*pow_int(10,__i); __pt--; } (pt)+=x_len;"
.LASF89:
	.string	"__UINT8_MAX__ 255"
.LASF146:
	.string	"__DBL_MIN__ ((double)2.22507385850720138309e-308L)"
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
.LASF238:
	.string	"__1M 0x100000"
.LASF241:
	.string	"__3G 0xc0000000"
.LASF210:
	.string	"__SIZEOF_WINT_T__ 4"
.LASF247:
	.string	"CMP_GOON_WHEN(exp) while(exp){ if(*pt1!=*pt2) return 0; pt1++; pt2++;}return 1;"
.LASF255:
	.string	"long long unsigned int"
.LASF160:
	.string	"__LDBL_MIN__ 3.36210314311209350626e-4932L"
.LASF3:
	.string	"__GNUC__ 4"
.LASF22:
	.string	"__CHAR_BIT__ 8"
.LASF150:
	.string	"__DBL_HAS_INFINITY__ 1"
.LASF245:
	.string	"eat_dec(pt,x) if(*pt<'0'||*pt>'9') goto donothing; x=0; char*__pt=(pt); while(*(__pt+1)>='0'&&*(__pt+1)<='9') __pt++; int __len=__pt-(pt)+1; for(int __i=0;__i<__len;__i++){ x+=(*__pt-48)*pow_int(10,__i); __pt--; } (pt)+=__len;donothing:;"
.LASF151:
	.string	"__DBL_HAS_QUIET_NAN__ 1"
.LASF45:
	.string	"__UINT32_TYPE__ unsigned int"
.LASF223:
	.string	"__linux__ 1"
.LASF219:
	.string	"__pentiumpro__ 1"
.LASF70:
	.string	"__INT_MAX__ 2147483647"
.LASF115:
	.string	"__UINT_FAST32_MAX__ 4294967295U"
.LASF139:
	.string	"__DBL_DIG__ 15"
.LASF249:
	.string	"long long int"
.LASF253:
	.string	"signed char"
.LASF179:
	.string	"__DEC64_SUBNORMAL_MIN__ 0.000000000000001E-383DD"
.LASF131:
	.string	"__FLT_MAX__ 3.40282346638528859812e+38F"
.LASF248:
	.string	"long unsigned int"
.LASF138:
	.string	"__DBL_MANT_DIG__ 53"
.LASF263:
	.string	"size"
.LASF214:
	.string	"__ATOMIC_HLE_ACQUIRE 65536"
.LASF54:
	.string	"__UINT_LEAST64_TYPE__ long long unsigned int"
.LASF224:
	.string	"__unix 1"
.LASF63:
	.string	"__INTPTR_TYPE__ int"
.LASF155:
	.string	"__LDBL_MIN_10_EXP__ (-4931)"
.LASF43:
	.string	"__UINT8_TYPE__ unsigned char"
.LASF168:
	.string	"__DEC32_MAX_EXP__ 97"
.LASF41:
	.string	"__INT32_TYPE__ int"
.LASF38:
	.string	"__SIG_ATOMIC_TYPE__ int"
.LASF230:
	.string	"bool _Bool"
.LASF140:
	.string	"__DBL_MIN_EXP__ (-1021)"
.LASF15:
	.string	"__SIZEOF_LONG__ 4"
.LASF6:
	.string	"__VERSION__ \"4.9.2\""
.LASF242:
	.string	"min(x,y) ((x)<(y)?(x):(y))"
.LASF164:
	.string	"__LDBL_HAS_INFINITY__ 1"
.LASF135:
	.string	"__FLT_HAS_DENORM__ 1"
.LASF211:
	.string	"__SIZEOF_PTRDIFF_T__ 4"
.LASF200:
	.string	"__GCC_ATOMIC_WCHAR_T_LOCK_FREE 2"
.LASF39:
	.string	"__INT8_TYPE__ signed char"
.LASF27:
	.string	"__BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__"
.LASF229:
	.string	"VALTYPE_H "
.LASF28:
	.string	"__FLOAT_WORD_ORDER__ __ORDER_LITTLE_ENDIAN__"
.LASF231:
	.string	"boolean _Bool"
.LASF208:
	.string	"__PRAGMA_REDEFINE_EXTNAME 1"
.LASF48:
	.string	"__INT_LEAST16_TYPE__ short int"
.LASF100:
	.string	"__INT64_C(c) c ## LL"
.LASF158:
	.string	"__DECIMAL_DIG__ 21"
.LASF272:
	.string	"ceil_divide"
.LASF145:
	.string	"__DBL_MAX__ ((double)1.79769313486231570815e+308L)"
.LASF40:
	.string	"__INT16_TYPE__ short int"
.LASF165:
	.string	"__LDBL_HAS_QUIET_NAN__ 1"
.LASF19:
	.string	"__SIZEOF_DOUBLE__ 8"
.LASF116:
	.string	"__UINT_FAST64_MAX__ 18446744073709551615ULL"
.LASF278:
	.string	"byte"
.LASF8:
	.string	"__ATOMIC_SEQ_CST 5"
.LASF203:
	.string	"__GCC_ATOMIC_LONG_LOCK_FREE 2"
.LASF207:
	.string	"__GCC_HAVE_DWARF2_CFI_ASM 1"
.LASF215:
	.string	"__ATOMIC_HLE_RELEASE 131072"
.LASF227:
	.string	"__DECIMAL_BID_FORMAT__ 1"
.LASF199:
	.string	"__GCC_ATOMIC_CHAR32_T_LOCK_FREE 2"
.LASF216:
	.string	"__i686 1"
.LASF35:
	.string	"__UINTMAX_TYPE__ long long unsigned int"
.LASF195:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 1"
.LASF169:
	.string	"__DEC32_MIN__ 1E-95DF"
.LASF154:
	.string	"__LDBL_MIN_EXP__ (-16381)"
.LASF258:
	.string	"value"
.LASF125:
	.string	"__FLT_DIG__ 6"
.LASF73:
	.string	"__WCHAR_MAX__ 2147483647L"
.LASF209:
	.string	"__SIZEOF_WCHAR_T__ 4"
.LASF10:
	.string	"__ATOMIC_RELEASE 3"
.LASF129:
	.string	"__FLT_MAX_10_EXP__ 38"
.LASF252:
	.string	"unsigned int"
.LASF76:
	.string	"__WINT_MIN__ 0U"
.LASF94:
	.string	"__INT8_C(c) c"
.LASF217:
	.string	"__i686__ 1"
.LASF122:
	.string	"__DEC_EVAL_METHOD__ 2"
.LASF170:
	.string	"__DEC32_MAX__ 9.999999E96DF"
.LASF109:
	.string	"__INT_FAST8_MAX__ 127"
.LASF282:
	.string	"end_flag"
.LASF85:
	.string	"__INT8_MAX__ 127"
.LASF264:
	.string	"initial_scale_count"
.LASF83:
	.string	"__SIG_ATOMIC_MAX__ 2147483647"
.LASF120:
	.string	"__GCC_IEC_559_COMPLEX 2"
.LASF137:
	.string	"__FLT_HAS_QUIET_NAN__ 1"
.LASF147:
	.string	"__DBL_EPSILON__ ((double)2.22044604925031308085e-16L)"
.LASF126:
	.string	"__FLT_MIN_EXP__ (-125)"
.LASF277:
	.string	"memcp"
.LASF93:
	.string	"__INT_LEAST8_MAX__ 127"
.LASF251:
	.string	"short unsigned int"
.LASF20:
	.string	"__SIZEOF_LONG_DOUBLE__ 12"
.LASF18:
	.string	"__SIZEOF_FLOAT__ 4"
.LASF112:
	.string	"__INT_FAST64_MAX__ 9223372036854775807LL"
.LASF25:
	.string	"__ORDER_BIG_ENDIAN__ 4321"
.LASF36:
	.string	"__CHAR16_TYPE__ short unsigned int"
.LASF262:
	.string	"human_memsize"
.LASF206:
	.string	"__GCC_ATOMIC_POINTER_LOCK_FREE 2"
.LASF218:
	.string	"__pentiumpro 1"
.LASF34:
	.string	"__INTMAX_TYPE__ long long int"
.LASF79:
	.string	"__INTMAX_MAX__ 9223372036854775807LL"
.LASF259:
	.string	"value32"
.LASF202:
	.string	"__GCC_ATOMIC_INT_LOCK_FREE 2"
.LASF1:
	.string	"__STDC_VERSION__ 199901L"
.LASF16:
	.string	"__SIZEOF_LONG_LONG__ 8"
.LASF96:
	.string	"__INT16_C(c) c"
.LASF58:
	.string	"__INT_FAST64_TYPE__ long long int"
.LASF128:
	.string	"__FLT_MAX_EXP__ 128"
.LASF149:
	.string	"__DBL_HAS_DENORM__ 1"
.LASF124:
	.string	"__FLT_MANT_DIG__ 24"
.LASF243:
	.string	"MAX(x,y) ((x)>(y)?(x):(y))"
.LASF71:
	.string	"__LONG_MAX__ 2147483647L"
.LASF133:
	.string	"__FLT_EPSILON__ 1.19209289550781250000e-7F"
.LASF222:
	.string	"__linux 1"
.LASF284:
	.string	"ku_utils.c"
.LASF204:
	.string	"__GCC_ATOMIC_LLONG_LOCK_FREE 2"
.LASF181:
	.string	"__DEC128_MIN_EXP__ (-6142)"
.LASF72:
	.string	"__LONG_LONG_MAX__ 9223372036854775807LL"
.LASF5:
	.string	"__GNUC_PATCHLEVEL__ 2"
.LASF235:
	.string	"NULL 0"
.LASF144:
	.string	"__DBL_DECIMAL_DIG__ 17"
.LASF283:
	.string	"GNU C 4.9.2 -mtune=generic -march=i686 -g3 -std=c99 -fno-builtin -fno-stack-protector"
.LASF270:
	.string	"base"
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
.LASF92:
	.string	"__UINT64_MAX__ 18446744073709551615ULL"
.LASF275:
	.string	"chars_to_str"
.LASF194:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 1"
.LASF286:
	.string	"mem_entity"
.LASF266:
	.string	"sizetype"
.LASF175:
	.string	"__DEC64_MAX_EXP__ 385"
.LASF11:
	.string	"__ATOMIC_ACQ_REL 4"
.LASF103:
	.string	"__UINT_LEAST16_MAX__ 65535"
.LASF113:
	.string	"__UINT_FAST8_MAX__ 255"
.LASF32:
	.string	"__WCHAR_TYPE__ long int"
.LASF228:
	.string	"KU_UTILS_H "
.LASF161:
	.string	"__LDBL_EPSILON__ 1.08420217248550443401e-19L"
.LASF201:
	.string	"__GCC_ATOMIC_SHORT_LOCK_FREE 2"
.LASF177:
	.string	"__DEC64_MAX__ 9.999999999999999E384DD"
.LASF184:
	.string	"__DEC128_MAX__ 9.999999999999999999999999999999999E6144DL"
.LASF220:
	.string	"__code_model_32__ 1"
.LASF110:
	.string	"__INT_FAST16_MAX__ 2147483647"
.LASF52:
	.string	"__UINT_LEAST16_TYPE__ short unsigned int"
.LASF97:
	.string	"__INT_LEAST32_MAX__ 2147483647"
.LASF142:
	.string	"__DBL_MAX_EXP__ 1024"
.LASF0:
	.string	"__STDC__ 1"
.LASF226:
	.string	"__ELF__ 1"
.LASF260:
	.string	"quard"
.LASF9:
	.string	"__ATOMIC_ACQUIRE 2"
.LASF178:
	.string	"__DEC64_EPSILON__ 1E-15DD"
.LASF87:
	.string	"__INT32_MAX__ 2147483647"
.LASF257:
	.string	"dest"
.LASF197:
	.string	"__GCC_ATOMIC_CHAR_LOCK_FREE 2"
.LASF279:
	.string	"memsetw"
.LASF166:
	.string	"__DEC32_MANT_DIG__ 7"
.LASF167:
	.string	"__DEC32_MIN_EXP__ (-94)"
.LASF61:
	.string	"__UINT_FAST32_TYPE__ unsigned int"
.LASF233:
	.string	"false 0"
.LASF59:
	.string	"__UINT_FAST8_TYPE__ unsigned char"
.LASF91:
	.string	"__UINT32_MAX__ 4294967295U"
.LASF30:
	.string	"__SIZE_TYPE__ unsigned int"
.LASF2:
	.string	"__STDC_HOSTED__ 1"
.LASF213:
	.string	"__i386__ 1"
.LASF159:
	.string	"__LDBL_MAX__ 1.18973149535723176502e+4932L"
.LASF90:
	.string	"__UINT16_MAX__ 65535"
.LASF180:
	.string	"__DEC128_MANT_DIG__ 34"
.LASF98:
	.string	"__INT32_C(c) c"
.LASF174:
	.string	"__DEC64_MIN_EXP__ (-382)"
.LASF74:
	.string	"__WCHAR_MIN__ (-__WCHAR_MAX__ - 1)"
.LASF77:
	.string	"__PTRDIFF_MAX__ 2147483647"
.LASF250:
	.string	"unsigned char"
.LASF105:
	.string	"__UINT_LEAST32_MAX__ 4294967295U"
.LASF37:
	.string	"__CHAR32_TYPE__ unsigned int"
.LASF237:
	.string	"__8K 0x2000"
.LASF80:
	.string	"__INTMAX_C(c) c ## LL"
.LASF254:
	.string	"short int"
.LASF47:
	.string	"__INT_LEAST8_TYPE__ signed char"
.LASF104:
	.string	"__UINT16_C(c) c"
.LASF196:
	.string	"__GCC_ATOMIC_BOOL_LOCK_FREE 2"
.LASF268:
	.string	"human_memsize_into"
.LASF4:
	.string	"__GNUC_MINOR__ 9"
.LASF143:
	.string	"__DBL_MAX_10_EXP__ 308"
.LASF26:
	.string	"__ORDER_PDP_ENDIAN__ 3412"
.LASF24:
	.string	"__ORDER_LITTLE_ENDIAN__ 1234"
.LASF33:
	.string	"__WINT_TYPE__ unsigned int"
.LASF265:
	.string	"gmkb"
.LASF50:
	.string	"__INT_LEAST64_TYPE__ long long int"
.LASF7:
	.string	"__ATOMIC_RELAXED 0"
.LASF21:
	.string	"__SIZEOF_SIZE_T__ 4"
.LASF285:
	.string	"/home/wws/lab/yanqi/src"
.LASF182:
	.string	"__DEC128_MAX_EXP__ 6145"
.LASF240:
	.string	"__1G 0x40000000"
.LASF119:
	.string	"__GCC_IEC_559 2"
.LASF221:
	.string	"__gnu_linux__ 1"
.LASF274:
	.string	"remainder"
.LASF67:
	.string	"__GXX_ABI_VERSION 1002"
.LASF234:
	.string	"__DEBUG "
.LASF269:
	.string	"pow_int"
.LASF256:
	.string	"char"
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
.LASF95:
	.string	"__INT_LEAST16_MAX__ 32767"
.LASF121:
	.string	"__FLT_EVAL_METHOD__ 2"
.LASF17:
	.string	"__SIZEOF_SHORT__ 2"
.LASF111:
	.string	"__INT_FAST32_MAX__ 2147483647"
.LASF280:
	.string	"word"
.LASF244:
	.ascii	"eat_hex(pt,x) char*__pt=(pt); x=0; if(*__pt!='0'||*(__pt+1)!"
	.ascii	"='x'){ x=-1; goto donothing; } __pt+=2; if(!((*__pt>='0'&&*_"
	.ascii	"_pt<='9'"
	.string	")||(*__pt>='a'&&*__pt<='f'))){ x=-1; goto donothing; } while((*__pt>='0'&&*__pt<='9')||(*__pt>='a'&&*__pt<='f')) __pt++; __pt--; int __len=__pt-pt+1-2; for(int __i=0;__i<__len;__i++){ x+=hex_int(*__pt)*pow_int(16,__i); __pt--; } (pt)+=(2+__len);donothing:;"
.LASF190:
	.string	"__NO_INLINE__ 1"
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
.LASF261:
	.string	"hex_int"
.LASF187:
	.string	"__REGISTER_PREFIX__ "
.LASF12:
	.string	"__ATOMIC_CONSUME 1"
.LASF186:
	.string	"__DEC128_SUBNORMAL_MIN__ 0.000000000000000000000000000000001E-6143DL"
.LASF185:
	.string	"__DEC128_EPSILON__ 1E-33DL"
.LASF44:
	.string	"__UINT16_TYPE__ short unsigned int"
.LASF114:
	.string	"__UINT_FAST16_MAX__ 4294967295U"
.LASF106:
	.string	"__UINT32_C(c) c ## U"
.LASF172:
	.string	"__DEC32_SUBNORMAL_MIN__ 0.000001E-95DF"
.LASF193:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 1"
.LASF236:
	.string	"__4K 0x1000"
.LASF267:
	.string	"memset"
.LASF55:
	.string	"__INT_FAST8_TYPE__ signed char"
.LASF84:
	.string	"__SIG_ATOMIC_MIN__ (-__SIG_ATOMIC_MAX__ - 1)"
.LASF162:
	.string	"__LDBL_DENORM_MIN__ 3.64519953188247460253e-4951L"
.LASF57:
	.string	"__INT_FAST32_TYPE__ int"
.LASF60:
	.string	"__UINT_FAST16_TYPE__ unsigned int"
.LASF117:
	.string	"__INTPTR_MAX__ 2147483647"
.LASF192:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 1"
.LASF148:
	.string	"__DBL_DENORM_MIN__ ((double)4.94065645841246544177e-324L)"
.LASF78:
	.string	"__SIZE_MAX__ 4294967295U"
.LASF127:
	.string	"__FLT_MIN_10_EXP__ (-37)"
.LASF205:
	.string	"__GCC_ATOMIC_TEST_AND_SET_TRUEVAL 1"
.LASF276:
	.string	"chars"
.LASF81:
	.string	"__UINTMAX_MAX__ 18446744073709551615ULL"
.LASF191:
	.string	"__STRICT_ANSI__ 1"
.LASF239:
	.string	"__4M 0x400000"
.LASF13:
	.string	"__FINITE_MATH_ONLY__ 0"
.LASF232:
	.string	"true 1"
.LASF56:
	.string	"__INT_FAST16_TYPE__ int"
.LASF188:
	.string	"__USER_LABEL_PREFIX__ "
.LASF53:
	.string	"__UINT_LEAST32_TYPE__ unsigned int"
.LASF62:
	.string	"__UINT_FAST64_TYPE__ long long unsigned int"
.LASF102:
	.string	"__UINT8_C(c) c"
.LASF51:
	.string	"__UINT_LEAST8_TYPE__ unsigned char"
.LASF171:
	.string	"__DEC32_EPSILON__ 1E-6DF"
.LASF153:
	.string	"__LDBL_DIG__ 18"
.LASF49:
	.string	"__INT_LEAST32_TYPE__ int"
.LASF118:
	.string	"__UINTPTR_MAX__ 4294967295U"
.LASF271:
	.string	"result"
.LASF176:
	.string	"__DEC64_MIN__ 1E-383DD"
.LASF141:
	.string	"__DBL_MIN_10_EXP__ (-307)"
.LASF134:
	.string	"__FLT_DENORM_MIN__ 1.40129846432481707092e-45F"
.LASF189:
	.string	"__GNUC_STDC_INLINE__ 1"
.LASF281:
	.string	"charscmp"
.LASF68:
	.string	"__SCHAR_MAX__ 127"
	.ident	"GCC: (Ubuntu 4.9.2-10ubuntu13) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
