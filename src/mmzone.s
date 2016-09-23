	.file	"mmzone.c"
	.text
.Ltext0:
	.section	.rodata
.LC0:
	.string	"mmzone.c"
.LC1:
	.string	"./include/old/list.h"
	.align 4
.LC2:
	.string	"new && prev && next && prev->prev && prev->next && next->prev && next->next"
	.text
	.type	__list_add, @function
__list_add:
.LFB0:
	.file 1 "./include/old/list.h"
	.loc 1 17 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 18 0
	cmpl	$0, 8(%ebp)
	je	.L2
	.loc 1 18 0 is_stmt 0 discriminator 2
	cmpl	$0, 12(%ebp)
	je	.L2
	.loc 1 18 0 discriminator 4
	cmpl	$0, 16(%ebp)
	je	.L2
	.loc 1 18 0 discriminator 6
	movl	12(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	.L2
	.loc 1 18 0 discriminator 8
	movl	12(%ebp), %eax
	movl	4(%eax), %eax
	testl	%eax, %eax
	je	.L2
	.loc 1 18 0 discriminator 10
	movl	16(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	.L2
	.loc 1 18 0 discriminator 12
	movl	16(%ebp), %eax
	movl	4(%eax), %eax
	testl	%eax, %eax
	jne	.L3
.L2:
	.loc 1 18 0 discriminator 13
	pushl	$19
	pushl	$.LC0
	pushl	$.LC1
	pushl	$.LC2
	call	assert_func
	addl	$16, %esp
.L3:
	.loc 1 20 0 is_stmt 1
	movl	8(%ebp), %eax
	movl	16(%ebp), %edx
	movl	%edx, 4(%eax)
	.loc 1 21 0
	movl	16(%ebp), %eax
	movl	8(%ebp), %edx
	movl	%edx, (%eax)
	.loc 1 22 0
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, (%eax)
	.loc 1 23 0
	movl	12(%ebp), %eax
	movl	8(%ebp), %edx
	movl	%edx, 4(%eax)
	.loc 1 24 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	__list_add, .-__list_add
	.type	list_add, @function
list_add:
.LFB1:
	.loc 1 31 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 32 0
	movl	12(%ebp), %eax
	movl	4(%eax), %eax
	subl	$4, %esp
	pushl	%eax
	pushl	12(%ebp)
	pushl	8(%ebp)
	call	__list_add
	addl	$16, %esp
	.loc 1 33 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	list_add, .-list_add
	.section	.rodata
	.align 4
.LC3:
	.string	"prev && next && prev->next && prev->prev && next->prev && next->next"
	.text
	.type	__list_del, @function
__list_del:
.LFB3:
	.loc 1 45 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 46 0
	cmpl	$0, 8(%ebp)
	je	.L6
	.loc 1 46 0 is_stmt 0 discriminator 2
	cmpl	$0, 12(%ebp)
	je	.L6
	.loc 1 46 0 discriminator 4
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	testl	%eax, %eax
	je	.L6
	.loc 1 46 0 discriminator 6
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	.L6
	.loc 1 46 0 discriminator 8
	movl	12(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	.L6
	.loc 1 46 0 discriminator 10
	movl	12(%ebp), %eax
	movl	4(%eax), %eax
	testl	%eax, %eax
	jne	.L7
.L6:
	.loc 1 46 0 discriminator 11
	pushl	$46
	pushl	$.LC0
	pushl	$.LC1
	pushl	$.LC3
	call	assert_func
	addl	$16, %esp
.L7:
	.loc 1 47 0 is_stmt 1
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, 4(%eax)
	.loc 1 48 0
	movl	12(%ebp), %eax
	movl	8(%ebp), %edx
	movl	%edx, (%eax)
	.loc 1 49 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE3:
	.size	__list_del, .-__list_del
	.type	list_del, @function
list_del:
.LFB4:
	.loc 1 52 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 53 0
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	subl	$8, %esp
	pushl	%edx
	pushl	%eax
	call	__list_del
	addl	$16, %esp
	.loc 1 54 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE4:
	.size	list_del, .-list_del
	.type	list_del_init, @function
list_del_init:
.LFB5:
	.loc 1 56 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 1 57 0
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	subl	$8, %esp
	pushl	%edx
	pushl	%eax
	call	__list_del
	addl	$16, %esp
	.loc 1 58 0
	movl	8(%ebp), %eax
	movl	8(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	.loc 1 59 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE5:
	.size	list_del_init, .-list_del_init
	.comm	mem_entity,4,1
	.type	sti, @function
sti:
.LFB22:
	.file 2 "./include/old/utils.h"
	.loc 2 194 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	.loc 2 195 0
#APP
# 195 "./include/old/utils.h" 1
	sti
# 0 "" 2
	.loc 2 196 0
#NO_APP
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE22:
	.size	sti, .-sti
	.type	cli_ex, @function
cli_ex:
.LFB23:
	.loc 2 202 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	.loc 2 204 0
#APP
# 204 "./include/old/utils.h" 1
	pushf
	cli
	pop %eax
	andl $0x200, %eax
	
# 0 "" 2
#NO_APP
	movl	%eax, -4(%ebp)
	.loc 2 210 0
	cmpl	$0, -4(%ebp)
	setne	%al
	.loc 2 211 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE23:
	.size	cli_ex, .-cli_ex
	.type	get_eflags, @function
get_eflags:
.LFB24:
	.loc 2 213 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	.loc 2 215 0
#APP
# 215 "./include/old/utils.h" 1
	pushfl
	pop  %eax
	
# 0 "" 2
#NO_APP
	movl	%eax, -4(%ebp)
	.loc 2 219 0
	movl	-4(%ebp), %eax
	.loc 2 220 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE24:
	.size	get_eflags, .-get_eflags
	.type	cli_already, @function
cli_already:
.LFB25:
	.loc 2 222 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	.loc 2 223 0
	call	get_eflags
	movl	%eax, -4(%ebp)
	.loc 2 224 0
	movl	-4(%ebp), %eax
	andl	$512, %eax
	testl	%eax, %eax
	sete	%al
	.loc 2 225 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE25:
	.size	cli_already, .-cli_already
	.comm	mem_map,4,4
	.comm	zone_dma,240,64
	.comm	zone_normal,240,64
	.comm	zone_highmem,240,64
	.globl	__zones
	.data
	.align 4
	.type	__zones, @object
	.size	__zones, 12
__zones:
	.long	zone_dma
	.long	zone_normal
	.long	zone_highmem
	.comm	size_of_zone,12,4
	.section	.rodata
.LC4:
	.string	"zone%u[spanned_pages:%x]\n"
	.text
	.globl	info_zone
	.type	info_zone, @function
info_zone:
.LFB42:
	.file 3 "mmzone.c"
	.loc 3 8 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 3 9 0
	movl	8(%ebp), %eax
	movl	__zones(,%eax,4), %eax
	movl	228(%eax), %eax
	subl	$8, %esp
	pushl	%eax
	pushl	$.LC4
	call	oprintf
	addl	$16, %esp
	.loc 3 10 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE42:
	.size	info_zone, .-info_zone
	.data
	.align 4
	.type	pa_of_zone, @object
	.size	pa_of_zone, 12
pa_of_zone:
	.long	0
	.long	16777216
	.long	939524096
	.section	.rodata
.LC5:
	.string	"init buddy \n"
	.text
	.globl	init_zone
	.type	init_zone, @function
init_zone:
.LFB43:
	.loc 3 14 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$20, %esp
	.cfi_offset 3, -12
	.loc 3 15 0
	subl	$12, %esp
	pushl	$.LC5
	call	oprintf
	addl	$16, %esp
.LBB2:
	.loc 3 16 0
	movl	$0, -12(%ebp)
	jmp	.L19
.L20:
	.loc 3 17 0 discriminator 3
	movl	-12(%ebp), %eax
	movl	__zones(,%eax,4), %ecx
	movl	mem_map, %ebx
	movl	-12(%ebp), %eax
	movl	pa_of_zone(,%eax,4), %eax
	shrl	$12, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	%eax, 224(%ecx)
	.loc 3 18 0 discriminator 3
	movl	-12(%ebp), %eax
	movl	__zones(,%eax,4), %eax
	movl	-12(%ebp), %edx
	movl	size_of_zone(,%edx,4), %edx
	shrl	$12, %edx
	movl	%edx, 228(%eax)
	.loc 3 16 0 discriminator 3
	addl	$1, -12(%ebp)
.L19:
	.loc 3 16 0 is_stmt 0 discriminator 1
	cmpl	$2, -12(%ebp)
	jle	.L20
.LBE2:
	.loc 3 24 0 is_stmt 1
	subl	$8, %esp
	pushl	$768
	pushl	$0
	call	init_free_area
	addl	$16, %esp
	.loc 3 25 0
	subl	$8, %esp
	pushl	$16384
	pushl	$1
	call	init_free_area
	addl	$16, %esp
	.loc 3 26 0
	subl	$8, %esp
	pushl	$0
	pushl	$2
	call	init_free_area
	addl	$16, %esp
	.loc 3 27 0
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE43:
	.size	init_zone, .-init_zone
	.globl	init_free_area
	.type	init_free_area, @function
init_free_area:
.LFB44:
	.loc 3 33 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$36, %esp
	.cfi_offset 3, -12
	.loc 3 34 0
	movl	8(%ebp), %eax
	movl	__zones(,%eax,4), %eax
	movl	%eax, -20(%ebp)
	.loc 3 35 0
	movl	-20(%ebp), %eax
	addl	$4, %eax
	movl	%eax, -24(%ebp)
	.loc 3 36 0
	movl	-20(%ebp), %eax
	movl	224(%eax), %eax
	movl	%eax, -28(%ebp)
.LBB3:
	.loc 3 37 0
	movl	$0, -12(%ebp)
	jmp	.L22
.L23:
	.loc 3 38 0 discriminator 3
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	leal	(%edx,%eax), %ebx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	addl	%eax, %edx
	movl	-12(%ebp), %ecx
	movl	%ecx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	sall	$2, %eax
	movl	%eax, %ecx
	movl	-24(%ebp), %eax
	addl	%ecx, %eax
	movl	%eax, 4(%edx)
	movl	4(%edx), %eax
	movl	%eax, (%ebx)
	.loc 3 39 0 discriminator 3
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	addl	%edx, %eax
	movl	$0, 12(%eax)
	.loc 3 40 0 discriminator 3
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	addl	%edx, %eax
	movl	$0, 16(%eax)
	.loc 3 37 0 discriminator 3
	addl	$1, -12(%ebp)
.L22:
	.loc 3 37 0 is_stmt 0 discriminator 1
	cmpl	$10, -12(%ebp)
	jle	.L23
.LBE3:
	.loc 3 43 0 is_stmt 1
	movl	12(%ebp), %eax
	movl	%eax, -16(%ebp)
	.loc 3 45 0
	jmp	.L24
.L25:
	.loc 3 46 0
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	movl	%eax, %edx
	movl	-28(%ebp), %eax
	addl	%edx, %eax
	movl	8(%ebp), %edx
	andl	$3, %edx
	andl	$3, %edx
	leal	0(,%edx,4), %ecx
	movzbl	20(%eax), %edx
	andl	$-13, %edx
	orl	%ecx, %edx
	movb	%dl, 20(%eax)
	.loc 3 47 0
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	movl	%eax, %edx
	movl	-28(%ebp), %eax
	addl	%edx, %eax
	movl	$1, 8(%eax)
	.loc 3 48 0
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	movl	%eax, %edx
	movl	-28(%ebp), %eax
	addl	%edx, %eax
	movl	$8, 16(%eax)
	.loc 3 50 0
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	movl	%eax, %edx
	movl	-28(%ebp), %eax
	addl	%edx, %eax
	subl	$8, %esp
	pushl	$8
	pushl	%eax
	call	free_pages
	addl	$16, %esp
	.loc 3 52 0
	addl	$256, -16(%ebp)
.L24:
	.loc 3 45 0
	movl	-16(%ebp), %edx
	movl	-20(%ebp), %eax
	movl	228(%eax), %eax
	cmpl	%eax, %edx
	jb	.L25
	.loc 3 54 0
	movl	-20(%ebp), %eax
	movl	$0, 232(%eax)
	movl	-20(%ebp), %eax
	movl	232(%eax), %edx
	movl	-20(%ebp), %eax
	movl	%edx, 236(%eax)
	.loc 3 56 0
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE44:
	.size	init_free_area, .-init_free_area
	.section	.rodata
.LC6:
	.string	"cli_already()"
	.align 4
.LC7:
	.string	"page->_count == 0 && \"only allow invoked by free_pages\""
	.align 4
.LC8:
	.string	"order == page->private && \"just comment this line, but be aware \t\t\t\t\t\t\t\t\taware of what happended\""
	.align 4
.LC9:
	.string	"zone->free_area[order].nr_free >= 0"
.LC10:
	.string	"buddy:boundary outside "
.LC11:
	.string	"orphan->_count == 0"
	.text
	.globl	__free_pages_bulk
	.type	__free_pages_bulk, @function
__free_pages_bulk:
.LFB45:
	.loc 3 61 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	.loc 3 62 0
	call	cli_already
	xorl	$1, %eax
	testb	%al, %al
	je	.L27
	.loc 3 62 0 is_stmt 0 discriminator 1
	pushl	$62
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC6
	call	assert_func
	addl	$16, %esp
.L27:
	.loc 3 63 0 is_stmt 1
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L28
	.loc 3 63 0 is_stmt 0 discriminator 1
	pushl	$63
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC7
	call	assert_func
	addl	$16, %esp
.L28:
	.loc 3 64 0 is_stmt 1
	movl	8(%ebp), %eax
	movl	16(%eax), %eax
	cmpl	16(%ebp), %eax
	je	.L29
	.loc 3 64 0 is_stmt 0 discriminator 1
	pushl	$65
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC8
	call	assert_func
	addl	$16, %esp
.L29:
	.loc 3 66 0 is_stmt 1
	movl	12(%ebp), %ecx
	movl	16(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	jns	.L30
	.loc 3 66 0 is_stmt 0 discriminator 1
	pushl	$66
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC9
	call	assert_func
	addl	$16, %esp
.L30:
	.loc 3 68 0 is_stmt 1
	movl	12(%ebp), %eax
	addl	$4, %eax
	movl	%eax, -28(%ebp)
	.loc 3 69 0
	movl	8(%ebp), %eax
	movl	%eax, -12(%ebp)
	.loc 3 70 0
	movl	$0, -16(%ebp)
	.loc 3 72 0
	movl	$0, -20(%ebp)
	.loc 3 74 0
	movl	-12(%ebp), %eax
	movzbl	20(%eax), %edx
	andl	$-3, %edx
	movb	%dl, 20(%eax)
	.loc 3 75 0
	movl	16(%ebp), %eax
	movl	%eax, -24(%ebp)
	jmp	.L31
.L38:
.LBB4:
	.loc 3 76 0
	movl	-24(%ebp), %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	movl	%eax, -32(%ebp)
	.loc 3 80 0
	movl	-12(%ebp), %eax
	movl	mem_map, %edx
	subl	%edx, %eax
	sarl	$3, %eax
	imull	$-1431655765, %eax, %eax
	movl	-32(%ebp), %ecx
	movl	$0, %edx
	divl	%ecx
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L32
	.loc 3 81 0
	movl	-32(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -20(%ebp)
	.loc 3 82 0
	movl	-12(%ebp), %eax
	movl	%eax, -16(%ebp)
	jmp	.L33
.L32:
	.loc 3 85 0
	movl	-32(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	negl	%eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -20(%ebp)
	.loc 3 86 0
	movl	-20(%ebp), %eax
	movl	%eax, -16(%ebp)
.L33:
	.loc 3 89 0
	movl	12(%ebp), %eax
	movl	224(%eax), %eax
	cmpl	-20(%ebp), %eax
	ja	.L34
	.loc 3 90 0 discriminator 1
	movl	12(%ebp), %eax
	movl	224(%eax), %ecx
	movl	12(%ebp), %eax
	movl	228(%eax), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	.loc 3 89 0 discriminator 1
	cmpl	-20(%ebp), %eax
	ja	.L35
.L34:
	.loc 3 91 0
	subl	$12, %esp
	pushl	$.LC10
	call	oprintf
	addl	$16, %esp
	.loc 3 92 0
	jmp	.L36
.L35:
	.loc 3 94 0
	subl	$8, %esp
	pushl	-24(%ebp)
	pushl	-20(%ebp)
	call	page_is_buddy
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L37
	jmp	.L36
.L37:
	.loc 3 97 0 discriminator 2
	movl	-20(%ebp), %eax
	subl	$12, %esp
	pushl	%eax
	call	list_del
	addl	$16, %esp
	movl	-24(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-28(%ebp), %eax
	addl	%edx, %eax
	movl	8(%eax), %edx
	subl	$1, %edx
	movl	%edx, 8(%eax)
	.loc 3 100 0 discriminator 2
	movl	-20(%ebp), %eax
	movzbl	20(%eax), %edx
	andl	$-3, %edx
	movb	%dl, 20(%eax)
	.loc 3 102 0 discriminator 2
	movl	-16(%ebp), %eax
	movl	%eax, -12(%ebp)
.LBE4:
	.loc 3 75 0 discriminator 2
	addl	$1, -24(%ebp)
.L31:
	.loc 3 75 0 is_stmt 0 discriminator 1
	cmpl	$9, -24(%ebp)
	jle	.L38
.L36:
	.loc 3 105 0 is_stmt 1
	movl	-12(%ebp), %edx
	movl	-12(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	-12(%ebp), %eax
	movl	4(%eax), %edx
	movl	-12(%ebp), %eax
	movl	%edx, (%eax)
	.loc 3 106 0
	movl	-24(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-28(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	subl	$8, %esp
	pushl	%edx
	pushl	%eax
	call	list_add
	addl	$16, %esp
	.loc 3 107 0
	movl	-12(%ebp), %eax
	movzbl	20(%eax), %edx
	orl	$2, %edx
	movb	%dl, 20(%eax)
	.loc 3 108 0
	movl	-12(%ebp), %eax
	movl	-24(%ebp), %edx
	movl	%edx, 16(%eax)
	.loc 3 109 0
	movl	-12(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L39
	.loc 3 109 0 is_stmt 0 discriminator 1
	pushl	$109
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC11
	call	assert_func
	addl	$16, %esp
.L39:
	.loc 3 110 0 is_stmt 1
	movl	-24(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-28(%ebp), %eax
	addl	%edx, %eax
	movl	8(%eax), %edx
	addl	$1, %edx
	movl	%edx, 8(%eax)
	.loc 3 112 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE45:
	.size	__free_pages_bulk, .-__free_pages_bulk
	.globl	page_is_buddy
	.type	page_is_buddy, @function
page_is_buddy:
.LFB46:
	.loc 3 114 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	.loc 3 115 0
	movl	8(%ebp), %eax
	movzbl	20(%eax), %eax
	andl	$2, %eax
	testb	%al, %al
	je	.L41
	.loc 3 115 0 is_stmt 0 discriminator 1
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	jne	.L41
	.loc 3 115 0 discriminator 2
	movl	8(%ebp), %eax
	movl	16(%eax), %eax
	cmpl	12(%ebp), %eax
	je	.L42
.L41:
	.loc 3 117 0 is_stmt 1
	movl	$0, %eax
	jmp	.L43
.L42:
	.loc 3 119 0
	movl	$1, %eax
.L43:
	.loc 3 120 0
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE46:
	.size	page_is_buddy, .-page_is_buddy
	.section	.rodata
.LC12:
	.string	"page frame reclaming required"
	.text
	.globl	__rmquene
	.type	__rmquene, @function
__rmquene:
.LFB47:
	.loc 3 121 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$36, %esp
	.cfi_offset 3, -12
	.loc 3 122 0
	call	cli_ex
	movzbl	%al, %eax
	movl	%eax, -16(%ebp)
	.loc 3 123 0
	movl	8(%ebp), %eax
	movl	232(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 232(%eax)
	.loc 3 124 0
	movl	8(%ebp), %ecx
	movl	12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	$16, %eax
	addl	%ecx, %eax
	movl	4(%eax), %eax
	leal	1(%eax), %ecx
	movl	8(%ebp), %ebx
	movl	12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	$16, %eax
	addl	%ebx, %eax
	movl	%ecx, 4(%eax)
	.loc 3 125 0
	movl	8(%ebp), %ecx
	movl	12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	jns	.L45
	.loc 3 125 0 is_stmt 0 discriminator 1
	pushl	$125
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC9
	call	assert_func
	addl	$16, %esp
.L45:
	.loc 3 126 0 is_stmt 1
	movl	8(%ebp), %eax
	addl	$4, %eax
	movl	%eax, -20(%ebp)
	.loc 3 127 0
	movl	12(%ebp), %eax
	movl	%eax, -12(%ebp)
	.loc 3 128 0
	jmp	.L46
.L47:
	.loc 3 129 0
	addl	$1, -12(%ebp)
	.loc 3 130 0
	cmpl	$11, -12(%ebp)
	jne	.L46
	.loc 3 130 0 is_stmt 0 discriminator 1
	subl	$12, %esp
	pushl	$.LC12
	call	spin
	addl	$16, %esp
.L46:
	.loc 3 128 0 is_stmt 1
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-20(%ebp), %eax
	addl	%edx, %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L47
	.loc 3 132 0
	jmp	.L48
.L49:
	.loc 3 133 0
	movl	8(%ebp), %eax
	addl	$4, %eax
	subl	$8, %esp
	pushl	-12(%ebp)
	pushl	%eax
	call	cleave
	addl	$16, %esp
	.loc 3 134 0
	subl	$1, -12(%ebp)
.L48:
	.loc 3 132 0
	movl	-12(%ebp), %eax
	cmpl	12(%ebp), %eax
	jg	.L49
	.loc 3 136 0
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-20(%ebp), %eax
	addl	%edx, %eax
	movl	4(%eax), %eax
	movl	%eax, -24(%ebp)
	.loc 3 137 0
	subl	$12, %esp
	pushl	-24(%ebp)
	call	list_del_init
	addl	$16, %esp
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-20(%ebp), %eax
	addl	%edx, %eax
	movl	8(%eax), %edx
	subl	$1, %edx
	movl	%edx, 8(%eax)
	.loc 3 139 0
	movl	-24(%ebp), %eax
	movl	%eax, -28(%ebp)
	.loc 3 140 0
	movl	-28(%ebp), %eax
	movl	$1, 8(%eax)
	.loc 3 141 0
	movl	-28(%ebp), %eax
	movzbl	20(%eax), %edx
	andl	$-3, %edx
	movb	%dl, 20(%eax)
	.loc 3 142 0
	movl	8(%ebp), %eax
	movl	232(%eax), %eax
	movl	%eax, %edx
	movl	-28(%ebp), %eax
	movzbl	%dl, %edx
	movl	%edx, %ecx
	sall	$4, %ecx
	movzwl	20(%eax), %edx
	andw	$-4081, %dx
	orl	%ecx, %edx
	movw	%dx, 20(%eax)
	.loc 3 144 0
	cmpl	$0, -16(%ebp)
	je	.L50
	.loc 3 144 0 is_stmt 0 discriminator 1
	call	sti
.L50:
	.loc 3 145 0 is_stmt 1
	movl	-28(%ebp), %eax
	.loc 3 146 0
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE47:
	.size	__rmquene, .-__rmquene
	.globl	cleave
	.type	cleave, @function
cleave:
.LFB48:
	.loc 3 151 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	.loc 3 152 0
	movl	12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -12(%ebp)
	.loc 3 154 0
	movl	-12(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -16(%ebp)
	.loc 3 155 0
	subl	$12, %esp
	pushl	-16(%ebp)
	call	list_del_init
	addl	$16, %esp
	.loc 3 156 0
	movl	12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movl	8(%eax), %edx
	subl	$1, %edx
	movl	%edx, 8(%eax)
	.loc 3 158 0
	movl	-16(%ebp), %eax
	movl	%eax, -20(%ebp)
	.loc 3 159 0
	movl	-20(%ebp), %eax
	movl	%eax, -24(%ebp)
	.loc 3 160 0
	movl	-24(%ebp), %eax
	movl	16(%eax), %eax
	leal	-1(%eax), %edx
	movl	-24(%ebp), %eax
	movl	%edx, 16(%eax)
	.loc 3 161 0
	movl	-24(%ebp), %eax
	movl	16(%eax), %eax
	movl	$24, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	-24(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -28(%ebp)
	.loc 3 162 0
	movl	-28(%ebp), %eax
	movl	-24(%ebp), %edx
	movl	(%edx), %ecx
	movl	%ecx, (%eax)
	movl	4(%edx), %ecx
	movl	%ecx, 4(%eax)
	movl	8(%edx), %ecx
	movl	%ecx, 8(%eax)
	movl	12(%edx), %ecx
	movl	%ecx, 12(%eax)
	movl	16(%edx), %ecx
	movl	%ecx, 16(%eax)
	movl	20(%edx), %edx
	movl	%edx, 20(%eax)
	.loc 3 163 0
	movl	12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	leal	-20(%eax), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	subl	$8, %esp
	pushl	%edx
	pushl	%eax
	call	list_add
	addl	$16, %esp
	.loc 3 164 0
	movl	12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	leal	-20(%eax), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, %edx
	movl	-28(%ebp), %eax
	subl	$8, %esp
	pushl	%edx
	pushl	%eax
	call	list_add
	addl	$16, %esp
	.loc 3 165 0
	movl	12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	leal	-20(%eax), %edx
	movl	8(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	leal	-20(%eax), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movl	8(%eax), %eax
	addl	$2, %eax
	movl	%eax, 8(%ecx)
	.loc 3 166 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE48:
	.size	cleave, .-cleave
	.globl	free_pages
	.type	free_pages, @function
free_pages:
.LFB49:
	.loc 3 174 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$20, %esp
	.cfi_offset 3, -12
	.loc 3 175 0
	call	cli_ex
	movzbl	%al, %eax
	movl	%eax, -12(%ebp)
	.loc 3 177 0
	movl	8(%ebp), %eax
	movzbl	20(%eax), %eax
	shrb	$2, %al
	andl	$3, %eax
	movzbl	%al, %eax
	movl	__zones(,%eax,4), %eax
	movl	%eax, -16(%ebp)
	.loc 3 178 0
	movl	-16(%ebp), %eax
	movl	236(%eax), %eax
	leal	1(%eax), %edx
	movl	-16(%ebp), %eax
	movl	%edx, 236(%eax)
	.loc 3 179 0
	movl	-16(%ebp), %ecx
	movl	12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	movl	16(%eax), %eax
	leal	1(%eax), %ecx
	movl	-16(%ebp), %ebx
	movl	12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	%ebx, %eax
	movl	%ecx, 16(%eax)
	.loc 3 180 0
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	leal	-1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%eax)
	.loc 3 181 0
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	jne	.L54
	.loc 3 182 0
	subl	$4, %esp
	pushl	12(%ebp)
	pushl	-16(%ebp)
	pushl	8(%ebp)
	call	__free_pages_bulk
	addl	$16, %esp
.L54:
	.loc 3 185 0
	cmpl	$0, -12(%ebp)
	je	.L53
	.loc 3 185 0 is_stmt 0 discriminator 1
	call	sti
.L53:
	.loc 3 186 0 is_stmt 1
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE49:
	.size	free_pages, .-free_pages
	.section	.rodata
.LC13:
	.string	"page"
	.text
	.globl	alloc_pages
	.type	alloc_pages, @function
alloc_pages:
.LFB50:
	.loc 3 189 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 3 193 0
	movl	8(%ebp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L57
	.loc 3 194 0
	subl	$8, %esp
	pushl	12(%ebp)
	pushl	$zone_dma
	call	__rmquene
	addl	$16, %esp
	movl	%eax, -12(%ebp)
	jmp	.L58
.L57:
	.loc 3 196 0
	movl	8(%ebp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L59
	.loc 3 199 0
	subl	$8, %esp
	pushl	12(%ebp)
	pushl	$zone_highmem
	call	__rmquene
	addl	$16, %esp
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L60
	.loc 3 198 0
	subl	$8, %esp
	pushl	12(%ebp)
	pushl	$zone_normal
	call	__rmquene
	addl	$16, %esp
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L60
	.loc 3 199 0 discriminator 2
	subl	$8, %esp
	pushl	12(%ebp)
	pushl	$zone_dma
	call	__rmquene
	addl	$16, %esp
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	je	.L61
.L60:
	.loc 3 199 0 is_stmt 0 discriminator 1
	movl	$1, %eax
	jmp	.L62
.L61:
	.loc 3 199 0 discriminator 3
	movl	$0, %eax
.L62:
	.loc 3 197 0 is_stmt 1
	movl	%eax, avoid_gcc_complain
	jmp	.L58
.L59:
	.loc 3 204 0
	subl	$8, %esp
	pushl	12(%ebp)
	pushl	$zone_normal
	call	__rmquene
	addl	$16, %esp
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L63
	.loc 3 204 0 is_stmt 0 discriminator 2
	subl	$8, %esp
	pushl	12(%ebp)
	pushl	$zone_dma
	call	__rmquene
	addl	$16, %esp
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	je	.L64
.L63:
	.loc 3 204 0 discriminator 3
	movl	$1, %eax
	jmp	.L65
.L64:
	.loc 3 204 0 discriminator 4
	movl	$0, %eax
.L65:
	.loc 3 203 0 is_stmt 1
	movl	%eax, avoid_gcc_complain
.L58:
	.loc 3 207 0
	cmpl	$0, -12(%ebp)
	jne	.L66
	.loc 3 207 0 is_stmt 0 discriminator 1
	pushl	$207
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC13
	call	assert_func
	addl	$16, %esp
.L66:
	.loc 3 208 0 is_stmt 1
	movl	8(%ebp), %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L67
.LBB5:
	.loc 3 209 0
	movl	-12(%ebp), %eax
	movl	mem_map, %edx
	subl	%edx, %eax
	sarl	$3, %eax
	imull	$-1431655765, %eax, %eax
	movl	%eax, -16(%ebp)
	.loc 3 210 0
	movl	-16(%ebp), %eax
	sall	$12, %eax
	subl	$1073741824, %eax
	movl	%eax, -20(%ebp)
	.loc 3 211 0
	movl	12(%ebp), %eax
	movl	$4096, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	subl	$4, %esp
	pushl	%eax
	pushl	$0
	pushl	-20(%ebp)
	call	memset
	addl	$16, %esp
.L67:
.LBE5:
	.loc 3 213 0
	movl	-12(%ebp), %eax
	.loc 3 214 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE50:
	.size	alloc_pages, .-alloc_pages
.Letext0:
	.file 4 "./include/old/mmzone.h"
	.file 5 "./include/old/ku_utils.h"
	.file 6 "./include/old/valType.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x7b7
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.long	.LASF428
	.byte	0x1
	.long	.LASF429
	.long	.LASF430
	.long	.Ltext0
	.long	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.long	.Ldebug_macro0
	.uleb128 0x2
	.long	.LASF358
	.byte	0x8
	.byte	0x1
	.byte	0x6
	.long	0x4e
	.uleb128 0x3
	.long	.LASF347
	.byte	0x1
	.byte	0x7
	.long	0x4e
	.byte	0
	.uleb128 0x3
	.long	.LASF348
	.byte	0x1
	.byte	0x8
	.long	0x4e
	.byte	0x4
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x29
	.uleb128 0x5
	.long	.LASF353
	.byte	0x1
	.byte	0x9
	.long	0x29
	.uleb128 0x6
	.byte	0x4
	.byte	0x7
	.long	.LASF349
	.uleb128 0x6
	.byte	0x8
	.byte	0x5
	.long	.LASF350
	.uleb128 0x6
	.byte	0x1
	.byte	0x8
	.long	.LASF351
	.uleb128 0x6
	.byte	0x2
	.byte	0x7
	.long	.LASF352
	.uleb128 0x7
	.string	"u32"
	.byte	0x6
	.byte	0x11
	.long	0x86
	.uleb128 0x6
	.byte	0x4
	.byte	0x7
	.long	.LASF354
	.uleb128 0x6
	.byte	0x1
	.byte	0x6
	.long	.LASF355
	.uleb128 0x6
	.byte	0x2
	.byte	0x5
	.long	.LASF356
	.uleb128 0x8
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x6
	.byte	0x8
	.byte	0x7
	.long	.LASF357
	.uleb128 0x2
	.long	.LASF359
	.byte	0x18
	.byte	0x4
	.byte	0x8
	.long	0x131
	.uleb128 0x9
	.string	"lru"
	.byte	0x4
	.byte	0x9
	.long	0x29
	.byte	0
	.uleb128 0x3
	.long	.LASF360
	.byte	0x4
	.byte	0xa
	.long	0x9b
	.byte	0x8
	.uleb128 0x3
	.long	.LASF361
	.byte	0x4
	.byte	0xb
	.long	0x9b
	.byte	0xc
	.uleb128 0x3
	.long	.LASF362
	.byte	0x4
	.byte	0x10
	.long	0x9b
	.byte	0x10
	.uleb128 0xa
	.long	.LASF363
	.byte	0x4
	.byte	0x11
	.long	0x9b
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0x14
	.uleb128 0xa
	.long	.LASF364
	.byte	0x4
	.byte	0x12
	.long	0x9b
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0x14
	.uleb128 0xa
	.long	.LASF365
	.byte	0x4
	.byte	0x13
	.long	0x86
	.byte	0x4
	.byte	0x2
	.byte	0x1c
	.byte	0x14
	.uleb128 0xa
	.long	.LASF366
	.byte	0x4
	.byte	0x14
	.long	0x86
	.byte	0x4
	.byte	0x8
	.byte	0x14
	.byte	0x14
	.uleb128 0xa
	.long	.LASF367
	.byte	0x4
	.byte	0x15
	.long	0x9b
	.byte	0x4
	.byte	0x14
	.byte	0
	.byte	0x14
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0xa9
	.uleb128 0x5
	.long	.LASF368
	.byte	0x4
	.byte	0x16
	.long	0xa9
	.uleb128 0x2
	.long	.LASF369
	.byte	0x14
	.byte	0x4
	.byte	0x31
	.long	0x17f
	.uleb128 0x3
	.long	.LASF370
	.byte	0x4
	.byte	0x32
	.long	0x29
	.byte	0
	.uleb128 0x3
	.long	.LASF371
	.byte	0x4
	.byte	0x33
	.long	0x9b
	.byte	0x8
	.uleb128 0x3
	.long	.LASF372
	.byte	0x4
	.byte	0x34
	.long	0x9b
	.byte	0xc
	.uleb128 0x3
	.long	.LASF373
	.byte	0x4
	.byte	0x34
	.long	0x9b
	.byte	0x10
	.byte	0
	.uleb128 0x5
	.long	.LASF374
	.byte	0x4
	.byte	0x35
	.long	0x142
	.uleb128 0x2
	.long	.LASF375
	.byte	0xf0
	.byte	0x4
	.byte	0x37
	.long	0x1df
	.uleb128 0x3
	.long	.LASF376
	.byte	0x4
	.byte	0x39
	.long	0x86
	.byte	0
	.uleb128 0x3
	.long	.LASF377
	.byte	0x4
	.byte	0x3a
	.long	0x1df
	.byte	0x4
	.uleb128 0x3
	.long	.LASF378
	.byte	0x4
	.byte	0x3b
	.long	0x131
	.byte	0xe0
	.uleb128 0x3
	.long	.LASF379
	.byte	0x4
	.byte	0x3c
	.long	0x86
	.byte	0xe4
	.uleb128 0x3
	.long	.LASF373
	.byte	0x4
	.byte	0x3d
	.long	0x9b
	.byte	0xe8
	.uleb128 0x3
	.long	.LASF372
	.byte	0x4
	.byte	0x3d
	.long	0x9b
	.byte	0xec
	.byte	0
	.uleb128 0xb
	.long	0x17f
	.long	0x1ef
	.uleb128 0xc
	.long	0x1ef
	.byte	0xa
	.byte	0
	.uleb128 0x6
	.byte	0x4
	.byte	0x7
	.long	.LASF380
	.uleb128 0x5
	.long	.LASF381
	.byte	0x4
	.byte	0x3e
	.long	0x18a
	.uleb128 0xd
	.long	.LASF382
	.byte	0x1
	.byte	0x10
	.long	.LFB0
	.long	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.long	0x241
	.uleb128 0xe
	.string	"new"
	.byte	0x1
	.byte	0x10
	.long	0x241
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xf
	.long	.LASF347
	.byte	0x1
	.byte	0x10
	.long	0x241
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0xf
	.long	.LASF348
	.byte	0x1
	.byte	0x11
	.long	0x241
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x54
	.uleb128 0xd
	.long	.LASF383
	.byte	0x1
	.byte	0x1f
	.long	.LFB1
	.long	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.long	0x279
	.uleb128 0xe
	.string	"new"
	.byte	0x1
	.byte	0x1f
	.long	0x241
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xf
	.long	.LASF384
	.byte	0x1
	.byte	0x1f
	.long	0x241
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.byte	0
	.uleb128 0xd
	.long	.LASF385
	.byte	0x1
	.byte	0x2d
	.long	.LFB3
	.long	.LFE3-.LFB3
	.uleb128 0x1
	.byte	0x9c
	.long	0x2ab
	.uleb128 0xf
	.long	.LASF347
	.byte	0x1
	.byte	0x2d
	.long	0x241
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xf
	.long	.LASF348
	.byte	0x1
	.byte	0x2d
	.long	0x241
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.byte	0
	.uleb128 0xd
	.long	.LASF386
	.byte	0x1
	.byte	0x34
	.long	.LFB4
	.long	.LFE4-.LFB4
	.uleb128 0x1
	.byte	0x9c
	.long	0x2cf
	.uleb128 0xf
	.long	.LASF387
	.byte	0x1
	.byte	0x34
	.long	0x241
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0xd
	.long	.LASF388
	.byte	0x1
	.byte	0x38
	.long	.LFB5
	.long	.LFE5-.LFB5
	.uleb128 0x1
	.byte	0x9c
	.long	0x2f3
	.uleb128 0xf
	.long	.LASF387
	.byte	0x1
	.byte	0x38
	.long	0x241
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x10
	.string	"sti"
	.byte	0x2
	.byte	0xc2
	.long	.LFB22
	.long	.LFE22-.LFB22
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x11
	.long	.LASF390
	.byte	0x2
	.byte	0xca
	.long	0x32b
	.long	.LFB23
	.long	.LFE23-.LFB23
	.uleb128 0x1
	.byte	0x9c
	.long	0x32b
	.uleb128 0x12
	.string	"IF"
	.byte	0x2
	.byte	0xcb
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x6
	.byte	0x1
	.byte	0x2
	.long	.LASF389
	.uleb128 0x11
	.long	.LASF391
	.byte	0x2
	.byte	0xd5
	.long	0x86
	.long	.LFB24
	.long	.LFE24-.LFB24
	.uleb128 0x1
	.byte	0x9c
	.long	0x35a
	.uleb128 0x13
	.long	.LASF392
	.byte	0x2
	.byte	0xd6
	.long	0x86
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x14
	.long	.LASF393
	.byte	0x2
	.byte	0xde
	.long	0x32b
	.long	.LFB25
	.long	.LFE25-.LFB25
	.uleb128 0x1
	.byte	0x9c
	.long	0x382
	.uleb128 0x13
	.long	.LASF392
	.byte	0x2
	.byte	0xdf
	.long	0x86
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x15
	.long	.LASF395
	.byte	0x3
	.byte	0x8
	.long	.LFB42
	.long	.LFE42-.LFB42
	.uleb128 0x1
	.byte	0x9c
	.long	0x3a6
	.uleb128 0xf
	.long	.LASF394
	.byte	0x3
	.byte	0x8
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x15
	.long	.LASF396
	.byte	0x3
	.byte	0xe
	.long	.LFB43
	.long	.LFE43-.LFB43
	.uleb128 0x1
	.byte	0x9c
	.long	0x3d2
	.uleb128 0x16
	.long	.LBB2
	.long	.LBE2-.LBB2
	.uleb128 0x12
	.string	"i"
	.byte	0x3
	.byte	0x10
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.byte	0
	.uleb128 0x15
	.long	.LASF397
	.byte	0x3
	.byte	0x21
	.long	.LFB44
	.long	.LFE44-.LFB44
	.uleb128 0x1
	.byte	0x9c
	.long	0x452
	.uleb128 0xf
	.long	.LASF394
	.byte	0x3
	.byte	0x21
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xf
	.long	.LASF398
	.byte	0x3
	.byte	0x21
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x13
	.long	.LASF399
	.byte	0x3
	.byte	0x22
	.long	0x452
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x13
	.long	.LASF377
	.byte	0x3
	.byte	0x23
	.long	0x458
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x13
	.long	.LASF400
	.byte	0x3
	.byte	0x24
	.long	0x131
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x13
	.long	.LASF401
	.byte	0x3
	.byte	0x2b
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x16
	.long	.LBB3
	.long	.LBE3-.LBB3
	.uleb128 0x12
	.string	"i"
	.byte	0x3
	.byte	0x25
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x1f6
	.uleb128 0x4
	.byte	0x4
	.long	0x17f
	.uleb128 0x15
	.long	.LASF402
	.byte	0x3
	.byte	0x3d
	.long	.LFB45
	.long	.LFE45-.LFB45
	.uleb128 0x1
	.byte	0x9c
	.long	0x4fc
	.uleb128 0xf
	.long	.LASF359
	.byte	0x3
	.byte	0x3d
	.long	0x131
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xf
	.long	.LASF399
	.byte	0x3
	.byte	0x3d
	.long	0x452
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0xf
	.long	.LASF403
	.byte	0x3
	.byte	0x3d
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0x13
	.long	.LASF377
	.byte	0x3
	.byte	0x44
	.long	0x458
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x13
	.long	.LASF404
	.byte	0x3
	.byte	0x45
	.long	0x131
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x13
	.long	.LASF405
	.byte	0x3
	.byte	0x46
	.long	0x131
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x13
	.long	.LASF406
	.byte	0x3
	.byte	0x48
	.long	0x131
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x13
	.long	.LASF407
	.byte	0x3
	.byte	0x49
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x16
	.long	.LBB4
	.long	.LBE4-.LBB4
	.uleb128 0x13
	.long	.LASF408
	.byte	0x3
	.byte	0x4c
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.byte	0
	.byte	0
	.uleb128 0x17
	.long	.LASF409
	.byte	0x3
	.byte	0x72
	.long	0x9b
	.long	.LFB46
	.long	.LFE46-.LFB46
	.uleb128 0x1
	.byte	0x9c
	.long	0x532
	.uleb128 0xf
	.long	.LASF359
	.byte	0x3
	.byte	0x72
	.long	0x131
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xf
	.long	.LASF403
	.byte	0x3
	.byte	0x72
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.byte	0
	.uleb128 0x18
	.long	.LASF410
	.byte	0x3
	.byte	0x79
	.long	0x131
	.long	.LFB47
	.long	.LFE47-.LFB47
	.uleb128 0x1
	.byte	0x9c
	.long	0x5aa
	.uleb128 0xf
	.long	.LASF399
	.byte	0x3
	.byte	0x79
	.long	0x452
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xf
	.long	.LASF403
	.byte	0x3
	.byte	0x79
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x12
	.string	"IF"
	.byte	0x3
	.byte	0x7a
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x13
	.long	.LASF377
	.byte	0x3
	.byte	0x7e
	.long	0x458
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x12
	.string	"i"
	.byte	0x3
	.byte	0x7f
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x12
	.string	"lru"
	.byte	0x3
	.byte	0x88
	.long	0x4e
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x12
	.string	"it"
	.byte	0x3
	.byte	0x8b
	.long	0x131
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.byte	0
	.uleb128 0x15
	.long	.LASF411
	.byte	0x3
	.byte	0x97
	.long	.LFB48
	.long	.LFE48-.LFB48
	.uleb128 0x1
	.byte	0x9c
	.long	0x622
	.uleb128 0xf
	.long	.LASF377
	.byte	0x3
	.byte	0x97
	.long	0x458
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xf
	.long	.LASF403
	.byte	0x3
	.byte	0x97
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x13
	.long	.LASF370
	.byte	0x3
	.byte	0x98
	.long	0x4e
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x12
	.string	"lru"
	.byte	0x3
	.byte	0x9a
	.long	0x4e
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x13
	.long	.LASF412
	.byte	0x3
	.byte	0x9e
	.long	0x622
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x13
	.long	.LASF413
	.byte	0x3
	.byte	0x9f
	.long	0x622
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x13
	.long	.LASF414
	.byte	0x3
	.byte	0xa1
	.long	0x622
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x137
	.uleb128 0x15
	.long	.LASF376
	.byte	0x3
	.byte	0xae
	.long	.LFB49
	.long	.LFE49-.LFB49
	.uleb128 0x1
	.byte	0x9c
	.long	0x675
	.uleb128 0xf
	.long	.LASF359
	.byte	0x3
	.byte	0xae
	.long	0x622
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xf
	.long	.LASF403
	.byte	0x3
	.byte	0xae
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x12
	.string	"IF"
	.byte	0x3
	.byte	0xaf
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x13
	.long	.LASF399
	.byte	0x3
	.byte	0xb1
	.long	0x452
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0x18
	.long	.LASF415
	.byte	0x3
	.byte	0xbd
	.long	0x131
	.long	.LFB50
	.long	.LFE50-.LFB50
	.uleb128 0x1
	.byte	0x9c
	.long	0x6ea
	.uleb128 0xf
	.long	.LASF416
	.byte	0x3
	.byte	0xbd
	.long	0x7b
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0xf
	.long	.LASF403
	.byte	0x3
	.byte	0xbd
	.long	0x9b
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x13
	.long	.LASF359
	.byte	0x3
	.byte	0xbf
	.long	0x131
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x19
	.long	.LASF420
	.byte	0x3
	.byte	0xc0
	.long	0x9b
	.uleb128 0x16
	.long	.LBB5
	.long	.LBE5-.LBB5
	.uleb128 0x12
	.string	"ppg"
	.byte	0x3
	.byte	0xd1
	.long	0x86
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x13
	.long	.LASF417
	.byte	0x3
	.byte	0xd2
	.long	0x6ea
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.byte	0
	.byte	0
	.uleb128 0x4
	.byte	0x4
	.long	0x6f0
	.uleb128 0x6
	.byte	0x1
	.byte	0x6
	.long	.LASF418
	.uleb128 0xb
	.long	0x86
	.long	0x707
	.uleb128 0xc
	.long	0x1ef
	.byte	0x2
	.byte	0
	.uleb128 0x13
	.long	.LASF419
	.byte	0x3
	.byte	0xd
	.long	0x6f7
	.uleb128 0x5
	.byte	0x3
	.long	pa_of_zone
	.uleb128 0xb
	.long	0x6f0
	.long	0x728
	.uleb128 0xc
	.long	0x1ef
	.byte	0x3
	.byte	0
	.uleb128 0x1a
	.long	.LASF421
	.byte	0x5
	.byte	0x35
	.long	0x718
	.uleb128 0x5
	.byte	0x3
	.long	mem_entity
	.uleb128 0x1a
	.long	.LASF422
	.byte	0x4
	.byte	0x1e
	.long	0x131
	.uleb128 0x5
	.byte	0x3
	.long	mem_map
	.uleb128 0x1a
	.long	.LASF423
	.byte	0x4
	.byte	0x40
	.long	0x1f6
	.uleb128 0x5
	.byte	0x3
	.long	zone_dma
	.uleb128 0x1a
	.long	.LASF424
	.byte	0x4
	.byte	0x41
	.long	0x1f6
	.uleb128 0x5
	.byte	0x3
	.long	zone_normal
	.uleb128 0x1a
	.long	.LASF425
	.byte	0x4
	.byte	0x42
	.long	0x1f6
	.uleb128 0x5
	.byte	0x3
	.long	zone_highmem
	.uleb128 0xb
	.long	0x452
	.long	0x78d
	.uleb128 0xc
	.long	0x1ef
	.byte	0x2
	.byte	0
	.uleb128 0x1a
	.long	.LASF426
	.byte	0x3
	.byte	0xc
	.long	0x77d
	.uleb128 0x5
	.byte	0x3
	.long	__zones
	.uleb128 0x1a
	.long	.LASF427
	.byte	0x4
	.byte	0x44
	.long	0x6f7
	.uleb128 0x5
	.byte	0x3
	.long	size_of_zone
	.uleb128 0x19
	.long	.LASF420
	.byte	0x3
	.byte	0xc0
	.long	0x9b
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
	.uleb128 0xb
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xd
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
	.uleb128 0xe
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
	.uleb128 0xf
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
	.uleb128 0x10
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
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
	.byte	0
	.byte	0
	.uleb128 0x11
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
	.uleb128 0x12
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
	.uleb128 0x15
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
	.uleb128 0x16
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x17
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
	.uleb128 0x18
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
	.uleb128 0x19
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
	.uleb128 0x1a
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
	.uleb128 0x3
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
	.uleb128 0x4
	.byte	0x5
	.uleb128 0x2
	.long	.LASF228
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x1
	.byte	0x5
	.uleb128 0x2
	.long	.LASF229
	.file 7 "./include/linux/assert.h"
	.byte	0x3
	.uleb128 0x5
	.uleb128 0x7
	.byte	0x7
	.long	.Ldebug_macro1
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro2
	.byte	0x4
	.file 8 "./include/linux/mm.h"
	.byte	0x3
	.uleb128 0x4
	.uleb128 0x8
	.byte	0x5
	.uleb128 0x2
	.long	.LASF235
	.byte	0x3
	.uleb128 0x4
	.uleb128 0x6
	.byte	0x7
	.long	.Ldebug_macro3
	.byte	0x4
	.byte	0x3
	.uleb128 0x5
	.uleb128 0x2
	.byte	0x5
	.uleb128 0x2
	.long	.LASF249
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x5
	.byte	0x7
	.long	.Ldebug_macro4
	.byte	0x4
	.file 9 "./include/linux/mylist.h"
	.byte	0x3
	.uleb128 0x4
	.uleb128 0x9
	.byte	0x7
	.long	.Ldebug_macro5
	.byte	0x4
	.file 10 "./include/linux/byteorder/generic.h"
	.byte	0x3
	.uleb128 0x7
	.uleb128 0xa
	.byte	0x7
	.long	.Ldebug_macro6
	.byte	0x4
	.file 11 "./include/linux/string.h"
	.byte	0x3
	.uleb128 0x8
	.uleb128 0xb
	.byte	0x5
	.uleb128 0x2
	.long	.LASF285
	.byte	0x4
	.file 12 "./include/old/mm.h"
	.byte	0x3
	.uleb128 0x3c
	.uleb128 0xc
	.byte	0x5
	.uleb128 0x2
	.long	.LASF286
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x8
	.byte	0x4
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro7
	.byte	0x4
	.byte	0x3
	.uleb128 0x7
	.uleb128 0x4
	.byte	0x4
	.file 13 "./include/old/pmm.h"
	.byte	0x3
	.uleb128 0x8
	.uleb128 0xd
	.byte	0x5
	.uleb128 0x2
	.long	.LASF297
	.file 14 "./arch/x86/include/asm/page.h"
	.byte	0x3
	.uleb128 0x4
	.uleb128 0xe
	.byte	0x7
	.long	.Ldebug_macro8
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro9
	.byte	0x4
	.file 15 "./include/linux/sched.h"
	.byte	0x3
	.uleb128 0x9
	.uleb128 0xf
	.byte	0x7
	.long	.Ldebug_macro10
	.byte	0x4
	.byte	0x5
	.uleb128 0x82
	.long	.LASF326
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro11
	.byte	0x4
	.byte	0x4
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.assert.h.2.04d8cd0d4ab92c4edaf5ee8e3da38922,comdat
.Ldebug_macro1:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF230
	.byte	0x5
	.uleb128 0x6
	.long	.LASF231
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.list.h.11.14b8b11cd281772ad6d5a70018d2cfae,comdat
.Ldebug_macro2:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0xb
	.long	.LASF232
	.byte	0x5
	.uleb128 0x46
	.long	.LASF233
	.byte	0x5
	.uleb128 0x57
	.long	.LASF234
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.valType.h.3.7c3190cc3f15c77f186fd44ab736eede,comdat
.Ldebug_macro3:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x3
	.long	.LASF236
	.byte	0x5
	.uleb128 0x5
	.long	.LASF237
	.byte	0x5
	.uleb128 0x6
	.long	.LASF238
	.byte	0x5
	.uleb128 0x7
	.long	.LASF239
	.byte	0x5
	.uleb128 0x8
	.long	.LASF240
	.byte	0x5
	.uleb128 0x9
	.long	.LASF241
	.byte	0x5
	.uleb128 0xb
	.long	.LASF242
	.byte	0x5
	.uleb128 0x39
	.long	.LASF243
	.byte	0x5
	.uleb128 0x3a
	.long	.LASF244
	.byte	0x5
	.uleb128 0x3b
	.long	.LASF245
	.byte	0x5
	.uleb128 0x3c
	.long	.LASF246
	.byte	0x5
	.uleb128 0x3d
	.long	.LASF247
	.byte	0x5
	.uleb128 0x3e
	.long	.LASF248
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.ku_utils.h.2.5922a71b1df9dd5ef65a03e03d1ab8b0,comdat
.Ldebug_macro4:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF250
	.byte	0x5
	.uleb128 0x4
	.long	.LASF251
	.byte	0x5
	.uleb128 0x5
	.long	.LASF252
	.byte	0x5
	.uleb128 0x8
	.long	.LASF253
	.byte	0x5
	.uleb128 0x1f
	.long	.LASF254
	.byte	0x5
	.uleb128 0x2c
	.long	.LASF255
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.mylist.h.2.6dffd1aa01612dc930709a466e043124,comdat
.Ldebug_macro5:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF256
	.byte	0x5
	.uleb128 0x12
	.long	.LASF257
	.byte	0x5
	.uleb128 0x1b
	.long	.LASF258
	.byte	0x5
	.uleb128 0x2c
	.long	.LASF259
	.byte	0x5
	.uleb128 0x58
	.long	.LASF260
	.byte	0x5
	.uleb128 0x68
	.long	.LASF261
	.byte	0x5
	.uleb128 0x76
	.long	.LASF262
	.byte	0x5
	.uleb128 0x7f
	.long	.LASF263
	.byte	0x5
	.uleb128 0x94
	.long	.LASF264
	.byte	0x5
	.uleb128 0xaf
	.long	.LASF265
	.byte	0x5
	.uleb128 0xc8
	.long	.LASF266
	.byte	0x5
	.uleb128 0xd1
	.long	.LASF267
	.byte	0x5
	.uleb128 0xdb
	.long	.LASF268
	.byte	0x5
	.uleb128 0xe5
	.long	.LASF269
	.byte	0x5
	.uleb128 0xf2
	.long	.LASF270
	.byte	0x5
	.uleb128 0xfb
	.long	.LASF271
	.byte	0x5
	.uleb128 0x103
	.long	.LASF272
	.byte	0x5
	.uleb128 0x112
	.long	.LASF273
	.byte	0x5
	.uleb128 0x125
	.long	.LASF274
	.byte	0x5
	.uleb128 0x12d
	.long	.LASF275
	.byte	0x5
	.uleb128 0x144
	.long	.LASF276
	.byte	0x5
	.uleb128 0x155
	.long	.LASF277
	.byte	0x5
	.uleb128 0x163
	.long	.LASF278
	.byte	0x5
	.uleb128 0x16c
	.long	.LASF279
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.generic.h.2.080a533b5efade0c3c025e01b2a9592c,comdat
.Ldebug_macro6:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF280
	.byte	0x5
	.uleb128 0x13
	.long	.LASF281
	.byte	0x5
	.uleb128 0x14
	.long	.LASF282
	.byte	0x5
	.uleb128 0x16
	.long	.LASF283
	.byte	0x5
	.uleb128 0x17
	.long	.LASF284
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.utils.h.64.4303da2b831b2923c55728136f07b37e,comdat
.Ldebug_macro7:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x40
	.long	.LASF287
	.byte	0x5
	.uleb128 0x41
	.long	.LASF288
	.byte	0x5
	.uleb128 0x7a
	.long	.LASF289
	.byte	0x5
	.uleb128 0x7f
	.long	.LASF290
	.byte	0x5
	.uleb128 0x80
	.long	.LASF291
	.byte	0x5
	.uleb128 0x81
	.long	.LASF292
	.byte	0x5
	.uleb128 0x82
	.long	.LASF293
	.byte	0x5
	.uleb128 0x96
	.long	.LASF294
	.byte	0x5
	.uleb128 0xe6
	.long	.LASF295
	.byte	0x5
	.uleb128 0xf0
	.long	.LASF296
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.page.h.2.207eb50c0e81a8bc7de8e22e9a0f0426,comdat
.Ldebug_macro8:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF298
	.byte	0x5
	.uleb128 0x5
	.long	.LASF299
	.byte	0x5
	.uleb128 0x6
	.long	.LASF300
	.byte	0x5
	.uleb128 0x7
	.long	.LASF301
	.byte	0x5
	.uleb128 0x8
	.long	.LASF302
	.byte	0x5
	.uleb128 0x9
	.long	.LASF303
	.byte	0x5
	.uleb128 0xb
	.long	.LASF304
	.byte	0x5
	.uleb128 0xc
	.long	.LASF305
	.byte	0x5
	.uleb128 0xd
	.long	.LASF306
	.byte	0x5
	.uleb128 0xf
	.long	.LASF307
	.byte	0x5
	.uleb128 0x10
	.long	.LASF308
	.byte	0x5
	.uleb128 0x16
	.long	.LASF309
	.byte	0x5
	.uleb128 0x1c
	.long	.LASF310
	.byte	0x5
	.uleb128 0x1d
	.long	.LASF311
	.byte	0x5
	.uleb128 0x20
	.long	.LASF312
	.byte	0x5
	.uleb128 0x21
	.long	.LASF313
	.byte	0x5
	.uleb128 0x64
	.long	.LASF314
	.byte	0x5
	.uleb128 0x65
	.long	.LASF315
	.byte	0x5
	.uleb128 0x66
	.long	.LASF316
	.byte	0x5
	.uleb128 0x6f
	.long	.LASF317
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.pmm.h.8.69f113fbfd31e0be7c6df631a51dd893,comdat
.Ldebug_macro9:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x8
	.long	.LASF318
	.byte	0x5
	.uleb128 0x9
	.long	.LASF319
	.byte	0x5
	.uleb128 0xf
	.long	.LASF320
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.sched.h.2.5f20ed4187e2b315e38086c6f42d15cd,comdat
.Ldebug_macro10:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF321
	.byte	0x5
	.uleb128 0xa
	.long	.LASF322
	.byte	0x5
	.uleb128 0xb
	.long	.LASF323
	.byte	0x5
	.uleb128 0xc
	.long	.LASF324
	.byte	0x5
	.uleb128 0xd
	.long	.LASF325
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.mmzone.h.7.e3c9150cc58cba9f45f09d3f9a9fdf77,comdat
.Ldebug_macro11:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x7
	.long	.LASF327
	.byte	0x5
	.uleb128 0x18
	.long	.LASF328
	.byte	0x5
	.uleb128 0x19
	.long	.LASF329
	.byte	0x5
	.uleb128 0x1a
	.long	.LASF330
	.byte	0x5
	.uleb128 0x1b
	.long	.LASF331
	.byte	0x5
	.uleb128 0x1c
	.long	.LASF332
	.byte	0x5
	.uleb128 0x1d
	.long	.LASF333
	.byte	0x5
	.uleb128 0x20
	.long	.LASF334
	.byte	0x5
	.uleb128 0x22
	.long	.LASF335
	.byte	0x5
	.uleb128 0x23
	.long	.LASF336
	.byte	0x5
	.uleb128 0x24
	.long	.LASF337
	.byte	0x5
	.uleb128 0x25
	.long	.LASF338
	.byte	0x5
	.uleb128 0x26
	.long	.LASF339
	.byte	0x5
	.uleb128 0x28
	.long	.LASF340
	.byte	0x5
	.uleb128 0x29
	.long	.LASF341
	.byte	0x5
	.uleb128 0x2a
	.long	.LASF342
	.byte	0x5
	.uleb128 0x2b
	.long	.LASF343
	.byte	0x5
	.uleb128 0x2d
	.long	.LASF344
	.byte	0x5
	.uleb128 0x2e
	.long	.LASF345
	.byte	0x5
	.uleb128 0x2f
	.long	.LASF346
	.byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF162:
	.string	"__LDBL_DENORM_MIN__ 3.64519953188247460253e-4951L"
.LASF77:
	.string	"__PTRDIFF_MAX__ 2147483647"
.LASF427:
	.string	"size_of_zone"
.LASF179:
	.string	"__DEC64_SUBNORMAL_MIN__ 0.000000000000001E-383DD"
.LASF144:
	.string	"__DBL_DECIMAL_DIG__ 17"
.LASF121:
	.string	"__FLT_EVAL_METHOD__ 2"
.LASF132:
	.string	"__FLT_MIN__ 1.17549435082228750797e-38F"
.LASF361:
	.string	"cow_shared"
.LASF417:
	.string	"vaddr"
.LASF366:
	.string	"debug"
.LASF205:
	.string	"__GCC_ATOMIC_TEST_AND_SET_TRUEVAL 1"
.LASF178:
	.string	"__DEC64_EPSILON__ 1E-15DD"
.LASF93:
	.string	"__INT_LEAST8_MAX__ 127"
.LASF260:
	.ascii	"LL_INSERT(list,location,new) do{ assert( ( (list) == (locati"
	.ascii	"on) ) || ( (list) &"
	.string	"& (location) ) ); assert((new)); if(!list && !location) { list = new; new->next = new->prev = 0; break; } new->next=location; new->prev=location->prev; if(location->prev) location->prev->next=new; location->prev=new; if(list==location) list=new; } while(0)"
.LASF85:
	.string	"__INT8_MAX__ 127"
.LASF102:
	.string	"__UINT8_C(c) c"
.LASF71:
	.string	"__LONG_MAX__ 2147483647L"
.LASF408:
	.string	"block_pgs"
.LASF287:
	.string	"return_say(msg) do{oprintf(\"%s\",msg);return;} while(0)"
.LASF140:
	.string	"__DBL_MIN_EXP__ (-1021)"
.LASF99:
	.string	"__INT_LEAST64_MAX__ 9223372036854775807LL"
.LASF217:
	.string	"__i686__ 1"
.LASF328:
	.string	"page_idx(page_t) ((unsigned)((page_t) - mem_map))"
.LASF210:
	.string	"__SIZEOF_WINT_T__ 4"
.LASF393:
	.string	"cli_already"
.LASF338:
	.string	"__GFP_HIGHMEM (1<<2)"
.LASF274:
	.string	"O_INSERT_AFTER(_prev,new) ({ new->next = _prev->next; new->prev = _prev; _prev->next->prev = new; _prev->next = new; })"
.LASF160:
	.string	"__LDBL_MIN__ 3.36210314311209350626e-4932L"
.LASF250:
	.string	"KU_UTILS_H "
.LASF281:
	.string	"ntohs(x) htons(x)"
.LASF336:
	.string	"__GFP_ZERO (1<<0)"
.LASF354:
	.string	"unsigned int"
.LASF348:
	.string	"next"
.LASF311:
	.string	"__pa2page_t(paddr) (mem_map + ((paddr) >> 12))"
.LASF405:
	.string	"assume_head"
.LASF21:
	.string	"__SIZEOF_SIZE_T__ 4"
.LASF36:
	.string	"__CHAR16_TYPE__ short unsigned int"
.LASF3:
	.string	"__GNUC__ 4"
.LASF384:
	.string	"head"
.LASF25:
	.string	"__ORDER_BIG_ENDIAN__ 4321"
.LASF183:
	.string	"__DEC128_MIN__ 1E-6143DL"
.LASF291:
	.string	"EXCHG_U32(a,b) do{unsigned c=a;a=b;b=c;} while(0)"
.LASF138:
	.string	"__DBL_MANT_DIG__ 53"
.LASF137:
	.string	"__FLT_HAS_QUIET_NAN__ 1"
.LASF11:
	.string	"__ATOMIC_ACQ_REL 4"
.LASF10:
	.string	"__ATOMIC_RELEASE 3"
.LASF329:
	.string	"pte_pfn(pte) ((pte)>>PAGE_SHIFT)"
.LASF31:
	.string	"__PTRDIFF_TYPE__ int"
.LASF40:
	.string	"__INT16_TYPE__ short int"
.LASF171:
	.string	"__DEC32_EPSILON__ 1E-6DF"
.LASF15:
	.string	"__SIZEOF_LONG__ 4"
.LASF70:
	.string	"__INT_MAX__ 2147483647"
.LASF153:
	.string	"__LDBL_DIG__ 18"
.LASF8:
	.string	"__ATOMIC_SEQ_CST 5"
.LASF17:
	.string	"__SIZEOF_SHORT__ 2"
.LASF389:
	.string	"_Bool"
.LASF134:
	.string	"__FLT_DENORM_MIN__ 1.40129846432481707092e-45F"
.LASF47:
	.string	"__INT_LEAST8_TYPE__ signed char"
.LASF376:
	.string	"free_pages"
.LASF233:
	.ascii	"LIST_FIND2(stru"
	.string	"_t,mb_t,root,key,value,result) do{ struct list_head * node = root->next; stru_t *obj; while(node != root){ *obj = MB2STRU(stru_t, node, mb_t); if( (obj)->key == value ) break; node = node->next; } if(node == root) result = 0; else result = obj; } while(0);"
.LASF82:
	.string	"__UINTMAX_C(c) c ## ULL"
.LASF375:
	.string	"zone_struct"
.LASF110:
	.string	"__INT_FAST16_MAX__ 2147483647"
.LASF27:
	.string	"__BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__"
.LASF172:
	.string	"__DEC32_SUBNORMAL_MIN__ 0.000001E-95DF"
.LASF262:
	.string	"LL_I2(root,new) do{ assert(root); if(root->next) root->next->prev = new; new->next = root->next; new->prev = root; root->next = new; }while(0)"
.LASF347:
	.string	"prev"
.LASF74:
	.string	"__WCHAR_MIN__ (-__WCHAR_MAX__ - 1)"
.LASF385:
	.string	"__list_del"
.LASF131:
	.string	"__FLT_MAX__ 3.40282346638528859812e+38F"
.LASF253:
	.ascii	"eat_hex(pt,x) char*__pt=(pt); x=0; if(*__pt!='0'||*(__pt+1)!"
	.ascii	"='x'){ x=-1; goto donothing; } __pt+=2; if(!((*__pt>='0'&&*_"
	.ascii	"_pt<='9'"
	.string	")||(*__pt>='a'&&*__pt<='f'))){ x=-1; goto donothing; } while((*__pt>='0'&&*__pt<='9')||(*__pt>='a'&&*__pt<='f')) __pt++; __pt--; int __len=__pt-pt+1-2; for(int __i=0;__i<__len;__i++){ x+=hex_int(*__pt)*pow_int(16,__i); __pt--; } (pt)+=(2+__len);donothing:;"
.LASF55:
	.string	"__INT_FAST8_TYPE__ signed char"
.LASF7:
	.string	"__ATOMIC_RELAXED 0"
.LASF339:
	.string	"__GFP_NORMAL (1<<3)"
.LASF66:
	.string	"__has_include_next(STR) __has_include_next__(STR)"
.LASF312:
	.string	"pte2page(pte) ((void *)__va((pte).value & PAGE_MASK))"
.LASF404:
	.string	"orphan"
.LASF227:
	.string	"__DECIMAL_BID_FORMAT__ 1"
.LASF415:
	.string	"alloc_pages"
.LASF92:
	.string	"__UINT64_MAX__ 18446744073709551615ULL"
.LASF249:
	.string	"UTILS_H "
.LASF94:
	.string	"__INT8_C(c) c"
.LASF228:
	.string	"MMZONE_H "
.LASF78:
	.string	"__SIZE_MAX__ 4294967295U"
.LASF49:
	.string	"__INT_LEAST32_TYPE__ int"
.LASF399:
	.string	"zone"
.LASF422:
	.string	"mem_map"
.LASF68:
	.string	"__SCHAR_MAX__ 127"
.LASF216:
	.string	"__i686 1"
.LASF87:
	.string	"__INT32_MAX__ 2147483647"
.LASF420:
	.string	"avoid_gcc_complain"
.LASF113:
	.string	"__UINT_FAST8_MAX__ 255"
.LASF64:
	.string	"__UINTPTR_TYPE__ unsigned int"
.LASF292:
	.string	"EXCHG_PTR(a,b) do { void *tmp = a; a = b; b = tmp; } while(0)"
.LASF259:
	.ascii	"LL2_DEL(ll2,node) do{ assert( (ll2) && (node) && (ll2)->root"
	.ascii	" && (ll2)->tail ); i"
	.string	"f( (node)->prev ){ (node)->prev->next = (node)->next; } else{ assert( (ll2)->root == node ); (ll2)->root = (node)->next; } if( (node)->next ){ (node)->next->prev = (node)->prev; } else{ assert( (ll2)->tail == node ); (ll2)->tail = (node)->prev; } }while(0)"
.LASF225:
	.string	"__unix__ 1"
.LASF192:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 1"
.LASF360:
	.string	"_count"
.LASF413:
	.string	"child1"
.LASF414:
	.string	"child2"
.LASF125:
	.string	"__FLT_DIG__ 6"
.LASF234:
	.string	"MB2STRU(stru_type,mb_addr,mb_name) (stru_type *)( (u32)(mb_addr)- (u32)&((stru_type *)0)->mb_name )"
.LASF247:
	.string	"__1G 0x40000000"
.LASF146:
	.string	"__DBL_MIN__ ((double)2.22507385850720138309e-308L)"
.LASF169:
	.string	"__DEC32_MIN__ 1E-95DF"
.LASF119:
	.string	"__GCC_IEC_559 2"
.LASF230:
	.string	"ASSERT_H "
.LASF307:
	.string	"PG_H10(pg_id) (pg_id>>10)"
.LASF161:
	.string	"__LDBL_EPSILON__ 1.08420217248550443401e-19L"
.LASF340:
	.string	"ZONE_DMA 0"
.LASF345:
	.string	"ZONE_NORMAL_PA 0X1000000"
.LASF357:
	.string	"long long unsigned int"
.LASF181:
	.string	"__DEC128_MIN_EXP__ (-6142)"
.LASF246:
	.string	"__4M 0x400000"
.LASF326:
	.string	"PGDIR_OF_MM(mm) ( (union pte *)__va(mm->cr3.value & PAGE_MASK) )"
.LASF185:
	.string	"__DEC128_EPSILON__ 1E-33DL"
.LASF111:
	.string	"__INT_FAST32_MAX__ 2147483647"
.LASF289:
	.string	"DSI(str,i) dispStr(str,0x400);dispInt(i);"
.LASF123:
	.string	"__FLT_RADIX__ 2"
.LASF20:
	.string	"__SIZEOF_LONG_DOUBLE__ 12"
.LASF257:
	.string	"LL2_POP(ll2) do{ assert( (ll2 && (ll2)->root && (ll2)->tail)); ll2->root = ll2->root->next; if(ll2->root) ll2->root->prev = 0; else ll2->tail = ll2->root; }while(0)"
.LASF151:
	.string	"__DBL_HAS_QUIET_NAN__ 1"
.LASF407:
	.string	"curr_order"
.LASF60:
	.string	"__UINT_FAST16_TYPE__ unsigned int"
.LASF215:
	.string	"__ATOMIC_HLE_RELEASE 131072"
.LASF156:
	.string	"__LDBL_MAX_EXP__ 16384"
.LASF270:
	.string	"LL_SCAN_ON_kEY_B(root,key,value) ({ typeof(root) curr = root; while(curr && curr->key <= (value) ) curr = curr->next; curr; })"
.LASF242:
	.string	"NULL 0"
.LASF248:
	.string	"__3G 0xc0000000"
.LASF364:
	.string	"PG_private"
.LASF177:
	.string	"__DEC64_MAX__ 9.999999999999999E384DD"
.LASF202:
	.string	"__GCC_ATOMIC_INT_LOCK_FREE 2"
.LASF109:
	.string	"__INT_FAST8_MAX__ 127"
.LASF159:
	.string	"__LDBL_MAX__ 1.18973149535723176502e+4932L"
.LASF24:
	.string	"__ORDER_LITTLE_ENDIAN__ 1234"
.LASF211:
	.string	"__SIZEOF_PTRDIFF_T__ 4"
.LASF72:
	.string	"__LONG_LONG_MAX__ 9223372036854775807LL"
.LASF285:
	.string	"LINUX_STRING_H "
.LASF180:
	.string	"__DEC128_MANT_DIG__ 34"
.LASF41:
	.string	"__INT32_TYPE__ int"
.LASF280:
	.string	"BYTEORDER_GENERIC_H "
.LASF168:
	.string	"__DEC32_MAX_EXP__ 97"
.LASF323:
	.string	"CLONE_VM 0x100"
.LASF343:
	.string	"ZONE_MAX 3"
.LASF244:
	.string	"__8K 0x2000"
.LASF145:
	.string	"__DBL_MAX__ ((double)1.79769313486231570815e+308L)"
.LASF95:
	.string	"__INT_LEAST16_MAX__ 32767"
.LASF368:
	.string	"page_t"
.LASF239:
	.string	"true 1"
.LASF54:
	.string	"__UINT_LEAST64_TYPE__ long long unsigned int"
.LASF346:
	.string	"ZONE_HIGHMEM_PA (896*0x100000)"
.LASF67:
	.string	"__GXX_ABI_VERSION 1002"
.LASF114:
	.string	"__UINT_FAST16_MAX__ 4294967295U"
.LASF383:
	.string	"list_add"
.LASF56:
	.string	"__INT_FAST16_TYPE__ int"
.LASF309:
	.string	"FLUSH_TLB __asm__ __volatile__(\"mov %%cr3, %0\\n\\t\" \"mov %0, %%cr3\\n\\t\" : :\"r\"(0))"
.LASF213:
	.string	"__i386__ 1"
.LASF44:
	.string	"__UINT16_TYPE__ short unsigned int"
.LASF4:
	.string	"__GNUC_MINOR__ 9"
.LASF197:
	.string	"__GCC_ATOMIC_CHAR_LOCK_FREE 2"
.LASF42:
	.string	"__INT64_TYPE__ long long int"
.LASF419:
	.string	"pa_of_zone"
.LASF411:
	.string	"cleave"
.LASF365:
	.string	"PG_zid"
.LASF288:
	.string	"returnx_say(x,msg) do{oprintf(\"%s\",msg);return x;} while(0)"
.LASF190:
	.string	"__NO_INLINE__ 1"
.LASF266:
	.ascii	"LL_DEL(list,location) d"
	.string	"o{ assert(list&&location); assert(!(!location->next && !location->prev && (list!=location))); if(location->prev) location->prev->next=location->next; if(location->next) location->next->prev=location->prev; if(list==location) list=location->next; } while(0)"
.LASF124:
	.string	"__FLT_MANT_DIG__ 24"
.LASF148:
	.string	"__DBL_DENORM_MIN__ ((double)4.94065645841246544177e-324L)"
.LASF318:
	.string	"HEAP_BASE 18*0x100000"
.LASF194:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 1"
.LASF46:
	.string	"__UINT64_TYPE__ long long unsigned int"
.LASF238:
	.string	"boolean _Bool"
.LASF284:
	.string	"BYTE_ENDIAN_FLIP4(x) x = htonl(x)"
.LASF324:
	.string	"CLONE_FS 0x200"
.LASF122:
	.string	"__DEC_EVAL_METHOD__ 2"
.LASF141:
	.string	"__DBL_MIN_10_EXP__ (-307)"
.LASF418:
	.string	"char"
.LASF295:
	.string	"MAKE_IP(a,b,c,d) (((a)<<24) + ((b)<<16) + ((c)<<8) + d)"
.LASF255:
	.string	"eat_dec_with_len(pt,x,x_len) char*__pt=(pt); while(*(__pt+1)>='0'&&*(__pt+1)<='9') __pt++; len=__pt-(pt)+1; for(int __i=0;__i<x_len;__i++){ x+=(*__pt-48)*pow_int(10,__i); __pt--; } (pt)+=x_len;"
.LASF155:
	.string	"__LDBL_MIN_10_EXP__ (-4931)"
.LASF81:
	.string	"__UINTMAX_MAX__ 18446744073709551615ULL"
.LASF220:
	.string	"__code_model_32__ 1"
.LASF236:
	.string	"VALTYPE_H "
.LASF335:
	.string	"__GFP_DEFAULT 0"
.LASF200:
	.string	"__GCC_ATOMIC_WCHAR_T_LOCK_FREE 2"
.LASF403:
	.string	"order"
.LASF258:
	.ascii	"LL2_A(ll2,node) do{ assert( (ll2) &&"
	.string	" (node) ); assert( ( (ll2)->root == 0 && (ll2)->tail == 0 ) || ( (ll2)->root != 0 && (ll2)->tail != 0) ); (node)->prev = (ll2)->tail; if( (ll2)->tail ){ (ll2)->tail->next = node; } else{ (ll2)->root = node; } (node)->next = 0; (ll2)->tail = node; }while(0)"
.LASF91:
	.string	"__UINT32_MAX__ 4294967295U"
.LASF231:
	.string	"assert(exp) do{ if(!(exp)) assert_func(#exp,__FILE__,__BASE_FILE__,__LINE__); } while(0)"
.LASF396:
	.string	"init_zone"
.LASF302:
	.string	"pa_idx(paddr) ((paddr)>>PAGE_SHIFT)"
.LASF170:
	.string	"__DEC32_MAX__ 9.999999E96DF"
.LASF48:
	.string	"__INT_LEAST16_TYPE__ short int"
.LASF107:
	.string	"__UINT_LEAST64_MAX__ 18446744073709551615ULL"
.LASF221:
	.string	"__gnu_linux__ 1"
.LASF416:
	.string	"gfp_mask"
.LASF139:
	.string	"__DBL_DIG__ 15"
.LASF198:
	.string	"__GCC_ATOMIC_CHAR16_T_LOCK_FREE 2"
.LASF157:
	.string	"__LDBL_MAX_10_EXP__ 4932"
.LASF371:
	.string	"nr_free"
.LASF298:
	.string	"X86_PAGE_H "
.LASF369:
	.string	"free_area_struct"
.LASF203:
	.string	"__GCC_ATOMIC_LONG_LOCK_FREE 2"
.LASF103:
	.string	"__UINT_LEAST16_MAX__ 65535"
.LASF398:
	.string	"start_idx"
.LASF388:
	.string	"list_del_init"
.LASF310:
	.string	"__va2page_t(vaddr) (mem_map + (((vaddr) - PAGE_OFFSET) >> 12))"
.LASF297:
	.string	"PMM_H "
.LASF86:
	.string	"__INT16_MAX__ 32767"
.LASF350:
	.string	"long long int"
.LASF22:
	.string	"__CHAR_BIT__ 8"
.LASF344:
	.string	"ZONE_DMA_PA 0"
.LASF196:
	.string	"__GCC_ATOMIC_BOOL_LOCK_FREE 2"
.LASF13:
	.string	"__FINITE_MATH_ONLY__ 0"
.LASF321:
	.string	"LINUX_SCHED_H "
.LASF314:
	.string	"PAGE_OFFSET 0XC0000000"
.LASF69:
	.string	"__SHRT_MAX__ 32767"
.LASF331:
	.string	"pte_page(pte) ( pfn_page( pte_pfn(pte) ) )"
.LASF283:
	.string	"BYTE_ENDIAN_FLIP2(x) x = htons(x)"
.LASF226:
	.string	"__ELF__ 1"
.LASF337:
	.string	"__GFP_DMA (1<<1)"
.LASF96:
	.string	"__INT16_C(c) c"
.LASF409:
	.string	"page_is_buddy"
.LASF18:
	.string	"__SIZEOF_FLOAT__ 4"
.LASF136:
	.string	"__FLT_HAS_INFINITY__ 1"
.LASF282:
	.string	"ntohl(x) htonl(x)"
.LASF0:
	.string	"__STDC__ 1"
.LASF406:
	.string	"phy_neighbor"
.LASF276:
	.string	"O_INSERT_INCRE_ON(root,new,mb) ({ assert(root && new); __typeof__(root) leftone = root->prev; while(new->mb > leftone->mb){ leftone = leftone->prev; if(leftone == root->prev){ root = new; break; } } O_INSERT_AFTER(leftone, new); })"
.LASF241:
	.string	"__DEBUG "
.LASF12:
	.string	"__ATOMIC_CONSUME 1"
.LASF378:
	.string	"zone_mem_map"
.LASF279:
	.string	"O_APPEND_SAFE(root,new) ({ if(!root){ root = new; new->prev = new->next = new; } else O_APPEND(root, new); })"
.LASF33:
	.string	"__WINT_TYPE__ unsigned int"
.LASF129:
	.string	"__FLT_MAX_10_EXP__ 38"
.LASF101:
	.string	"__UINT_LEAST8_MAX__ 255"
.LASF327:
	.string	"G_PGNUM (gmemsize>>12)"
.LASF106:
	.string	"__UINT32_C(c) c ## U"
.LASF19:
	.string	"__SIZEOF_DOUBLE__ 8"
.LASF373:
	.string	"allocs"
.LASF5:
	.string	"__GNUC_PATCHLEVEL__ 2"
.LASF76:
	.string	"__WINT_MIN__ 0U"
.LASF429:
	.string	"mmzone.c"
.LASF133:
	.string	"__FLT_EPSILON__ 1.19209289550781250000e-7F"
.LASF424:
	.string	"zone_normal"
.LASF293:
	.string	"EXCHG_U16(a,b) do{ u16 tmp = a; a = b; b = tmp; } while(0)"
.LASF275:
	.string	"O_INSERT_BEFORE(Next,new) ({ new->next = Next; new->prev = Next->prev; Next->prev->next = new; Next->prev = new; })"
.LASF362:
	.string	"private"
.LASF232:
	.string	"INIT_LIST_HEAD(l) do{ (l)->prev = (l)->next = l; } while(0)"
.LASF164:
	.string	"__LDBL_HAS_INFINITY__ 1"
.LASF62:
	.string	"__UINT_FAST64_TYPE__ long long unsigned int"
.LASF120:
	.string	"__GCC_IEC_559_COMPLEX 2"
.LASF322:
	.string	"CSIGNAL 0xff"
.LASF237:
	.string	"bool _Bool"
.LASF209:
	.string	"__SIZEOF_WCHAR_T__ 4"
.LASF400:
	.string	"zone_map"
.LASF84:
	.string	"__SIG_ATOMIC_MIN__ (-__SIG_ATOMIC_MAX__ - 1)"
.LASF28:
	.string	"__FLOAT_WORD_ORDER__ __ORDER_LITTLE_ENDIAN__"
.LASF193:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 1"
.LASF166:
	.string	"__DEC32_MANT_DIG__ 7"
.LASF174:
	.string	"__DEC64_MIN_EXP__ (-382)"
.LASF271:
	.string	"LL_SCAN_ON_KEY_S(root,key,value) ({ typeof(root) curr = root; while(curr && curr->key >= (value) ) curr = curr->next; curr; })"
.LASF386:
	.string	"list_del"
.LASF73:
	.string	"__WCHAR_MAX__ 2147483647L"
.LASF9:
	.string	"__ATOMIC_ACQUIRE 2"
.LASF104:
	.string	"__UINT16_C(c) c"
.LASF317:
	.string	"KV __va"
.LASF263:
	.string	"LL_REPLACE(root,old,new) do{ new->prev = old->prev; new->next = old->next; if(new->prev) new->prev->next = new; if(new->next) new->next->prev = new; if(root == old) root = new; }while(0)"
.LASF300:
	.string	"PAGE_SIZE 0x1000"
.LASF381:
	.string	"zone_t"
.LASF35:
	.string	"__UINTMAX_TYPE__ long long unsigned int"
.LASF243:
	.string	"__4K 0x1000"
.LASF330:
	.string	"pfn_page(pfn) (mem_map + (pfn))"
.LASF89:
	.string	"__UINT8_MAX__ 255"
.LASF325:
	.string	"CLONE_FD 0x400"
.LASF26:
	.string	"__ORDER_PDP_ENDIAN__ 3412"
.LASF52:
	.string	"__UINT_LEAST16_TYPE__ short unsigned int"
.LASF130:
	.string	"__FLT_DECIMAL_DIG__ 9"
.LASF394:
	.string	"zone_id"
.LASF154:
	.string	"__LDBL_MIN_EXP__ (-16381)"
.LASF75:
	.string	"__WINT_MAX__ 4294967295U"
.LASF370:
	.string	"free_list"
.LASF187:
	.string	"__REGISTER_PREFIX__ "
.LASF115:
	.string	"__UINT_FAST32_MAX__ 4294967295U"
.LASF356:
	.string	"short int"
.LASF58:
	.string	"__INT_FAST64_TYPE__ long long int"
.LASF175:
	.string	"__DEC64_MAX_EXP__ 385"
.LASF212:
	.string	"__i386 1"
.LASF117:
	.string	"__INTPTR_MAX__ 2147483647"
.LASF61:
	.string	"__UINT_FAST32_TYPE__ unsigned int"
.LASF37:
	.string	"__CHAR32_TYPE__ unsigned int"
.LASF182:
	.string	"__DEC128_MAX_EXP__ 6145"
.LASF359:
	.string	"page"
.LASF303:
	.string	"pa_pg pa_idx"
.LASF273:
	.ascii	"LL_I_"
	.string	"INCRE_ON(root,new,mb) ({ new->prev = 0; new->next = root; while(new->next && new->next->mb < new->mb){ new->prev = new->next; new->next = new->next->next; } if(new->next) new->next->prev = new; if(new->prev) new->prev->next = new; else root = new->next; })"
.LASF299:
	.string	"PAGE_SHIFT 12"
.LASF59:
	.string	"__UINT_FAST8_TYPE__ unsigned char"
.LASF98:
	.string	"__INT32_C(c) c"
.LASF165:
	.string	"__LDBL_HAS_QUIET_NAN__ 1"
.LASF402:
	.string	"__free_pages_bulk"
.LASF207:
	.string	"__GCC_HAVE_DWARF2_CFI_ASM 1"
.LASF313:
	.string	"pte2page_t(pte) ( mem_map + (pte).physical )"
.LASF392:
	.string	"eflags"
.LASF222:
	.string	"__linux 1"
.LASF45:
	.string	"__UINT32_TYPE__ unsigned int"
.LASF88:
	.string	"__INT64_MAX__ 9223372036854775807LL"
.LASF412:
	.string	"mother"
.LASF100:
	.string	"__INT64_C(c) c ## LL"
.LASF272:
	.string	"LL_CHECK(root,node) do{ void *backup = root; while(root){ if(root == node) break; root = root->next; } assert(root && \"can not find node in that list\"); root = backup; }while(0)"
.LASF267:
	.string	"LL_INFO(list,attr) do{ void*root=list; while(list){ printf(\"%d \",list->attr); list=list->next; } list=root; } while(0)"
.LASF97:
	.string	"__INT_LEAST32_MAX__ 2147483647"
.LASF16:
	.string	"__SIZEOF_LONG_LONG__ 8"
.LASF43:
	.string	"__UINT8_TYPE__ unsigned char"
.LASF341:
	.string	"ZONE_NORMAL 1"
.LASF428:
	.string	"GNU C 4.9.2 -mtune=generic -march=i686 -g3 -std=c99 -fno-builtin -fno-stack-protector"
.LASF363:
	.string	"PG_highmem"
.LASF50:
	.string	"__INT_LEAST64_TYPE__ long long int"
.LASF379:
	.string	"spanned_pages"
.LASF29:
	.string	"__SIZEOF_POINTER__ 4"
.LASF367:
	.string	"padden"
.LASF296:
	.string	"ARR_CELLS(array,stru_t) ( sizeof(array) / sizeof(stru_t))"
.LASF332:
	.string	"page_va(page) __va( (page - mem_map) << PAGE_SHIFT)"
.LASF252:
	.string	"MAX(x,y) ((x)>(y)?(x):(y))"
.LASF315:
	.string	"__pa(vaddr) ((unsigned)(vaddr) - PAGE_OFFSET)"
.LASF421:
	.string	"mem_entity"
.LASF83:
	.string	"__SIG_ATOMIC_MAX__ 2147483647"
.LASF395:
	.string	"info_zone"
.LASF277:
	.string	"O_SCAN_UNTIL_MEET_LARGER(root,mb,value) ({ assert( (root) ); __typeof__(root) node = root; do{ if( (node)->mb > value) break; node = node->next; if(node != root) continue; node = 0; break; }while(1); node; })"
.LASF108:
	.string	"__UINT64_C(c) c ## ULL"
.LASF305:
	.string	"PG_USU 4"
.LASF380:
	.string	"sizetype"
.LASF188:
	.string	"__USER_LABEL_PREFIX__ "
.LASF349:
	.string	"long unsigned int"
.LASF118:
	.string	"__UINTPTR_MAX__ 4294967295U"
.LASF199:
	.string	"__GCC_ATOMIC_CHAR32_T_LOCK_FREE 2"
.LASF1:
	.string	"__STDC_VERSION__ 199901L"
.LASF224:
	.string	"__unix 1"
.LASF90:
	.string	"__UINT16_MAX__ 65535"
.LASF390:
	.string	"cli_ex"
.LASF80:
	.string	"__INTMAX_C(c) c ## LL"
.LASF214:
	.string	"__ATOMIC_HLE_ACQUIRE 65536"
.LASF2:
	.string	"__STDC_HOSTED__ 1"
.LASF423:
	.string	"zone_dma"
.LASF79:
	.string	"__INTMAX_MAX__ 9223372036854775807LL"
.LASF65:
	.string	"__has_include(STR) __has_include__(STR)"
.LASF112:
	.string	"__INT_FAST64_MAX__ 9223372036854775807LL"
.LASF206:
	.string	"__GCC_ATOMIC_POINTER_LOCK_FREE 2"
.LASF387:
	.string	"entry"
.LASF426:
	.string	"__zones"
.LASF204:
	.string	"__GCC_ATOMIC_LLONG_LOCK_FREE 2"
.LASF128:
	.string	"__FLT_MAX_EXP__ 128"
.LASF286:
	.string	"MM_H "
.LASF351:
	.string	"unsigned char"
.LASF167:
	.string	"__DEC32_MIN_EXP__ (-94)"
.LASF353:
	.string	"list_head_t"
.LASF261:
	.string	"LL_I(root,new) do{ if(root){ new->prev = root; new->next = root->next; if(root->next) root->next->prev = new; root->next = new; } else{ root = new; new->prev = new->next = 0; } }while(0)"
.LASF63:
	.string	"__INTPTR_TYPE__ int"
.LASF430:
	.string	"/home/wws/lab/yanqi/src"
.LASF301:
	.string	"PAGE_MASK (~0xfff)"
.LASF191:
	.string	"__STRICT_ANSI__ 1"
.LASF39:
	.string	"__INT8_TYPE__ signed char"
.LASF51:
	.string	"__UINT_LEAST8_TYPE__ unsigned char"
.LASF316:
	.string	"__va(paddr) ((unsigned)(paddr) + PAGE_OFFSET)"
.LASF410:
	.string	"__rmquene"
.LASF333:
	.string	"virt_to_page(vaddr) pfn_page( __pa(vaddr) >> PAGE_SHIFT)"
.LASF116:
	.string	"__UINT_FAST64_MAX__ 18446744073709551615ULL"
.LASF30:
	.string	"__SIZE_TYPE__ unsigned int"
.LASF219:
	.string	"__pentiumpro__ 1"
.LASF235:
	.string	"LINUX_MM_H "
.LASF142:
	.string	"__DBL_MAX_EXP__ 1024"
.LASF358:
	.string	"list_head"
.LASF152:
	.string	"__LDBL_MANT_DIG__ 64"
.LASF342:
	.string	"ZONE_HIGHMEM 2"
.LASF201:
	.string	"__GCC_ATOMIC_SHORT_LOCK_FREE 2"
.LASF294:
	.string	"MEMBER_OFFSET(stru_type,member_name) ( (unsigned)&(((stru_type *)0)->member_name) )"
.LASF290:
	.string	"POINTER_SHIFT(pt,type,len) (type*)((u32)pt+len)"
.LASF53:
	.string	"__UINT_LEAST32_TYPE__ unsigned int"
.LASF127:
	.string	"__FLT_MIN_10_EXP__ (-37)"
.LASF304:
	.string	"PG_P 1"
.LASF401:
	.string	"linked"
.LASF382:
	.string	"__list_add"
.LASF150:
	.string	"__DBL_HAS_INFINITY__ 1"
.LASF105:
	.string	"__UINT_LEAST32_MAX__ 4294967295U"
.LASF57:
	.string	"__INT_FAST32_TYPE__ int"
.LASF268:
	.string	"LL_ASSIGN(list,attr,value) do{ void *root = list; while(list){ list->attr=value; list=list->next; } list = root; } while(0)"
.LASF14:
	.string	"__SIZEOF_INT__ 4"
.LASF34:
	.string	"__INTMAX_TYPE__ long long int"
.LASF186:
	.string	"__DEC128_SUBNORMAL_MIN__ 0.000000000000000000000000000000001E-6143DL"
.LASF320:
	.string	"BLOCK_DATA_END(block) ((int)((char*)block+sizeof(EMPTY_BLOCK)+block->size-1))"
.LASF308:
	.string	"PG_L10(pg_id) (pg_id&(0x400-1))"
.LASF264:
	.ascii	"LL_I_INCRE(list,new,attr) do{ assert(new); if(!list){ list=n"
	.ascii	"ew; new->prev=new->next=0; break; } void*root=list; while(li"
	.ascii	"st->next && new->attr > list->attr) list=list"
	.string	"->next; if(new->attr > list->attr){ new->next = 0; new->prev=list; list->next = new; list=root; } else{ new->next = list; new->prev = list->prev; if(list->prev) list->prev->next = new; list->prev=new; if(root==list) list=new; else list = root; } } while(0)"
.LASF355:
	.string	"signed char"
.LASF334:
	.string	"MAX_ORDER 10"
.LASF143:
	.string	"__DBL_MAX_10_EXP__ 308"
.LASF352:
	.string	"short unsigned int"
.LASF278:
	.string	"O_APPEND(root,new) ({ (new)->next = root; (new)->prev = root->prev; (root)->prev->next = new; (root)->prev = new; })"
.LASF189:
	.string	"__GNUC_STDC_INLINE__ 1"
.LASF269:
	.string	"LL_SCAN_ON_KEY(root,key,value,result) do{ result = root; while(result){ if( (result)->key == (value) ){ break; } result = (result)->next; } }while(0)"
.LASF23:
	.string	"__BIGGEST_ALIGNMENT__ 16"
.LASF306:
	.string	"PG_RWW 2"
.LASF147:
	.string	"__DBL_EPSILON__ ((double)2.22044604925031308085e-16L)"
.LASF126:
	.string	"__FLT_MIN_EXP__ (-125)"
.LASF254:
	.string	"eat_dec(pt,x) if(*pt<'0'||*pt>'9') goto donothing; x=0; char*__pt=(pt); while(*(__pt+1)>='0'&&*(__pt+1)<='9') __pt++; int __len=__pt-(pt)+1; for(int __i=0;__i<__len;__i++){ x+=(*__pt-48)*pow_int(10,__i); __pt--; } (pt)+=__len;donothing:;"
.LASF374:
	.string	"free_area_t"
.LASF184:
	.string	"__DEC128_MAX__ 9.999999999999999999999999999999999E6144DL"
.LASF425:
	.string	"zone_highmem"
.LASF265:
	.ascii	"LL_I_DECRE(list,new,attr) do{ assert(new); if(!list){ list=n"
	.ascii	"ew; new->prev=new->next=0; break; } void*root=list; while(li"
	.ascii	"st->next && new->at"
	.string	"tr < list->attr) list=list->next; if(new->attr < list->attr){ new->next = 0; list->next=new; new->prev=list; list=root; } else{ new->next=list; new->prev=list->prev; if(list->prev) list->prev->next=new; list->prev=new; if(root==list) list=new; } } while(0)"
.LASF149:
	.string	"__DBL_HAS_DENORM__ 1"
.LASF377:
	.string	"free_area"
.LASF223:
	.string	"__linux__ 1"
.LASF32:
	.string	"__WCHAR_TYPE__ long int"
.LASF319:
	.string	"HEAP_SIZE (64*0x100000)"
.LASF391:
	.string	"get_eflags"
.LASF245:
	.string	"__1M 0x100000"
.LASF240:
	.string	"false 0"
.LASF372:
	.string	"frees"
.LASF256:
	.string	"MYLIST_H "
.LASF176:
	.string	"__DEC64_MIN__ 1E-383DD"
.LASF218:
	.string	"__pentiumpro 1"
.LASF208:
	.string	"__PRAGMA_REDEFINE_EXTNAME 1"
.LASF38:
	.string	"__SIG_ATOMIC_TYPE__ int"
.LASF251:
	.string	"min(x,y) ((x)<(y)?(x):(y))"
.LASF195:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 1"
.LASF397:
	.string	"init_free_area"
.LASF163:
	.string	"__LDBL_HAS_DENORM__ 1"
.LASF229:
	.string	"LIST_H "
.LASF6:
	.string	"__VERSION__ \"4.9.2\""
.LASF173:
	.string	"__DEC64_MANT_DIG__ 16"
.LASF135:
	.string	"__FLT_HAS_DENORM__ 1"
.LASF158:
	.string	"__DECIMAL_DIG__ 21"
	.ident	"GCC: (Ubuntu 4.9.2-10ubuntu13) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
