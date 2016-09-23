	.file	"read_write.c"
	.text
.Ltext0:
	.comm	dentry_hashtable,4,4
	.comm	dentry_cache,4,4
	.comm	mem_entity,4,1
	.comm	mem_map,4,4
	.comm	zone_dma,240,64
	.comm	zone_normal,240,64
	.comm	zone_highmem,240,64
	.comm	__zones,12,4
	.comm	size_of_zone,12,4
	.comm	__hs_pcb,4,4
	.comm	__ext_pcb,4,4
	.comm	inode_hashtable,4,4
	.type	fcheck, @function
fcheck:
.LFB49:
	.file 1 "./include/linux/fs.h"
	.loc 1 95 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 96 0
	call	get_current
	movl	72(%eax), %eax
	movl	(%eax), %eax
	cmpl	8(%ebp), %eax
	ja	.L2
	.loc 1 96 0 is_stmt 0 discriminator 1
	movl	$0, %eax
	jmp	.L3
.L2:
	.loc 1 97 0 is_stmt 1
	call	get_current
	movl	72(%eax), %eax
	movl	4(%eax), %eax
	movl	8(%ebp), %edx
	sall	$2, %edx
	addl	%edx, %eax
	movl	(%eax), %eax
.L3:
	.loc 1 98 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE49:
	.size	fcheck, .-fcheck
	.type	fget, @function
fget:
.LFB50:
	.loc 1 99 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 100 0
	movl	8(%ebp), %eax
	subl	$12, %esp
	pushl	%eax
	call	fcheck
	addl	$16, %esp
	movl	%eax, -12(%ebp)
	.loc 1 101 0
	cmpl	$0, -12(%ebp)
	je	.L5
	.loc 1 102 0
	movl	-12(%ebp), %eax
	movl	16(%eax), %eax
	leal	1(%eax), %edx
	movl	-12(%ebp), %eax
	movl	%edx, 16(%eax)
.L5:
	.loc 1 104 0
	movl	-12(%ebp), %eax
	.loc 1 105 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE50:
	.size	fget, .-fget
	.comm	inode_cache,4,4
	.comm	file_cache,4,4
	.type	do_lseek, @function
do_lseek:
.LFB51:
	.file 2 "../src/fs/read_write.c"
	.loc 2 4 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	.loc 2 5 0
	movl	16(%ebp), %eax
	cmpl	$1, %eax
	je	.L9
	cmpl	$2, %eax
	je	.L10
	jmp	.L8
.L9:
	.loc 2 7 0
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, 12(%ebp)
	.loc 2 8 0
	jmp	.L8
.L10:
	.loc 2 10 0
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	(%eax), %eax
	movl	16(%eax), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, 12(%ebp)
.L8:
	.loc 2 12 0
	cmpl	$0, 12(%ebp)
	jns	.L11
	.loc 2 12 0 is_stmt 0 discriminator 1
	movl	$-22, %eax
	jmp	.L12
.L11:
	.loc 2 14 0 is_stmt 1
	movl	12(%ebp), %edx
	movl	8(%ebp), %eax
	movl	%edx, 4(%eax)
	.loc 2 16 0
	movl	12(%ebp), %eax
.L12:
	.loc 2 17 0
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE51:
	.size	do_lseek, .-do_lseek
	.globl	sys_lseek
	.type	sys_lseek, @function
sys_lseek:
.LFB52:
	.loc 2 22 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 2 23 0
	subl	$12, %esp
	pushl	8(%ebp)
	call	fcheck
	addl	$16, %esp
	movl	%eax, -12(%ebp)
	.loc 2 24 0
	subl	$4, %esp
	pushl	16(%ebp)
	pushl	12(%ebp)
	pushl	-12(%ebp)
	call	do_lseek
	addl	$16, %esp
	movl	%eax, 12(%ebp)
	.loc 2 25 0
	cmpl	$0, 12(%ebp)
	jns	.L14
	.loc 2 26 0
	movl	$-1, %eax
	jmp	.L15
.L14:
	.loc 2 29 0
	movl	12(%ebp), %eax
.L15:
	.loc 2 30 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE52:
	.size	sys_lseek, .-sys_lseek
	.globl	sys_close
	.type	sys_close, @function
sys_close:
.LFB53:
	.loc 2 36 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 2 37 0
	call	get_current
	movl	72(%eax), %eax
	movl	(%eax), %eax
	cmpl	8(%ebp), %eax
	ja	.L17
	.loc 2 37 0 is_stmt 0 discriminator 1
	movl	$-22, %eax
	jmp	.L18
.L17:
	.loc 2 38 0 is_stmt 1
	call	get_current
	movl	72(%eax), %eax
	movl	4(%eax), %eax
	movl	8(%ebp), %edx
	sall	$2, %edx
	addl	%edx, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L19
	.loc 2 38 0 is_stmt 0 discriminator 1
	movl	$-22, %eax
	jmp	.L18
.L19:
	.loc 2 41 0 is_stmt 1
	call	get_current
	movl	72(%eax), %eax
	movl	4(%eax), %eax
	movl	8(%ebp), %edx
	sall	$2, %edx
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, -12(%ebp)
	.loc 2 42 0
	call	get_current
	movl	72(%eax), %eax
	movl	4(%eax), %eax
	movl	8(%ebp), %edx
	sall	$2, %edx
	addl	%edx, %eax
	movl	$0, (%eax)
	.loc 2 44 0
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	movl	(%eax), %eax
	movl	28(%eax), %eax
	movl	%eax, -16(%ebp)
	.loc 2 45 0
	movl	-16(%ebp), %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	je	.L20
	.loc 2 45 0 is_stmt 0 discriminator 1
	movl	-16(%ebp), %eax
	movl	12(%eax), %eax
	subl	$12, %esp
	pushl	-12(%ebp)
	call	*%eax
	addl	$16, %esp
.L20:
	.loc 2 47 0 is_stmt 1
	movl	-12(%ebp), %eax
	movl	16(%eax), %eax
	leal	-1(%eax), %edx
	movl	-12(%ebp), %eax
	movl	%edx, 16(%eax)
	movl	-12(%ebp), %eax
	movl	16(%eax), %eax
	testl	%eax, %eax
	jne	.L21
	.loc 2 48 0
	subl	$12, %esp
	pushl	-12(%ebp)
	call	kfree
	addl	$16, %esp
.L21:
	.loc 2 50 0
	movl	$0, %eax
.L18:
	.loc 2 51 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE53:
	.size	sys_close, .-sys_close
	.type	do_read, @function
do_read:
.LFB54:
	.loc 2 55 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 2 56 0
	cmpl	$0, 8(%ebp)
	jne	.L23
	.loc 2 56 0 is_stmt 0 discriminator 1
	movl	$-9, %eax
	jmp	.L24
.L23:
	.loc 2 57 0 is_stmt 1
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L25
	.loc 2 57 0 is_stmt 0 discriminator 1
	movl	$-13, %eax
	jmp	.L24
.L25:
	.loc 2 59 0 is_stmt 1
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	(%eax), %eax
	movl	16(%eax), %eax
	movl	%eax, -12(%ebp)
	.loc 2 60 0
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	16(%ebp), %eax
	addl	%edx, %eax
	cmpl	-12(%ebp), %eax
	jbe	.L26
	.loc 2 60 0 is_stmt 0 discriminator 1
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	movl	-12(%ebp), %edx
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, 16(%ebp)
.L26:
	.loc 2 61 0 is_stmt 1
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	(%eax), %eax
	movl	28(%eax), %eax
	movl	4(%eax), %eax
	pushl	$0
	pushl	16(%ebp)
	pushl	12(%ebp)
	pushl	8(%ebp)
	call	*%eax
	addl	$16, %esp
	movl	%eax, -16(%ebp)
	.loc 2 62 0
	movl	-16(%ebp), %eax
.L24:
	.loc 2 63 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE54:
	.size	do_read, .-do_read
	.globl	sys_read
	.type	sys_read, @function
sys_read:
.LFB55:
	.loc 2 64 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 2 66 0
	subl	$12, %esp
	pushl	8(%ebp)
	call	fcheck
	addl	$16, %esp
	movl	%eax, -12(%ebp)
	.loc 2 67 0
	subl	$4, %esp
	pushl	16(%ebp)
	pushl	12(%ebp)
	pushl	-12(%ebp)
	call	do_read
	addl	$16, %esp
	movl	%eax, -16(%ebp)
	.loc 2 68 0
	cmpl	$0, -16(%ebp)
	jns	.L28
	.loc 2 70 0
	movl	$-1, %eax
	jmp	.L29
.L28:
	.loc 2 72 0
	movl	-16(%ebp), %eax
.L29:
	.loc 2 73 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE55:
	.size	sys_read, .-sys_read
	.globl	k_open
	.type	k_open, @function
k_open:
.LFB56:
	.loc 2 78 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 2 79 0
	subl	$4, %esp
	pushl	16(%ebp)
	pushl	12(%ebp)
	pushl	8(%ebp)
	call	sys_open
	addl	$16, %esp
	movl	%eax, -12(%ebp)
	.loc 2 80 0
	subl	$12, %esp
	pushl	-12(%ebp)
	call	fget
	addl	$16, %esp
	.loc 2 81 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE56:
	.size	k_open, .-k_open
	.globl	k_read
	.type	k_read, @function
k_read:
.LFB57:
	.loc 2 83 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 2 84 0
	subl	$4, %esp
	pushl	16(%ebp)
	pushl	12(%ebp)
	pushl	8(%ebp)
	call	do_read
	addl	$16, %esp
	.loc 2 85 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE57:
	.size	k_read, .-k_read
	.globl	k_seek
	.type	k_seek, @function
k_seek:
.LFB58:
	.loc 2 88 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	.loc 2 89 0
	pushl	16(%ebp)
	pushl	12(%ebp)
	pushl	8(%ebp)
	call	do_lseek
	addl	$12, %esp
	.loc 2 90 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE58:
	.size	k_seek, .-k_seek
.Letext0:
	.file 3 "./include/old/list.h"
	.file 4 "./include/old/valType.h"
	.file 5 "./include/linux/mount.h"
	.file 6 "./include/linux/dcache.h"
	.file 7 "./arch/x86/include/asm/page.h"
	.file 8 "./include/old/mmzone.h"
	.file 9 "./include/linux/sched.h"
	.file 10 "./include/linux/mm.h"
	.file 11 "./include/asm/resource.h"
	.file 12 "./include/old/proc.h"
	.file 13 "./include/old/ku_utils.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x115f
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.long	.LASF600
	.byte	0x1
	.long	.LASF601
	.long	.LASF602
	.long	.Ltext0
	.long	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.long	.Ldebug_macro0
	.uleb128 0x2
	.long	.LASF437
	.byte	0x8
	.byte	0x3
	.byte	0x6
	.long	0x4e
	.uleb128 0x3
	.long	.LASF426
	.byte	0x3
	.byte	0x7
	.long	0x4e
	.byte	0
	.uleb128 0x3
	.long	.LASF427
	.byte	0x3
	.byte	0x8
	.long	0x4e
	.byte	0x4
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x29
	.uleb128 0x5
	.long	.LASF431
	.byte	0x4
	.byte	0xd
	.long	0x5f
	.uleb128 0x6
	.byte	0x4
	.byte	0x7
	.long	.LASF428
	.uleb128 0x6
	.byte	0x8
	.byte	0x5
	.long	.LASF429
	.uleb128 0x6
	.byte	0x1
	.byte	0x8
	.long	.LASF430
	.uleb128 0x7
	.string	"u16"
	.byte	0x4
	.byte	0x10
	.long	0x7f
	.uleb128 0x6
	.byte	0x2
	.byte	0x7
	.long	.LASF432
	.uleb128 0x7
	.string	"u32"
	.byte	0x4
	.byte	0x11
	.long	0x91
	.uleb128 0x6
	.byte	0x4
	.byte	0x7
	.long	.LASF433
	.uleb128 0x6
	.byte	0x1
	.byte	0x6
	.long	.LASF434
	.uleb128 0x6
	.byte	0x2
	.byte	0x5
	.long	.LASF435
	.uleb128 0x8
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x6
	.byte	0x8
	.byte	0x7
	.long	.LASF436
	.uleb128 0x2
	.long	.LASF438
	.byte	0x20
	.byte	0x5
	.byte	0x6
	.long	0x114
	.uleb128 0x9
	.string	"dev"
	.byte	0x5
	.byte	0x7
	.long	0x74
	.byte	0
	.uleb128 0x9
	.string	"sb"
	.byte	0x5
	.byte	0x8
	.long	0x152
	.byte	0x4
	.uleb128 0x3
	.long	.LASF439
	.byte	0x5
	.byte	0x9
	.long	0x1c4
	.byte	0x8
	.uleb128 0x3
	.long	.LASF440
	.byte	0x5
	.byte	0xa
	.long	0x1c4
	.byte	0xc
	.uleb128 0x3
	.long	.LASF441
	.byte	0x5
	.byte	0xb
	.long	0x1ca
	.byte	0x10
	.uleb128 0x3
	.long	.LASF442
	.byte	0x5
	.byte	0xc
	.long	0x29
	.byte	0x14
	.uleb128 0x3
	.long	.LASF443
	.byte	0x5
	.byte	0xd
	.long	0xa6
	.byte	0x1c
	.byte	0
	.uleb128 0xa
	.long	.LASF444
	.value	0x20c
	.byte	0x1
	.byte	0x33
	.long	0x152
	.uleb128 0x3
	.long	.LASF445
	.byte	0x1
	.byte	0x34
	.long	0xcd0
	.byte	0
	.uleb128 0x3
	.long	.LASF446
	.byte	0x1
	.byte	0x35
	.long	0x1c4
	.byte	0x4
	.uleb128 0x9
	.string	"dev"
	.byte	0x1
	.byte	0x36
	.long	0x74
	.byte	0x8
	.uleb128 0x3
	.long	.LASF447
	.byte	0x1
	.byte	0x37
	.long	0xcd6
	.byte	0xa
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x114
	.uleb128 0x2
	.long	.LASF448
	.byte	0x30
	.byte	0x6
	.byte	0x11
	.long	0x1c4
	.uleb128 0x3
	.long	.LASF449
	.byte	0x6
	.byte	0x12
	.long	0x2dc
	.byte	0
	.uleb128 0x3
	.long	.LASF441
	.byte	0x6
	.byte	0x13
	.long	0x1c4
	.byte	0x4
	.uleb128 0x9
	.string	"sb"
	.byte	0x6
	.byte	0x14
	.long	0x152
	.byte	0x8
	.uleb128 0x3
	.long	.LASF450
	.byte	0x6
	.byte	0x15
	.long	0x1d0
	.byte	0xc
	.uleb128 0x3
	.long	.LASF445
	.byte	0x6
	.byte	0x16
	.long	0x2e2
	.byte	0x18
	.uleb128 0x3
	.long	.LASF438
	.byte	0x6
	.byte	0x17
	.long	0x29
	.byte	0x1c
	.uleb128 0x3
	.long	.LASF443
	.byte	0x6
	.byte	0x18
	.long	0xa6
	.byte	0x24
	.uleb128 0x3
	.long	.LASF451
	.byte	0x6
	.byte	0x1a
	.long	0x29
	.byte	0x28
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x158
	.uleb128 0x4
	.byte	0x4
	.long	0xb4
	.uleb128 0x2
	.long	.LASF452
	.byte	0xc
	.byte	0x6
	.byte	0x9
	.long	0x201
	.uleb128 0x3
	.long	.LASF450
	.byte	0x6
	.byte	0xa
	.long	0x201
	.byte	0
	.uleb128 0x9
	.string	"len"
	.byte	0x6
	.byte	0xb
	.long	0xa6
	.byte	0x4
	.uleb128 0x3
	.long	.LASF451
	.byte	0x6
	.byte	0xc
	.long	0x91
	.byte	0x8
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x207
	.uleb128 0xb
	.long	0x20c
	.uleb128 0x6
	.byte	0x1
	.byte	0x6
	.long	.LASF453
	.uleb128 0x2
	.long	.LASF454
	.byte	0x4
	.byte	0x6
	.byte	0xe
	.long	0x22c
	.uleb128 0x3
	.long	.LASF455
	.byte	0x6
	.byte	0xf
	.long	0x246
	.byte	0
	.byte	0
	.uleb128 0xc
	.long	0xa6
	.long	0x240
	.uleb128 0xd
	.long	0x240
	.uleb128 0xd
	.long	0x240
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x1d0
	.uleb128 0x4
	.byte	0x4
	.long	0x22c
	.uleb128 0x2
	.long	.LASF449
	.byte	0xa8
	.byte	0x1
	.byte	0x20
	.long	0x2dc
	.uleb128 0x9
	.string	"ino"
	.byte	0x1
	.byte	0x21
	.long	0x91
	.byte	0
	.uleb128 0x9
	.string	"dev"
	.byte	0x1
	.byte	0x22
	.long	0x74
	.byte	0x4
	.uleb128 0x3
	.long	.LASF456
	.byte	0x1
	.byte	0x23
	.long	0x74
	.byte	0x6
	.uleb128 0x3
	.long	.LASF457
	.byte	0x1
	.byte	0x24
	.long	0x86
	.byte	0x8
	.uleb128 0x3
	.long	.LASF458
	.byte	0x1
	.byte	0x25
	.long	0x86
	.byte	0xc
	.uleb128 0x3
	.long	.LASF459
	.byte	0x1
	.byte	0x26
	.long	0x86
	.byte	0x10
	.uleb128 0x9
	.string	"sb"
	.byte	0x1
	.byte	0x27
	.long	0x152
	.byte	0x14
	.uleb128 0x3
	.long	.LASF445
	.byte	0x1
	.byte	0x28
	.long	0xc49
	.byte	0x18
	.uleb128 0x3
	.long	.LASF460
	.byte	0x1
	.byte	0x29
	.long	0xc8c
	.byte	0x1c
	.uleb128 0x3
	.long	.LASF451
	.byte	0x1
	.byte	0x2a
	.long	0x29
	.byte	0x20
	.uleb128 0x3
	.long	.LASF447
	.byte	0x1
	.byte	0x2d
	.long	0xc92
	.byte	0x28
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x24c
	.uleb128 0x4
	.byte	0x4
	.long	0x213
	.uleb128 0xe
	.byte	0x4
	.byte	0x7
	.byte	0x2c
	.long	0x378
	.uleb128 0xf
	.long	.LASF461
	.byte	0x7
	.byte	0x2d
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0
	.uleb128 0xf
	.long	.LASF462
	.byte	0x7
	.byte	0x2e
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0
	.uleb128 0xf
	.long	.LASF463
	.byte	0x7
	.byte	0x2f
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1d
	.byte	0
	.uleb128 0x10
	.string	"PWT"
	.byte	0x7
	.byte	0x30
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1c
	.byte	0
	.uleb128 0x10
	.string	"PCD"
	.byte	0x7
	.byte	0x31
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1b
	.byte	0
	.uleb128 0xf
	.long	.LASF464
	.byte	0x7
	.byte	0x32
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1a
	.byte	0
	.uleb128 0xf
	.long	.LASF465
	.byte	0x7
	.byte	0x33
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x19
	.byte	0
	.uleb128 0x10
	.string	"avl"
	.byte	0x7
	.byte	0x35
	.long	0x91
	.byte	0x4
	.byte	0x3
	.byte	0x14
	.byte	0
	.uleb128 0xf
	.long	.LASF466
	.byte	0x7
	.byte	0x36
	.long	0x91
	.byte	0x4
	.byte	0x14
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0xe
	.byte	0x4
	.byte	0x7
	.byte	0x38
	.long	0x390
	.uleb128 0xf
	.long	.LASF467
	.byte	0x7
	.byte	0x39
	.long	0x91
	.byte	0x4
	.byte	0xc
	.byte	0x14
	.byte	0
	.byte	0
	.uleb128 0x11
	.string	"pte"
	.byte	0x4
	.byte	0x7
	.byte	0x2a
	.long	0x3b2
	.uleb128 0x12
	.long	.LASF468
	.byte	0x7
	.byte	0x2b
	.long	0xa6
	.uleb128 0x13
	.long	0x2e8
	.uleb128 0x13
	.long	0x378
	.byte	0
	.uleb128 0xe
	.byte	0x4
	.byte	0x7
	.byte	0x49
	.long	0x3ca
	.uleb128 0xf
	.long	.LASF466
	.byte	0x7
	.byte	0x4b
	.long	0x91
	.byte	0x4
	.byte	0x14
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x11
	.string	"cr3"
	.byte	0x4
	.byte	0x7
	.byte	0x47
	.long	0x3e7
	.uleb128 0x12
	.long	.LASF468
	.byte	0x7
	.byte	0x48
	.long	0xa6
	.uleb128 0x13
	.long	0x3b2
	.byte	0
	.uleb128 0xe
	.byte	0x4
	.byte	0x7
	.byte	0x51
	.long	0x43b
	.uleb128 0xf
	.long	.LASF469
	.byte	0x7
	.byte	0x52
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0
	.uleb128 0xf
	.long	.LASF470
	.byte	0x7
	.byte	0x53
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0
	.uleb128 0xf
	.long	.LASF471
	.byte	0x7
	.byte	0x54
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1d
	.byte	0
	.uleb128 0xf
	.long	.LASF472
	.byte	0x7
	.byte	0x55
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1c
	.byte	0
	.uleb128 0xf
	.long	.LASF473
	.byte	0x7
	.byte	0x56
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1b
	.byte	0
	.byte	0
	.uleb128 0xe
	.byte	0x4
	.byte	0x7
	.byte	0x59
	.long	0x480
	.uleb128 0xf
	.long	.LASF474
	.byte	0x7
	.byte	0x5a
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0
	.uleb128 0xf
	.long	.LASF475
	.byte	0x7
	.byte	0x5b
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0
	.uleb128 0xf
	.long	.LASF476
	.byte	0x7
	.byte	0x5c
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1d
	.byte	0
	.uleb128 0xf
	.long	.LASF477
	.byte	0x7
	.byte	0x5e
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1b
	.byte	0
	.byte	0
	.uleb128 0x14
	.long	.LASF478
	.byte	0x4
	.byte	0x7
	.byte	0x4f
	.long	0x4a2
	.uleb128 0x12
	.long	.LASF468
	.byte	0x7
	.byte	0x50
	.long	0x86
	.uleb128 0x13
	.long	0x3e7
	.uleb128 0x13
	.long	0x43b
	.byte	0
	.uleb128 0x2
	.long	.LASF479
	.byte	0x18
	.byte	0x8
	.byte	0x8
	.long	0x52a
	.uleb128 0x9
	.string	"lru"
	.byte	0x8
	.byte	0x9
	.long	0x29
	.byte	0
	.uleb128 0x3
	.long	.LASF480
	.byte	0x8
	.byte	0xa
	.long	0xa6
	.byte	0x8
	.uleb128 0x3
	.long	.LASF481
	.byte	0x8
	.byte	0xb
	.long	0xa6
	.byte	0xc
	.uleb128 0x3
	.long	.LASF482
	.byte	0x8
	.byte	0x10
	.long	0xa6
	.byte	0x10
	.uleb128 0xf
	.long	.LASF483
	.byte	0x8
	.byte	0x11
	.long	0xa6
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0x14
	.uleb128 0xf
	.long	.LASF484
	.byte	0x8
	.byte	0x12
	.long	0xa6
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0x14
	.uleb128 0xf
	.long	.LASF485
	.byte	0x8
	.byte	0x13
	.long	0x91
	.byte	0x4
	.byte	0x2
	.byte	0x1c
	.byte	0x14
	.uleb128 0xf
	.long	.LASF486
	.byte	0x8
	.byte	0x14
	.long	0x91
	.byte	0x4
	.byte	0x8
	.byte	0x14
	.byte	0x14
	.uleb128 0xf
	.long	.LASF487
	.byte	0x8
	.byte	0x15
	.long	0xa6
	.byte	0x4
	.byte	0x14
	.byte	0
	.byte	0x14
	.byte	0
	.uleb128 0x2
	.long	.LASF488
	.byte	0x14
	.byte	0x8
	.byte	0x31
	.long	0x567
	.uleb128 0x3
	.long	.LASF489
	.byte	0x8
	.byte	0x32
	.long	0x29
	.byte	0
	.uleb128 0x3
	.long	.LASF490
	.byte	0x8
	.byte	0x33
	.long	0xa6
	.byte	0x8
	.uleb128 0x3
	.long	.LASF491
	.byte	0x8
	.byte	0x34
	.long	0xa6
	.byte	0xc
	.uleb128 0x3
	.long	.LASF492
	.byte	0x8
	.byte	0x34
	.long	0xa6
	.byte	0x10
	.byte	0
	.uleb128 0x5
	.long	.LASF493
	.byte	0x8
	.byte	0x35
	.long	0x52a
	.uleb128 0x2
	.long	.LASF494
	.byte	0xf0
	.byte	0x8
	.byte	0x37
	.long	0x5c7
	.uleb128 0x3
	.long	.LASF495
	.byte	0x8
	.byte	0x39
	.long	0x91
	.byte	0
	.uleb128 0x3
	.long	.LASF496
	.byte	0x8
	.byte	0x3a
	.long	0x5c7
	.byte	0x4
	.uleb128 0x3
	.long	.LASF497
	.byte	0x8
	.byte	0x3b
	.long	0x5de
	.byte	0xe0
	.uleb128 0x3
	.long	.LASF498
	.byte	0x8
	.byte	0x3c
	.long	0x91
	.byte	0xe4
	.uleb128 0x3
	.long	.LASF492
	.byte	0x8
	.byte	0x3d
	.long	0xa6
	.byte	0xe8
	.uleb128 0x3
	.long	.LASF491
	.byte	0x8
	.byte	0x3d
	.long	0xa6
	.byte	0xec
	.byte	0
	.uleb128 0x15
	.long	0x567
	.long	0x5d7
	.uleb128 0x16
	.long	0x5d7
	.byte	0xa
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.byte	0x7
	.long	.LASF499
	.uleb128 0x4
	.byte	0x4
	.long	0x4a2
	.uleb128 0x5
	.long	.LASF500
	.byte	0x8
	.byte	0x3e
	.long	0x572
	.uleb128 0x17
	.string	"mm"
	.byte	0x24
	.byte	0x9
	.byte	0x10
	.long	0x667
	.uleb128 0x9
	.string	"cr3"
	.byte	0x9
	.byte	0x11
	.long	0x3ca
	.byte	0
	.uleb128 0x9
	.string	"vma"
	.byte	0x9
	.byte	0x12
	.long	0x6eb
	.byte	0x4
	.uleb128 0x3
	.long	.LASF501
	.byte	0x9
	.byte	0x14
	.long	0x5f
	.byte	0x8
	.uleb128 0x3
	.long	.LASF502
	.byte	0x9
	.byte	0x14
	.long	0x5f
	.byte	0xc
	.uleb128 0x3
	.long	.LASF503
	.byte	0x9
	.byte	0x15
	.long	0x5f
	.byte	0x10
	.uleb128 0x3
	.long	.LASF504
	.byte	0x9
	.byte	0x15
	.long	0x5f
	.byte	0x14
	.uleb128 0x3
	.long	.LASF505
	.byte	0x9
	.byte	0x16
	.long	0x5f
	.byte	0x18
	.uleb128 0x9
	.string	"brk"
	.byte	0x9
	.byte	0x16
	.long	0x5f
	.byte	0x1c
	.uleb128 0x3
	.long	.LASF443
	.byte	0x9
	.byte	0x17
	.long	0xa6
	.byte	0x20
	.byte	0
	.uleb128 0x2
	.long	.LASF506
	.byte	0x28
	.byte	0xa
	.byte	0x57
	.long	0x6eb
	.uleb128 0x9
	.string	"mm"
	.byte	0xa
	.byte	0x58
	.long	0x82c
	.byte	0
	.uleb128 0x3
	.long	.LASF507
	.byte	0xa
	.byte	0x59
	.long	0x86
	.byte	0x4
	.uleb128 0x9
	.string	"end"
	.byte	0xa
	.byte	0x5a
	.long	0x86
	.byte	0x8
	.uleb128 0x3
	.long	.LASF508
	.byte	0xa
	.byte	0x5b
	.long	0x390
	.byte	0xc
	.uleb128 0x3
	.long	.LASF467
	.byte	0xa
	.byte	0x5f
	.long	0x7ae
	.byte	0x10
	.uleb128 0x3
	.long	.LASF426
	.byte	0xa
	.byte	0x61
	.long	0x6eb
	.byte	0x14
	.uleb128 0x3
	.long	.LASF427
	.byte	0xa
	.byte	0x61
	.long	0x6eb
	.byte	0x18
	.uleb128 0x9
	.string	"ops"
	.byte	0xa
	.byte	0x62
	.long	0x832
	.byte	0x1c
	.uleb128 0x3
	.long	.LASF509
	.byte	0xa
	.byte	0x63
	.long	0x88d
	.byte	0x20
	.uleb128 0x3
	.long	.LASF510
	.byte	0xa
	.byte	0x64
	.long	0x86
	.byte	0x24
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x667
	.uleb128 0xe
	.byte	0x2
	.byte	0xa
	.byte	0x24
	.long	0x7ae
	.uleb128 0xf
	.long	.LASF511
	.byte	0xa
	.byte	0x25
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0
	.uleb128 0xf
	.long	.LASF462
	.byte	0xa
	.byte	0x26
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0
	.uleb128 0xf
	.long	.LASF512
	.byte	0xa
	.byte	0x27
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1d
	.byte	0
	.uleb128 0xf
	.long	.LASF513
	.byte	0xa
	.byte	0x28
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1c
	.byte	0
	.uleb128 0xf
	.long	.LASF514
	.byte	0xa
	.byte	0x2a
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1b
	.byte	0
	.uleb128 0xf
	.long	.LASF515
	.byte	0xa
	.byte	0x2b
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x1a
	.byte	0
	.uleb128 0xf
	.long	.LASF516
	.byte	0xa
	.byte	0x2c
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x19
	.byte	0
	.uleb128 0xf
	.long	.LASF517
	.byte	0xa
	.byte	0x2d
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x18
	.byte	0
	.uleb128 0xf
	.long	.LASF518
	.byte	0xa
	.byte	0x2f
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x17
	.byte	0
	.uleb128 0xf
	.long	.LASF519
	.byte	0xa
	.byte	0x30
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x16
	.byte	0
	.uleb128 0xf
	.long	.LASF520
	.byte	0xa
	.byte	0x31
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x15
	.byte	0
	.uleb128 0xf
	.long	.LASF521
	.byte	0xa
	.byte	0x32
	.long	0x91
	.byte	0x4
	.byte	0x1
	.byte	0x14
	.byte	0
	.byte	0
	.uleb128 0x14
	.long	.LASF522
	.byte	0x4
	.byte	0xa
	.byte	0x23
	.long	0x7cb
	.uleb128 0x13
	.long	0x6f1
	.uleb128 0x12
	.long	.LASF468
	.byte	0xa
	.byte	0x34
	.long	0x91
	.byte	0
	.uleb128 0x2
	.long	.LASF523
	.byte	0xc
	.byte	0xa
	.byte	0x51
	.long	0x7fc
	.uleb128 0x3
	.long	.LASF524
	.byte	0xa
	.byte	0x52
	.long	0x807
	.byte	0
	.uleb128 0x3
	.long	.LASF525
	.byte	0xa
	.byte	0x53
	.long	0x807
	.byte	0x4
	.uleb128 0x3
	.long	.LASF526
	.byte	0xa
	.byte	0x54
	.long	0x826
	.byte	0x8
	.byte	0
	.uleb128 0x18
	.long	0x807
	.uleb128 0xd
	.long	0x6eb
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x7fc
	.uleb128 0xc
	.long	0x5de
	.long	0x826
	.uleb128 0xd
	.long	0x6eb
	.uleb128 0xd
	.long	0x86
	.uleb128 0xd
	.long	0x480
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x80d
	.uleb128 0x4
	.byte	0x4
	.long	0x5ef
	.uleb128 0x4
	.byte	0x4
	.long	0x7cb
	.uleb128 0x2
	.long	.LASF509
	.byte	0x18
	.byte	0x1
	.byte	0x48
	.long	0x88d
	.uleb128 0x3
	.long	.LASF448
	.byte	0x1
	.byte	0x49
	.long	0x1c4
	.byte	0
	.uleb128 0x9
	.string	"pos"
	.byte	0x1
	.byte	0x4a
	.long	0x91
	.byte	0x4
	.uleb128 0x3
	.long	.LASF467
	.byte	0x1
	.byte	0x4b
	.long	0x91
	.byte	0x8
	.uleb128 0x3
	.long	.LASF527
	.byte	0x1
	.byte	0x4c
	.long	0x91
	.byte	0xc
	.uleb128 0x3
	.long	.LASF443
	.byte	0x1
	.byte	0x4e
	.long	0xa6
	.byte	0x10
	.uleb128 0x3
	.long	.LASF528
	.byte	0x1
	.byte	0x4f
	.long	0xce7
	.byte	0x14
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x838
	.uleb128 0x19
	.byte	0x4
	.byte	0xb
	.byte	0x3
	.long	0x8b4
	.uleb128 0x1a
	.long	.LASF529
	.sleb128 0
	.uleb128 0x1a
	.long	.LASF530
	.sleb128 1
	.uleb128 0x1a
	.long	.LASF531
	.sleb128 2
	.uleb128 0x1a
	.long	.LASF532
	.sleb128 3
	.byte	0
	.uleb128 0x2
	.long	.LASF533
	.byte	0x8
	.byte	0xb
	.byte	0xc
	.long	0x8d9
	.uleb128 0x9
	.string	"cur"
	.byte	0xb
	.byte	0xd
	.long	0x91
	.byte	0
	.uleb128 0x9
	.string	"max"
	.byte	0xb
	.byte	0xe
	.long	0x91
	.byte	0x4
	.byte	0
	.uleb128 0x15
	.long	0x20c
	.long	0x8e9
	.uleb128 0x16
	.long	0x5d7
	.byte	0xf
	.byte	0
	.uleb128 0x2
	.long	.LASF534
	.byte	0x14
	.byte	0xc
	.byte	0x25
	.long	0x932
	.uleb128 0x3
	.long	.LASF443
	.byte	0xc
	.byte	0x26
	.long	0xa6
	.byte	0
	.uleb128 0x3
	.long	.LASF446
	.byte	0xc
	.byte	0x27
	.long	0x1c4
	.byte	0x4
	.uleb128 0x9
	.string	"pwd"
	.byte	0xc
	.byte	0x27
	.long	0x1c4
	.byte	0x8
	.uleb128 0x3
	.long	.LASF535
	.byte	0xc
	.byte	0x28
	.long	0x1ca
	.byte	0xc
	.uleb128 0x3
	.long	.LASF536
	.byte	0xc
	.byte	0x28
	.long	0x1ca
	.byte	0x10
	.byte	0
	.uleb128 0x2
	.long	.LASF537
	.byte	0x8c
	.byte	0xc
	.byte	0x30
	.long	0x96f
	.uleb128 0x3
	.long	.LASF538
	.byte	0xc
	.byte	0x35
	.long	0xa6
	.byte	0
	.uleb128 0x3
	.long	.LASF539
	.byte	0xc
	.byte	0x36
	.long	0x96f
	.byte	0x4
	.uleb128 0x3
	.long	.LASF540
	.byte	0xc
	.byte	0x37
	.long	0x975
	.byte	0x8
	.uleb128 0x3
	.long	.LASF443
	.byte	0xc
	.byte	0x38
	.long	0xa6
	.byte	0x88
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x88d
	.uleb128 0x15
	.long	0x88d
	.long	0x985
	.uleb128 0x16
	.long	0x5d7
	.byte	0x1f
	.byte	0
	.uleb128 0x2
	.long	.LASF541
	.byte	0x8
	.byte	0xc
	.byte	0x3b
	.long	0x9aa
	.uleb128 0x9
	.string	"esp"
	.byte	0xc
	.byte	0x3c
	.long	0x91
	.byte	0
	.uleb128 0x9
	.string	"eip"
	.byte	0xc
	.byte	0x3d
	.long	0x91
	.byte	0x4
	.byte	0
	.uleb128 0x2
	.long	.LASF542
	.byte	0x44
	.byte	0xc
	.byte	0x41
	.long	0xa7d
	.uleb128 0x9
	.string	"ebx"
	.byte	0xc
	.byte	0x42
	.long	0x86
	.byte	0
	.uleb128 0x9
	.string	"ecx"
	.byte	0xc
	.byte	0x42
	.long	0x86
	.byte	0x4
	.uleb128 0x9
	.string	"edx"
	.byte	0xc
	.byte	0x42
	.long	0x86
	.byte	0x8
	.uleb128 0x9
	.string	"esi"
	.byte	0xc
	.byte	0x42
	.long	0x86
	.byte	0xc
	.uleb128 0x9
	.string	"edi"
	.byte	0xc
	.byte	0x43
	.long	0x86
	.byte	0x10
	.uleb128 0x9
	.string	"ebp"
	.byte	0xc
	.byte	0x43
	.long	0x86
	.byte	0x14
	.uleb128 0x9
	.string	"eax"
	.byte	0xc
	.byte	0x43
	.long	0x86
	.byte	0x18
	.uleb128 0x9
	.string	"ds"
	.byte	0xc
	.byte	0x44
	.long	0x86
	.byte	0x1c
	.uleb128 0x9
	.string	"es"
	.byte	0xc
	.byte	0x44
	.long	0x86
	.byte	0x20
	.uleb128 0x9
	.string	"gs"
	.byte	0xc
	.byte	0x44
	.long	0x86
	.byte	0x24
	.uleb128 0x9
	.string	"fs"
	.byte	0xc
	.byte	0x44
	.long	0x86
	.byte	0x28
	.uleb128 0x3
	.long	.LASF543
	.byte	0xc
	.byte	0x45
	.long	0x86
	.byte	0x2c
	.uleb128 0x9
	.string	"eip"
	.byte	0xc
	.byte	0x46
	.long	0x86
	.byte	0x30
	.uleb128 0x9
	.string	"cs"
	.byte	0xc
	.byte	0x46
	.long	0x86
	.byte	0x34
	.uleb128 0x3
	.long	.LASF544
	.byte	0xc
	.byte	0x46
	.long	0x86
	.byte	0x38
	.uleb128 0x9
	.string	"esp"
	.byte	0xc
	.byte	0x46
	.long	0x86
	.byte	0x3c
	.uleb128 0x9
	.string	"ss"
	.byte	0xc
	.byte	0x46
	.long	0x86
	.byte	0x40
	.byte	0
	.uleb128 0x5
	.long	.LASF545
	.byte	0xc
	.byte	0x47
	.long	0x9aa
	.uleb128 0x2
	.long	.LASF546
	.byte	0x24
	.byte	0xc
	.byte	0x4a
	.long	0xaad
	.uleb128 0x3
	.long	.LASF547
	.byte	0xc
	.byte	0x4b
	.long	0xaad
	.byte	0
	.uleb128 0x9
	.string	"esp"
	.byte	0xc
	.byte	0x4c
	.long	0xa6
	.byte	0x20
	.byte	0
	.uleb128 0x15
	.long	0xa6
	.long	0xabd
	.uleb128 0x16
	.long	0x5d7
	.byte	0x7
	.byte	0
	.uleb128 0xe
	.byte	0x90
	.byte	0xc
	.byte	0x54
	.long	0xba8
	.uleb128 0x3
	.long	.LASF548
	.byte	0xc
	.byte	0x55
	.long	0xa6
	.byte	0
	.uleb128 0x3
	.long	.LASF549
	.byte	0xc
	.byte	0x56
	.long	0xa6
	.byte	0x4
	.uleb128 0x3
	.long	.LASF426
	.byte	0xc
	.byte	0x57
	.long	0xbc9
	.byte	0x8
	.uleb128 0x3
	.long	.LASF427
	.byte	0xc
	.byte	0x58
	.long	0xbc9
	.byte	0xc
	.uleb128 0x9
	.string	"pid"
	.byte	0xc
	.byte	0x59
	.long	0x86
	.byte	0x10
	.uleb128 0x3
	.long	.LASF550
	.byte	0xc
	.byte	0x5a
	.long	0x8d9
	.byte	0x14
	.uleb128 0x3
	.long	.LASF551
	.byte	0xc
	.byte	0x5b
	.long	0x86
	.byte	0x24
	.uleb128 0x3
	.long	.LASF552
	.byte	0xc
	.byte	0x5c
	.long	0x86
	.byte	0x28
	.uleb128 0x3
	.long	.LASF553
	.byte	0xc
	.byte	0x5c
	.long	0x86
	.byte	0x2c
	.uleb128 0x3
	.long	.LASF554
	.byte	0xc
	.byte	0x5d
	.long	0x86
	.byte	0x30
	.uleb128 0x3
	.long	.LASF555
	.byte	0xc
	.byte	0x5d
	.long	0x86
	.byte	0x34
	.uleb128 0x9
	.string	"mm"
	.byte	0xc
	.byte	0x5e
	.long	0x82c
	.byte	0x38
	.uleb128 0x3
	.long	.LASF541
	.byte	0xc
	.byte	0x5f
	.long	0x985
	.byte	0x3c
	.uleb128 0x9
	.string	"fs"
	.byte	0xc
	.byte	0x60
	.long	0xbcf
	.byte	0x44
	.uleb128 0x3
	.long	.LASF556
	.byte	0xc
	.byte	0x61
	.long	0xbd5
	.byte	0x48
	.uleb128 0x3
	.long	.LASF557
	.byte	0xc
	.byte	0x62
	.long	0xbdb
	.byte	0x4c
	.uleb128 0x3
	.long	.LASF558
	.byte	0xc
	.byte	0x63
	.long	0xa88
	.byte	0x64
	.uleb128 0x3
	.long	.LASF559
	.byte	0xc
	.byte	0x64
	.long	0x86
	.byte	0x88
	.uleb128 0x3
	.long	.LASF560
	.byte	0xc
	.byte	0x65
	.long	0x86
	.byte	0x8c
	.byte	0
	.uleb128 0x1b
	.string	"pcb"
	.value	0x2000
	.byte	0xc
	.byte	0x52
	.long	0xbc9
	.uleb128 0x1c
	.long	0xbeb
	.byte	0
	.uleb128 0x1d
	.long	.LASF561
	.byte	0xc
	.byte	0x69
	.long	0xa7d
	.value	0x1fbc
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0xba8
	.uleb128 0x4
	.byte	0x4
	.long	0x8e9
	.uleb128 0x4
	.byte	0x4
	.long	0x932
	.uleb128 0x15
	.long	0x8b4
	.long	0xbeb
	.uleb128 0x16
	.long	0x5d7
	.byte	0x2
	.byte	0
	.uleb128 0x1e
	.value	0x1fbc
	.byte	0xc
	.byte	0x53
	.long	0xc05
	.uleb128 0x13
	.long	0xabd
	.uleb128 0x12
	.long	.LASF487
	.byte	0xc
	.byte	0x67
	.long	0xc05
	.byte	0
	.uleb128 0x15
	.long	0x20c
	.long	0xc16
	.uleb128 0x1f
	.long	0x5d7
	.value	0x1fbb
	.byte	0
	.uleb128 0x2
	.long	.LASF562
	.byte	0x4
	.byte	0x1
	.byte	0x11
	.long	0xc2f
	.uleb128 0x3
	.long	.LASF563
	.byte	0x1
	.byte	0x1a
	.long	0xc43
	.byte	0
	.byte	0
	.uleb128 0xc
	.long	0xa6
	.long	0xc43
	.uleb128 0xd
	.long	0x2dc
	.uleb128 0xd
	.long	0x1c4
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0xc2f
	.uleb128 0x4
	.byte	0x4
	.long	0xc16
	.uleb128 0x2
	.long	.LASF564
	.byte	0x10
	.byte	0x1
	.byte	0x55
	.long	0xc8c
	.uleb128 0x3
	.long	.LASF565
	.byte	0x1
	.byte	0x56
	.long	0xd02
	.byte	0
	.uleb128 0x3
	.long	.LASF566
	.byte	0x1
	.byte	0x57
	.long	0xd32
	.byte	0x4
	.uleb128 0x3
	.long	.LASF524
	.byte	0x1
	.byte	0x59
	.long	0xd4c
	.byte	0x8
	.uleb128 0x3
	.long	.LASF567
	.byte	0x1
	.byte	0x5a
	.long	0xd61
	.byte	0xc
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0xc4f
	.uleb128 0x15
	.long	0x20c
	.long	0xca2
	.uleb128 0x16
	.long	0x5d7
	.byte	0x7f
	.byte	0
	.uleb128 0x2
	.long	.LASF568
	.byte	0x4
	.byte	0x1
	.byte	0x30
	.long	0xcbb
	.uleb128 0x3
	.long	.LASF569
	.byte	0x1
	.byte	0x31
	.long	0xcca
	.byte	0
	.byte	0
	.uleb128 0xc
	.long	0xa6
	.long	0xcca
	.uleb128 0xd
	.long	0x2dc
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0xcbb
	.uleb128 0x4
	.byte	0x4
	.long	0xca2
	.uleb128 0x15
	.long	0x20c
	.long	0xce7
	.uleb128 0x1f
	.long	0x5d7
	.value	0x1ff
	.byte	0
	.uleb128 0x20
	.byte	0x4
	.uleb128 0xc
	.long	0xa6
	.long	0xd02
	.uleb128 0xd
	.long	0x88d
	.uleb128 0xd
	.long	0xa6
	.uleb128 0xd
	.long	0x91
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0xce9
	.uleb128 0xc
	.long	0xa6
	.long	0xd26
	.uleb128 0xd
	.long	0x88d
	.uleb128 0xd
	.long	0xd26
	.uleb128 0xd
	.long	0x91
	.uleb128 0xd
	.long	0xd2c
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x20c
	.uleb128 0x4
	.byte	0x4
	.long	0x91
	.uleb128 0x4
	.byte	0x4
	.long	0xd08
	.uleb128 0xc
	.long	0xa6
	.long	0xd4c
	.uleb128 0xd
	.long	0x2dc
	.uleb128 0xd
	.long	0x88d
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0xd38
	.uleb128 0xc
	.long	0xa6
	.long	0xd61
	.uleb128 0xd
	.long	0x88d
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0xd52
	.uleb128 0x21
	.long	.LASF570
	.byte	0x1
	.byte	0x5f
	.long	0x88d
	.long	.LFB49
	.long	.LFE49-.LFB49
	.uleb128 0x1
	.byte	0x9c
	.long	0xd8e
	.uleb128 0x22
	.string	"fd"
	.byte	0x1
	.byte	0x5f
	.long	0x91
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x21
	.long	.LASF571
	.byte	0x1
	.byte	0x63
	.long	0x88d
	.long	.LFB50
	.long	.LFE50-.LFB50
	.uleb128 0x1
	.byte	0x9c
	.long	0xdc3
	.uleb128 0x22
	.string	"fd"
	.byte	0x1
	.byte	0x63
	.long	0xa6
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x23
	.long	.LASF509
	.byte	0x1
	.byte	0x64
	.long	0x88d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0x24
	.long	.LASF572
	.byte	0x2
	.byte	0x4
	.long	0xa6
	.long	.LFB51
	.long	.LFE51-.LFB51
	.uleb128 0x1
	.byte	0x9c
	.long	0xe07
	.uleb128 0x25
	.long	.LASF509
	.byte	0x2
	.byte	0x4
	.long	0x88d
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x25
	.long	.LASF573
	.byte	0x2
	.byte	0x4
	.long	0xa6
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x25
	.long	.LASF574
	.byte	0x2
	.byte	0x4
	.long	0x91
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.byte	0
	.uleb128 0x26
	.long	.LASF575
	.byte	0x2
	.byte	0x16
	.long	0xa6
	.long	.LFB52
	.long	.LFE52-.LFB52
	.uleb128 0x1
	.byte	0x9c
	.long	0xe58
	.uleb128 0x22
	.string	"fd"
	.byte	0x2
	.byte	0x16
	.long	0x91
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x25
	.long	.LASF573
	.byte	0x2
	.byte	0x16
	.long	0xa6
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x25
	.long	.LASF574
	.byte	0x2
	.byte	0x16
	.long	0x91
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0x23
	.long	.LASF509
	.byte	0x2
	.byte	0x17
	.long	0x88d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0x26
	.long	.LASF576
	.byte	0x2
	.byte	0x24
	.long	0xa6
	.long	.LFB53
	.long	.LFE53-.LFB53
	.uleb128 0x1
	.byte	0x9c
	.long	0xe9b
	.uleb128 0x22
	.string	"fd"
	.byte	0x2
	.byte	0x24
	.long	0x91
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x23
	.long	.LASF509
	.byte	0x2
	.byte	0x29
	.long	0x88d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x23
	.long	.LASF577
	.byte	0x2
	.byte	0x2c
	.long	0xc8c
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0x21
	.long	.LASF578
	.byte	0x2
	.byte	0x37
	.long	0xa6
	.long	.LFB54
	.long	.LFE54-.LFB54
	.uleb128 0x1
	.byte	0x9c
	.long	0xefb
	.uleb128 0x25
	.long	.LASF509
	.byte	0x2
	.byte	0x37
	.long	0x88d
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x22
	.string	"buf"
	.byte	0x2
	.byte	0x37
	.long	0xd26
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x25
	.long	.LASF459
	.byte	0x2
	.byte	0x37
	.long	0x91
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0x23
	.long	.LASF579
	.byte	0x2
	.byte	0x3b
	.long	0x91
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x27
	.string	"ret"
	.byte	0x2
	.byte	0x3d
	.long	0xa6
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0x26
	.long	.LASF580
	.byte	0x2
	.byte	0x40
	.long	0xa6
	.long	.LFB55
	.long	.LFE55-.LFB55
	.uleb128 0x1
	.byte	0x9c
	.long	0xf5a
	.uleb128 0x22
	.string	"fd"
	.byte	0x2
	.byte	0x40
	.long	0x91
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x22
	.string	"buf"
	.byte	0x2
	.byte	0x40
	.long	0xd26
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x25
	.long	.LASF459
	.byte	0x2
	.byte	0x40
	.long	0x91
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0x23
	.long	.LASF581
	.byte	0x2
	.byte	0x41
	.long	0xa6
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x23
	.long	.LASF509
	.byte	0x2
	.byte	0x42
	.long	0x88d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0x26
	.long	.LASF582
	.byte	0x2
	.byte	0x4e
	.long	0x88d
	.long	.LFB56
	.long	.LFE56-.LFB56
	.uleb128 0x1
	.byte	0x9c
	.long	0xfab
	.uleb128 0x25
	.long	.LASF583
	.byte	0x2
	.byte	0x4e
	.long	0xd26
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x25
	.long	.LASF467
	.byte	0x2
	.byte	0x4e
	.long	0x54
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x25
	.long	.LASF527
	.byte	0x2
	.byte	0x4e
	.long	0x54
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0x27
	.string	"fd"
	.byte	0x2
	.byte	0x4f
	.long	0xa6
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0x26
	.long	.LASF584
	.byte	0x2
	.byte	0x53
	.long	0xa6
	.long	.LFB57
	.long	.LFE57-.LFB57
	.uleb128 0x1
	.byte	0x9c
	.long	0xfef
	.uleb128 0x25
	.long	.LASF509
	.byte	0x2
	.byte	0x53
	.long	0x88d
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x22
	.string	"buf"
	.byte	0x2
	.byte	0x53
	.long	0xd26
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x25
	.long	.LASF459
	.byte	0x2
	.byte	0x53
	.long	0x91
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.byte	0
	.uleb128 0x26
	.long	.LASF585
	.byte	0x2
	.byte	0x58
	.long	0xa6
	.long	.LFB58
	.long	.LFE58-.LFB58
	.uleb128 0x1
	.byte	0x9c
	.long	0x1033
	.uleb128 0x25
	.long	.LASF509
	.byte	0x2
	.byte	0x58
	.long	0x88d
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x25
	.long	.LASF573
	.byte	0x2
	.byte	0x58
	.long	0xa6
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x25
	.long	.LASF574
	.byte	0x2
	.byte	0x58
	.long	0x91
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.byte	0
	.uleb128 0x28
	.long	.LASF603
	.uleb128 0x29
	.long	.LASF586
	.byte	0x6
	.byte	0x6
	.long	0x4e
	.uleb128 0x5
	.byte	0x3
	.long	dentry_hashtable
	.uleb128 0x29
	.long	.LASF587
	.byte	0x6
	.byte	0x9e
	.long	0x105a
	.uleb128 0x5
	.byte	0x3
	.long	dentry_cache
	.uleb128 0x4
	.byte	0x4
	.long	0x1033
	.uleb128 0x15
	.long	0x20c
	.long	0x1070
	.uleb128 0x16
	.long	0x5d7
	.byte	0x3
	.byte	0
	.uleb128 0x29
	.long	.LASF588
	.byte	0xd
	.byte	0x35
	.long	0x1060
	.uleb128 0x5
	.byte	0x3
	.long	mem_entity
	.uleb128 0x29
	.long	.LASF589
	.byte	0x8
	.byte	0x1e
	.long	0x5de
	.uleb128 0x5
	.byte	0x3
	.long	mem_map
	.uleb128 0x29
	.long	.LASF590
	.byte	0x8
	.byte	0x40
	.long	0x5e4
	.uleb128 0x5
	.byte	0x3
	.long	zone_dma
	.uleb128 0x29
	.long	.LASF591
	.byte	0x8
	.byte	0x41
	.long	0x5e4
	.uleb128 0x5
	.byte	0x3
	.long	zone_normal
	.uleb128 0x29
	.long	.LASF592
	.byte	0x8
	.byte	0x42
	.long	0x5e4
	.uleb128 0x5
	.byte	0x3
	.long	zone_highmem
	.uleb128 0x15
	.long	0x10d5
	.long	0x10d5
	.uleb128 0x16
	.long	0x5d7
	.byte	0x2
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x5e4
	.uleb128 0x29
	.long	.LASF593
	.byte	0x8
	.byte	0x43
	.long	0x10c5
	.uleb128 0x5
	.byte	0x3
	.long	__zones
	.uleb128 0x15
	.long	0x91
	.long	0x10fc
	.uleb128 0x16
	.long	0x5d7
	.byte	0x2
	.byte	0
	.uleb128 0x29
	.long	.LASF594
	.byte	0x8
	.byte	0x44
	.long	0x10ec
	.uleb128 0x5
	.byte	0x3
	.long	size_of_zone
	.uleb128 0x29
	.long	.LASF595
	.byte	0xc
	.byte	0x10
	.long	0xbc9
	.uleb128 0x5
	.byte	0x3
	.long	__hs_pcb
	.uleb128 0x29
	.long	.LASF596
	.byte	0xc
	.byte	0x11
	.long	0xbc9
	.uleb128 0x5
	.byte	0x3
	.long	__ext_pcb
	.uleb128 0x29
	.long	.LASF597
	.byte	0x1
	.byte	0x45
	.long	0x4e
	.uleb128 0x5
	.byte	0x3
	.long	inode_hashtable
	.uleb128 0x29
	.long	.LASF598
	.byte	0x1
	.byte	0x73
	.long	0x105a
	.uleb128 0x5
	.byte	0x3
	.long	inode_cache
	.uleb128 0x29
	.long	.LASF599
	.byte	0x1
	.byte	0x74
	.long	0x105a
	.uleb128 0x5
	.byte	0x3
	.long	file_cache
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
	.uleb128 0x3
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
	.uleb128 0x4
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
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
	.uleb128 0x6
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
	.uleb128 0x7
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
	.uleb128 0x8
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
	.uleb128 0x9
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
	.uleb128 0xa
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0x5
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
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
	.uleb128 0xf
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
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0xd
	.uleb128 0xb
	.uleb128 0xc
	.uleb128 0xb
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x10
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
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0xd
	.uleb128 0xb
	.uleb128 0xc
	.uleb128 0xb
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x17
	.byte	0x1
	.uleb128 0x3
	.uleb128 0x8
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
	.uleb128 0x12
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
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0xd
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x17
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
	.uleb128 0x15
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0x8
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
	.uleb128 0x18
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x19
	.uleb128 0x4
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
	.uleb128 0x1a
	.uleb128 0x28
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1c
	.uleb128 0xd
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0xb
	.uleb128 0x5
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1c
	.uleb128 0xd
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x1d
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
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x1e
	.uleb128 0x17
	.byte	0x1
	.uleb128 0xb
	.uleb128 0x5
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1f
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x20
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x21
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
	.uleb128 0x22
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
	.uleb128 0x23
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
	.uleb128 0x24
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
	.uleb128 0x25
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
	.uleb128 0x26
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
	.uleb128 0x27
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
	.uleb128 0x28
	.uleb128 0x13
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x29
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
	.uleb128 0x2
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
	.uleb128 0x1
	.byte	0x5
	.uleb128 0x2
	.long	.LASF228
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x6
	.byte	0x5
	.uleb128 0x2
	.long	.LASF229
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x3
	.byte	0x5
	.uleb128 0x2
	.long	.LASF230
	.file 14 "./include/linux/assert.h"
	.byte	0x3
	.uleb128 0x5
	.uleb128 0xe
	.byte	0x7
	.long	.Ldebug_macro1
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro2
	.byte	0x4
	.byte	0x3
	.uleb128 0x4
	.uleb128 0x5
	.byte	0x5
	.uleb128 0x2
	.long	.LASF236
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x6
	.byte	0x4
	.byte	0x3
	.uleb128 0x4
	.uleb128 0x4
	.byte	0x7
	.long	.Ldebug_macro3
	.byte	0x4
	.byte	0x4
	.byte	0x5
	.uleb128 0x7
	.long	.LASF250
	.file 15 "./include/linux/slab.h"
	.byte	0x3
	.uleb128 0x9d
	.uleb128 0xf
	.byte	0x7
	.long	.Ldebug_macro4
	.byte	0x4
	.byte	0x4
	.byte	0x3
	.uleb128 0x4
	.uleb128 0xc
	.byte	0x5
	.uleb128 0x2
	.long	.LASF259
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x4
	.byte	0x4
	.file 16 "./include/old/utils.h"
	.byte	0x3
	.uleb128 0x4
	.uleb128 0x10
	.byte	0x5
	.uleb128 0x2
	.long	.LASF260
	.byte	0x3
	.uleb128 0x3
	.uleb128 0xd
	.byte	0x7
	.long	.Ldebug_macro5
	.byte	0x4
	.file 17 "./include/linux/mylist.h"
	.byte	0x3
	.uleb128 0x4
	.uleb128 0x11
	.byte	0x7
	.long	.Ldebug_macro6
	.byte	0x4
	.file 18 "./include/linux/byteorder/generic.h"
	.byte	0x3
	.uleb128 0x7
	.uleb128 0x12
	.byte	0x7
	.long	.Ldebug_macro7
	.byte	0x4
	.file 19 "./include/linux/string.h"
	.byte	0x3
	.uleb128 0x8
	.uleb128 0x13
	.byte	0x5
	.uleb128 0x2
	.long	.LASF296
	.byte	0x4
	.file 20 "./include/old/mm.h"
	.byte	0x3
	.uleb128 0x3c
	.uleb128 0x14
	.byte	0x5
	.uleb128 0x2
	.long	.LASF297
	.byte	0x3
	.uleb128 0x3
	.uleb128 0xa
	.byte	0x5
	.uleb128 0x2
	.long	.LASF298
	.byte	0x3
	.uleb128 0x5
	.uleb128 0x10
	.byte	0x4
	.byte	0x3
	.uleb128 0x7
	.uleb128 0x8
	.byte	0x5
	.uleb128 0x2
	.long	.LASF299
	.byte	0x3
	.uleb128 0x4
	.uleb128 0xa
	.byte	0x4
	.byte	0x3
	.uleb128 0x5
	.uleb128 0x7
	.byte	0x7
	.long	.Ldebug_macro8
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro9
	.byte	0x4
	.file 21 "./include/old/pmm.h"
	.byte	0x3
	.uleb128 0x8
	.uleb128 0x15
	.byte	0x7
	.long	.Ldebug_macro10
	.byte	0x4
	.byte	0x3
	.uleb128 0x9
	.uleb128 0x9
	.byte	0x7
	.long	.Ldebug_macro11
	.byte	0x4
	.byte	0x5
	.uleb128 0x82
	.long	.LASF349
	.byte	0x4
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro12
	.byte	0x4
	.file 22 "./include/old/ku_proc.h"
	.byte	0x3
	.uleb128 0x5
	.uleb128 0x16
	.byte	0x7
	.long	.Ldebug_macro13
	.byte	0x4
	.byte	0x3
	.uleb128 0x7
	.uleb128 0xb
	.byte	0x5
	.uleb128 0x2
	.long	.LASF371
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro14
	.byte	0x3
	.uleb128 0x70
	.uleb128 0x1
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro15
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro16
	.byte	0x4
	.file 23 "./include/linux/errno.h"
	.byte	0x3
	.uleb128 0x2
	.uleb128 0x17
	.byte	0x5
	.uleb128 0xb
	.long	.LASF388
	.file 24 "./arch/x86/include/asm/errno.h"
	.byte	0x3
	.uleb128 0xc
	.uleb128 0x18
	.byte	0x5
	.uleb128 0x2
	.long	.LASF389
	.file 25 "./include/asm-generic/errno.h"
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x19
	.byte	0x5
	.uleb128 0x2
	.long	.LASF390
	.file 26 "./include/asm-generic/errno-base.h"
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x1a
	.byte	0x7
	.long	.Ldebug_macro17
	.byte	0x4
	.byte	0x4
	.byte	0x4
	.byte	0x4
	.byte	0x4
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.assert.h.2.04d8cd0d4ab92c4edaf5ee8e3da38922,comdat
.Ldebug_macro1:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF231
	.byte	0x5
	.uleb128 0x6
	.long	.LASF232
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.list.h.11.14b8b11cd281772ad6d5a70018d2cfae,comdat
.Ldebug_macro2:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0xb
	.long	.LASF233
	.byte	0x5
	.uleb128 0x46
	.long	.LASF234
	.byte	0x5
	.uleb128 0x57
	.long	.LASF235
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.valType.h.3.7c3190cc3f15c77f186fd44ab736eede,comdat
.Ldebug_macro3:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x3
	.long	.LASF237
	.byte	0x5
	.uleb128 0x5
	.long	.LASF238
	.byte	0x5
	.uleb128 0x6
	.long	.LASF239
	.byte	0x5
	.uleb128 0x7
	.long	.LASF240
	.byte	0x5
	.uleb128 0x8
	.long	.LASF241
	.byte	0x5
	.uleb128 0x9
	.long	.LASF242
	.byte	0x5
	.uleb128 0xb
	.long	.LASF243
	.byte	0x5
	.uleb128 0x39
	.long	.LASF244
	.byte	0x5
	.uleb128 0x3a
	.long	.LASF245
	.byte	0x5
	.uleb128 0x3b
	.long	.LASF246
	.byte	0x5
	.uleb128 0x3c
	.long	.LASF247
	.byte	0x5
	.uleb128 0x3d
	.long	.LASF248
	.byte	0x5
	.uleb128 0x3e
	.long	.LASF249
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.slab.h.2.e2f5bf1bbed146f27a60b3aa1d730158,comdat
.Ldebug_macro4:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF251
	.byte	0x5
	.uleb128 0x5
	.long	.LASF252
	.byte	0x5
	.uleb128 0x6
	.long	.LASF253
	.byte	0x5
	.uleb128 0x7
	.long	.LASF254
	.byte	0x5
	.uleb128 0x9
	.long	.LASF255
	.byte	0x5
	.uleb128 0xa
	.long	.LASF256
	.byte	0x5
	.uleb128 0x12
	.long	.LASF257
	.byte	0x5
	.uleb128 0x1c
	.long	.LASF258
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.ku_utils.h.2.5922a71b1df9dd5ef65a03e03d1ab8b0,comdat
.Ldebug_macro5:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF261
	.byte	0x5
	.uleb128 0x4
	.long	.LASF262
	.byte	0x5
	.uleb128 0x5
	.long	.LASF263
	.byte	0x5
	.uleb128 0x8
	.long	.LASF264
	.byte	0x5
	.uleb128 0x1f
	.long	.LASF265
	.byte	0x5
	.uleb128 0x2c
	.long	.LASF266
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.mylist.h.2.6dffd1aa01612dc930709a466e043124,comdat
.Ldebug_macro6:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF267
	.byte	0x5
	.uleb128 0x12
	.long	.LASF268
	.byte	0x5
	.uleb128 0x1b
	.long	.LASF269
	.byte	0x5
	.uleb128 0x2c
	.long	.LASF270
	.byte	0x5
	.uleb128 0x58
	.long	.LASF271
	.byte	0x5
	.uleb128 0x68
	.long	.LASF272
	.byte	0x5
	.uleb128 0x76
	.long	.LASF273
	.byte	0x5
	.uleb128 0x7f
	.long	.LASF274
	.byte	0x5
	.uleb128 0x94
	.long	.LASF275
	.byte	0x5
	.uleb128 0xaf
	.long	.LASF276
	.byte	0x5
	.uleb128 0xc8
	.long	.LASF277
	.byte	0x5
	.uleb128 0xd1
	.long	.LASF278
	.byte	0x5
	.uleb128 0xdb
	.long	.LASF279
	.byte	0x5
	.uleb128 0xe5
	.long	.LASF280
	.byte	0x5
	.uleb128 0xf2
	.long	.LASF281
	.byte	0x5
	.uleb128 0xfb
	.long	.LASF282
	.byte	0x5
	.uleb128 0x103
	.long	.LASF283
	.byte	0x5
	.uleb128 0x112
	.long	.LASF284
	.byte	0x5
	.uleb128 0x125
	.long	.LASF285
	.byte	0x5
	.uleb128 0x12d
	.long	.LASF286
	.byte	0x5
	.uleb128 0x144
	.long	.LASF287
	.byte	0x5
	.uleb128 0x155
	.long	.LASF288
	.byte	0x5
	.uleb128 0x163
	.long	.LASF289
	.byte	0x5
	.uleb128 0x16c
	.long	.LASF290
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.generic.h.2.080a533b5efade0c3c025e01b2a9592c,comdat
.Ldebug_macro7:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF291
	.byte	0x5
	.uleb128 0x13
	.long	.LASF292
	.byte	0x5
	.uleb128 0x14
	.long	.LASF293
	.byte	0x5
	.uleb128 0x16
	.long	.LASF294
	.byte	0x5
	.uleb128 0x17
	.long	.LASF295
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.page.h.2.207eb50c0e81a8bc7de8e22e9a0f0426,comdat
.Ldebug_macro8:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF300
	.byte	0x5
	.uleb128 0x5
	.long	.LASF301
	.byte	0x5
	.uleb128 0x6
	.long	.LASF302
	.byte	0x5
	.uleb128 0x7
	.long	.LASF303
	.byte	0x5
	.uleb128 0x8
	.long	.LASF304
	.byte	0x5
	.uleb128 0x9
	.long	.LASF305
	.byte	0x5
	.uleb128 0xb
	.long	.LASF306
	.byte	0x5
	.uleb128 0xc
	.long	.LASF307
	.byte	0x5
	.uleb128 0xd
	.long	.LASF308
	.byte	0x5
	.uleb128 0xf
	.long	.LASF309
	.byte	0x5
	.uleb128 0x10
	.long	.LASF310
	.byte	0x5
	.uleb128 0x16
	.long	.LASF311
	.byte	0x5
	.uleb128 0x1c
	.long	.LASF312
	.byte	0x5
	.uleb128 0x1d
	.long	.LASF313
	.byte	0x5
	.uleb128 0x20
	.long	.LASF314
	.byte	0x5
	.uleb128 0x21
	.long	.LASF315
	.byte	0x5
	.uleb128 0x64
	.long	.LASF316
	.byte	0x5
	.uleb128 0x65
	.long	.LASF317
	.byte	0x5
	.uleb128 0x66
	.long	.LASF318
	.byte	0x5
	.uleb128 0x6f
	.long	.LASF319
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.mmzone.h.7.e3c9150cc58cba9f45f09d3f9a9fdf77,comdat
.Ldebug_macro9:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x7
	.long	.LASF320
	.byte	0x5
	.uleb128 0x18
	.long	.LASF321
	.byte	0x5
	.uleb128 0x19
	.long	.LASF322
	.byte	0x5
	.uleb128 0x1a
	.long	.LASF323
	.byte	0x5
	.uleb128 0x1b
	.long	.LASF324
	.byte	0x5
	.uleb128 0x1c
	.long	.LASF325
	.byte	0x5
	.uleb128 0x1d
	.long	.LASF326
	.byte	0x5
	.uleb128 0x20
	.long	.LASF327
	.byte	0x5
	.uleb128 0x22
	.long	.LASF328
	.byte	0x5
	.uleb128 0x23
	.long	.LASF329
	.byte	0x5
	.uleb128 0x24
	.long	.LASF330
	.byte	0x5
	.uleb128 0x25
	.long	.LASF331
	.byte	0x5
	.uleb128 0x26
	.long	.LASF332
	.byte	0x5
	.uleb128 0x28
	.long	.LASF333
	.byte	0x5
	.uleb128 0x29
	.long	.LASF334
	.byte	0x5
	.uleb128 0x2a
	.long	.LASF335
	.byte	0x5
	.uleb128 0x2b
	.long	.LASF336
	.byte	0x5
	.uleb128 0x2d
	.long	.LASF337
	.byte	0x5
	.uleb128 0x2e
	.long	.LASF338
	.byte	0x5
	.uleb128 0x2f
	.long	.LASF339
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.pmm.h.2.0ed63dcb6cf5b539e5b580d439a8fe22,comdat
.Ldebug_macro10:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF340
	.byte	0x5
	.uleb128 0x8
	.long	.LASF341
	.byte	0x5
	.uleb128 0x9
	.long	.LASF342
	.byte	0x5
	.uleb128 0xf
	.long	.LASF343
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.sched.h.2.5f20ed4187e2b315e38086c6f42d15cd,comdat
.Ldebug_macro11:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF344
	.byte	0x5
	.uleb128 0xa
	.long	.LASF345
	.byte	0x5
	.uleb128 0xb
	.long	.LASF346
	.byte	0x5
	.uleb128 0xc
	.long	.LASF347
	.byte	0x5
	.uleb128 0xd
	.long	.LASF348
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.utils.h.64.4303da2b831b2923c55728136f07b37e,comdat
.Ldebug_macro12:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x40
	.long	.LASF350
	.byte	0x5
	.uleb128 0x41
	.long	.LASF351
	.byte	0x5
	.uleb128 0x7a
	.long	.LASF352
	.byte	0x5
	.uleb128 0x7f
	.long	.LASF353
	.byte	0x5
	.uleb128 0x80
	.long	.LASF354
	.byte	0x5
	.uleb128 0x81
	.long	.LASF355
	.byte	0x5
	.uleb128 0x82
	.long	.LASF356
	.byte	0x5
	.uleb128 0x96
	.long	.LASF357
	.byte	0x5
	.uleb128 0xe6
	.long	.LASF358
	.byte	0x5
	.uleb128 0xf0
	.long	.LASF359
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.ku_proc.h.3.dde670f70c5d84b57ae6d3e9345b9deb,comdat
.Ldebug_macro13:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x3
	.long	.LASF360
	.byte	0x5
	.uleb128 0x5
	.long	.LASF361
	.byte	0x5
	.uleb128 0x6
	.long	.LASF362
	.byte	0x5
	.uleb128 0x7
	.long	.LASF363
	.byte	0x5
	.uleb128 0x8
	.long	.LASF364
	.byte	0x5
	.uleb128 0x9
	.long	.LASF365
	.byte	0x5
	.uleb128 0xa
	.long	.LASF366
	.byte	0x5
	.uleb128 0xb
	.long	.LASF367
	.byte	0x5
	.uleb128 0xc
	.long	.LASF368
	.byte	0x5
	.uleb128 0xd
	.long	.LASF369
	.byte	0x5
	.uleb128 0xe
	.long	.LASF370
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.proc.h.9.787373a02089489eee7b84d8741fae40,comdat
.Ldebug_macro14:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x9
	.long	.LASF372
	.byte	0x5
	.uleb128 0xc
	.long	.LASF373
	.byte	0x5
	.uleb128 0x16
	.long	.LASF374
	.byte	0x5
	.uleb128 0x2b
	.long	.LASF375
	.byte	0x5
	.uleb128 0x49
	.long	.LASF376
	.byte	0x5
	.uleb128 0x4e
	.long	.LASF377
	.byte	0x5
	.uleb128 0x4f
	.long	.LASF378
	.byte	0x5
	.uleb128 0x6d
	.long	.LASF379
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.proc.h.141.8c77b34ef2b417fda52f0c261904a280,comdat
.Ldebug_macro15:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x8d
	.long	.LASF380
	.byte	0x5
	.uleb128 0xa1
	.long	.LASF381
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.fs.h.11.a65a17799966213b91b406978697ab7b,comdat
.Ldebug_macro16:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0xb
	.long	.LASF382
	.byte	0x5
	.uleb128 0xd
	.long	.LASF383
	.byte	0x5
	.uleb128 0xf
	.long	.LASF384
	.byte	0x5
	.uleb128 0x2c
	.long	.LASF385
	.byte	0x5
	.uleb128 0x46
	.long	.LASF386
	.byte	0x5
	.uleb128 0x7a
	.long	.LASF387
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.errnobase.h.2.98fa30cf7638fb03f889e2c995f78b42,comdat
.Ldebug_macro17:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF391
	.byte	0x5
	.uleb128 0x4
	.long	.LASF392
	.byte	0x5
	.uleb128 0x5
	.long	.LASF393
	.byte	0x5
	.uleb128 0x6
	.long	.LASF394
	.byte	0x5
	.uleb128 0x7
	.long	.LASF395
	.byte	0x5
	.uleb128 0x8
	.long	.LASF396
	.byte	0x5
	.uleb128 0x9
	.long	.LASF397
	.byte	0x5
	.uleb128 0xa
	.long	.LASF398
	.byte	0x5
	.uleb128 0xb
	.long	.LASF399
	.byte	0x5
	.uleb128 0xc
	.long	.LASF400
	.byte	0x5
	.uleb128 0xd
	.long	.LASF401
	.byte	0x5
	.uleb128 0xe
	.long	.LASF402
	.byte	0x5
	.uleb128 0xf
	.long	.LASF403
	.byte	0x5
	.uleb128 0x10
	.long	.LASF404
	.byte	0x5
	.uleb128 0x11
	.long	.LASF405
	.byte	0x5
	.uleb128 0x12
	.long	.LASF406
	.byte	0x5
	.uleb128 0x13
	.long	.LASF407
	.byte	0x5
	.uleb128 0x14
	.long	.LASF408
	.byte	0x5
	.uleb128 0x15
	.long	.LASF409
	.byte	0x5
	.uleb128 0x16
	.long	.LASF410
	.byte	0x5
	.uleb128 0x17
	.long	.LASF411
	.byte	0x5
	.uleb128 0x18
	.long	.LASF412
	.byte	0x5
	.uleb128 0x19
	.long	.LASF413
	.byte	0x5
	.uleb128 0x1a
	.long	.LASF414
	.byte	0x5
	.uleb128 0x1b
	.long	.LASF415
	.byte	0x5
	.uleb128 0x1c
	.long	.LASF416
	.byte	0x5
	.uleb128 0x1d
	.long	.LASF417
	.byte	0x5
	.uleb128 0x1e
	.long	.LASF418
	.byte	0x5
	.uleb128 0x1f
	.long	.LASF419
	.byte	0x5
	.uleb128 0x20
	.long	.LASF420
	.byte	0x5
	.uleb128 0x21
	.long	.LASF421
	.byte	0x5
	.uleb128 0x22
	.long	.LASF422
	.byte	0x5
	.uleb128 0x23
	.long	.LASF423
	.byte	0x5
	.uleb128 0x24
	.long	.LASF424
	.byte	0x5
	.uleb128 0x25
	.long	.LASF425
	.byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF77:
	.string	"__PTRDIFF_MAX__ 2147483647"
.LASF594:
	.string	"size_of_zone"
.LASF179:
	.string	"__DEC64_SUBNORMAL_MIN__ 0.000000000000001E-383DD"
.LASF571:
	.string	"fget"
.LASF144:
	.string	"__DBL_DECIMAL_DIG__ 17"
.LASF121:
	.string	"__FLT_EVAL_METHOD__ 2"
.LASF568:
	.string	"super_operations"
.LASF132:
	.string	"__FLT_MIN__ 1.17549435082228750797e-38F"
.LASF481:
	.string	"cow_shared"
.LASF486:
	.string	"debug"
.LASF205:
	.string	"__GCC_ATOMIC_TEST_AND_SET_TRUEVAL 1"
.LASF508:
	.string	"empty_pte"
.LASF534:
	.string	"fs_struct"
.LASF366:
	.string	"MSGTYPE_HS_READY 4"
.LASF93:
	.string	"__INT_LEAST8_MAX__ 127"
.LASF271:
	.ascii	"LL_INSERT(list,location,new) do{ assert( ( (list) == (locati"
	.ascii	"on) ) || ( (list) &"
	.string	"& (location) ) ); assert((new)); if(!list && !location) { list = new; new->next = new->prev = 0; break; } new->next=location; new->prev=location->prev; if(location->prev) location->prev->next=new; location->prev=new; if(list==location) list=new; } while(0)"
.LASF85:
	.string	"__INT8_MAX__ 127"
.LASF457:
	.string	"mktime"
.LASF102:
	.string	"__UINT8_C(c) c"
.LASF383:
	.string	"FMODE_WRITE 2"
.LASF511:
	.string	"readable"
.LASF71:
	.string	"__LONG_MAX__ 2147483647L"
.LASF535:
	.string	"rootmnt"
.LASF390:
	.string	"ERRNO_H "
.LASF502:
	.string	"end_code"
.LASF350:
	.string	"return_say(msg) do{oprintf(\"%s\",msg);return;} while(0)"
.LASF140:
	.string	"__DBL_MIN_EXP__ (-1021)"
.LASF99:
	.string	"__INT_LEAST64_MAX__ 9223372036854775807LL"
.LASF391:
	.string	"ERRNO_BASE_H "
.LASF257:
	.string	"kmem_cache_create register_slab_type"
.LASF467:
	.string	"flags"
.LASF321:
	.string	"page_idx(page_t) ((unsigned)((page_t) - mem_map))"
.LASF210:
	.string	"__SIZEOF_WINT_T__ 4"
.LASF422:
	.string	"EMLINK 31"
.LASF576:
	.string	"sys_close"
.LASF211:
	.string	"__SIZEOF_PTRDIFF_T__ 4"
.LASF331:
	.string	"__GFP_HIGHMEM (1<<2)"
.LASF285:
	.string	"O_INSERT_AFTER(_prev,new) ({ new->next = _prev->next; new->prev = _prev; _prev->next->prev = new; _prev->next = new; })"
.LASF469:
	.string	"protection"
.LASF162:
	.string	"__LDBL_DENORM_MIN__ 3.64519953188247460253e-4951L"
.LASF292:
	.string	"ntohs(x) htons(x)"
.LASF329:
	.string	"__GFP_ZERO (1<<0)"
.LASF433:
	.string	"unsigned int"
.LASF427:
	.string	"next"
.LASF313:
	.string	"__pa2page_t(paddr) (mem_map + ((paddr) >> 12))"
.LASF575:
	.string	"sys_lseek"
.LASF21:
	.string	"__SIZEOF_SIZE_T__ 4"
.LASF36:
	.string	"__CHAR16_TYPE__ short unsigned int"
.LASF397:
	.string	"ENXIO 6"
.LASF25:
	.string	"__ORDER_BIG_ENDIAN__ 4321"
.LASF536:
	.string	"pwdmnt"
.LASF505:
	.string	"start_brk"
.LASF252:
	.string	"SLAB_HWCACHE_ALIGN 1"
.LASF548:
	.string	"need_resched"
.LASF138:
	.string	"__DBL_MANT_DIG__ 53"
.LASF137:
	.string	"__FLT_HAS_QUIET_NAN__ 1"
.LASF372:
	.string	"P_NAME_MAX 16"
.LASF10:
	.string	"__ATOMIC_RELEASE 3"
.LASF322:
	.string	"pte_pfn(pte) ((pte)>>PAGE_SHIFT)"
.LASF31:
	.string	"__PTRDIFF_TYPE__ int"
.LASF472:
	.string	"dirty_rsv"
.LASF537:
	.string	"files_struct"
.LASF40:
	.string	"__INT16_TYPE__ short int"
.LASF171:
	.string	"__DEC32_EPSILON__ 1E-6DF"
.LASF365:
	.string	"MSGTYPE_HD_DONE 3"
.LASF319:
	.string	"KV __va"
.LASF318:
	.string	"__va(paddr) ((unsigned)(paddr) + PAGE_OFFSET)"
.LASF153:
	.string	"__LDBL_DIG__ 18"
.LASF506:
	.string	"vm_area"
.LASF8:
	.string	"__ATOMIC_SEQ_CST 5"
.LASF403:
	.string	"ENOMEM 12"
.LASF538:
	.string	"max_fds"
.LASF17:
	.string	"__SIZEOF_SHORT__ 2"
.LASF514:
	.string	"mayread"
.LASF47:
	.string	"__INT_LEAST8_TYPE__ signed char"
.LASF596:
	.string	"__ext_pcb"
.LASF234:
	.ascii	"LIST_FIND2(stru"
	.string	"_t,mb_t,root,key,value,result) do{ struct list_head * node = root->next; stru_t *obj; while(node != root){ *obj = MB2STRU(stru_t, node, mb_t); if( (obj)->key == value ) break; node = node->next; } if(node == root) result = 0; else result = obj; } while(0);"
.LASF82:
	.string	"__UINTMAX_C(c) c ## ULL"
.LASF494:
	.string	"zone_struct"
.LASF597:
	.string	"inode_hashtable"
.LASF27:
	.string	"__BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__"
.LASF101:
	.string	"__UINT_LEAST8_MAX__ 255"
.LASF527:
	.string	"mode"
.LASF273:
	.string	"LL_I2(root,new) do{ assert(root); if(root->next) root->next->prev = new; new->next = root->next; new->prev = root; root->next = new; }while(0)"
.LASF426:
	.string	"prev"
.LASF74:
	.string	"__WCHAR_MIN__ (-__WCHAR_MAX__ - 1)"
.LASF517:
	.string	"mayshare"
.LASF131:
	.string	"__FLT_MAX__ 3.40282346638528859812e+38F"
.LASF186:
	.string	"__DEC128_SUBNORMAL_MIN__ 0.000000000000000000000000000000001E-6143DL"
.LASF264:
	.ascii	"eat_hex(pt,x) char*__pt=(pt); x=0; if(*__pt!='0'||*(__pt+1)!"
	.ascii	"='x'){ x=-1; goto donothing; } __pt+=2; if(!((*__pt>='0'&&*_"
	.ascii	"_pt<='9'"
	.string	")||(*__pt>='a'&&*__pt<='f'))){ x=-1; goto donothing; } while((*__pt>='0'&&*__pt<='9')||(*__pt>='a'&&*__pt<='f')) __pt++; __pt--; int __len=__pt-pt+1-2; for(int __i=0;__i<__len;__i++){ x+=hex_int(*__pt)*pow_int(16,__i); __pt--; } (pt)+=(2+__len);donothing:;"
.LASF55:
	.string	"__INT_FAST8_TYPE__ signed char"
.LASF558:
	.string	"fstack"
.LASF561:
	.string	"regs"
.LASF332:
	.string	"__GFP_NORMAL (1<<3)"
.LASF209:
	.string	"__SIZEOF_WCHAR_T__ 4"
.LASF66:
	.string	"__has_include_next(STR) __has_include_next__(STR)"
.LASF510:
	.string	"pgoff"
.LASF314:
	.string	"pte2page(pte) ((void *)__va((pte).value & PAGE_MASK))"
.LASF416:
	.string	"ENOTTY 25"
.LASF601:
	.string	"../src/fs/read_write.c"
.LASF424:
	.string	"EDOM 33"
.LASF306:
	.string	"PG_P 1"
.LASF373:
	.string	"g_tss (&base_tss)"
.LASF227:
	.string	"__DECIMAL_BID_FORMAT__ 1"
.LASF361:
	.string	"MSGTYPE_TIMER 255"
.LASF386:
	.string	"I_HASHTABLE_LEN 4096"
.LASF92:
	.string	"__UINT64_MAX__ 18446744073709551615ULL"
.LASF58:
	.string	"__INT_FAST64_TYPE__ long long int"
.LASF346:
	.string	"CLONE_VM 0x100"
.LASF94:
	.string	"__INT8_C(c) c"
.LASF581:
	.string	"bytes_r"
.LASF299:
	.string	"MMZONE_H "
.LASF78:
	.string	"__SIZE_MAX__ 4294967295U"
.LASF445:
	.string	"operations"
.LASF216:
	.string	"__i686 1"
.LASF87:
	.string	"__INT32_MAX__ 2147483647"
.LASF325:
	.string	"page_va(page) __va( (page - mem_map) << PAGE_SHIFT)"
.LASF113:
	.string	"__UINT_FAST8_MAX__ 255"
.LASF64:
	.string	"__UINTPTR_TYPE__ unsigned int"
.LASF355:
	.string	"EXCHG_PTR(a,b) do { void *tmp = a; a = b; b = tmp; } while(0)"
.LASF270:
	.ascii	"LL2_DEL(ll2,node) do{ assert( (ll2) && (node) && (ll2)->root"
	.ascii	" && (ll2)->tail ); i"
	.string	"f( (node)->prev ){ (node)->prev->next = (node)->next; } else{ assert( (ll2)->root == node ); (ll2)->root = (node)->next; } if( (node)->next ){ (node)->next->prev = (node)->prev; } else{ assert( (ll2)->tail == node ); (ll2)->tail = (node)->prev; } }while(0)"
.LASF225:
	.string	"__unix__ 1"
.LASF192:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 1"
.LASF566:
	.string	"read"
.LASF377:
	.string	"PCB_SIZE 0x2000"
.LASF261:
	.string	"KU_UTILS_H "
.LASF385:
	.string	"INODE_COMMON_SIZE 128"
.LASF553:
	.string	"time_slice_full"
.LASF196:
	.string	"__GCC_ATOMIC_BOOL_LOCK_FREE 2"
.LASF260:
	.string	"UTILS_H "
.LASF425:
	.string	"ERANGE 34"
.LASF404:
	.string	"EACCES 13"
.LASF547:
	.string	"base"
.LASF443:
	.string	"count"
.LASF146:
	.string	"__DBL_MIN__ ((double)2.22507385850720138309e-308L)"
.LASF169:
	.string	"__DEC32_MIN__ 1E-95DF"
.LASF276:
	.ascii	"LL_I_DECRE(list,new,attr) do{ assert(new); if(!list){ list=n"
	.ascii	"ew; new->prev=new->next=0; break; } void*root=list; while(li"
	.ascii	"st->next && new->at"
	.string	"tr < list->attr) list=list->next; if(new->attr < list->attr){ new->next = 0; list->next=new; new->prev=list; list=root; } else{ new->next=list; new->prev=list->prev; if(list->prev) list->prev->next=new; list->prev=new; if(root==list) list=new; } } while(0)"
.LASF309:
	.string	"PG_H10(pg_id) (pg_id>>10)"
.LASF161:
	.string	"__LDBL_EPSILON__ 1.08420217248550443401e-19L"
.LASF323:
	.string	"pfn_page(pfn) (mem_map + (pfn))"
.LASF337:
	.string	"ZONE_DMA_PA 0"
.LASF170:
	.string	"__DEC32_MAX__ 9.999999E96DF"
.LASF338:
	.string	"ZONE_NORMAL_PA 0X1000000"
.LASF436:
	.string	"long long unsigned int"
.LASF419:
	.string	"ENOSPC 28"
.LASF181:
	.string	"__DEC128_MIN_EXP__ (-6142)"
.LASF509:
	.string	"file"
.LASF258:
	.string	"static_cursor_up "
.LASF349:
	.string	"PGDIR_OF_MM(mm) ( (union pte *)__va(mm->cr3.value & PAGE_MASK) )"
.LASF185:
	.string	"__DEC128_EPSILON__ 1E-33DL"
.LASF111:
	.string	"__INT_FAST32_MAX__ 2147483647"
.LASF352:
	.string	"DSI(str,i) dispStr(str,0x400);dispInt(i);"
.LASF269:
	.ascii	"LL2_A(ll2,node) do{ assert( (ll2) &&"
	.string	" (node) ); assert( ( (ll2)->root == 0 && (ll2)->tail == 0 ) || ( (ll2)->root != 0 && (ll2)->tail != 0) ); (node)->prev = (ll2)->tail; if( (ll2)->tail ){ (ll2)->tail->next = node; } else{ (ll2)->root = node; } (node)->next = 0; (ll2)->tail = node; }while(0)"
.LASF585:
	.string	"k_seek"
.LASF447:
	.string	"common"
.LASF123:
	.string	"__FLT_RADIX__ 2"
.LASF20:
	.string	"__SIZEOF_LONG_DOUBLE__ 12"
.LASF480:
	.string	"_count"
.LASF407:
	.string	"EBUSY 16"
.LASF151:
	.string	"__DBL_HAS_QUIET_NAN__ 1"
.LASF475:
	.string	"$on_read"
.LASF379:
	.string	"current (get_current())"
.LASF60:
	.string	"__UINT_FAST16_TYPE__ unsigned int"
.LASF212:
	.string	"__i386 1"
.LASF215:
	.string	"__ATOMIC_HLE_RELEASE 131072"
.LASF444:
	.string	"super_block"
.LASF156:
	.string	"__LDBL_MAX_EXP__ 16384"
.LASF281:
	.string	"LL_SCAN_ON_kEY_B(root,key,value) ({ typeof(root) curr = root; while(curr && curr->key <= (value) ) curr = curr->next; curr; })"
.LASF249:
	.string	"__3G 0xc0000000"
.LASF484:
	.string	"PG_private"
.LASF177:
	.string	"__DEC64_MAX__ 9.999999999999999E384DD"
.LASF134:
	.string	"__FLT_DENORM_MIN__ 1.40129846432481707092e-45F"
.LASF202:
	.string	"__GCC_ATOMIC_INT_LOCK_FREE 2"
.LASF477:
	.string	"$data"
.LASF354:
	.string	"EXCHG_U32(a,b) do{unsigned c=a;a=b;b=c;} while(0)"
.LASF560:
	.string	"__task_struct_end"
.LASF109:
	.string	"__INT_FAST8_MAX__ 127"
.LASF468:
	.string	"value"
.LASF159:
	.string	"__LDBL_MAX__ 1.18973149535723176502e+4932L"
.LASF367:
	.string	"MSGTYPE_HS_DONE 5"
.LASF315:
	.string	"pte2page_t(pte) ( mem_map + (pte).physical )"
.LASF470:
	.string	"on_write"
.LASF599:
	.string	"file_cache"
.LASF250:
	.string	"D_HASHTABLE_LEN 1024"
.LASF569:
	.string	"read_inode"
.LASF557:
	.string	"rlimits"
.LASF41:
	.string	"__INT32_TYPE__ int"
.LASF289:
	.string	"O_APPEND(root,new) ({ (new)->next = root; (new)->prev = root->prev; (root)->prev->next = new; (root)->prev = new; })"
.LASF545:
	.string	"stack_frame"
.LASF582:
	.string	"k_open"
.LASF519:
	.string	"growsup"
.LASF168:
	.string	"__DEC32_MAX_EXP__ 97"
.LASF3:
	.string	"__GNUC__ 4"
.LASF406:
	.string	"ENOTBLK 15"
.LASF384:
	.string	"FMODE_SEEK 4"
.LASF573:
	.string	"offset"
.LASF336:
	.string	"ZONE_MAX 3"
.LASF245:
	.string	"__8K 0x2000"
.LASF579:
	.string	"filesize"
.LASF145:
	.string	"__DBL_MAX__ ((double)1.79769313486231570815e+308L)"
.LASF464:
	.string	"accessed"
.LASF95:
	.string	"__INT_LEAST16_MAX__ 32767"
.LASF320:
	.string	"G_PGNUM (gmemsize>>12)"
.LASF240:
	.string	"true 1"
.LASF24:
	.string	"__ORDER_LITTLE_ENDIAN__ 1234"
.LASF54:
	.string	"__UINT_LEAST64_TYPE__ long long unsigned int"
.LASF339:
	.string	"ZONE_HIGHMEM_PA (896*0x100000)"
.LASF67:
	.string	"__GXX_ABI_VERSION 1002"
.LASF376:
	.string	"EFLAGS_STACK_LEN 7"
.LASF114:
	.string	"__UINT_FAST16_MAX__ 4294967295U"
.LASF360:
	.string	"KU_PROC_H "
.LASF574:
	.string	"origin"
.LASF478:
	.string	"pgerr_code"
.LASF417:
	.string	"ETXTBSY 26"
.LASF56:
	.string	"__INT_FAST16_TYPE__ int"
.LASF409:
	.string	"EXDEV 18"
.LASF311:
	.string	"FLUSH_TLB __asm__ __volatile__(\"mov %%cr3, %0\\n\\t\" \"mov %0, %%cr3\\n\\t\" : :\"r\"(0))"
.LASF213:
	.string	"__i386__ 1"
.LASF44:
	.string	"__UINT16_TYPE__ short unsigned int"
.LASF546:
	.string	"eflags_stack"
.LASF4:
	.string	"__GNUC_MINOR__ 9"
.LASF108:
	.string	"__UINT64_C(c) c ## ULL"
.LASF583:
	.string	"path"
.LASF53:
	.string	"__UINT_LEAST32_TYPE__ unsigned int"
.LASF42:
	.string	"__INT64_TYPE__ long long int"
.LASF129:
	.string	"__FLT_MAX_10_EXP__ 38"
.LASF164:
	.string	"__LDBL_HAS_INFINITY__ 1"
.LASF485:
	.string	"PG_zid"
.LASF523:
	.string	"vm_operations"
.LASF474:
	.string	"$nopage"
.LASF190:
	.string	"__NO_INLINE__ 1"
.LASF598:
	.string	"inode_cache"
.LASF124:
	.string	"__FLT_MANT_DIG__ 24"
.LASF254:
	.string	"SLAB_ZERO 4"
.LASF148:
	.string	"__DBL_DENORM_MIN__ ((double)4.94065645841246544177e-324L)"
.LASF341:
	.string	"HEAP_BASE 18*0x100000"
.LASF187:
	.string	"__REGISTER_PREFIX__ "
.LASF551:
	.string	"prio"
.LASF238:
	.string	"bool _Bool"
.LASF295:
	.string	"BYTE_ENDIAN_FLIP4(x) x = htonl(x)"
.LASF570:
	.string	"fcheck"
.LASF347:
	.string	"CLONE_FS 0x200"
.LASF122:
	.string	"__DEC_EVAL_METHOD__ 2"
.LASF540:
	.string	"origin_filep"
.LASF141:
	.string	"__DBL_MIN_10_EXP__ (-307)"
.LASF584:
	.string	"k_read"
.LASF63:
	.string	"__INTPTR_TYPE__ int"
.LASF266:
	.string	"eat_dec_with_len(pt,x,x_len) char*__pt=(pt); while(*(__pt+1)>='0'&&*(__pt+1)<='9') __pt++; len=__pt-(pt)+1; for(int __i=0;__i<x_len;__i++){ x+=(*__pt-48)*pow_int(10,__i); __pt--; } (pt)+=x_len;"
.LASF155:
	.string	"__LDBL_MIN_10_EXP__ (-4931)"
.LASF235:
	.string	"MB2STRU(stru_type,mb_addr,mb_name) (stru_type *)( (u32)(mb_addr)- (u32)&((stru_type *)0)->mb_name )"
.LASF400:
	.string	"EBADF 9"
.LASF423:
	.string	"EPIPE 32"
.LASF564:
	.string	"file_operations"
.LASF279:
	.string	"LL_ASSIGN(list,attr,value) do{ void *root = list; while(list){ list->attr=value; list=list->next; } list = root; } while(0)"
.LASF451:
	.string	"hash"
.LASF521:
	.string	"dontcopy"
.LASF516:
	.string	"mayexec"
.LASF411:
	.string	"ENOTDIR 20"
.LASF237:
	.string	"VALTYPE_H "
.LASF525:
	.string	"close"
.LASF328:
	.string	"__GFP_DEFAULT 0"
.LASF243:
	.string	"NULL 0"
.LASF471:
	.string	"from_user"
.LASF528:
	.string	"data"
.LASF204:
	.string	"__GCC_ATOMIC_LLONG_LOCK_FREE 2"
.LASF370:
	.string	"MSGTYPE_FS_DONE 7"
.LASF91:
	.string	"__UINT32_MAX__ 4294967295U"
.LASF358:
	.string	"MAKE_IP(a,b,c,d) (((a)<<24) + ((b)<<16) + ((c)<<8) + d)"
.LASF232:
	.string	"assert(exp) do{ if(!(exp)) assert_func(#exp,__FILE__,__BASE_FILE__,__LINE__); } while(0)"
.LASF415:
	.string	"EMFILE 24"
.LASF565:
	.string	"lseek"
.LASF388:
	.string	"LINUX_ERRNO_H "
.LASF304:
	.string	"pa_idx(paddr) ((paddr)>>PAGE_SHIFT)"
.LASF543:
	.string	"err_code"
.LASF461:
	.string	"present"
.LASF434:
	.string	"signed char"
.LASF378:
	.string	"THREAD_SIZE 0x2000"
.LASF48:
	.string	"__INT_LEAST16_TYPE__ short int"
.LASF107:
	.string	"__UINT_LEAST64_MAX__ 18446744073709551615ULL"
.LASF580:
	.string	"sys_read"
.LASF476:
	.string	"$in_kernel"
.LASF369:
	.string	"MSGTYPE_USR_ASK 6"
.LASF586:
	.string	"dentry_hashtable"
.LASF198:
	.string	"__GCC_ATOMIC_CHAR16_T_LOCK_FREE 2"
.LASF490:
	.string	"nr_free"
.LASF488:
	.string	"free_area_struct"
.LASF203:
	.string	"__GCC_ATOMIC_LONG_LOCK_FREE 2"
.LASF513:
	.string	"shared"
.LASF103:
	.string	"__UINT_LEAST16_MAX__ 65535"
.LASF282:
	.string	"LL_SCAN_ON_KEY_S(root,key,value) ({ typeof(root) curr = root; while(curr && curr->key >= (value) ) curr = curr->next; curr; })"
.LASF312:
	.string	"__va2page_t(vaddr) (mem_map + (((vaddr) - PAGE_OFFSET) >> 12))"
.LASF340:
	.string	"PMM_H "
.LASF567:
	.string	"onclose"
.LASF371:
	.string	"RESOURCE_H "
.LASF86:
	.string	"__INT16_MAX__ 32767"
.LASF429:
	.string	"long long int"
.LASF22:
	.string	"__CHAR_BIT__ 8"
.LASF51:
	.string	"__UINT_LEAST8_TYPE__ unsigned char"
.LASF13:
	.string	"__FINITE_MATH_ONLY__ 0"
.LASF518:
	.string	"growsdown"
.LASF449:
	.string	"inode"
.LASF362:
	.string	"MSGTYPE_DEEP 0"
.LASF288:
	.string	"O_SCAN_UNTIL_MEET_LARGER(root,mb,value) ({ assert( (root) ); __typeof__(root) node = root; do{ if( (node)->mb > value) break; node = node->next; if(node != root) continue; node = 0; break; }while(1); node; })"
.LASF396:
	.string	"EIO 5"
.LASF316:
	.string	"PAGE_OFFSET 0XC0000000"
.LASF69:
	.string	"__SHRT_MAX__ 32767"
.LASF324:
	.string	"pte_page(pte) ( pfn_page( pte_pfn(pte) ) )"
.LASF307:
	.string	"PG_USU 4"
.LASF294:
	.string	"BYTE_ENDIAN_FLIP2(x) x = htons(x)"
.LASF226:
	.string	"__ELF__ 1"
.LASF297:
	.string	"MM_H "
.LASF96:
	.string	"__INT16_C(c) c"
.LASF207:
	.string	"__GCC_HAVE_DWARF2_CFI_ASM 1"
.LASF277:
	.ascii	"LL_DEL(list,location) d"
	.string	"o{ assert(list&&location); assert(!(!location->next && !location->prev && (list!=location))); if(location->prev) location->prev->next=location->next; if(location->next) location->next->prev=location->prev; if(list==location) list=location->next; } while(0)"
.LASF18:
	.string	"__SIZEOF_FLOAT__ 4"
.LASF172:
	.string	"__DEC32_SUBNORMAL_MIN__ 0.000001E-95DF"
.LASF351:
	.string	"returnx_say(x,msg) do{oprintf(\"%s\",msg);return x;} while(0)"
.LASF178:
	.string	"__DEC64_EPSILON__ 1E-15DD"
.LASF136:
	.string	"__FLT_HAS_INFINITY__ 1"
.LASF49:
	.string	"__INT_LEAST32_TYPE__ int"
.LASF460:
	.string	"file_ops"
.LASF413:
	.string	"EINVAL 22"
.LASF293:
	.string	"ntohl(x) htonl(x)"
.LASF420:
	.string	"ESPIPE 29"
.LASF498:
	.string	"spanned_pages"
.LASF0:
	.string	"__STDC__ 1"
.LASF15:
	.string	"__SIZEOF_LONG__ 4"
.LASF287:
	.string	"O_INSERT_INCRE_ON(root,new,mb) ({ assert(root && new); __typeof__(root) leftone = root->prev; while(new->mb > leftone->mb){ leftone = leftone->prev; if(leftone == root->prev){ root = new; break; } } O_INSERT_AFTER(leftone, new); })"
.LASF501:
	.string	"start_code"
.LASF458:
	.string	"chgtime"
.LASF12:
	.string	"__ATOMIC_CONSUME 1"
.LASF497:
	.string	"zone_mem_map"
.LASF290:
	.string	"O_APPEND_SAFE(root,new) ({ if(!root){ root = new; new->prev = new->next = new; } else O_APPEND(root, new); })"
.LASF33:
	.string	"__WINT_TYPE__ unsigned int"
.LASF117:
	.string	"__INTPTR_MAX__ 2147483647"
.LASF459:
	.string	"size"
.LASF106:
	.string	"__UINT32_C(c) c ## U"
.LASF455:
	.string	"compare"
.LASF45:
	.string	"__UINT32_TYPE__ unsigned int"
.LASF19:
	.string	"__SIZEOF_DOUBLE__ 8"
.LASF333:
	.string	"ZONE_DMA 0"
.LASF492:
	.string	"allocs"
.LASF5:
	.string	"__GNUC_PATCHLEVEL__ 2"
.LASF393:
	.string	"ENOENT 2"
.LASF76:
	.string	"__WINT_MIN__ 0U"
.LASF368:
	.string	"MSGTYPE_FS_READY 8"
.LASF152:
	.string	"__LDBL_MANT_DIG__ 64"
.LASF438:
	.string	"vfsmount"
.LASF591:
	.string	"zone_normal"
.LASF356:
	.string	"EXCHG_U16(a,b) do{ u16 tmp = a; a = b; b = tmp; } while(0)"
.LASF286:
	.string	"O_INSERT_BEFORE(Next,new) ({ new->next = Next; new->prev = Next->prev; Next->prev->next = new; Next->prev = new; })"
.LASF482:
	.string	"private"
.LASF233:
	.string	"INIT_LIST_HEAD(l) do{ (l)->prev = (l)->next = l; } while(0)"
.LASF526:
	.string	"nopage"
.LASF392:
	.string	"EPERM 1"
.LASF530:
	.string	"RLIMIT_FSIZE"
.LASF62:
	.string	"__UINT_FAST64_TYPE__ long long unsigned int"
.LASF120:
	.string	"__GCC_IEC_559_COMPLEX 2"
.LASF345:
	.string	"CSIGNAL 0xff"
.LASF72:
	.string	"__LONG_LONG_MAX__ 9223372036854775807LL"
.LASF487:
	.string	"padden"
.LASF344:
	.string	"LINUX_SCHED_H "
.LASF28:
	.string	"__FLOAT_WORD_ORDER__ __ORDER_LITTLE_ENDIAN__"
.LASF193:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 1"
.LASF399:
	.string	"ENOEXEC 8"
.LASF166:
	.string	"__DEC32_MANT_DIG__ 7"
.LASF394:
	.string	"ESRCH 3"
.LASF174:
	.string	"__DEC64_MIN_EXP__ (-382)"
.LASF84:
	.string	"__SIG_ATOMIC_MIN__ (-__SIG_ATOMIC_MAX__ - 1)"
.LASF125:
	.string	"__FLT_DIG__ 6"
.LASF503:
	.string	"start_data"
.LASF73:
	.string	"__WCHAR_MAX__ 2147483647L"
.LASF9:
	.string	"__ATOMIC_ACQUIRE 2"
.LASF104:
	.string	"__UINT16_C(c) c"
.LASF242:
	.string	"__DEBUG "
.LASF308:
	.string	"PG_RWW 2"
.LASF274:
	.string	"LL_REPLACE(root,old,new) do{ new->prev = old->prev; new->next = old->next; if(new->prev) new->prev->next = new; if(new->next) new->next->prev = new; if(root == old) root = new; }while(0)"
.LASF465:
	.string	"dirty"
.LASF550:
	.string	"p_name"
.LASF302:
	.string	"PAGE_SIZE 0x1000"
.LASF466:
	.string	"physical"
.LASF578:
	.string	"do_read"
.LASF500:
	.string	"zone_t"
.LASF218:
	.string	"__pentiumpro 1"
.LASF35:
	.string	"__UINTMAX_TYPE__ long long unsigned int"
.LASF456:
	.string	"rdev"
.LASF244:
	.string	"__4K 0x1000"
.LASF208:
	.string	"__PRAGMA_REDEFINE_EXTNAME 1"
.LASF251:
	.string	"SLAB_H "
.LASF89:
	.string	"__UINT8_MAX__ 255"
.LASF348:
	.string	"CLONE_FD 0x400"
.LASF200:
	.string	"__GCC_ATOMIC_WCHAR_T_LOCK_FREE 2"
.LASF26:
	.string	"__ORDER_PDP_ENDIAN__ 3412"
.LASF395:
	.string	"EINTR 4"
.LASF75:
	.string	"__WINT_MAX__ 4294967295U"
.LASF453:
	.string	"char"
.LASF130:
	.string	"__FLT_DECIMAL_DIG__ 9"
.LASF220:
	.string	"__code_model_32__ 1"
.LASF532:
	.string	"RLIMIT_MAX"
.LASF533:
	.string	"rlimit"
.LASF398:
	.string	"E2BIG 7"
.LASF154:
	.string	"__LDBL_MIN_EXP__ (-16381)"
.LASF412:
	.string	"EISDIR 21"
.LASF489:
	.string	"free_list"
.LASF68:
	.string	"__SCHAR_MAX__ 127"
.LASF441:
	.string	"parent"
.LASF115:
	.string	"__UINT_FAST32_MAX__ 4294967295U"
.LASF529:
	.string	"RLIMIT_CPU"
.LASF435:
	.string	"short int"
.LASF473:
	.string	"instruction"
.LASF175:
	.string	"__DEC64_MAX_EXP__ 385"
.LASF194:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 1"
.LASF247:
	.string	"__4M 0x400000"
.LASF520:
	.string	"denywrite"
.LASF418:
	.string	"EFBIG 27"
.LASF61:
	.string	"__UINT_FAST32_TYPE__ unsigned int"
.LASF310:
	.string	"PG_L10(pg_id) (pg_id&(0x400-1))"
.LASF380:
	.string	"SET_PID_EAX(pid,return_val) pcb_table[pid].regs.eax=return_val"
.LASF255:
	.string	"L1_CACHLINE_SIZE 32"
.LASF300:
	.string	"X86_PAGE_H "
.LASF37:
	.string	"__CHAR32_TYPE__ unsigned int"
.LASF572:
	.string	"do_lseek"
.LASF183:
	.string	"__DEC128_MIN__ 1E-6143DL"
.LASF182:
	.string	"__DEC128_MAX_EXP__ 6145"
.LASF479:
	.string	"page"
.LASF305:
	.string	"pa_pg pa_idx"
.LASF284:
	.ascii	"LL_I_"
	.string	"INCRE_ON(root,new,mb) ({ new->prev = 0; new->next = root; while(new->next && new->next->mb < new->mb){ new->prev = new->next; new->next = new->next->next; } if(new->next) new->next->prev = new; if(new->prev) new->prev->next = new; else root = new->next; })"
.LASF301:
	.string	"PAGE_SHIFT 12"
.LASF59:
	.string	"__UINT_FAST8_TYPE__ unsigned char"
.LASF98:
	.string	"__INT32_C(c) c"
.LASF165:
	.string	"__LDBL_HAS_QUIET_NAN__ 1"
.LASF39:
	.string	"__INT8_TYPE__ signed char"
.LASF221:
	.string	"__gnu_linux__ 1"
.LASF522:
	.string	"vm_flags"
.LASF544:
	.string	"eflags"
.LASF222:
	.string	"__linux 1"
.LASF549:
	.string	"sigpending"
.LASF256:
	.string	"BYTES_PER_WORD 4"
.LASF539:
	.string	"filep"
.LASF381:
	.string	"__fstack (current->fstack)"
.LASF556:
	.string	"files"
.LASF431:
	.string	"ulong"
.LASF364:
	.string	"MSGTYPE_FS_ASK 2"
.LASF88:
	.string	"__INT64_MAX__ 9223372036854775807LL"
.LASF100:
	.string	"__INT64_C(c) c ## LL"
.LASF283:
	.string	"LL_CHECK(root,node) do{ void *backup = root; while(root){ if(root == node) break; root = root->next; } assert(root && \"can not find node in that list\"); root = backup; }while(0)"
.LASF278:
	.string	"LL_INFO(list,attr) do{ void*root=list; while(list){ printf(\"%d \",list->attr); list=list->next; } list=root; } while(0)"
.LASF97:
	.string	"__INT_LEAST32_MAX__ 2147483647"
.LASF16:
	.string	"__SIZEOF_LONG_LONG__ 8"
.LASF43:
	.string	"__UINT8_TYPE__ unsigned char"
.LASF334:
	.string	"ZONE_NORMAL 1"
.LASF600:
	.string	"GNU C 4.9.2 -mtune=generic -march=i686 -g3 -std=c99 -fno-builtin -fno-stack-protector"
.LASF483:
	.string	"PG_highmem"
.LASF236:
	.string	"MOUNT_H "
.LASF524:
	.string	"open"
.LASF50:
	.string	"__INT_LEAST64_TYPE__ long long int"
.LASF504:
	.string	"end_data"
.LASF439:
	.string	"small_root"
.LASF374:
	.string	"size_buffer 16"
.LASF450:
	.string	"name"
.LASF507:
	.string	"start"
.LASF29:
	.string	"__SIZEOF_POINTER__ 4"
.LASF248:
	.string	"__1G 0x40000000"
.LASF359:
	.string	"ARR_CELLS(array,stru_t) ( sizeof(array) / sizeof(stru_t))"
.LASF268:
	.string	"LL2_POP(ll2) do{ assert( (ll2 && (ll2)->root && (ll2)->tail)); ll2->root = ll2->root->next; if(ll2->root) ll2->root->prev = 0; else ll2->tail = ll2->root; }while(0)"
.LASF559:
	.string	"magic"
.LASF554:
	.string	"msg_type"
.LASF263:
	.string	"MAX(x,y) ((x)>(y)?(x):(y))"
.LASF317:
	.string	"__pa(vaddr) ((unsigned)(vaddr) - PAGE_OFFSET)"
.LASF291:
	.string	"BYTEORDER_GENERIC_H "
.LASF588:
	.string	"mem_entity"
.LASF83:
	.string	"__SIG_ATOMIC_MAX__ 2147483647"
.LASF389:
	.string	"X86_ERRNO_H "
.LASF531:
	.string	"RLIMIT_NOFILE"
.LASF199:
	.string	"__GCC_ATOMIC_CHAR32_T_LOCK_FREE 2"
.LASF259:
	.string	"PROC_H "
.LASF552:
	.string	"time_slice"
.LASF499:
	.string	"sizetype"
.LASF188:
	.string	"__USER_LABEL_PREFIX__ "
.LASF428:
	.string	"long unsigned int"
.LASF118:
	.string	"__UINTPTR_MAX__ 4294967295U"
.LASF542:
	.string	"pt_regs"
.LASF1:
	.string	"__STDC_VERSION__ 199901L"
.LASF224:
	.string	"__unix 1"
.LASF90:
	.string	"__UINT16_MAX__ 65535"
.LASF375:
	.string	"NR_OPEN_DEFAULT 32"
.LASF7:
	.string	"__ATOMIC_RELAXED 0"
.LASF2:
	.string	"__STDC_HOSTED__ 1"
.LASF590:
	.string	"zone_dma"
.LASF79:
	.string	"__INTMAX_MAX__ 9223372036854775807LL"
.LASF541:
	.string	"thread"
.LASF65:
	.string	"__has_include(STR) __has_include__(STR)"
.LASF231:
	.string	"ASSERT_H "
.LASF112:
	.string	"__INT_FAST64_MAX__ 9223372036854775807LL"
.LASF206:
	.string	"__GCC_ATOMIC_POINTER_LOCK_FREE 2"
.LASF253:
	.string	"SLAB_CACHE_DMA 2"
.LASF408:
	.string	"EEXIST 17"
.LASF217:
	.string	"__i686__ 1"
.LASF593:
	.string	"__zones"
.LASF587:
	.string	"dentry_cache"
.LASF128:
	.string	"__FLT_MAX_EXP__ 128"
.LASF110:
	.string	"__INT_FAST16_MAX__ 2147483647"
.LASF462:
	.string	"writable"
.LASF430:
	.string	"unsigned char"
.LASF167:
	.string	"__DEC32_MIN_EXP__ (-94)"
.LASF272:
	.string	"LL_I(root,new) do{ if(root){ new->prev = root; new->next = root->next; if(root->next) root->next->prev = new; root->next = new; } else{ root = new; new->prev = new->next = 0; } }while(0)"
.LASF602:
	.string	"/home/wws/lab/yanqi/src"
.LASF303:
	.string	"PAGE_MASK (~0xfff)"
.LASF401:
	.string	"ECHILD 10"
.LASF180:
	.string	"__DEC128_MANT_DIG__ 34"
.LASF223:
	.string	"__linux__ 1"
.LASF326:
	.string	"virt_to_page(vaddr) pfn_page( __pa(vaddr) >> PAGE_SHIFT)"
.LASF239:
	.string	"boolean _Bool"
.LASF116:
	.string	"__UINT_FAST64_MAX__ 18446744073709551615ULL"
.LASF30:
	.string	"__SIZE_TYPE__ unsigned int"
.LASF387:
	.string	"get_file(file) ( (file)->count++ )"
.LASF133:
	.string	"__FLT_EPSILON__ 1.19209289550781250000e-7F"
.LASF405:
	.string	"EFAULT 14"
.LASF298:
	.string	"LINUX_MM_H "
.LASF142:
	.string	"__DBL_MAX_EXP__ 1024"
.LASF437:
	.string	"list_head"
.LASF446:
	.string	"root"
.LASF335:
	.string	"ZONE_HIGHMEM 2"
.LASF201:
	.string	"__GCC_ATOMIC_SHORT_LOCK_FREE 2"
.LASF357:
	.string	"MEMBER_OFFSET(stru_type,member_name) ( (unsigned)&(((stru_type *)0)->member_name) )"
.LASF515:
	.string	"maywrite"
.LASF353:
	.string	"POINTER_SHIFT(pt,type,len) (type*)((u32)pt+len)"
.LASF442:
	.string	"clash"
.LASF127:
	.string	"__FLT_MIN_10_EXP__ (-37)"
.LASF228:
	.string	"FS_H "
.LASF150:
	.string	"__DBL_HAS_INFINITY__ 1"
.LASF105:
	.string	"__UINT_LEAST32_MAX__ 4294967295U"
.LASF57:
	.string	"__INT_FAST32_TYPE__ int"
.LASF160:
	.string	"__LDBL_MIN__ 3.36210314311209350626e-4932L"
.LASF342:
	.string	"HEAP_SIZE (64*0x100000)"
.LASF14:
	.string	"__SIZEOF_INT__ 4"
.LASF34:
	.string	"__INTMAX_TYPE__ long long int"
.LASF80:
	.string	"__INTMAX_C(c) c ## LL"
.LASF343:
	.string	"BLOCK_DATA_END(block) ((int)((char*)block+sizeof(EMPTY_BLOCK)+block->size-1))"
.LASF577:
	.string	"fops"
.LASF275:
	.ascii	"LL_I_INCRE(list,new,attr) do{ assert(new); if(!list){ list=n"
	.ascii	"ew; new->prev=new->next=0; break; } void*root=list; while(li"
	.ascii	"st->next && new->attr > list->attr) list=list"
	.string	"->next; if(new->attr > list->attr){ new->next = 0; new->prev=list; list->next = new; list=root; } else{ new->next = list; new->prev = list->prev; if(list->prev) list->prev->next = new; list->prev=new; if(root==list) list=new; else list = root; } } while(0)"
.LASF555:
	.string	"msg_bind"
.LASF603:
	.string	"slab_head"
.LASF46:
	.string	"__UINT64_TYPE__ long long unsigned int"
.LASF495:
	.string	"free_pages"
.LASF327:
	.string	"MAX_ORDER 10"
.LASF143:
	.string	"__DBL_MAX_10_EXP__ 308"
.LASF158:
	.string	"__DECIMAL_DIG__ 21"
.LASF595:
	.string	"__hs_pcb"
.LASF432:
	.string	"short unsigned int"
.LASF229:
	.string	"DCACHE_H "
.LASF197:
	.string	"__GCC_ATOMIC_CHAR_LOCK_FREE 2"
.LASF189:
	.string	"__GNUC_STDC_INLINE__ 1"
.LASF280:
	.string	"LL_SCAN_ON_KEY(root,key,value,result) do{ result = root; while(result){ if( (result)->key == (value) ){ break; } result = (result)->next; } }while(0)"
.LASF402:
	.string	"EAGAIN 11"
.LASF23:
	.string	"__BIGGEST_ALIGNMENT__ 16"
.LASF52:
	.string	"__UINT_LEAST16_TYPE__ short unsigned int"
.LASF410:
	.string	"ENODEV 19"
.LASF147:
	.string	"__DBL_EPSILON__ ((double)2.22044604925031308085e-16L)"
.LASF414:
	.string	"ENFILE 23"
.LASF126:
	.string	"__FLT_MIN_EXP__ (-125)"
.LASF265:
	.string	"eat_dec(pt,x) if(*pt<'0'||*pt>'9') goto donothing; x=0; char*__pt=(pt); while(*(__pt+1)>='0'&&*(__pt+1)<='9') __pt++; int __len=__pt-(pt)+1; for(int __i=0;__i<__len;__i++){ x+=(*__pt-48)*pow_int(10,__i); __pt--; } (pt)+=__len;donothing:;"
.LASF493:
	.string	"free_area_t"
.LASF184:
	.string	"__DEC128_MAX__ 9.999999999999999999999999999999999E6144DL"
.LASF214:
	.string	"__ATOMIC_HLE_ACQUIRE 65536"
.LASF219:
	.string	"__pentiumpro__ 1"
.LASF592:
	.string	"zone_highmem"
.LASF448:
	.string	"dentry"
.LASF191:
	.string	"__STRICT_ANSI__ 1"
.LASF382:
	.string	"FMODE_READ 1"
.LASF330:
	.string	"__GFP_DMA (1<<1)"
.LASF363:
	.string	"MSGTYPE_CHAR 1"
.LASF267:
	.string	"MYLIST_H "
.LASF562:
	.string	"inode_operations"
.LASF149:
	.string	"__DBL_HAS_DENORM__ 1"
.LASF496:
	.string	"free_area"
.LASF81:
	.string	"__UINTMAX_MAX__ 18446744073709551615ULL"
.LASF463:
	.string	"user"
.LASF454:
	.string	"dentry_operations"
.LASF32:
	.string	"__WCHAR_TYPE__ long int"
.LASF440:
	.string	"mountpoint"
.LASF11:
	.string	"__ATOMIC_ACQ_REL 4"
.LASF421:
	.string	"EROFS 30"
.LASF246:
	.string	"__1M 0x100000"
.LASF296:
	.string	"LINUX_STRING_H "
.LASF241:
	.string	"false 0"
.LASF491:
	.string	"frees"
.LASF157:
	.string	"__LDBL_MAX_10_EXP__ 4932"
.LASF176:
	.string	"__DEC64_MIN__ 1E-383DD"
.LASF512:
	.string	"executable"
.LASF70:
	.string	"__INT_MAX__ 2147483647"
.LASF38:
	.string	"__SIG_ATOMIC_TYPE__ int"
.LASF563:
	.string	"lookup"
.LASF589:
	.string	"mem_map"
.LASF262:
	.string	"min(x,y) ((x)<(y)?(x):(y))"
.LASF195:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 1"
.LASF163:
	.string	"__LDBL_HAS_DENORM__ 1"
.LASF230:
	.string	"LIST_H "
.LASF452:
	.string	"qstr"
.LASF6:
	.string	"__VERSION__ \"4.9.2\""
.LASF139:
	.string	"__DBL_DIG__ 15"
.LASF173:
	.string	"__DEC64_MANT_DIG__ 16"
.LASF135:
	.string	"__FLT_HAS_DENORM__ 1"
.LASF119:
	.string	"__GCC_IEC_559 2"
	.ident	"GCC: (Ubuntu 4.9.2-10ubuntu13) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
