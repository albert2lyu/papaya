	.file	"mm.c"
	.text
.Ltext0:
	.comm	mem_entity,4,1
	.comm	mem_map,4,4
	.comm	zone_dma,240,64
	.comm	zone_normal,240,64
	.comm	zone_highmem,240,64
	.comm	__zones,12,4
	.comm	size_of_zone,12,4
	.type	__alloc_pages, @function
__alloc_pages:
.LFB22:
	.file 1 "./include/old/mmzone.h"
	.loc 1 109 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 1 110 0
	subl	$8, %esp
	pushl	12(%ebp)
	pushl	8(%ebp)
	call	alloc_pages
	addl	$16, %esp
	movl	%eax, %edx
	movl	mem_map, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	sarl	$3, %eax
	imull	$-1431655765, %eax, %eax
	movl	%eax, -12(%ebp)
	.loc 1 111 0
	movl	-12(%ebp), %eax
	sall	$12, %eax
	subl	$1073741824, %eax
	.loc 1 112 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE22:
	.size	__alloc_pages, .-__alloc_pages
	.type	__alloc_page, @function
__alloc_page:
.LFB24:
	.loc 1 120 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 121 0
	subl	$8, %esp
	pushl	$0
	pushl	8(%ebp)
	call	__alloc_pages
	addl	$16, %esp
	.loc 1 122 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE24:
	.size	__alloc_page, .-__alloc_page
	.comm	__hs_pcb,4,4
	.comm	__ext_pcb,4,4
	.comm	dentry_hashtable,4,4
	.comm	dentry_cache,4,4
	.comm	inode_hashtable,4,4
	.comm	inode_cache,4,4
	.comm	file_cache,4,4
	.comm	mm_cache,4,4
	.comm	vm_area_cache,4,4
	.comm	fs_struct_cache,4,4
	.comm	files_struct_cache,4,4
	.globl	gmemsize
	.bss
	.align 4
	.type	gmemsize, @object
	.size	gmemsize, 4
gmemsize:
	.zero	4
	.comm	testbuf,1024,64
	.section	.rodata
.LC0:
	.string	"type"
.LC1:
	.string	"len"
.LC2:
	.string	"start"
.LC3:
	.string	"%12s%12s%10s\n"
.LC4:
	.string	"free"
.LC5:
	.string	"occupied"
.LC6:
	.string	"%12x%12x%10s\n"
	.text
	.globl	init_memory
	.type	init_memory, @function
init_memory:
.LFB51:
	.file 2 "mm.c"
	.loc 2 16 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$20, %esp
	.cfi_offset 3, -12
	.loc 2 19 0
	call	heap_init
	.loc 2 21 0
	movl	$realmod_info, %eax
	subl	$1073741824, %eax
	movl	(%eax), %eax
	movl	%eax, -16(%ebp)
	.loc 2 22 0
	movl	$realmod_info, %eax
	subl	$1073741820, %eax
	movl	%eax, -20(%ebp)
	.loc 2 23 0
	pushl	$.LC0
	pushl	$.LC1
	pushl	$.LC2
	pushl	$.LC3
	call	oprintf
	addl	$16, %esp
.LBB2:
	.loc 2 24 0
	movl	$0, -12(%ebp)
	jmp	.L6
.L10:
	.loc 2 26 0
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-20(%ebp), %eax
	addl	%edx, %eax
	movl	16(%eax), %eax
	.loc 2 25 0
	cmpl	$1, %eax
	jne	.L7
	.loc 2 25 0 is_stmt 0 discriminator 1
	movl	$.LC4, %ebx
	jmp	.L8
.L7:
	.loc 2 25 0 discriminator 2
	movl	$.LC5, %ebx
.L8:
	.loc 2 25 0 discriminator 4
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-20(%ebp), %eax
	addl	%edx, %eax
	movl	8(%eax), %ecx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-20(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	pushl	%ebx
	pushl	%ecx
	pushl	%eax
	pushl	$.LC6
	call	oprintf
	addl	$16, %esp
	.loc 2 27 0 is_stmt 1 discriminator 4
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-20(%ebp), %eax
	addl	%edx, %eax
	movl	16(%eax), %eax
	cmpl	$1, %eax
	jne	.L9
	.loc 2 27 0 is_stmt 0 discriminator 1
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-20(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %edx
	movl	gmemsize, %eax
	cmpl	%eax, %edx
	jbe	.L9
	.loc 2 28 0 is_stmt 1
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-20(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %ecx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-20(%ebp), %eax
	addl	%edx, %eax
	movl	8(%eax), %eax
	addl	%ecx, %eax
	movl	%eax, gmemsize
.L9:
	.loc 2 24 0 discriminator 2
	addl	$1, -12(%ebp)
.L6:
	.loc 2 24 0 is_stmt 0 discriminator 1
	movl	-12(%ebp), %eax
	cmpl	-16(%ebp), %eax
	jl	.L10
.LBE2:
	.loc 2 33 0 is_stmt 1
	movl	gmemsize, %eax
	shrl	$12, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	movl	%eax, -24(%ebp)
	.loc 2 34 0
	subl	$12, %esp
	pushl	-24(%ebp)
	call	kmalloc0
	addl	$16, %esp
	movl	%eax, mem_map
	.loc 2 36 0
	movl	$16777216, size_of_zone
	.loc 2 37 0
	movl	gmemsize, %eax
	cmpl	$939524096, %eax
	jbe	.L11
	.loc 2 38 0
	movl	$922746880, size_of_zone+4
	.loc 2 39 0
	movl	gmemsize, %eax
	subl	$939524096, %eax
	movl	%eax, size_of_zone+8
	jmp	.L5
.L11:
	.loc 2 42 0
	movl	gmemsize, %eax
	subl	$16777216, %eax
	movl	%eax, size_of_zone+4
	.loc 2 43 0
	movl	$0, size_of_zone+8
.L5:
	.loc 2 45 0
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE51:
	.size	init_memory, .-init_memory
	.globl	map_pg
	.type	map_pg, @function
map_pg:
.LFB52:
	.loc 2 48 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 2 51 0
	movl	12(%ebp), %eax
	sarl	$10, %eax
	leal	0(,%eax,4), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -12(%ebp)
	.loc 2 52 0
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L14
	.loc 2 55 0
	subl	$12, %esp
	pushl	$1
	call	__alloc_page
	addl	$16, %esp
	addl	$1073741824, %eax
	orl	$7, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	movl	%edx, (%eax)
.L14:
	.loc 2 57 0
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	andl	$-4096, %eax
	subl	$1073741824, %eax
	movl	%eax, -16(%ebp)
	.loc 2 59 0
	movl	12(%ebp), %eax
	andl	$1023, %eax
	leal	0(,%eax,4), %edx
	movl	-16(%ebp), %eax
	addl	%eax, %edx
	movl	16(%ebp), %eax
	sall	$12, %eax
	orl	20(%ebp), %eax
	orl	24(%ebp), %eax
	orl	$1, %eax
	movl	%eax, (%edx)
	.loc 2 60 0
	movl	$0, %eax
#APP
# 60 "mm.c" 1
	mov %cr3, %eax
	mov %eax, %cr3
	
# 0 "" 2
	.loc 2 61 0
#NO_APP
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE52:
	.size	map_pg, .-map_pg
	.section	.rodata
	.align 4
.LC7:
	.string	" temp mmio map begin >>>>>>>>>\n"
.LC8:
	.string	" temp mmio map done -----\n"
	.text
	.globl	temp_mmio_map
	.type	temp_mmio_map, @function
temp_mmio_map:
.LFB53:
	.loc 2 68 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	.loc 2 74 0
	subl	$12, %esp
	pushl	$.LC7
	call	oprintf
	addl	$16, %esp
	.loc 2 75 0
	movl	$-1072693248, -24(%ebp)
	.loc 2 78 0
	movl	$-73400320, -28(%ebp)
	.loc 2 79 0
	movl	$-72351744, -12(%ebp)
.LBB3:
	.loc 2 80 0
	movl	-28(%ebp), %eax
	movl	%eax, -16(%ebp)
	jmp	.L16
.L20:
.LBB4:
	.loc 2 81 0
	movl	-16(%ebp), %eax
	addl	$1073741824, %eax
	shrl	$12, %eax
	movl	%eax, -32(%ebp)
	.loc 2 82 0
	movl	-16(%ebp), %eax
	shrl	$12, %eax
	movl	%eax, -36(%ebp)
	.loc 2 83 0
	subl	$12, %esp
	pushl	$2
	pushl	$0
	pushl	-36(%ebp)
	pushl	-32(%ebp)
	pushl	-24(%ebp)
	call	map_pg
	addl	$32, %esp
	.loc 2 85 0
	movl	-16(%ebp), %eax
	cmpl	-12(%ebp), %eax
	jne	.L17
.LBB5:
	.loc 2 87 0
	movl	done.2000, %eax
	testl	%eax, %eax
	je	.L18
	jmp	.L19
.L18:
	.loc 2 88 0
	movl	$1, done.2000
	.loc 2 90 0
	movl	$-20971520, -12(%ebp)
	.loc 2 91 0
	movl	$-21495808, -16(%ebp)
.L17:
.LBE5:
.LBE4:
	.loc 2 80 0 discriminator 2
	addl	$4096, -16(%ebp)
.L16:
	.loc 2 80 0 is_stmt 0 discriminator 1
	movl	-16(%ebp), %eax
	cmpl	-12(%ebp), %eax
	jbe	.L20
.L19:
.LBE3:
.LBB6:
	.loc 2 95 0 is_stmt 1
	movl	$-37814272, -20(%ebp)
	jmp	.L21
.L22:
.LBB7:
	.loc 2 96 0 discriminator 3
	movl	-20(%ebp), %eax
	addl	$1073741824, %eax
	shrl	$12, %eax
	movl	%eax, -40(%ebp)
	.loc 2 97 0 discriminator 3
	movl	-20(%ebp), %eax
	shrl	$12, %eax
	movl	%eax, -44(%ebp)
	.loc 2 98 0 discriminator 3
	subl	$12, %esp
	pushl	$2
	pushl	$0
	pushl	-44(%ebp)
	pushl	-40(%ebp)
	pushl	-24(%ebp)
	call	map_pg
	addl	$32, %esp
.LBE7:
	.loc 2 95 0 discriminator 3
	addl	$4096, -20(%ebp)
.L21:
	.loc 2 95 0 is_stmt 0 discriminator 1
	cmpl	$-37748736, -20(%ebp)
	jbe	.L22
.LBE6:
	.loc 2 100 0 is_stmt 1
	subl	$12, %esp
	pushl	$.LC8
	call	oprintf
	addl	$16, %esp
	.loc 2 101 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE53:
	.size	temp_mmio_map, .-temp_mmio_map
	.globl	mm_init
	.type	mm_init, @function
mm_init:
.LFB54:
	.loc 2 105 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 2 106 0
	call	init_memory
	.loc 2 107 0
	call	init_zone
	.loc 2 108 0
	call	temp_mmio_map
	.loc 2 110 0
	movb	$1, mm_available
	.loc 2 111 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE54:
	.size	mm_init, .-mm_init
	.section	.rodata
.LC9:
	.string	"mm_cache"
.LC10:
	.string	"vma_cache"
.LC11:
	.string	"fs_struct_cache"
.LC12:
	.string	"files_struct_cache"
	.text
	.globl	mm_init2
	.type	mm_init2, @function
mm_init2:
.LFB55:
	.loc 2 113 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 2 114 0
	subl	$8, %esp
	pushl	$0
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$36
	pushl	$.LC9
	call	register_slab_type
	addl	$32, %esp
	movl	%eax, mm_cache
	.loc 2 116 0
	subl	$8, %esp
	pushl	$0
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$40
	pushl	$.LC10
	call	register_slab_type
	addl	$32, %esp
	movl	%eax, vm_area_cache
	.loc 2 118 0
	subl	$8, %esp
	pushl	$0
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$20
	pushl	$.LC11
	call	register_slab_type
	addl	$32, %esp
	movl	%eax, fs_struct_cache
	.loc 2 121 0
	subl	$8, %esp
	pushl	$0
	pushl	$0
	pushl	$1
	pushl	$0
	pushl	$140
	pushl	$.LC12
	call	register_slab_type
	addl	$32, %esp
	movl	%eax, files_struct_cache
	.loc 2 124 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE55:
	.size	mm_init2, .-mm_init2
	.local	done.2000
	.comm	done.2000,4,4
.Letext0:
	.file 3 "./include/old/valType.h"
	.file 4 "./include/old/list.h"
	.file 5 "./arch/x86/include/asm/page.h"
	.file 6 "./include/linux/sched.h"
	.file 7 "./include/linux/mm.h"
	.file 8 "./include/linux/fs.h"
	.file 9 "./include/asm/resource.h"
	.file 10 "./include/old/proc.h"
	.file 11 "./include/linux/dcache.h"
	.file 12 "./include/linux/mount.h"
	.file 13 "./include/old/bootinfo.h"
	.file 14 "./include/old/ku_utils.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x1216
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.long	.LASF603
	.byte	0x1
	.long	.LASF604
	.long	.LASF605
	.long	.Ltext0
	.long	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.long	.Ldebug_macro0
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF415
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF416
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.long	.LASF417
	.uleb128 0x3
	.string	"u16"
	.byte	0x3
	.byte	0x10
	.long	0x49
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.long	.LASF418
	.uleb128 0x3
	.string	"u32"
	.byte	0x3
	.byte	0x11
	.long	0x5b
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF419
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF420
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.long	.LASF421
	.uleb128 0x4
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.long	.LASF422
	.uleb128 0x5
	.long	.LASF443
	.byte	0x8
	.byte	0x4
	.byte	0x6
	.long	0xa3
	.uleb128 0x6
	.long	.LASF423
	.byte	0x4
	.byte	0x7
	.long	0xa3
	.byte	0
	.uleb128 0x6
	.long	.LASF424
	.byte	0x4
	.byte	0x8
	.long	0xa3
	.byte	0x4
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x7e
	.uleb128 0x8
	.byte	0x4
	.byte	0x5
	.byte	0x2c
	.long	0x139
	.uleb128 0x9
	.long	.LASF425
	.byte	0x5
	.byte	0x2d
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0
	.uleb128 0x9
	.long	.LASF426
	.byte	0x5
	.byte	0x2e
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0
	.uleb128 0x9
	.long	.LASF427
	.byte	0x5
	.byte	0x2f
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1d
	.byte	0
	.uleb128 0xa
	.string	"PWT"
	.byte	0x5
	.byte	0x30
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1c
	.byte	0
	.uleb128 0xa
	.string	"PCD"
	.byte	0x5
	.byte	0x31
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1b
	.byte	0
	.uleb128 0x9
	.long	.LASF428
	.byte	0x5
	.byte	0x32
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1a
	.byte	0
	.uleb128 0x9
	.long	.LASF429
	.byte	0x5
	.byte	0x33
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x19
	.byte	0
	.uleb128 0xa
	.string	"avl"
	.byte	0x5
	.byte	0x35
	.long	0x5b
	.byte	0x4
	.byte	0x3
	.byte	0x14
	.byte	0
	.uleb128 0x9
	.long	.LASF430
	.byte	0x5
	.byte	0x36
	.long	0x5b
	.byte	0x4
	.byte	0x14
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x8
	.byte	0x4
	.byte	0x5
	.byte	0x38
	.long	0x151
	.uleb128 0x9
	.long	.LASF431
	.byte	0x5
	.byte	0x39
	.long	0x5b
	.byte	0x4
	.byte	0xc
	.byte	0x14
	.byte	0
	.byte	0
	.uleb128 0xb
	.string	"pte"
	.byte	0x4
	.byte	0x5
	.byte	0x2a
	.long	0x173
	.uleb128 0xc
	.long	.LASF432
	.byte	0x5
	.byte	0x2b
	.long	0x70
	.uleb128 0xd
	.long	0xa9
	.uleb128 0xd
	.long	0x139
	.byte	0
	.uleb128 0x8
	.byte	0x4
	.byte	0x5
	.byte	0x49
	.long	0x18b
	.uleb128 0x9
	.long	.LASF430
	.byte	0x5
	.byte	0x4b
	.long	0x5b
	.byte	0x4
	.byte	0x14
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0xb
	.string	"cr3"
	.byte	0x4
	.byte	0x5
	.byte	0x47
	.long	0x1a8
	.uleb128 0xc
	.long	.LASF432
	.byte	0x5
	.byte	0x48
	.long	0x70
	.uleb128 0xd
	.long	0x173
	.byte	0
	.uleb128 0x8
	.byte	0x4
	.byte	0x5
	.byte	0x51
	.long	0x1fc
	.uleb128 0x9
	.long	.LASF433
	.byte	0x5
	.byte	0x52
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0
	.uleb128 0x9
	.long	.LASF434
	.byte	0x5
	.byte	0x53
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0
	.uleb128 0x9
	.long	.LASF435
	.byte	0x5
	.byte	0x54
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1d
	.byte	0
	.uleb128 0x9
	.long	.LASF436
	.byte	0x5
	.byte	0x55
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1c
	.byte	0
	.uleb128 0x9
	.long	.LASF437
	.byte	0x5
	.byte	0x56
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1b
	.byte	0
	.byte	0
	.uleb128 0x8
	.byte	0x4
	.byte	0x5
	.byte	0x59
	.long	0x241
	.uleb128 0x9
	.long	.LASF438
	.byte	0x5
	.byte	0x5a
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0
	.uleb128 0x9
	.long	.LASF439
	.byte	0x5
	.byte	0x5b
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0
	.uleb128 0x9
	.long	.LASF440
	.byte	0x5
	.byte	0x5c
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1d
	.byte	0
	.uleb128 0x9
	.long	.LASF441
	.byte	0x5
	.byte	0x5e
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1b
	.byte	0
	.byte	0
	.uleb128 0xe
	.long	.LASF442
	.byte	0x4
	.byte	0x5
	.byte	0x4f
	.long	0x263
	.uleb128 0xc
	.long	.LASF432
	.byte	0x5
	.byte	0x50
	.long	0x50
	.uleb128 0xd
	.long	0x1a8
	.uleb128 0xd
	.long	0x1fc
	.byte	0
	.uleb128 0x5
	.long	.LASF444
	.byte	0x18
	.byte	0x1
	.byte	0x8
	.long	0x2eb
	.uleb128 0xf
	.string	"lru"
	.byte	0x1
	.byte	0x9
	.long	0x7e
	.byte	0
	.uleb128 0x6
	.long	.LASF445
	.byte	0x1
	.byte	0xa
	.long	0x70
	.byte	0x8
	.uleb128 0x6
	.long	.LASF446
	.byte	0x1
	.byte	0xb
	.long	0x70
	.byte	0xc
	.uleb128 0x6
	.long	.LASF447
	.byte	0x1
	.byte	0x10
	.long	0x70
	.byte	0x10
	.uleb128 0x9
	.long	.LASF448
	.byte	0x1
	.byte	0x11
	.long	0x70
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0x14
	.uleb128 0x9
	.long	.LASF449
	.byte	0x1
	.byte	0x12
	.long	0x70
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0x14
	.uleb128 0x9
	.long	.LASF450
	.byte	0x1
	.byte	0x13
	.long	0x5b
	.byte	0x4
	.byte	0x2
	.byte	0x1c
	.byte	0x14
	.uleb128 0x9
	.long	.LASF451
	.byte	0x1
	.byte	0x14
	.long	0x5b
	.byte	0x4
	.byte	0x8
	.byte	0x14
	.byte	0x14
	.uleb128 0x9
	.long	.LASF452
	.byte	0x1
	.byte	0x15
	.long	0x70
	.byte	0x4
	.byte	0x14
	.byte	0
	.byte	0x14
	.byte	0
	.uleb128 0x5
	.long	.LASF453
	.byte	0x14
	.byte	0x1
	.byte	0x31
	.long	0x328
	.uleb128 0x6
	.long	.LASF454
	.byte	0x1
	.byte	0x32
	.long	0x7e
	.byte	0
	.uleb128 0x6
	.long	.LASF455
	.byte	0x1
	.byte	0x33
	.long	0x70
	.byte	0x8
	.uleb128 0x6
	.long	.LASF456
	.byte	0x1
	.byte	0x34
	.long	0x70
	.byte	0xc
	.uleb128 0x6
	.long	.LASF457
	.byte	0x1
	.byte	0x34
	.long	0x70
	.byte	0x10
	.byte	0
	.uleb128 0x10
	.long	.LASF458
	.byte	0x1
	.byte	0x35
	.long	0x2eb
	.uleb128 0x5
	.long	.LASF459
	.byte	0xf0
	.byte	0x1
	.byte	0x37
	.long	0x388
	.uleb128 0x6
	.long	.LASF460
	.byte	0x1
	.byte	0x39
	.long	0x5b
	.byte	0
	.uleb128 0x6
	.long	.LASF461
	.byte	0x1
	.byte	0x3a
	.long	0x388
	.byte	0x4
	.uleb128 0x6
	.long	.LASF462
	.byte	0x1
	.byte	0x3b
	.long	0x39f
	.byte	0xe0
	.uleb128 0x6
	.long	.LASF463
	.byte	0x1
	.byte	0x3c
	.long	0x5b
	.byte	0xe4
	.uleb128 0x6
	.long	.LASF457
	.byte	0x1
	.byte	0x3d
	.long	0x70
	.byte	0xe8
	.uleb128 0x6
	.long	.LASF456
	.byte	0x1
	.byte	0x3d
	.long	0x70
	.byte	0xec
	.byte	0
	.uleb128 0x11
	.long	0x328
	.long	0x398
	.uleb128 0x12
	.long	0x398
	.byte	0xa
	.byte	0
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF464
	.uleb128 0x7
	.byte	0x4
	.long	0x263
	.uleb128 0x10
	.long	.LASF465
	.byte	0x1
	.byte	0x3e
	.long	0x333
	.uleb128 0x13
	.string	"mm"
	.byte	0x24
	.byte	0x6
	.byte	0x10
	.long	0x428
	.uleb128 0xf
	.string	"cr3"
	.byte	0x6
	.byte	0x11
	.long	0x18b
	.byte	0
	.uleb128 0xf
	.string	"vma"
	.byte	0x6
	.byte	0x12
	.long	0x4ac
	.byte	0x4
	.uleb128 0x6
	.long	.LASF466
	.byte	0x6
	.byte	0x14
	.long	0x29
	.byte	0x8
	.uleb128 0x6
	.long	.LASF467
	.byte	0x6
	.byte	0x14
	.long	0x29
	.byte	0xc
	.uleb128 0x6
	.long	.LASF468
	.byte	0x6
	.byte	0x15
	.long	0x29
	.byte	0x10
	.uleb128 0x6
	.long	.LASF469
	.byte	0x6
	.byte	0x15
	.long	0x29
	.byte	0x14
	.uleb128 0x6
	.long	.LASF470
	.byte	0x6
	.byte	0x16
	.long	0x29
	.byte	0x18
	.uleb128 0xf
	.string	"brk"
	.byte	0x6
	.byte	0x16
	.long	0x29
	.byte	0x1c
	.uleb128 0x6
	.long	.LASF471
	.byte	0x6
	.byte	0x17
	.long	0x70
	.byte	0x20
	.byte	0
	.uleb128 0x5
	.long	.LASF472
	.byte	0x28
	.byte	0x7
	.byte	0x57
	.long	0x4ac
	.uleb128 0xf
	.string	"mm"
	.byte	0x7
	.byte	0x58
	.long	0x636
	.byte	0
	.uleb128 0x6
	.long	.LASF473
	.byte	0x7
	.byte	0x59
	.long	0x50
	.byte	0x4
	.uleb128 0xf
	.string	"end"
	.byte	0x7
	.byte	0x5a
	.long	0x50
	.byte	0x8
	.uleb128 0x6
	.long	.LASF474
	.byte	0x7
	.byte	0x5b
	.long	0x151
	.byte	0xc
	.uleb128 0x6
	.long	.LASF431
	.byte	0x7
	.byte	0x5f
	.long	0x5b8
	.byte	0x10
	.uleb128 0x6
	.long	.LASF423
	.byte	0x7
	.byte	0x61
	.long	0x4ac
	.byte	0x14
	.uleb128 0x6
	.long	.LASF424
	.byte	0x7
	.byte	0x61
	.long	0x4ac
	.byte	0x18
	.uleb128 0xf
	.string	"ops"
	.byte	0x7
	.byte	0x62
	.long	0x63c
	.byte	0x1c
	.uleb128 0x6
	.long	.LASF475
	.byte	0x7
	.byte	0x63
	.long	0x697
	.byte	0x20
	.uleb128 0x6
	.long	.LASF476
	.byte	0x7
	.byte	0x64
	.long	0x50
	.byte	0x24
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x428
	.uleb128 0x5
	.long	.LASF477
	.byte	0x14
	.byte	0x7
	.byte	0xd
	.long	0x4fb
	.uleb128 0x6
	.long	.LASF478
	.byte	0x7
	.byte	0xe
	.long	0x50
	.byte	0
	.uleb128 0x6
	.long	.LASF479
	.byte	0x7
	.byte	0xe
	.long	0x50
	.byte	0x4
	.uleb128 0x6
	.long	.LASF480
	.byte	0x7
	.byte	0xf
	.long	0x50
	.byte	0x8
	.uleb128 0x6
	.long	.LASF481
	.byte	0x7
	.byte	0xf
	.long	0x50
	.byte	0xc
	.uleb128 0x6
	.long	.LASF482
	.byte	0x7
	.byte	0x10
	.long	0x50
	.byte	0x10
	.byte	0
	.uleb128 0x8
	.byte	0x2
	.byte	0x7
	.byte	0x24
	.long	0x5b8
	.uleb128 0x9
	.long	.LASF483
	.byte	0x7
	.byte	0x25
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0
	.uleb128 0x9
	.long	.LASF426
	.byte	0x7
	.byte	0x26
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0
	.uleb128 0x9
	.long	.LASF484
	.byte	0x7
	.byte	0x27
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1d
	.byte	0
	.uleb128 0x9
	.long	.LASF485
	.byte	0x7
	.byte	0x28
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1c
	.byte	0
	.uleb128 0x9
	.long	.LASF486
	.byte	0x7
	.byte	0x2a
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1b
	.byte	0
	.uleb128 0x9
	.long	.LASF487
	.byte	0x7
	.byte	0x2b
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1a
	.byte	0
	.uleb128 0x9
	.long	.LASF488
	.byte	0x7
	.byte	0x2c
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x19
	.byte	0
	.uleb128 0x9
	.long	.LASF489
	.byte	0x7
	.byte	0x2d
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x18
	.byte	0
	.uleb128 0x9
	.long	.LASF490
	.byte	0x7
	.byte	0x2f
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x17
	.byte	0
	.uleb128 0x9
	.long	.LASF491
	.byte	0x7
	.byte	0x30
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x16
	.byte	0
	.uleb128 0x9
	.long	.LASF492
	.byte	0x7
	.byte	0x31
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x15
	.byte	0
	.uleb128 0x9
	.long	.LASF493
	.byte	0x7
	.byte	0x32
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x14
	.byte	0
	.byte	0
	.uleb128 0xe
	.long	.LASF494
	.byte	0x4
	.byte	0x7
	.byte	0x23
	.long	0x5d5
	.uleb128 0xd
	.long	0x4fb
	.uleb128 0xc
	.long	.LASF432
	.byte	0x7
	.byte	0x34
	.long	0x5b
	.byte	0
	.uleb128 0x5
	.long	.LASF495
	.byte	0xc
	.byte	0x7
	.byte	0x51
	.long	0x606
	.uleb128 0x6
	.long	.LASF496
	.byte	0x7
	.byte	0x52
	.long	0x611
	.byte	0
	.uleb128 0x6
	.long	.LASF497
	.byte	0x7
	.byte	0x53
	.long	0x611
	.byte	0x4
	.uleb128 0x6
	.long	.LASF498
	.byte	0x7
	.byte	0x54
	.long	0x630
	.byte	0x8
	.byte	0
	.uleb128 0x14
	.long	0x611
	.uleb128 0x15
	.long	0x4ac
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x606
	.uleb128 0x16
	.long	0x39f
	.long	0x630
	.uleb128 0x15
	.long	0x4ac
	.uleb128 0x15
	.long	0x50
	.uleb128 0x15
	.long	0x241
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x617
	.uleb128 0x7
	.byte	0x4
	.long	0x3b0
	.uleb128 0x7
	.byte	0x4
	.long	0x5d5
	.uleb128 0x5
	.long	.LASF475
	.byte	0x18
	.byte	0x8
	.byte	0x48
	.long	0x697
	.uleb128 0x6
	.long	.LASF499
	.byte	0x8
	.byte	0x49
	.long	0x7af
	.byte	0
	.uleb128 0xf
	.string	"pos"
	.byte	0x8
	.byte	0x4a
	.long	0x5b
	.byte	0x4
	.uleb128 0x6
	.long	.LASF431
	.byte	0x8
	.byte	0x4b
	.long	0x5b
	.byte	0x8
	.uleb128 0x6
	.long	.LASF500
	.byte	0x8
	.byte	0x4c
	.long	0x5b
	.byte	0xc
	.uleb128 0x6
	.long	.LASF471
	.byte	0x8
	.byte	0x4e
	.long	0x70
	.byte	0x10
	.uleb128 0x6
	.long	.LASF501
	.byte	0x8
	.byte	0x4f
	.long	0xd25
	.byte	0x14
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x642
	.uleb128 0x17
	.byte	0x4
	.byte	0x9
	.byte	0x3
	.long	0x6be
	.uleb128 0x18
	.long	.LASF502
	.sleb128 0
	.uleb128 0x18
	.long	.LASF503
	.sleb128 1
	.uleb128 0x18
	.long	.LASF504
	.sleb128 2
	.uleb128 0x18
	.long	.LASF505
	.sleb128 3
	.byte	0
	.uleb128 0x5
	.long	.LASF506
	.byte	0x8
	.byte	0x9
	.byte	0xc
	.long	0x6e3
	.uleb128 0xf
	.string	"cur"
	.byte	0x9
	.byte	0xd
	.long	0x5b
	.byte	0
	.uleb128 0xf
	.string	"max"
	.byte	0x9
	.byte	0xe
	.long	0x5b
	.byte	0x4
	.byte	0
	.uleb128 0x11
	.long	0x6f3
	.long	0x6f3
	.uleb128 0x12
	.long	0x398
	.byte	0xf
	.byte	0
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF507
	.uleb128 0x5
	.long	.LASF508
	.byte	0x14
	.byte	0xa
	.byte	0x25
	.long	0x743
	.uleb128 0x6
	.long	.LASF471
	.byte	0xa
	.byte	0x26
	.long	0x70
	.byte	0
	.uleb128 0x6
	.long	.LASF509
	.byte	0xa
	.byte	0x27
	.long	0x7af
	.byte	0x4
	.uleb128 0xf
	.string	"pwd"
	.byte	0xa
	.byte	0x27
	.long	0x7af
	.byte	0x8
	.uleb128 0x6
	.long	.LASF510
	.byte	0xa
	.byte	0x28
	.long	0x815
	.byte	0xc
	.uleb128 0x6
	.long	.LASF511
	.byte	0xa
	.byte	0x28
	.long	0x815
	.byte	0x10
	.byte	0
	.uleb128 0x5
	.long	.LASF499
	.byte	0x30
	.byte	0xb
	.byte	0x11
	.long	0x7af
	.uleb128 0x6
	.long	.LASF512
	.byte	0xb
	.byte	0x12
	.long	0xc48
	.byte	0
	.uleb128 0x6
	.long	.LASF513
	.byte	0xb
	.byte	0x13
	.long	0x7af
	.byte	0x4
	.uleb128 0xf
	.string	"sb"
	.byte	0xb
	.byte	0x14
	.long	0xb3d
	.byte	0x8
	.uleb128 0x6
	.long	.LASF514
	.byte	0xb
	.byte	0x15
	.long	0xb43
	.byte	0xc
	.uleb128 0x6
	.long	.LASF515
	.byte	0xb
	.byte	0x16
	.long	0xc4e
	.byte	0x18
	.uleb128 0x6
	.long	.LASF516
	.byte	0xb
	.byte	0x17
	.long	0x7e
	.byte	0x1c
	.uleb128 0x6
	.long	.LASF471
	.byte	0xb
	.byte	0x18
	.long	0x70
	.byte	0x24
	.uleb128 0x6
	.long	.LASF517
	.byte	0xb
	.byte	0x1a
	.long	0x7e
	.byte	0x28
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x743
	.uleb128 0x5
	.long	.LASF516
	.byte	0x20
	.byte	0xc
	.byte	0x6
	.long	0x815
	.uleb128 0xf
	.string	"dev"
	.byte	0xc
	.byte	0x7
	.long	0x3e
	.byte	0
	.uleb128 0xf
	.string	"sb"
	.byte	0xc
	.byte	0x8
	.long	0xb3d
	.byte	0x4
	.uleb128 0x6
	.long	.LASF518
	.byte	0xc
	.byte	0x9
	.long	0x7af
	.byte	0x8
	.uleb128 0x6
	.long	.LASF519
	.byte	0xc
	.byte	0xa
	.long	0x7af
	.byte	0xc
	.uleb128 0x6
	.long	.LASF513
	.byte	0xc
	.byte	0xb
	.long	0x815
	.byte	0x10
	.uleb128 0x6
	.long	.LASF520
	.byte	0xc
	.byte	0xc
	.long	0x7e
	.byte	0x14
	.uleb128 0x6
	.long	.LASF471
	.byte	0xc
	.byte	0xd
	.long	0x70
	.byte	0x1c
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x7b5
	.uleb128 0x5
	.long	.LASF521
	.byte	0x8c
	.byte	0xa
	.byte	0x30
	.long	0x858
	.uleb128 0x6
	.long	.LASF522
	.byte	0xa
	.byte	0x35
	.long	0x70
	.byte	0
	.uleb128 0x6
	.long	.LASF523
	.byte	0xa
	.byte	0x36
	.long	0x858
	.byte	0x4
	.uleb128 0x6
	.long	.LASF524
	.byte	0xa
	.byte	0x37
	.long	0x85e
	.byte	0x8
	.uleb128 0x6
	.long	.LASF471
	.byte	0xa
	.byte	0x38
	.long	0x70
	.byte	0x88
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x697
	.uleb128 0x11
	.long	0x697
	.long	0x86e
	.uleb128 0x12
	.long	0x398
	.byte	0x1f
	.byte	0
	.uleb128 0x5
	.long	.LASF525
	.byte	0x8
	.byte	0xa
	.byte	0x3b
	.long	0x893
	.uleb128 0xf
	.string	"esp"
	.byte	0xa
	.byte	0x3c
	.long	0x5b
	.byte	0
	.uleb128 0xf
	.string	"eip"
	.byte	0xa
	.byte	0x3d
	.long	0x5b
	.byte	0x4
	.byte	0
	.uleb128 0x5
	.long	.LASF526
	.byte	0x44
	.byte	0xa
	.byte	0x41
	.long	0x966
	.uleb128 0xf
	.string	"ebx"
	.byte	0xa
	.byte	0x42
	.long	0x50
	.byte	0
	.uleb128 0xf
	.string	"ecx"
	.byte	0xa
	.byte	0x42
	.long	0x50
	.byte	0x4
	.uleb128 0xf
	.string	"edx"
	.byte	0xa
	.byte	0x42
	.long	0x50
	.byte	0x8
	.uleb128 0xf
	.string	"esi"
	.byte	0xa
	.byte	0x42
	.long	0x50
	.byte	0xc
	.uleb128 0xf
	.string	"edi"
	.byte	0xa
	.byte	0x43
	.long	0x50
	.byte	0x10
	.uleb128 0xf
	.string	"ebp"
	.byte	0xa
	.byte	0x43
	.long	0x50
	.byte	0x14
	.uleb128 0xf
	.string	"eax"
	.byte	0xa
	.byte	0x43
	.long	0x50
	.byte	0x18
	.uleb128 0xf
	.string	"ds"
	.byte	0xa
	.byte	0x44
	.long	0x50
	.byte	0x1c
	.uleb128 0xf
	.string	"es"
	.byte	0xa
	.byte	0x44
	.long	0x50
	.byte	0x20
	.uleb128 0xf
	.string	"gs"
	.byte	0xa
	.byte	0x44
	.long	0x50
	.byte	0x24
	.uleb128 0xf
	.string	"fs"
	.byte	0xa
	.byte	0x44
	.long	0x50
	.byte	0x28
	.uleb128 0x6
	.long	.LASF527
	.byte	0xa
	.byte	0x45
	.long	0x50
	.byte	0x2c
	.uleb128 0xf
	.string	"eip"
	.byte	0xa
	.byte	0x46
	.long	0x50
	.byte	0x30
	.uleb128 0xf
	.string	"cs"
	.byte	0xa
	.byte	0x46
	.long	0x50
	.byte	0x34
	.uleb128 0x6
	.long	.LASF528
	.byte	0xa
	.byte	0x46
	.long	0x50
	.byte	0x38
	.uleb128 0xf
	.string	"esp"
	.byte	0xa
	.byte	0x46
	.long	0x50
	.byte	0x3c
	.uleb128 0xf
	.string	"ss"
	.byte	0xa
	.byte	0x46
	.long	0x50
	.byte	0x40
	.byte	0
	.uleb128 0x10
	.long	.LASF529
	.byte	0xa
	.byte	0x47
	.long	0x893
	.uleb128 0x5
	.long	.LASF530
	.byte	0x24
	.byte	0xa
	.byte	0x4a
	.long	0x996
	.uleb128 0x6
	.long	.LASF531
	.byte	0xa
	.byte	0x4b
	.long	0x996
	.byte	0
	.uleb128 0xf
	.string	"esp"
	.byte	0xa
	.byte	0x4c
	.long	0x70
	.byte	0x20
	.byte	0
	.uleb128 0x11
	.long	0x70
	.long	0x9a6
	.uleb128 0x12
	.long	0x398
	.byte	0x7
	.byte	0
	.uleb128 0x8
	.byte	0x90
	.byte	0xa
	.byte	0x54
	.long	0xa91
	.uleb128 0x6
	.long	.LASF532
	.byte	0xa
	.byte	0x55
	.long	0x70
	.byte	0
	.uleb128 0x6
	.long	.LASF533
	.byte	0xa
	.byte	0x56
	.long	0x70
	.byte	0x4
	.uleb128 0x6
	.long	.LASF423
	.byte	0xa
	.byte	0x57
	.long	0xab2
	.byte	0x8
	.uleb128 0x6
	.long	.LASF424
	.byte	0xa
	.byte	0x58
	.long	0xab2
	.byte	0xc
	.uleb128 0xf
	.string	"pid"
	.byte	0xa
	.byte	0x59
	.long	0x50
	.byte	0x10
	.uleb128 0x6
	.long	.LASF534
	.byte	0xa
	.byte	0x5a
	.long	0x6e3
	.byte	0x14
	.uleb128 0x6
	.long	.LASF535
	.byte	0xa
	.byte	0x5b
	.long	0x50
	.byte	0x24
	.uleb128 0x6
	.long	.LASF536
	.byte	0xa
	.byte	0x5c
	.long	0x50
	.byte	0x28
	.uleb128 0x6
	.long	.LASF537
	.byte	0xa
	.byte	0x5c
	.long	0x50
	.byte	0x2c
	.uleb128 0x6
	.long	.LASF538
	.byte	0xa
	.byte	0x5d
	.long	0x50
	.byte	0x30
	.uleb128 0x6
	.long	.LASF539
	.byte	0xa
	.byte	0x5d
	.long	0x50
	.byte	0x34
	.uleb128 0xf
	.string	"mm"
	.byte	0xa
	.byte	0x5e
	.long	0x636
	.byte	0x38
	.uleb128 0x6
	.long	.LASF525
	.byte	0xa
	.byte	0x5f
	.long	0x86e
	.byte	0x3c
	.uleb128 0xf
	.string	"fs"
	.byte	0xa
	.byte	0x60
	.long	0xab8
	.byte	0x44
	.uleb128 0x6
	.long	.LASF540
	.byte	0xa
	.byte	0x61
	.long	0xabe
	.byte	0x48
	.uleb128 0x6
	.long	.LASF541
	.byte	0xa
	.byte	0x62
	.long	0xac4
	.byte	0x4c
	.uleb128 0x6
	.long	.LASF542
	.byte	0xa
	.byte	0x63
	.long	0x971
	.byte	0x64
	.uleb128 0x6
	.long	.LASF543
	.byte	0xa
	.byte	0x64
	.long	0x50
	.byte	0x88
	.uleb128 0x6
	.long	.LASF544
	.byte	0xa
	.byte	0x65
	.long	0x50
	.byte	0x8c
	.byte	0
	.uleb128 0x19
	.string	"pcb"
	.value	0x2000
	.byte	0xa
	.byte	0x52
	.long	0xab2
	.uleb128 0x1a
	.long	0xad4
	.byte	0
	.uleb128 0x1b
	.long	.LASF545
	.byte	0xa
	.byte	0x69
	.long	0x966
	.value	0x1fbc
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xa91
	.uleb128 0x7
	.byte	0x4
	.long	0x6fa
	.uleb128 0x7
	.byte	0x4
	.long	0x81b
	.uleb128 0x11
	.long	0x6be
	.long	0xad4
	.uleb128 0x12
	.long	0x398
	.byte	0x2
	.byte	0
	.uleb128 0x1c
	.value	0x1fbc
	.byte	0xa
	.byte	0x53
	.long	0xaee
	.uleb128 0xd
	.long	0x9a6
	.uleb128 0xc
	.long	.LASF452
	.byte	0xa
	.byte	0x67
	.long	0xaee
	.byte	0
	.uleb128 0x11
	.long	0x6f3
	.long	0xaff
	.uleb128 0x1d
	.long	0x398
	.value	0x1fbb
	.byte	0
	.uleb128 0x1e
	.long	.LASF546
	.value	0x20c
	.byte	0x8
	.byte	0x33
	.long	0xb3d
	.uleb128 0x6
	.long	.LASF515
	.byte	0x8
	.byte	0x34
	.long	0xd0e
	.byte	0
	.uleb128 0x6
	.long	.LASF509
	.byte	0x8
	.byte	0x35
	.long	0x7af
	.byte	0x4
	.uleb128 0xf
	.string	"dev"
	.byte	0x8
	.byte	0x36
	.long	0x3e
	.byte	0x8
	.uleb128 0x6
	.long	.LASF547
	.byte	0x8
	.byte	0x37
	.long	0xd14
	.byte	0xa
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xaff
	.uleb128 0x5
	.long	.LASF548
	.byte	0xc
	.byte	0xb
	.byte	0x9
	.long	0xb74
	.uleb128 0x6
	.long	.LASF514
	.byte	0xb
	.byte	0xa
	.long	0xb74
	.byte	0
	.uleb128 0xf
	.string	"len"
	.byte	0xb
	.byte	0xb
	.long	0x70
	.byte	0x4
	.uleb128 0x6
	.long	.LASF517
	.byte	0xb
	.byte	0xc
	.long	0x5b
	.byte	0x8
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xb7a
	.uleb128 0x1f
	.long	0x6f3
	.uleb128 0x5
	.long	.LASF549
	.byte	0x4
	.byte	0xb
	.byte	0xe
	.long	0xb98
	.uleb128 0x6
	.long	.LASF550
	.byte	0xb
	.byte	0xf
	.long	0xbb2
	.byte	0
	.byte	0
	.uleb128 0x16
	.long	0x70
	.long	0xbac
	.uleb128 0x15
	.long	0xbac
	.uleb128 0x15
	.long	0xbac
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xb43
	.uleb128 0x7
	.byte	0x4
	.long	0xb98
	.uleb128 0x5
	.long	.LASF512
	.byte	0xa8
	.byte	0x8
	.byte	0x20
	.long	0xc48
	.uleb128 0xf
	.string	"ino"
	.byte	0x8
	.byte	0x21
	.long	0x5b
	.byte	0
	.uleb128 0xf
	.string	"dev"
	.byte	0x8
	.byte	0x22
	.long	0x3e
	.byte	0x4
	.uleb128 0x6
	.long	.LASF551
	.byte	0x8
	.byte	0x23
	.long	0x3e
	.byte	0x6
	.uleb128 0x6
	.long	.LASF552
	.byte	0x8
	.byte	0x24
	.long	0x50
	.byte	0x8
	.uleb128 0x6
	.long	.LASF553
	.byte	0x8
	.byte	0x25
	.long	0x50
	.byte	0xc
	.uleb128 0x6
	.long	.LASF554
	.byte	0x8
	.byte	0x26
	.long	0x50
	.byte	0x10
	.uleb128 0xf
	.string	"sb"
	.byte	0x8
	.byte	0x27
	.long	0xb3d
	.byte	0x14
	.uleb128 0x6
	.long	.LASF515
	.byte	0x8
	.byte	0x28
	.long	0xc87
	.byte	0x18
	.uleb128 0x6
	.long	.LASF555
	.byte	0x8
	.byte	0x29
	.long	0xcca
	.byte	0x1c
	.uleb128 0x6
	.long	.LASF517
	.byte	0x8
	.byte	0x2a
	.long	0x7e
	.byte	0x20
	.uleb128 0x6
	.long	.LASF547
	.byte	0x8
	.byte	0x2d
	.long	0xcd0
	.byte	0x28
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xbb8
	.uleb128 0x7
	.byte	0x4
	.long	0xb7f
	.uleb128 0x5
	.long	.LASF556
	.byte	0x4
	.byte	0x8
	.byte	0x11
	.long	0xc6d
	.uleb128 0x6
	.long	.LASF557
	.byte	0x8
	.byte	0x1a
	.long	0xc81
	.byte	0
	.byte	0
	.uleb128 0x16
	.long	0x70
	.long	0xc81
	.uleb128 0x15
	.long	0xc48
	.uleb128 0x15
	.long	0x7af
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xc6d
	.uleb128 0x7
	.byte	0x4
	.long	0xc54
	.uleb128 0x5
	.long	.LASF558
	.byte	0x10
	.byte	0x8
	.byte	0x55
	.long	0xcca
	.uleb128 0x6
	.long	.LASF559
	.byte	0x8
	.byte	0x56
	.long	0xd40
	.byte	0
	.uleb128 0x6
	.long	.LASF560
	.byte	0x8
	.byte	0x57
	.long	0xd70
	.byte	0x4
	.uleb128 0x6
	.long	.LASF496
	.byte	0x8
	.byte	0x59
	.long	0xd8a
	.byte	0x8
	.uleb128 0x6
	.long	.LASF561
	.byte	0x8
	.byte	0x5a
	.long	0xd9f
	.byte	0xc
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xc8d
	.uleb128 0x11
	.long	0x6f3
	.long	0xce0
	.uleb128 0x12
	.long	0x398
	.byte	0x7f
	.byte	0
	.uleb128 0x5
	.long	.LASF562
	.byte	0x4
	.byte	0x8
	.byte	0x30
	.long	0xcf9
	.uleb128 0x6
	.long	.LASF563
	.byte	0x8
	.byte	0x31
	.long	0xd08
	.byte	0
	.byte	0
	.uleb128 0x16
	.long	0x70
	.long	0xd08
	.uleb128 0x15
	.long	0xc48
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xcf9
	.uleb128 0x7
	.byte	0x4
	.long	0xce0
	.uleb128 0x11
	.long	0x6f3
	.long	0xd25
	.uleb128 0x1d
	.long	0x398
	.value	0x1ff
	.byte	0
	.uleb128 0x20
	.byte	0x4
	.uleb128 0x16
	.long	0x70
	.long	0xd40
	.uleb128 0x15
	.long	0x697
	.uleb128 0x15
	.long	0x70
	.uleb128 0x15
	.long	0x5b
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xd27
	.uleb128 0x16
	.long	0x70
	.long	0xd64
	.uleb128 0x15
	.long	0x697
	.uleb128 0x15
	.long	0xd64
	.uleb128 0x15
	.long	0x5b
	.uleb128 0x15
	.long	0xd6a
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x6f3
	.uleb128 0x7
	.byte	0x4
	.long	0x5b
	.uleb128 0x7
	.byte	0x4
	.long	0xd46
	.uleb128 0x16
	.long	0x70
	.long	0xd8a
	.uleb128 0x15
	.long	0xc48
	.uleb128 0x15
	.long	0x697
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xd76
	.uleb128 0x16
	.long	0x70
	.long	0xd9f
	.uleb128 0x15
	.long	0x697
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xd90
	.uleb128 0x1c
	.value	0x100
	.byte	0xd
	.byte	0xc
	.long	0xdc5
	.uleb128 0xc
	.long	.LASF477
	.byte	0xd
	.byte	0xd
	.long	0xdc5
	.uleb128 0xc
	.long	.LASF564
	.byte	0xd
	.byte	0xe
	.long	0xdd5
	.byte	0
	.uleb128 0x11
	.long	0x4b2
	.long	0xdd5
	.uleb128 0x12
	.long	0x398
	.byte	0x9
	.byte	0
	.uleb128 0x11
	.long	0x6f3
	.long	0xde5
	.uleb128 0x12
	.long	0x398
	.byte	0xff
	.byte	0
	.uleb128 0x1e
	.long	.LASF565
	.value	0x104
	.byte	0xd
	.byte	0xa
	.long	0xe05
	.uleb128 0x6
	.long	.LASF566
	.byte	0xd
	.byte	0xb
	.long	0x5b
	.byte	0
	.uleb128 0x1a
	.long	0xda5
	.byte	0x4
	.byte	0
	.uleb128 0x21
	.long	.LASF569
	.byte	0x1
	.byte	0x6d
	.long	0xd25
	.long	.LFB22
	.long	.LFE22-.LFB22
	.uleb128 0x1
	.byte	0x9c
	.long	0xe49
	.uleb128 0x22
	.long	.LASF567
	.byte	0x1
	.byte	0x6d
	.long	0x50
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x22
	.long	.LASF568
	.byte	0x1
	.byte	0x6d
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x23
	.string	"ppg"
	.byte	0x1
	.byte	0x6e
	.long	0x50
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0x21
	.long	.LASF570
	.byte	0x1
	.byte	0x77
	.long	0xd25
	.long	.LFB24
	.long	.LFE24-.LFB24
	.uleb128 0x1
	.byte	0x9c
	.long	0xe71
	.uleb128 0x24
	.string	"gfp"
	.byte	0x1
	.byte	0x77
	.long	0x50
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x25
	.long	.LASF573
	.byte	0x2
	.byte	0x10
	.long	.LFB51
	.long	.LFE51-.LFB51
	.uleb128 0x1
	.byte	0x9c
	.long	0xec7
	.uleb128 0x26
	.long	.LASF566
	.byte	0x2
	.byte	0x15
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x26
	.long	.LASF571
	.byte	0x2
	.byte	0x16
	.long	0xec7
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x26
	.long	.LASF572
	.byte	0x2
	.byte	0x21
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x27
	.long	.LBB2
	.long	.LBE2-.LBB2
	.uleb128 0x23
	.string	"i"
	.byte	0x2
	.byte	0x18
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x4b2
	.uleb128 0x25
	.long	.LASF574
	.byte	0x2
	.byte	0x30
	.long	.LFB52
	.long	.LFE52-.LFB52
	.uleb128 0x1
	.byte	0x9c
	.long	0xf43
	.uleb128 0x24
	.string	"dir"
	.byte	0x2
	.byte	0x30
	.long	0xf43
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x24
	.string	"vpg"
	.byte	0x2
	.byte	0x30
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x24
	.string	"ppg"
	.byte	0x2
	.byte	0x30
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0x24
	.string	"us"
	.byte	0x2
	.byte	0x30
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 12
	.uleb128 0x24
	.string	"rw"
	.byte	0x2
	.byte	0x30
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 16
	.uleb128 0x26
	.long	.LASF575
	.byte	0x2
	.byte	0x33
	.long	0xf43
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x23
	.string	"tbl"
	.byte	0x2
	.byte	0x39
	.long	0xf43
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x50
	.uleb128 0x25
	.long	.LASF576
	.byte	0x2
	.byte	0x44
	.long	.LFB53
	.long	.LFE53-.LFB53
	.uleb128 0x1
	.byte	0x9c
	.long	0x1024
	.uleb128 0x23
	.string	"dir"
	.byte	0x2
	.byte	0x4b
	.long	0xd6a
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x26
	.long	.LASF473
	.byte	0x2
	.byte	0x4e
	.long	0x50
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x23
	.string	"end"
	.byte	0x2
	.byte	0x4f
	.long	0x50
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x28
	.long	.LBB3
	.long	.LBE3-.LBB3
	.long	0xfe5
	.uleb128 0x26
	.long	.LASF577
	.byte	0x2
	.byte	0x50
	.long	0x5b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x27
	.long	.LBB4
	.long	.LBE4-.LBB4
	.uleb128 0x23
	.string	"vpg"
	.byte	0x2
	.byte	0x51
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x23
	.string	"ppg"
	.byte	0x2
	.byte	0x52
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 -44
	.uleb128 0x27
	.long	.LBB5
	.long	.LBE5-.LBB5
	.uleb128 0x26
	.long	.LASF578
	.byte	0x2
	.byte	0x56
	.long	0x70
	.uleb128 0x5
	.byte	0x3
	.long	done.2000
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x27
	.long	.LBB6
	.long	.LBE6-.LBB6
	.uleb128 0x26
	.long	.LASF577
	.byte	0x2
	.byte	0x5f
	.long	0x5b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x27
	.long	.LBB7
	.long	.LBE7-.LBB7
	.uleb128 0x23
	.string	"vpg"
	.byte	0x2
	.byte	0x60
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x23
	.string	"ppg"
	.byte	0x2
	.byte	0x61
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 -52
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x25
	.long	.LASF579
	.byte	0x2
	.byte	0x69
	.long	.LFB54
	.long	.LFE54-.LFB54
	.uleb128 0x1
	.byte	0x9c
	.long	0x1045
	.uleb128 0x29
	.long	.LASF581
	.byte	0x2
	.byte	0x6d
	.long	0x1045
	.byte	0
	.uleb128 0x2
	.byte	0x1
	.byte	0x2
	.long	.LASF580
	.uleb128 0x2a
	.long	.LASF606
	.byte	0x2
	.byte	0x71
	.long	.LFB55
	.long	.LFE55-.LFB55
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x2b
	.long	.LASF607
	.uleb128 0x11
	.long	0x6f3
	.long	0x1072
	.uleb128 0x12
	.long	0x398
	.byte	0x3
	.byte	0
	.uleb128 0x2c
	.long	.LASF582
	.byte	0xe
	.byte	0x35
	.long	0x1062
	.uleb128 0x5
	.byte	0x3
	.long	mem_entity
	.uleb128 0x2c
	.long	.LASF583
	.byte	0x1
	.byte	0x1e
	.long	0x39f
	.uleb128 0x5
	.byte	0x3
	.long	mem_map
	.uleb128 0x2c
	.long	.LASF584
	.byte	0x1
	.byte	0x40
	.long	0x3a5
	.uleb128 0x5
	.byte	0x3
	.long	zone_dma
	.uleb128 0x2c
	.long	.LASF585
	.byte	0x1
	.byte	0x41
	.long	0x3a5
	.uleb128 0x5
	.byte	0x3
	.long	zone_normal
	.uleb128 0x2c
	.long	.LASF586
	.byte	0x1
	.byte	0x42
	.long	0x3a5
	.uleb128 0x5
	.byte	0x3
	.long	zone_highmem
	.uleb128 0x11
	.long	0x10d7
	.long	0x10d7
	.uleb128 0x12
	.long	0x398
	.byte	0x2
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x3a5
	.uleb128 0x2c
	.long	.LASF587
	.byte	0x1
	.byte	0x43
	.long	0x10c7
	.uleb128 0x5
	.byte	0x3
	.long	__zones
	.uleb128 0x11
	.long	0x5b
	.long	0x10fe
	.uleb128 0x12
	.long	0x398
	.byte	0x2
	.byte	0
	.uleb128 0x2c
	.long	.LASF588
	.byte	0x1
	.byte	0x44
	.long	0x10ee
	.uleb128 0x5
	.byte	0x3
	.long	size_of_zone
	.uleb128 0x2c
	.long	.LASF589
	.byte	0x2
	.byte	0xe
	.long	0x50
	.uleb128 0x5
	.byte	0x3
	.long	gmemsize
	.uleb128 0x2c
	.long	.LASF590
	.byte	0x2
	.byte	0xb
	.long	0x1131
	.uleb128 0x5
	.byte	0x3
	.long	vm_area_cache
	.uleb128 0x7
	.byte	0x4
	.long	0x105d
	.uleb128 0x2c
	.long	.LASF591
	.byte	0x2
	.byte	0xa
	.long	0x1131
	.uleb128 0x5
	.byte	0x3
	.long	mm_cache
	.uleb128 0x2c
	.long	.LASF592
	.byte	0x2
	.byte	0xc
	.long	0x1131
	.uleb128 0x5
	.byte	0x3
	.long	fs_struct_cache
	.uleb128 0x2c
	.long	.LASF593
	.byte	0x2
	.byte	0xd
	.long	0x1131
	.uleb128 0x5
	.byte	0x3
	.long	files_struct_cache
	.uleb128 0x2c
	.long	.LASF594
	.byte	0xa
	.byte	0x10
	.long	0xab2
	.uleb128 0x5
	.byte	0x3
	.long	__hs_pcb
	.uleb128 0x2c
	.long	.LASF595
	.byte	0xa
	.byte	0x11
	.long	0xab2
	.uleb128 0x5
	.byte	0x3
	.long	__ext_pcb
	.uleb128 0x2c
	.long	.LASF596
	.byte	0xb
	.byte	0x6
	.long	0xa3
	.uleb128 0x5
	.byte	0x3
	.long	dentry_hashtable
	.uleb128 0x2c
	.long	.LASF597
	.byte	0xb
	.byte	0x9e
	.long	0x1131
	.uleb128 0x5
	.byte	0x3
	.long	dentry_cache
	.uleb128 0x2c
	.long	.LASF598
	.byte	0x8
	.byte	0x45
	.long	0xa3
	.uleb128 0x5
	.byte	0x3
	.long	inode_hashtable
	.uleb128 0x2c
	.long	.LASF599
	.byte	0x8
	.byte	0x73
	.long	0x1131
	.uleb128 0x5
	.byte	0x3
	.long	inode_cache
	.uleb128 0x2c
	.long	.LASF600
	.byte	0x8
	.byte	0x74
	.long	0x1131
	.uleb128 0x5
	.byte	0x3
	.long	file_cache
	.uleb128 0x29
	.long	.LASF601
	.byte	0xd
	.byte	0x12
	.long	0xde5
	.uleb128 0x11
	.long	0x6f3
	.long	0x11fd
	.uleb128 0x1d
	.long	0x398
	.value	0x3ff
	.byte	0
	.uleb128 0x2c
	.long	.LASF602
	.byte	0x2
	.byte	0xf
	.long	0x11ec
	.uleb128 0x5
	.byte	0x3
	.long	testbuf
	.uleb128 0x29
	.long	.LASF581
	.byte	0x2
	.byte	0x6d
	.long	0x1045
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
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
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
	.uleb128 0x9
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
	.uleb128 0xa
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
	.uleb128 0xb
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
	.uleb128 0xc
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
	.uleb128 0xd
	.uleb128 0xd
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
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
	.uleb128 0xf
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
	.uleb128 0x10
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
	.uleb128 0x11
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x13
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
	.uleb128 0x14
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x16
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
	.uleb128 0x17
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
	.uleb128 0x18
	.uleb128 0x28
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1c
	.uleb128 0xd
	.byte	0
	.byte	0
	.uleb128 0x19
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
	.uleb128 0x1a
	.uleb128 0xd
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x1b
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
	.uleb128 0x1c
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
	.uleb128 0x1d
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x1e
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
	.uleb128 0x1f
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
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
	.uleb128 0x23
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
	.uleb128 0x24
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
	.uleb128 0x25
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
	.uleb128 0x26
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
	.uleb128 0x27
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x28
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x1
	.uleb128 0x13
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
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x2a
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
	.uleb128 0x2b
	.uleb128 0x13
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x2c
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
	.file 15 "./include/old/disp.h"
	.byte	0x3
	.uleb128 0x1
	.uleb128 0xf
	.byte	0x5
	.uleb128 0x2
	.long	.LASF228
	.byte	0x4
	.file 16 "./include/old/utils.h"
	.byte	0x3
	.uleb128 0x2
	.uleb128 0x10
	.byte	0x5
	.uleb128 0x2
	.long	.LASF229
	.byte	0x3
	.uleb128 0x3
	.uleb128 0xe
	.byte	0x5
	.uleb128 0x2
	.long	.LASF230
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x3
	.byte	0x7
	.long	.Ldebug_macro1
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro2
	.byte	0x4
	.file 17 "./include/linux/mylist.h"
	.byte	0x3
	.uleb128 0x4
	.uleb128 0x11
	.byte	0x7
	.long	.Ldebug_macro3
	.byte	0x4
	.file 18 "./include/linux/assert.h"
	.byte	0x3
	.uleb128 0x6
	.uleb128 0x12
	.byte	0x7
	.long	.Ldebug_macro4
	.byte	0x4
	.file 19 "./include/linux/byteorder/generic.h"
	.byte	0x3
	.uleb128 0x7
	.uleb128 0x13
	.byte	0x7
	.long	.Ldebug_macro5
	.byte	0x4
	.file 20 "./include/linux/string.h"
	.byte	0x3
	.uleb128 0x8
	.uleb128 0x14
	.byte	0x5
	.uleb128 0x2
	.long	.LASF280
	.byte	0x4
	.file 21 "./include/old/mm.h"
	.byte	0x3
	.uleb128 0x3c
	.uleb128 0x15
	.byte	0x5
	.uleb128 0x2
	.long	.LASF281
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x7
	.byte	0x5
	.uleb128 0x2
	.long	.LASF282
	.byte	0x3
	.uleb128 0x5
	.uleb128 0x10
	.byte	0x4
	.byte	0x3
	.uleb128 0x6
	.uleb128 0x4
	.byte	0x7
	.long	.Ldebug_macro6
	.byte	0x4
	.byte	0x3
	.uleb128 0x7
	.uleb128 0x1
	.byte	0x5
	.uleb128 0x2
	.long	.LASF287
	.byte	0x3
	.uleb128 0x4
	.uleb128 0x7
	.byte	0x4
	.byte	0x3
	.uleb128 0x5
	.uleb128 0x5
	.byte	0x7
	.long	.Ldebug_macro7
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro8
	.byte	0x4
	.file 22 "./include/old/pmm.h"
	.byte	0x3
	.uleb128 0x8
	.uleb128 0x16
	.byte	0x7
	.long	.Ldebug_macro9
	.byte	0x4
	.byte	0x3
	.uleb128 0x9
	.uleb128 0x6
	.byte	0x7
	.long	.Ldebug_macro10
	.byte	0x4
	.byte	0x5
	.uleb128 0x82
	.long	.LASF337
	.byte	0x4
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro11
	.byte	0x4
	.byte	0x3
	.uleb128 0x5
	.uleb128 0xa
	.byte	0x5
	.uleb128 0x2
	.long	.LASF348
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x3
	.byte	0x4
	.file 23 "./include/old/ku_proc.h"
	.byte	0x3
	.uleb128 0x5
	.uleb128 0x17
	.byte	0x7
	.long	.Ldebug_macro12
	.byte	0x4
	.byte	0x3
	.uleb128 0x7
	.uleb128 0x9
	.byte	0x5
	.uleb128 0x2
	.long	.LASF360
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro13
	.byte	0x3
	.uleb128 0x70
	.uleb128 0x8
	.byte	0x5
	.uleb128 0x2
	.long	.LASF369
	.byte	0x3
	.uleb128 0x3
	.uleb128 0xb
	.byte	0x5
	.uleb128 0x2
	.long	.LASF370
	.byte	0x3
	.uleb128 0x4
	.uleb128 0xc
	.byte	0x5
	.uleb128 0x2
	.long	.LASF371
	.byte	0x3
	.uleb128 0x3
	.uleb128 0xb
	.byte	0x4
	.byte	0x4
	.byte	0x5
	.uleb128 0x7
	.long	.LASF372
	.file 24 "./include/linux/slab.h"
	.byte	0x3
	.uleb128 0x9d
	.uleb128 0x18
	.byte	0x7
	.long	.Ldebug_macro14
	.byte	0x4
	.byte	0x4
	.byte	0x3
	.uleb128 0x4
	.uleb128 0xa
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro15
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro16
	.byte	0x4
	.byte	0x3
	.uleb128 0x6
	.uleb128 0xd
	.byte	0x7
	.long	.Ldebug_macro17
	.byte	0x4
	.file 25 "./include/old/elf.h"
	.byte	0x3
	.uleb128 0x7
	.uleb128 0x19
	.byte	0x7
	.long	.Ldebug_macro18
	.byte	0x4
	.file 26 "./include/old/fork.h"
	.byte	0x3
	.uleb128 0x8
	.uleb128 0x1a
	.byte	0x5
	.uleb128 0x2
	.long	.LASF414
	.byte	0x4
	.byte	0x4
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.valType.h.3.7c3190cc3f15c77f186fd44ab736eede,comdat
.Ldebug_macro1:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x3
	.long	.LASF231
	.byte	0x5
	.uleb128 0x5
	.long	.LASF232
	.byte	0x5
	.uleb128 0x6
	.long	.LASF233
	.byte	0x5
	.uleb128 0x7
	.long	.LASF234
	.byte	0x5
	.uleb128 0x8
	.long	.LASF235
	.byte	0x5
	.uleb128 0x9
	.long	.LASF236
	.byte	0x5
	.uleb128 0xb
	.long	.LASF237
	.byte	0x5
	.uleb128 0x39
	.long	.LASF238
	.byte	0x5
	.uleb128 0x3a
	.long	.LASF239
	.byte	0x5
	.uleb128 0x3b
	.long	.LASF240
	.byte	0x5
	.uleb128 0x3c
	.long	.LASF241
	.byte	0x5
	.uleb128 0x3d
	.long	.LASF242
	.byte	0x5
	.uleb128 0x3e
	.long	.LASF243
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.ku_utils.h.4.65f3e6564a5123768a74f8d300528221,comdat
.Ldebug_macro2:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x4
	.long	.LASF244
	.byte	0x5
	.uleb128 0x5
	.long	.LASF245
	.byte	0x5
	.uleb128 0x8
	.long	.LASF246
	.byte	0x5
	.uleb128 0x1f
	.long	.LASF247
	.byte	0x5
	.uleb128 0x2c
	.long	.LASF248
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.mylist.h.2.6dffd1aa01612dc930709a466e043124,comdat
.Ldebug_macro3:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF249
	.byte	0x5
	.uleb128 0x12
	.long	.LASF250
	.byte	0x5
	.uleb128 0x1b
	.long	.LASF251
	.byte	0x5
	.uleb128 0x2c
	.long	.LASF252
	.byte	0x5
	.uleb128 0x58
	.long	.LASF253
	.byte	0x5
	.uleb128 0x68
	.long	.LASF254
	.byte	0x5
	.uleb128 0x76
	.long	.LASF255
	.byte	0x5
	.uleb128 0x7f
	.long	.LASF256
	.byte	0x5
	.uleb128 0x94
	.long	.LASF257
	.byte	0x5
	.uleb128 0xaf
	.long	.LASF258
	.byte	0x5
	.uleb128 0xc8
	.long	.LASF259
	.byte	0x5
	.uleb128 0xd1
	.long	.LASF260
	.byte	0x5
	.uleb128 0xdb
	.long	.LASF261
	.byte	0x5
	.uleb128 0xe5
	.long	.LASF262
	.byte	0x5
	.uleb128 0xf2
	.long	.LASF263
	.byte	0x5
	.uleb128 0xfb
	.long	.LASF264
	.byte	0x5
	.uleb128 0x103
	.long	.LASF265
	.byte	0x5
	.uleb128 0x112
	.long	.LASF266
	.byte	0x5
	.uleb128 0x125
	.long	.LASF267
	.byte	0x5
	.uleb128 0x12d
	.long	.LASF268
	.byte	0x5
	.uleb128 0x144
	.long	.LASF269
	.byte	0x5
	.uleb128 0x155
	.long	.LASF270
	.byte	0x5
	.uleb128 0x163
	.long	.LASF271
	.byte	0x5
	.uleb128 0x16c
	.long	.LASF272
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.assert.h.2.04d8cd0d4ab92c4edaf5ee8e3da38922,comdat
.Ldebug_macro4:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF273
	.byte	0x5
	.uleb128 0x6
	.long	.LASF274
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.generic.h.2.080a533b5efade0c3c025e01b2a9592c,comdat
.Ldebug_macro5:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF275
	.byte	0x5
	.uleb128 0x13
	.long	.LASF276
	.byte	0x5
	.uleb128 0x14
	.long	.LASF277
	.byte	0x5
	.uleb128 0x16
	.long	.LASF278
	.byte	0x5
	.uleb128 0x17
	.long	.LASF279
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.list.h.2.c01f29f9717739ede2f0953eaf2ad283,comdat
.Ldebug_macro6:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF283
	.byte	0x5
	.uleb128 0xb
	.long	.LASF284
	.byte	0x5
	.uleb128 0x46
	.long	.LASF285
	.byte	0x5
	.uleb128 0x57
	.long	.LASF286
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.page.h.2.207eb50c0e81a8bc7de8e22e9a0f0426,comdat
.Ldebug_macro7:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF288
	.byte	0x5
	.uleb128 0x5
	.long	.LASF289
	.byte	0x5
	.uleb128 0x6
	.long	.LASF290
	.byte	0x5
	.uleb128 0x7
	.long	.LASF291
	.byte	0x5
	.uleb128 0x8
	.long	.LASF292
	.byte	0x5
	.uleb128 0x9
	.long	.LASF293
	.byte	0x5
	.uleb128 0xb
	.long	.LASF294
	.byte	0x5
	.uleb128 0xc
	.long	.LASF295
	.byte	0x5
	.uleb128 0xd
	.long	.LASF296
	.byte	0x5
	.uleb128 0xf
	.long	.LASF297
	.byte	0x5
	.uleb128 0x10
	.long	.LASF298
	.byte	0x5
	.uleb128 0x16
	.long	.LASF299
	.byte	0x5
	.uleb128 0x1c
	.long	.LASF300
	.byte	0x5
	.uleb128 0x1d
	.long	.LASF301
	.byte	0x5
	.uleb128 0x20
	.long	.LASF302
	.byte	0x5
	.uleb128 0x21
	.long	.LASF303
	.byte	0x5
	.uleb128 0x64
	.long	.LASF304
	.byte	0x5
	.uleb128 0x65
	.long	.LASF305
	.byte	0x5
	.uleb128 0x66
	.long	.LASF306
	.byte	0x5
	.uleb128 0x6f
	.long	.LASF307
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.mmzone.h.7.e3c9150cc58cba9f45f09d3f9a9fdf77,comdat
.Ldebug_macro8:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x7
	.long	.LASF308
	.byte	0x5
	.uleb128 0x18
	.long	.LASF309
	.byte	0x5
	.uleb128 0x19
	.long	.LASF310
	.byte	0x5
	.uleb128 0x1a
	.long	.LASF311
	.byte	0x5
	.uleb128 0x1b
	.long	.LASF312
	.byte	0x5
	.uleb128 0x1c
	.long	.LASF313
	.byte	0x5
	.uleb128 0x1d
	.long	.LASF314
	.byte	0x5
	.uleb128 0x20
	.long	.LASF315
	.byte	0x5
	.uleb128 0x22
	.long	.LASF316
	.byte	0x5
	.uleb128 0x23
	.long	.LASF317
	.byte	0x5
	.uleb128 0x24
	.long	.LASF318
	.byte	0x5
	.uleb128 0x25
	.long	.LASF319
	.byte	0x5
	.uleb128 0x26
	.long	.LASF320
	.byte	0x5
	.uleb128 0x28
	.long	.LASF321
	.byte	0x5
	.uleb128 0x29
	.long	.LASF322
	.byte	0x5
	.uleb128 0x2a
	.long	.LASF323
	.byte	0x5
	.uleb128 0x2b
	.long	.LASF324
	.byte	0x5
	.uleb128 0x2d
	.long	.LASF325
	.byte	0x5
	.uleb128 0x2e
	.long	.LASF326
	.byte	0x5
	.uleb128 0x2f
	.long	.LASF327
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.pmm.h.2.0ed63dcb6cf5b539e5b580d439a8fe22,comdat
.Ldebug_macro9:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF328
	.byte	0x5
	.uleb128 0x8
	.long	.LASF329
	.byte	0x5
	.uleb128 0x9
	.long	.LASF330
	.byte	0x5
	.uleb128 0xf
	.long	.LASF331
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.sched.h.2.5f20ed4187e2b315e38086c6f42d15cd,comdat
.Ldebug_macro10:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF332
	.byte	0x5
	.uleb128 0xa
	.long	.LASF333
	.byte	0x5
	.uleb128 0xb
	.long	.LASF334
	.byte	0x5
	.uleb128 0xc
	.long	.LASF335
	.byte	0x5
	.uleb128 0xd
	.long	.LASF336
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.utils.h.64.4303da2b831b2923c55728136f07b37e,comdat
.Ldebug_macro11:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x40
	.long	.LASF338
	.byte	0x5
	.uleb128 0x41
	.long	.LASF339
	.byte	0x5
	.uleb128 0x7a
	.long	.LASF340
	.byte	0x5
	.uleb128 0x7f
	.long	.LASF341
	.byte	0x5
	.uleb128 0x80
	.long	.LASF342
	.byte	0x5
	.uleb128 0x81
	.long	.LASF343
	.byte	0x5
	.uleb128 0x82
	.long	.LASF344
	.byte	0x5
	.uleb128 0x96
	.long	.LASF345
	.byte	0x5
	.uleb128 0xe6
	.long	.LASF346
	.byte	0x5
	.uleb128 0xf0
	.long	.LASF347
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.ku_proc.h.3.dde670f70c5d84b57ae6d3e9345b9deb,comdat
.Ldebug_macro12:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x3
	.long	.LASF349
	.byte	0x5
	.uleb128 0x5
	.long	.LASF350
	.byte	0x5
	.uleb128 0x6
	.long	.LASF351
	.byte	0x5
	.uleb128 0x7
	.long	.LASF352
	.byte	0x5
	.uleb128 0x8
	.long	.LASF353
	.byte	0x5
	.uleb128 0x9
	.long	.LASF354
	.byte	0x5
	.uleb128 0xa
	.long	.LASF355
	.byte	0x5
	.uleb128 0xb
	.long	.LASF356
	.byte	0x5
	.uleb128 0xc
	.long	.LASF357
	.byte	0x5
	.uleb128 0xd
	.long	.LASF358
	.byte	0x5
	.uleb128 0xe
	.long	.LASF359
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.proc.h.9.787373a02089489eee7b84d8741fae40,comdat
.Ldebug_macro13:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x9
	.long	.LASF361
	.byte	0x5
	.uleb128 0xc
	.long	.LASF362
	.byte	0x5
	.uleb128 0x16
	.long	.LASF363
	.byte	0x5
	.uleb128 0x2b
	.long	.LASF364
	.byte	0x5
	.uleb128 0x49
	.long	.LASF365
	.byte	0x5
	.uleb128 0x4e
	.long	.LASF366
	.byte	0x5
	.uleb128 0x4f
	.long	.LASF367
	.byte	0x5
	.uleb128 0x6d
	.long	.LASF368
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.slab.h.2.e2f5bf1bbed146f27a60b3aa1d730158,comdat
.Ldebug_macro14:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF373
	.byte	0x5
	.uleb128 0x5
	.long	.LASF374
	.byte	0x5
	.uleb128 0x6
	.long	.LASF375
	.byte	0x5
	.uleb128 0x7
	.long	.LASF376
	.byte	0x5
	.uleb128 0x9
	.long	.LASF377
	.byte	0x5
	.uleb128 0xa
	.long	.LASF378
	.byte	0x5
	.uleb128 0x12
	.long	.LASF379
	.byte	0x5
	.uleb128 0x1c
	.long	.LASF380
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.fs.h.11.a65a17799966213b91b406978697ab7b,comdat
.Ldebug_macro15:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0xb
	.long	.LASF381
	.byte	0x5
	.uleb128 0xd
	.long	.LASF382
	.byte	0x5
	.uleb128 0xf
	.long	.LASF383
	.byte	0x5
	.uleb128 0x2c
	.long	.LASF384
	.byte	0x5
	.uleb128 0x46
	.long	.LASF385
	.byte	0x5
	.uleb128 0x7a
	.long	.LASF386
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.proc.h.141.8c77b34ef2b417fda52f0c261904a280,comdat
.Ldebug_macro16:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x8d
	.long	.LASF387
	.byte	0x5
	.uleb128 0xa1
	.long	.LASF388
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.bootinfo.h.2.63a8e433d1db63bb8ccaac3434455f8e,comdat
.Ldebug_macro17:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF389
	.byte	0x5
	.uleb128 0x13
	.long	.LASF390
	.byte	0x5
	.uleb128 0x1a
	.long	.LASF391
	.byte	0x5
	.uleb128 0x1c
	.long	.LASF392
	.byte	0x5
	.uleb128 0x1f
	.long	.LASF393
	.byte	0x5
	.uleb128 0x22
	.long	.LASF394
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.elf.h.2.e45df630c9e4543fa7605e11ca3dd584,comdat
.Ldebug_macro18:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF395
	.byte	0x5
	.uleb128 0x23
	.long	.LASF396
	.byte	0x5
	.uleb128 0x24
	.long	.LASF397
	.byte	0x5
	.uleb128 0x25
	.long	.LASF398
	.byte	0x5
	.uleb128 0x28
	.long	.LASF399
	.byte	0x5
	.uleb128 0x29
	.long	.LASF400
	.byte	0x5
	.uleb128 0x2a
	.long	.LASF401
	.byte	0x5
	.uleb128 0x2b
	.long	.LASF402
	.byte	0x5
	.uleb128 0x2c
	.long	.LASF403
	.byte	0x5
	.uleb128 0x2d
	.long	.LASF404
	.byte	0x5
	.uleb128 0x2e
	.long	.LASF405
	.byte	0x5
	.uleb128 0x2f
	.long	.LASF406
	.byte	0x5
	.uleb128 0x30
	.long	.LASF407
	.byte	0x5
	.uleb128 0x31
	.long	.LASF408
	.byte	0x5
	.uleb128 0x32
	.long	.LASF409
	.byte	0x5
	.uleb128 0x33
	.long	.LASF410
	.byte	0x5
	.uleb128 0x34
	.long	.LASF411
	.byte	0x5
	.uleb128 0x36
	.long	.LASF412
	.byte	0x5
	.uleb128 0x39
	.long	.LASF413
	.byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF481:
	.string	"len_high"
.LASF77:
	.string	"__PTRDIFF_MAX__ 2147483647"
.LASF588:
	.string	"size_of_zone"
.LASF179:
	.string	"__DEC64_SUBNORMAL_MIN__ 0.000000000000001E-383DD"
.LASF144:
	.string	"__DBL_DECIMAL_DIG__ 17"
.LASF121:
	.string	"__FLT_EVAL_METHOD__ 2"
.LASF562:
	.string	"super_operations"
.LASF132:
	.string	"__FLT_MIN__ 1.17549435082228750797e-38F"
.LASF446:
	.string	"cow_shared"
.LASF577:
	.string	"vaddr"
.LASF451:
	.string	"debug"
.LASF205:
	.string	"__GCC_ATOMIC_TEST_AND_SET_TRUEVAL 1"
.LASF474:
	.string	"empty_pte"
.LASF508:
	.string	"fs_struct"
.LASF355:
	.string	"MSGTYPE_HS_READY 4"
.LASF93:
	.string	"__INT_LEAST8_MAX__ 127"
.LASF253:
	.ascii	"LL_INSERT(list,location,new) do{ assert( ( (list) == (locati"
	.ascii	"on) ) || ( (list) &"
	.string	"& (location) ) ); assert((new)); if(!list && !location) { list = new; new->next = new->prev = 0; break; } new->next=location; new->prev=location->prev; if(location->prev) location->prev->next=new; location->prev=new; if(list==location) list=new; } while(0)"
.LASF349:
	.string	"KU_PROC_H "
.LASF486:
	.string	"mayread"
.LASF85:
	.string	"__INT8_MAX__ 127"
.LASF552:
	.string	"mktime"
.LASF102:
	.string	"__UINT8_C(c) c"
.LASF569:
	.string	"__alloc_pages"
.LASF483:
	.string	"readable"
.LASF393:
	.string	"g_memseg_num (*(unsigned*)KV(&_memseg_num))"
.LASF71:
	.string	"__LONG_MAX__ 2147483647L"
.LASF510:
	.string	"rootmnt"
.LASF467:
	.string	"end_code"
.LASF228:
	.string	"DISP_H "
.LASF140:
	.string	"__DBL_MIN_EXP__ (-1021)"
.LASF413:
	.string	"PH_SIZE (sizeof(Elf32_Phdr))"
.LASF66:
	.string	"__has_include_next(STR) __has_include_next__(STR)"
.LASF399:
	.string	"PT_NULL 0"
.LASF590:
	.string	"vm_area_cache"
.LASF431:
	.string	"flags"
.LASF309:
	.string	"page_idx(page_t) ((unsigned)((page_t) - mem_map))"
.LASF210:
	.string	"__SIZEOF_WINT_T__ 4"
.LASF211:
	.string	"__SIZEOF_PTRDIFF_T__ 4"
.LASF319:
	.string	"__GFP_HIGHMEM (1<<2)"
.LASF267:
	.string	"O_INSERT_AFTER(_prev,new) ({ new->next = _prev->next; new->prev = _prev; _prev->next->prev = new; _prev->next = new; })"
.LASF433:
	.string	"protection"
.LASF572:
	.string	"mapsize"
.LASF162:
	.string	"__LDBL_DENORM_MIN__ 3.64519953188247460253e-4951L"
.LASF317:
	.string	"__GFP_ZERO (1<<0)"
.LASF419:
	.string	"unsigned int"
.LASF424:
	.string	"next"
.LASF301:
	.string	"__pa2page_t(paddr) (mem_map + ((paddr) >> 12))"
.LASF21:
	.string	"__SIZEOF_SIZE_T__ 4"
.LASF36:
	.string	"__CHAR16_TYPE__ short unsigned int"
.LASF397:
	.string	"PF_W 0x2"
.LASF25:
	.string	"__ORDER_BIG_ENDIAN__ 4321"
.LASF511:
	.string	"pwdmnt"
.LASF470:
	.string	"start_brk"
.LASF532:
	.string	"need_resched"
.LASF138:
	.string	"__DBL_MANT_DIG__ 53"
.LASF477:
	.string	"mem_seginfo"
.LASF361:
	.string	"P_NAME_MAX 16"
.LASF10:
	.string	"__ATOMIC_RELEASE 3"
.LASF310:
	.string	"pte_pfn(pte) ((pte)>>PAGE_SHIFT)"
.LASF78:
	.string	"__SIZE_MAX__ 4294967295U"
.LASF436:
	.string	"dirty_rsv"
.LASF521:
	.string	"files_struct"
.LASF40:
	.string	"__INT16_TYPE__ short int"
.LASF171:
	.string	"__DEC32_EPSILON__ 1E-6DF"
.LASF354:
	.string	"MSGTYPE_HD_DONE 3"
.LASF15:
	.string	"__SIZEOF_LONG__ 4"
.LASF306:
	.string	"__va(paddr) ((unsigned)(paddr) + PAGE_OFFSET)"
.LASF472:
	.string	"vm_area"
.LASF8:
	.string	"__ATOMIC_SEQ_CST 5"
.LASF308:
	.string	"G_PGNUM (gmemsize>>12)"
.LASF522:
	.string	"max_fds"
.LASF17:
	.string	"__SIZEOF_SHORT__ 2"
.LASF63:
	.string	"__INTPTR_TYPE__ int"
.LASF47:
	.string	"__INT_LEAST8_TYPE__ signed char"
.LASF460:
	.string	"free_pages"
.LASF285:
	.ascii	"LIST_FIND2(stru"
	.string	"_t,mb_t,root,key,value,result) do{ struct list_head * node = root->next; stru_t *obj; while(node != root){ *obj = MB2STRU(stru_t, node, mb_t); if( (obj)->key == value ) break; node = node->next; } if(node == root) result = 0; else result = obj; } while(0);"
.LASF82:
	.string	"__UINTMAX_C(c) c ## ULL"
.LASF459:
	.string	"zone_struct"
.LASF407:
	.string	"PT_LOOS 0x60000000"
.LASF403:
	.string	"PT_NOTE 4"
.LASF598:
	.string	"inode_hashtable"
.LASF27:
	.string	"__BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__"
.LASF101:
	.string	"__UINT_LEAST8_MAX__ 255"
.LASF500:
	.string	"mode"
.LASF255:
	.string	"LL_I2(root,new) do{ assert(root); if(root->next) root->next->prev = new; new->next = root->next; new->prev = root; root->next = new; }while(0)"
.LASF423:
	.string	"prev"
.LASF74:
	.string	"__WCHAR_MIN__ (-__WCHAR_MAX__ - 1)"
.LASF489:
	.string	"mayshare"
.LASF401:
	.string	"PT_DYNAMIC 2"
.LASF131:
	.string	"__FLT_MAX__ 3.40282346638528859812e+38F"
.LASF186:
	.string	"__DEC128_SUBNORMAL_MIN__ 0.000000000000000000000000000000001E-6143DL"
.LASF246:
	.ascii	"eat_hex(pt,x) char*__pt=(pt); x=0; if(*__pt!='0'||*(__pt+1)!"
	.ascii	"='x'){ x=-1; goto donothing; } __pt+=2; if(!((*__pt>='0'&&*_"
	.ascii	"_pt<='9'"
	.string	")||(*__pt>='a'&&*__pt<='f'))){ x=-1; goto donothing; } while((*__pt>='0'&&*__pt<='9')||(*__pt>='a'&&*__pt<='f')) __pt++; __pt--; int __len=__pt-pt+1-2; for(int __i=0;__i<__len;__i++){ x+=hex_int(*__pt)*pow_int(16,__i); __pt--; } (pt)+=(2+__len);donothing:;"
.LASF476:
	.string	"pgoff"
.LASF542:
	.string	"fstack"
.LASF545:
	.string	"regs"
.LASF320:
	.string	"__GFP_NORMAL (1<<3)"
.LASF209:
	.string	"__SIZEOF_WCHAR_T__ 4"
.LASF348:
	.string	"PROC_H "
.LASF302:
	.string	"pte2page(pte) ((void *)__va((pte).value & PAGE_MASK))"
.LASF362:
	.string	"g_tss (&base_tss)"
.LASF227:
	.string	"__DECIMAL_BID_FORMAT__ 1"
.LASF350:
	.string	"MSGTYPE_TIMER 255"
.LASF385:
	.string	"I_HASHTABLE_LEN 4096"
.LASF92:
	.string	"__UINT64_MAX__ 18446744073709551615ULL"
.LASF195:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 1"
.LASF58:
	.string	"__INT_FAST64_TYPE__ long long int"
.LASF334:
	.string	"CLONE_VM 0x100"
.LASF94:
	.string	"__INT8_C(c) c"
.LASF287:
	.string	"MMZONE_H "
.LASF72:
	.string	"__LONG_LONG_MAX__ 9223372036854775807LL"
.LASF409:
	.string	"PT_LOPROC 0x70000000"
.LASF515:
	.string	"operations"
.LASF216:
	.string	"__i686 1"
.LASF87:
	.string	"__INT32_MAX__ 2147483647"
.LASF113:
	.string	"__UINT_FAST8_MAX__ 255"
.LASF64:
	.string	"__UINTPTR_TYPE__ unsigned int"
.LASF49:
	.string	"__INT_LEAST32_TYPE__ int"
.LASF111:
	.string	"__INT_FAST32_MAX__ 2147483647"
.LASF225:
	.string	"__unix__ 1"
.LASF192:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 1"
.LASF560:
	.string	"read"
.LASF366:
	.string	"PCB_SIZE 0x2000"
.LASF230:
	.string	"KU_UTILS_H "
.LASF384:
	.string	"INODE_COMMON_SIZE 128"
.LASF537:
	.string	"time_slice_full"
.LASF196:
	.string	"__GCC_ATOMIC_BOOL_LOCK_FREE 2"
.LASF193:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 1"
.LASF531:
	.string	"base"
.LASF471:
	.string	"count"
.LASF146:
	.string	"__DBL_MIN__ ((double)2.22507385850720138309e-308L)"
.LASF169:
	.string	"__DEC32_MIN__ 1E-95DF"
.LASF370:
	.string	"DCACHE_H "
.LASF567:
	.string	"gfp_mask"
.LASF83:
	.string	"__SIG_ATOMIC_MAX__ 2147483647"
.LASF297:
	.string	"PG_H10(pg_id) (pg_id>>10)"
.LASF161:
	.string	"__LDBL_EPSILON__ 1.08420217248550443401e-19L"
.LASF311:
	.string	"pfn_page(pfn) (mem_map + (pfn))"
.LASF325:
	.string	"ZONE_DMA_PA 0"
.LASF170:
	.string	"__DEC32_MAX__ 9.999999E96DF"
.LASF326:
	.string	"ZONE_NORMAL_PA 0X1000000"
.LASF422:
	.string	"long long unsigned int"
.LASF181:
	.string	"__DEC128_MIN_EXP__ (-6142)"
.LASF475:
	.string	"file"
.LASF380:
	.string	"static_cursor_up "
.LASF337:
	.string	"PGDIR_OF_MM(mm) ( (union pte *)__va(mm->cr3.value & PAGE_MASK) )"
.LASF185:
	.string	"__DEC128_EPSILON__ 1E-33DL"
.LASF573:
	.string	"init_memory"
.LASF340:
	.string	"DSI(str,i) dispStr(str,0x400);dispInt(i);"
.LASF251:
	.ascii	"LL2_A(ll2,node) do{ assert( (ll2) &&"
	.string	" (node) ); assert( ( (ll2)->root == 0 && (ll2)->tail == 0 ) || ( (ll2)->root != 0 && (ll2)->tail != 0) ); (node)->prev = (ll2)->tail; if( (ll2)->tail ){ (ll2)->tail->next = node; } else{ (ll2)->root = node; } (node)->next = 0; (ll2)->tail = node; }while(0)"
.LASF547:
	.string	"common"
.LASF123:
	.string	"__FLT_RADIX__ 2"
.LASF20:
	.string	"__SIZEOF_LONG_DOUBLE__ 12"
.LASF445:
	.string	"_count"
.LASF439:
	.string	"$on_read"
.LASF402:
	.string	"PT_INTERP 3"
.LASF368:
	.string	"current (get_current())"
.LASF60:
	.string	"__UINT_FAST16_TYPE__ unsigned int"
.LASF212:
	.string	"__i386 1"
.LASF215:
	.string	"__ATOMIC_HLE_RELEASE 131072"
.LASF546:
	.string	"super_block"
.LASF156:
	.string	"__LDBL_MAX_EXP__ 16384"
.LASF43:
	.string	"__UINT8_TYPE__ unsigned char"
.LASF263:
	.string	"LL_SCAN_ON_kEY_B(root,key,value) ({ typeof(root) curr = root; while(curr && curr->key <= (value) ) curr = curr->next; curr; })"
.LASF243:
	.string	"__3G 0xc0000000"
.LASF449:
	.string	"PG_private"
.LASF177:
	.string	"__DEC64_MAX__ 9.999999999999999E384DD"
.LASF134:
	.string	"__FLT_DENORM_MIN__ 1.40129846432481707092e-45F"
.LASF202:
	.string	"__GCC_ATOMIC_INT_LOCK_FREE 2"
.LASF441:
	.string	"$data"
.LASF342:
	.string	"EXCHG_U32(a,b) do{unsigned c=a;a=b;b=c;} while(0)"
.LASF544:
	.string	"__task_struct_end"
.LASF109:
	.string	"__INT_FAST8_MAX__ 127"
.LASF432:
	.string	"value"
.LASF498:
	.string	"nopage"
.LASF356:
	.string	"MSGTYPE_HS_DONE 5"
.LASF229:
	.string	"UTILS_H "
.LASF434:
	.string	"on_write"
.LASF600:
	.string	"file_cache"
.LASF372:
	.string	"D_HASHTABLE_LEN 1024"
.LASF563:
	.string	"read_inode"
.LASF137:
	.string	"__FLT_HAS_QUIET_NAN__ 1"
.LASF151:
	.string	"__DBL_HAS_QUIET_NAN__ 1"
.LASF41:
	.string	"__INT32_TYPE__ int"
.LASF271:
	.string	"O_APPEND(root,new) ({ (new)->next = root; (new)->prev = root->prev; (root)->prev->next = new; (root)->prev = new; })"
.LASF529:
	.string	"stack_frame"
.LASF275:
	.string	"BYTEORDER_GENERIC_H "
.LASF491:
	.string	"growsup"
.LASF168:
	.string	"__DEC32_MAX_EXP__ 97"
.LASF284:
	.string	"INIT_LIST_HEAD(l) do{ (l)->prev = (l)->next = l; } while(0)"
.LASF3:
	.string	"__GNUC__ 4"
.LASF383:
	.string	"FMODE_SEEK 4"
.LASF324:
	.string	"ZONE_MAX 3"
.LASF239:
	.string	"__8K 0x2000"
.LASF145:
	.string	"__DBL_MAX__ ((double)1.79769313486231570815e+308L)"
.LASF428:
	.string	"accessed"
.LASF95:
	.string	"__INT_LEAST16_MAX__ 32767"
.LASF580:
	.string	"_Bool"
.LASF234:
	.string	"true 1"
.LASF24:
	.string	"__ORDER_LITTLE_ENDIAN__ 1234"
.LASF54:
	.string	"__UINT_LEAST64_TYPE__ long long unsigned int"
.LASF327:
	.string	"ZONE_HIGHMEM_PA (896*0x100000)"
.LASF67:
	.string	"__GXX_ABI_VERSION 1002"
.LASF375:
	.string	"SLAB_CACHE_DMA 2"
.LASF365:
	.string	"EFLAGS_STACK_LEN 7"
.LASF114:
	.string	"__UINT_FAST16_MAX__ 4294967295U"
.LASF579:
	.string	"mm_init"
.LASF426:
	.string	"writable"
.LASF323:
	.string	"ZONE_HIGHMEM 2"
.LASF442:
	.string	"pgerr_code"
.LASF56:
	.string	"__INT_FAST16_TYPE__ int"
.LASF307:
	.string	"KV __va"
.LASF299:
	.string	"FLUSH_TLB __asm__ __volatile__(\"mov %%cr3, %0\\n\\t\" \"mov %0, %%cr3\\n\\t\" : :\"r\"(0))"
.LASF213:
	.string	"__i386__ 1"
.LASF44:
	.string	"__UINT16_TYPE__ short unsigned int"
.LASF530:
	.string	"eflags_stack"
.LASF4:
	.string	"__GNUC_MINOR__ 9"
.LASF189:
	.string	"__GNUC_STDC_INLINE__ 1"
.LASF233:
	.string	"boolean _Bool"
.LASF52:
	.string	"__UINT_LEAST16_TYPE__ short unsigned int"
.LASF129:
	.string	"__FLT_MAX_10_EXP__ 38"
.LASF164:
	.string	"__LDBL_HAS_INFINITY__ 1"
.LASF450:
	.string	"PG_zid"
.LASF495:
	.string	"vm_operations"
.LASF438:
	.string	"$nopage"
.LASF190:
	.string	"__NO_INLINE__ 1"
.LASF599:
	.string	"inode_cache"
.LASF534:
	.string	"p_name"
.LASF376:
	.string	"SLAB_ZERO 4"
.LASF479:
	.string	"base_high"
.LASF148:
	.string	"__DBL_DENORM_MIN__ ((double)4.94065645841246544177e-324L)"
.LASF329:
	.string	"HEAP_BASE 18*0x100000"
.LASF187:
	.string	"__REGISTER_PREFIX__ "
.LASF46:
	.string	"__UINT64_TYPE__ long long unsigned int"
.LASF232:
	.string	"bool _Bool"
.LASF180:
	.string	"__DEC128_MANT_DIG__ 34"
.LASF279:
	.string	"BYTE_ENDIAN_FLIP4(x) x = htonl(x)"
.LASF335:
	.string	"CLONE_FS 0x200"
.LASF122:
	.string	"__DEC_EVAL_METHOD__ 2"
.LASF524:
	.string	"origin_filep"
.LASF141:
	.string	"__DBL_MIN_10_EXP__ (-307)"
.LASF507:
	.string	"char"
.LASF346:
	.string	"MAKE_IP(a,b,c,d) (((a)<<24) + ((b)<<16) + ((c)<<8) + d)"
.LASF248:
	.string	"eat_dec_with_len(pt,x,x_len) char*__pt=(pt); while(*(__pt+1)>='0'&&*(__pt+1)<='9') __pt++; len=__pt-(pt)+1; for(int __i=0;__i<x_len;__i++){ x+=(*__pt-48)*pow_int(10,__i); __pt--; } (pt)+=x_len;"
.LASF155:
	.string	"__LDBL_MIN_10_EXP__ (-4931)"
.LASF286:
	.string	"MB2STRU(stru_type,mb_addr,mb_name) (stru_type *)( (u32)(mb_addr)- (u32)&((stru_type *)0)->mb_name )"
.LASF313:
	.string	"page_va(page) __va( (page - mem_map) << PAGE_SHIFT)"
.LASF245:
	.string	"MAX(x,y) ((x)>(y)?(x):(y))"
.LASF558:
	.string	"file_operations"
.LASF261:
	.string	"LL_ASSIGN(list,attr,value) do{ void *root = list; while(list){ list->attr=value; list=list->next; } list = root; } while(0)"
.LASF517:
	.string	"hash"
.LASF493:
	.string	"dontcopy"
.LASF488:
	.string	"mayexec"
.LASF231:
	.string	"VALTYPE_H "
.LASF497:
	.string	"close"
.LASF316:
	.string	"__GFP_DEFAULT 0"
.LASF568:
	.string	"order"
.LASF435:
	.string	"from_user"
.LASF501:
	.string	"data"
.LASF204:
	.string	"__GCC_ATOMIC_LLONG_LOCK_FREE 2"
.LASF359:
	.string	"MSGTYPE_FS_DONE 7"
.LASF91:
	.string	"__UINT32_MAX__ 4294967295U"
.LASF400:
	.string	"PT_LOAD 1"
.LASF274:
	.string	"assert(exp) do{ if(!(exp)) assert_func(#exp,__FILE__,__BASE_FILE__,__LINE__); } while(0)"
.LASF559:
	.string	"lseek"
.LASF292:
	.string	"pa_idx(paddr) ((paddr)>>PAGE_SHIFT)"
.LASF527:
	.string	"err_code"
.LASF425:
	.string	"present"
.LASF374:
	.string	"SLAB_HWCACHE_ALIGN 1"
.LASF379:
	.string	"kmem_cache_create register_slab_type"
.LASF256:
	.string	"LL_REPLACE(root,old,new) do{ new->prev = old->prev; new->next = old->next; if(new->prev) new->prev->next = new; if(new->next) new->next->prev = new; if(root == old) root = new; }while(0)"
.LASF48:
	.string	"__INT_LEAST16_TYPE__ short int"
.LASF107:
	.string	"__UINT_LEAST64_MAX__ 18446744073709551615ULL"
.LASF221:
	.string	"__gnu_linux__ 1"
.LASF440:
	.string	"$in_kernel"
.LASF197:
	.string	"__GCC_ATOMIC_CHAR_LOCK_FREE 2"
.LASF358:
	.string	"MSGTYPE_USR_ASK 6"
.LASF596:
	.string	"dentry_hashtable"
.LASF198:
	.string	"__GCC_ATOMIC_CHAR16_T_LOCK_FREE 2"
.LASF157:
	.string	"__LDBL_MAX_10_EXP__ 4932"
.LASF99:
	.string	"__INT_LEAST64_MAX__ 9223372036854775807LL"
.LASF408:
	.string	"PT_HIOS 0x6fffffff"
.LASF453:
	.string	"free_area_struct"
.LASF203:
	.string	"__GCC_ATOMIC_LONG_LOCK_FREE 2"
.LASF485:
	.string	"shared"
.LASF103:
	.string	"__UINT_LEAST16_MAX__ 65535"
.LASF264:
	.string	"LL_SCAN_ON_KEY_S(root,key,value) ({ typeof(root) curr = root; while(curr && curr->key >= (value) ) curr = curr->next; curr; })"
.LASF300:
	.string	"__va2page_t(vaddr) (mem_map + (((vaddr) - PAGE_OFFSET) >> 12))"
.LASF414:
	.string	"FORK_H "
.LASF328:
	.string	"PMM_H "
.LASF561:
	.string	"onclose"
.LASF360:
	.string	"RESOURCE_H "
.LASF86:
	.string	"__INT16_MAX__ 32767"
.LASF416:
	.string	"long long int"
.LASF22:
	.string	"__CHAR_BIT__ 8"
.LASF51:
	.string	"__UINT_LEAST8_TYPE__ unsigned char"
.LASF13:
	.string	"__FINITE_MATH_ONLY__ 0"
.LASF490:
	.string	"growsdown"
.LASF564:
	.string	"padding"
.LASF351:
	.string	"MSGTYPE_DEEP 0"
.LASF606:
	.string	"mm_init2"
.LASF304:
	.string	"PAGE_OFFSET 0XC0000000"
.LASF69:
	.string	"__SHRT_MAX__ 32767"
.LASF312:
	.string	"pte_page(pte) ( pfn_page( pte_pfn(pte) ) )"
.LASF295:
	.string	"PG_USU 4"
.LASF278:
	.string	"BYTE_ENDIAN_FLIP2(x) x = htons(x)"
.LASF382:
	.string	"FMODE_WRITE 2"
.LASF226:
	.string	"__ELF__ 1"
.LASF281:
	.string	"MM_H "
.LASF96:
	.string	"__INT16_C(c) c"
.LASF207:
	.string	"__GCC_HAVE_DWARF2_CFI_ASM 1"
.LASF259:
	.ascii	"LL_DEL(list,location) d"
	.string	"o{ assert(list&&location); assert(!(!location->next && !location->prev && (list!=location))); if(location->prev) location->prev->next=location->next; if(location->next) location->next->prev=location->prev; if(list==location) list=location->next; } while(0)"
.LASF18:
	.string	"__SIZEOF_FLOAT__ 4"
.LASF31:
	.string	"__PTRDIFF_TYPE__ int"
.LASF571:
	.string	"memseg"
.LASF178:
	.string	"__DEC64_EPSILON__ 1E-15DD"
.LASF136:
	.string	"__FLT_HAS_INFINITY__ 1"
.LASF574:
	.string	"map_pg"
.LASF555:
	.string	"file_ops"
.LASF277:
	.string	"ntohl(x) htonl(x)"
.LASF463:
	.string	"spanned_pages"
.LASF0:
	.string	"__STDC__ 1"
.LASF593:
	.string	"files_struct_cache"
.LASF269:
	.string	"O_INSERT_INCRE_ON(root,new,mb) ({ assert(root && new); __typeof__(root) leftone = root->prev; while(new->mb > leftone->mb){ leftone = leftone->prev; if(leftone == root->prev){ root = new; break; } } O_INSERT_AFTER(leftone, new); })"
.LASF466:
	.string	"start_code"
.LASF553:
	.string	"chgtime"
.LASF12:
	.string	"__ATOMIC_CONSUME 1"
.LASF462:
	.string	"zone_mem_map"
.LASF272:
	.string	"O_APPEND_SAFE(root,new) ({ if(!root){ root = new; new->prev = new->next = new; } else O_APPEND(root, new); })"
.LASF33:
	.string	"__WINT_TYPE__ unsigned int"
.LASF117:
	.string	"__INTPTR_MAX__ 2147483647"
.LASF554:
	.string	"size"
.LASF106:
	.string	"__UINT32_C(c) c ## U"
.LASF550:
	.string	"compare"
.LASF19:
	.string	"__SIZEOF_DOUBLE__ 8"
.LASF321:
	.string	"ZONE_DMA 0"
.LASF457:
	.string	"allocs"
.LASF5:
	.string	"__GNUC_PATCHLEVEL__ 2"
.LASF76:
	.string	"__WINT_MIN__ 0U"
.LASF357:
	.string	"MSGTYPE_FS_READY 8"
.LASF152:
	.string	"__LDBL_MANT_DIG__ 64"
.LASF153:
	.string	"__LDBL_DIG__ 18"
.LASF516:
	.string	"vfsmount"
.LASF585:
	.string	"zone_normal"
.LASF344:
	.string	"EXCHG_U16(a,b) do{ u16 tmp = a; a = b; b = tmp; } while(0)"
.LASF392:
	.string	"fiximg_start_sector ((unsigned)&_fiximg_start_sector)"
.LASF268:
	.string	"O_INSERT_BEFORE(Next,new) ({ new->next = Next; new->prev = Next->prev; Next->prev->next = new; Next->prev = new; })"
.LASF447:
	.string	"private"
.LASF258:
	.ascii	"LL_I_DECRE(list,new,attr) do{ assert(new); if(!list){ list=n"
	.ascii	"ew; new->prev=new->next=0; break; } void*root=list; while(li"
	.ascii	"st->next && new->at"
	.string	"tr < list->attr) list=list->next; if(new->attr < list->attr){ new->next = 0; list->next=new; new->prev=list; list=root; } else{ new->next=list; new->prev=list->prev; if(list->prev) list->prev->next=new; list->prev=new; if(root==list) list=new; } } while(0)"
.LASF592:
	.string	"fs_struct_cache"
.LASF503:
	.string	"RLIMIT_FSIZE"
.LASF62:
	.string	"__UINT_FAST64_TYPE__ long long unsigned int"
.LASF120:
	.string	"__GCC_IEC_559_COMPLEX 2"
.LASF333:
	.string	"CSIGNAL 0xff"
.LASF480:
	.string	"len_low"
.LASF452:
	.string	"padden"
.LASF314:
	.string	"virt_to_page(vaddr) pfn_page( __pa(vaddr) >> PAGE_SHIFT)"
.LASF332:
	.string	"LINUX_SCHED_H "
.LASF28:
	.string	"__FLOAT_WORD_ORDER__ __ORDER_LITTLE_ENDIAN__"
.LASF578:
	.string	"done"
.LASF166:
	.string	"__DEC32_MANT_DIG__ 7"
.LASF174:
	.string	"__DEC64_MIN_EXP__ (-382)"
.LASF84:
	.string	"__SIG_ATOMIC_MIN__ (-__SIG_ATOMIC_MAX__ - 1)"
.LASF535:
	.string	"prio"
.LASF601:
	.string	"realmod_info"
.LASF468:
	.string	"start_data"
.LASF73:
	.string	"__WCHAR_MAX__ 2147483647L"
.LASF9:
	.string	"__ATOMIC_ACQUIRE 2"
.LASF104:
	.string	"__UINT16_C(c) c"
.LASF236:
	.string	"__DEBUG "
.LASF478:
	.string	"base_low"
.LASF429:
	.string	"dirty"
.LASF53:
	.string	"__UINT_LEAST32_TYPE__ unsigned int"
.LASF543:
	.string	"magic"
.LASF290:
	.string	"PAGE_SIZE 0x1000"
.LASF430:
	.string	"physical"
.LASF465:
	.string	"zone_t"
.LASF218:
	.string	"__pentiumpro 1"
.LASF35:
	.string	"__UINTMAX_TYPE__ long long unsigned int"
.LASF551:
	.string	"rdev"
.LASF575:
	.string	"dirent"
.LASF208:
	.string	"__PRAGMA_REDEFINE_EXTNAME 1"
.LASF373:
	.string	"SLAB_H "
.LASF89:
	.string	"__UINT8_MAX__ 255"
.LASF336:
	.string	"CLONE_FD 0x400"
.LASF200:
	.string	"__GCC_ATOMIC_WCHAR_T_LOCK_FREE 2"
.LASF26:
	.string	"__ORDER_PDP_ENDIAN__ 3412"
.LASF75:
	.string	"__WINT_MAX__ 4294967295U"
.LASF411:
	.string	"PT_GNU_EH_FRAME 0x6474e550"
.LASF130:
	.string	"__FLT_DECIMAL_DIG__ 9"
.LASF220:
	.string	"__code_model_32__ 1"
.LASF505:
	.string	"RLIMIT_MAX"
.LASF506:
	.string	"rlimit"
.LASF154:
	.string	"__LDBL_MIN_EXP__ (-16381)"
.LASF454:
	.string	"free_list"
.LASF68:
	.string	"__SCHAR_MAX__ 127"
.LASF513:
	.string	"parent"
.LASF115:
	.string	"__UINT_FAST32_MAX__ 4294967295U"
.LASF502:
	.string	"RLIMIT_CPU"
.LASF421:
	.string	"short int"
.LASF395:
	.string	"ELF_H "
.LASF437:
	.string	"instruction"
.LASF175:
	.string	"__DEC64_MAX_EXP__ 385"
.LASF194:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 1"
.LASF241:
	.string	"__4M 0x400000"
.LASF492:
	.string	"denywrite"
.LASF394:
	.string	"g_memseg_info ( (struct memseg_info *)KV(&_base_meminfo) )"
.LASF276:
	.string	"ntohs(x) htons(x)"
.LASF61:
	.string	"__UINT_FAST32_TYPE__ unsigned int"
.LASF343:
	.string	"EXCHG_PTR(a,b) do { void *tmp = a; a = b; b = tmp; } while(0)"
.LASF387:
	.string	"SET_PID_EAX(pid,return_val) pcb_table[pid].regs.eax=return_val"
.LASF270:
	.string	"O_SCAN_UNTIL_MEET_LARGER(root,mb,value) ({ assert( (root) ); __typeof__(root) node = root; do{ if( (node)->mb > value) break; node = node->next; if(node != root) continue; node = 0; break; }while(1); node; })"
.LASF288:
	.string	"X86_PAGE_H "
.LASF37:
	.string	"__CHAR32_TYPE__ unsigned int"
.LASF371:
	.string	"MOUNT_H "
.LASF183:
	.string	"__DEC128_MIN__ 1E-6143DL"
.LASF390:
	.string	"realmod_info ((struct realmod_info_struct*)KV(&realmod_info))"
.LASF182:
	.string	"__DEC128_MAX_EXP__ 6145"
.LASF444:
	.string	"page"
.LASF293:
	.string	"pa_pg pa_idx"
.LASF266:
	.ascii	"LL_I_"
	.string	"INCRE_ON(root,new,mb) ({ new->prev = 0; new->next = root; while(new->next && new->next->mb < new->mb){ new->prev = new->next; new->next = new->next->next; } if(new->next) new->next->prev = new; if(new->prev) new->prev->next = new; else root = new->next; })"
.LASF289:
	.string	"PAGE_SHIFT 12"
.LASF59:
	.string	"__UINT_FAST8_TYPE__ unsigned char"
.LASF98:
	.string	"__INT32_C(c) c"
.LASF165:
	.string	"__LDBL_HAS_QUIET_NAN__ 1"
.LASF39:
	.string	"__INT8_TYPE__ signed char"
.LASF494:
	.string	"vm_flags"
.LASF528:
	.string	"eflags"
.LASF222:
	.string	"__linux 1"
.LASF533:
	.string	"sigpending"
.LASF378:
	.string	"BYTES_PER_WORD 4"
.LASF523:
	.string	"filep"
.LASF404:
	.string	"PT_SHLIB 5"
.LASF388:
	.string	"__fstack (current->fstack)"
.LASF406:
	.string	"PT_TLS 7"
.LASF540:
	.string	"files"
.LASF45:
	.string	"__UINT32_TYPE__ unsigned int"
.LASF353:
	.string	"MSGTYPE_FS_ASK 2"
.LASF377:
	.string	"L1_CACHLINE_SIZE 32"
.LASF576:
	.string	"temp_mmio_map"
.LASF55:
	.string	"__INT_FAST8_TYPE__ signed char"
.LASF100:
	.string	"__INT64_C(c) c ## LL"
.LASF265:
	.string	"LL_CHECK(root,node) do{ void *backup = root; while(root){ if(root == node) break; root = root->next; } assert(root && \"can not find node in that list\"); root = backup; }while(0)"
.LASF260:
	.string	"LL_INFO(list,attr) do{ void*root=list; while(list){ printf(\"%d \",list->attr); list=list->next; } list=root; } while(0)"
.LASF97:
	.string	"__INT_LEAST32_MAX__ 2147483647"
.LASF16:
	.string	"__SIZEOF_LONG_LONG__ 8"
.LASF238:
	.string	"__4K 0x1000"
.LASF565:
	.string	"realmod_info_struct"
.LASF581:
	.string	"mm_available"
.LASF541:
	.string	"rlimits"
.LASF603:
	.string	"GNU C 4.9.2 -mtune=generic -march=i686 -g3 -std=c99 -fno-builtin -fno-stack-protector"
.LASF448:
	.string	"PG_highmem"
.LASF512:
	.string	"inode"
.LASF50:
	.string	"__INT_LEAST64_TYPE__ long long int"
.LASF469:
	.string	"end_data"
.LASF518:
	.string	"small_root"
.LASF363:
	.string	"size_buffer 16"
.LASF514:
	.string	"name"
.LASF473:
	.string	"start"
.LASF29:
	.string	"__SIZEOF_POINTER__ 4"
.LASF242:
	.string	"__1G 0x40000000"
.LASF347:
	.string	"ARR_CELLS(array,stru_t) ( sizeof(array) / sizeof(stru_t))"
.LASF250:
	.string	"LL2_POP(ll2) do{ assert( (ll2 && (ll2)->root && (ll2)->tail)); ll2->root = ll2->root->next; if(ll2->root) ll2->root->prev = 0; else ll2->tail = ll2->root; }while(0)"
.LASF496:
	.string	"open"
.LASF538:
	.string	"msg_type"
.LASF124:
	.string	"__FLT_MANT_DIG__ 24"
.LASF305:
	.string	"__pa(vaddr) ((unsigned)(vaddr) - PAGE_OFFSET)"
.LASF88:
	.string	"__INT64_MAX__ 9223372036854775807LL"
.LASF582:
	.string	"mem_entity"
.LASF595:
	.string	"__ext_pcb"
.LASF504:
	.string	"RLIMIT_NOFILE"
.LASF199:
	.string	"__GCC_ATOMIC_CHAR32_T_LOCK_FREE 2"
.LASF536:
	.string	"time_slice"
.LASF391:
	.string	"kernel_image_start_sector ((unsigned)&_kernel_image_start_sector)"
.LASF464:
	.string	"sizetype"
.LASF42:
	.string	"__INT64_TYPE__ long long int"
.LASF188:
	.string	"__USER_LABEL_PREFIX__ "
.LASF415:
	.string	"long unsigned int"
.LASF118:
	.string	"__UINTPTR_MAX__ 4294967295U"
.LASF526:
	.string	"pt_regs"
.LASF1:
	.string	"__STDC_VERSION__ 199901L"
.LASF224:
	.string	"__unix 1"
.LASF90:
	.string	"__UINT16_MAX__ 65535"
.LASF322:
	.string	"ZONE_NORMAL 1"
.LASF364:
	.string	"NR_OPEN_DEFAULT 32"
.LASF7:
	.string	"__ATOMIC_RELAXED 0"
.LASF604:
	.string	"mm.c"
.LASF2:
	.string	"__STDC_HOSTED__ 1"
.LASF584:
	.string	"zone_dma"
.LASF79:
	.string	"__INTMAX_MAX__ 9223372036854775807LL"
.LASF396:
	.string	"PF_R 0x4"
.LASF525:
	.string	"thread"
.LASF405:
	.string	"PT_PHDR 6"
.LASF65:
	.string	"__has_include(STR) __has_include__(STR)"
.LASF273:
	.string	"ASSERT_H "
.LASF112:
	.string	"__INT_FAST64_MAX__ 9223372036854775807LL"
.LASF206:
	.string	"__GCC_ATOMIC_POINTER_LOCK_FREE 2"
.LASF602:
	.string	"testbuf"
.LASF339:
	.string	"returnx_say(x,msg) do{oprintf(\"%s\",msg);return x;} while(0)"
.LASF125:
	.string	"__FLT_DIG__ 6"
.LASF217:
	.string	"__i686__ 1"
.LASF587:
	.string	"__zones"
.LASF597:
	.string	"dentry_cache"
.LASF128:
	.string	"__FLT_MAX_EXP__ 128"
.LASF482:
	.string	"type"
.LASF110:
	.string	"__INT_FAST16_MAX__ 2147483647"
.LASF417:
	.string	"unsigned char"
.LASF167:
	.string	"__DEC32_MIN_EXP__ (-94)"
.LASF455:
	.string	"nr_free"
.LASF254:
	.string	"LL_I(root,new) do{ if(root){ new->prev = root; new->next = root->next; if(root->next) root->next->prev = new; root->next = new; } else{ root = new; new->prev = new->next = 0; } }while(0)"
.LASF412:
	.string	"PT_GNU_STACK (PT_LOOS + 0x474e551)"
.LASF605:
	.string	"/home/wws/lab/yanqi/src"
.LASF291:
	.string	"PAGE_MASK (~0xfff)"
.LASF398:
	.string	"PF_X 0x1"
.LASF367:
	.string	"THREAD_SIZE 0x2000"
.LASF159:
	.string	"__LDBL_MAX__ 1.18973149535723176502e+4932L"
.LASF223:
	.string	"__linux__ 1"
.LASF566:
	.string	"mem_segnum"
.LASF237:
	.string	"NULL 0"
.LASF116:
	.string	"__UINT_FAST64_MAX__ 18446744073709551615ULL"
.LASF30:
	.string	"__SIZE_TYPE__ unsigned int"
.LASF386:
	.string	"get_file(file) ( (file)->count++ )"
.LASF133:
	.string	"__FLT_EPSILON__ 1.19209289550781250000e-7F"
.LASF282:
	.string	"LINUX_MM_H "
.LASF142:
	.string	"__DBL_MAX_EXP__ 1024"
.LASF443:
	.string	"list_head"
.LASF509:
	.string	"root"
.LASF252:
	.ascii	"LL2_DEL(ll2,node) do{ assert( (ll2) && (node) && (ll2)->root"
	.ascii	" && (ll2)->tail ); i"
	.string	"f( (node)->prev ){ (node)->prev->next = (node)->next; } else{ assert( (ll2)->root == node ); (ll2)->root = (node)->next; } if( (node)->next ){ (node)->next->prev = (node)->prev; } else{ assert( (ll2)->tail == node ); (ll2)->tail = (node)->prev; } }while(0)"
.LASF201:
	.string	"__GCC_ATOMIC_SHORT_LOCK_FREE 2"
.LASF345:
	.string	"MEMBER_OFFSET(stru_type,member_name) ( (unsigned)&(((stru_type *)0)->member_name) )"
.LASF487:
	.string	"maywrite"
.LASF341:
	.string	"POINTER_SHIFT(pt,type,len) (type*)((u32)pt+len)"
.LASF520:
	.string	"clash"
.LASF127:
	.string	"__FLT_MIN_10_EXP__ (-37)"
.LASF294:
	.string	"PG_P 1"
.LASF150:
	.string	"__DBL_HAS_INFINITY__ 1"
.LASF303:
	.string	"pte2page_t(pte) ( mem_map + (pte).physical )"
.LASF105:
	.string	"__UINT_LEAST32_MAX__ 4294967295U"
.LASF57:
	.string	"__INT_FAST32_TYPE__ int"
.LASF160:
	.string	"__LDBL_MIN__ 3.36210314311209350626e-4932L"
.LASF330:
	.string	"HEAP_SIZE (64*0x100000)"
.LASF14:
	.string	"__SIZEOF_INT__ 4"
.LASF34:
	.string	"__INTMAX_TYPE__ long long int"
.LASF80:
	.string	"__INTMAX_C(c) c ## LL"
.LASF338:
	.string	"return_say(msg) do{oprintf(\"%s\",msg);return;} while(0)"
.LASF331:
	.string	"BLOCK_DATA_END(block) ((int)((char*)block+sizeof(EMPTY_BLOCK)+block->size-1))"
.LASF298:
	.string	"PG_L10(pg_id) (pg_id&(0x400-1))"
.LASF257:
	.ascii	"LL_I_INCRE(list,new,attr) do{ assert(new); if(!list){ list=n"
	.ascii	"ew; new->prev=new->next=0; break; } void*root=list; while(li"
	.ascii	"st->next && new->attr > list->attr) list=list"
	.string	"->next; if(new->attr > list->attr){ new->next = 0; new->prev=list; list->next = new; list=root; } else{ new->next = list; new->prev = list->prev; if(list->prev) list->prev->next = new; list->prev=new; if(root==list) list=new; else list = root; } } while(0)"
.LASF539:
	.string	"msg_bind"
.LASF607:
	.string	"slab_head"
.LASF420:
	.string	"signed char"
.LASF389:
	.string	"BOOT_INFO_H "
.LASF315:
	.string	"MAX_ORDER 10"
.LASF143:
	.string	"__DBL_MAX_10_EXP__ 308"
.LASF158:
	.string	"__DECIMAL_DIG__ 21"
.LASF594:
	.string	"__hs_pcb"
.LASF418:
	.string	"short unsigned int"
.LASF589:
	.string	"gmemsize"
.LASF172:
	.string	"__DEC32_SUBNORMAL_MIN__ 0.000001E-95DF"
.LASF570:
	.string	"__alloc_page"
.LASF262:
	.string	"LL_SCAN_ON_KEY(root,key,value,result) do{ result = root; while(result){ if( (result)->key == (value) ){ break; } result = (result)->next; } }while(0)"
.LASF23:
	.string	"__BIGGEST_ALIGNMENT__ 16"
.LASF296:
	.string	"PG_RWW 2"
.LASF147:
	.string	"__DBL_EPSILON__ ((double)2.22044604925031308085e-16L)"
.LASF126:
	.string	"__FLT_MIN_EXP__ (-125)"
.LASF247:
	.string	"eat_dec(pt,x) if(*pt<'0'||*pt>'9') goto donothing; x=0; char*__pt=(pt); while(*(__pt+1)>='0'&&*(__pt+1)<='9') __pt++; int __len=__pt-(pt)+1; for(int __i=0;__i<__len;__i++){ x+=(*__pt-48)*pow_int(10,__i); __pt--; } (pt)+=__len;donothing:;"
.LASF458:
	.string	"free_area_t"
.LASF184:
	.string	"__DEC128_MAX__ 9.999999999999999999999999999999999E6144DL"
.LASF214:
	.string	"__ATOMIC_HLE_ACQUIRE 65536"
.LASF219:
	.string	"__pentiumpro__ 1"
.LASF369:
	.string	"FS_H "
.LASF586:
	.string	"zone_highmem"
.LASF499:
	.string	"dentry"
.LASF191:
	.string	"__STRICT_ANSI__ 1"
.LASF381:
	.string	"FMODE_READ 1"
.LASF318:
	.string	"__GFP_DMA (1<<1)"
.LASF352:
	.string	"MSGTYPE_CHAR 1"
.LASF249:
	.string	"MYLIST_H "
.LASF556:
	.string	"inode_operations"
.LASF149:
	.string	"__DBL_HAS_DENORM__ 1"
.LASF461:
	.string	"free_area"
.LASF81:
	.string	"__UINTMAX_MAX__ 18446744073709551615ULL"
.LASF427:
	.string	"user"
.LASF549:
	.string	"dentry_operations"
.LASF32:
	.string	"__WCHAR_TYPE__ long int"
.LASF519:
	.string	"mountpoint"
.LASF11:
	.string	"__ATOMIC_ACQ_REL 4"
.LASF240:
	.string	"__1M 0x100000"
.LASF280:
	.string	"LINUX_STRING_H "
.LASF235:
	.string	"false 0"
.LASF410:
	.string	"PT_HIPROC 0x7fffffff"
.LASF456:
	.string	"frees"
.LASF108:
	.string	"__UINT64_C(c) c ## ULL"
.LASF176:
	.string	"__DEC64_MIN__ 1E-383DD"
.LASF484:
	.string	"executable"
.LASF70:
	.string	"__INT_MAX__ 2147483647"
.LASF38:
	.string	"__SIG_ATOMIC_TYPE__ int"
.LASF557:
	.string	"lookup"
.LASF583:
	.string	"mem_map"
.LASF244:
	.string	"min(x,y) ((x)<(y)?(x):(y))"
.LASF591:
	.string	"mm_cache"
.LASF163:
	.string	"__LDBL_HAS_DENORM__ 1"
.LASF283:
	.string	"LIST_H "
.LASF548:
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
