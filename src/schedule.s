	.file	"schedule.c"
	.text
.Ltext0:
	.comm	list_active,4,4
	.comm	list_expire,4,4
	.comm	mem_entity,4,1
	.comm	mem_map,4,4
	.comm	zone_dma,240,64
	.comm	zone_normal,240,64
	.comm	zone_highmem,240,64
	.comm	__zones,12,4
	.comm	size_of_zone,12,4
	.type	sti, @function
sti:
.LFB34:
	.file 1 "./include/old/utils.h"
	.loc 1 194 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	.loc 1 195 0
#APP
# 195 "./include/old/utils.h" 1
	sti
# 0 "" 2
	.loc 1 196 0
#NO_APP
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE34:
	.size	sti, .-sti
	.type	cli_ex, @function
cli_ex:
.LFB35:
	.loc 1 202 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	.loc 1 204 0
#APP
# 204 "./include/old/utils.h" 1
	pushf
	cli
	pop %eax
	andl $0x200, %eax
	
# 0 "" 2
#NO_APP
	movl	%eax, -4(%ebp)
	.loc 1 210 0
	cmpl	$0, -4(%ebp)
	setne	%al
	.loc 1 211 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE35:
	.size	cli_ex, .-cli_ex
	.comm	__hs_pcb,4,4
	.comm	__ext_pcb,4,4
	.comm	dentry_hashtable,4,4
	.comm	dentry_cache,4,4
	.comm	inode_hashtable,4,4
	.comm	inode_cache,4,4
	.comm	file_cache,4,4
	.comm	ticks,4,4
	.local	list_sleep
	.comm	list_sleep,4,4
	.globl	pcb_lists
	.data
	.align 4
	.type	pcb_lists, @object
	.size	pcb_lists, 12
pcb_lists:
	.long	list_active
	.long	list_expire
	.long	list_sleep
	.section	.rodata
.LC0:
	.string	"schedule.c"
.LC1:
	.string	"list_active&&p"
	.align 4
.LC2:
	.string	"!(!p->next && !p->prev && (list_active!=p))"
.LC3:
	.string	"p"
	.text
	.globl	active_sleep
	.type	active_sleep, @function
active_sleep:
.LFB51:
	.file 2 "schedule.c"
	.loc 2 13 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 2 14 0
	call	cli_ex
	movzbl	%al, %eax
	movl	%eax, -12(%ebp)
	.loc 2 16 0
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, 48(%eax)
	.loc 2 17 0
	movl	8(%ebp), %eax
	movl	16(%ebp), %edx
	movl	%edx, 52(%eax)
	.loc 2 18 0
	movl	list_active, %eax
	testl	%eax, %eax
	je	.L5
	.loc 2 18 0 is_stmt 0 discriminator 2
	cmpl	$0, 8(%ebp)
	jne	.L6
.L5:
	.loc 2 18 0 discriminator 3
	pushl	$18
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC1
	call	assert_func
	addl	$16, %esp
.L6:
	.loc 2 18 0 discriminator 5
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	jne	.L7
	.loc 2 18 0 discriminator 6
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	jne	.L7
	.loc 2 18 0 discriminator 8
	movl	list_active, %eax
	cmpl	8(%ebp), %eax
	je	.L7
	.loc 2 18 0 discriminator 10
	pushl	$18
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC2
	call	assert_func
	addl	$16, %esp
.L7:
	.loc 2 18 0 discriminator 12
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L8
	.loc 2 18 0 discriminator 13
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	8(%ebp), %edx
	movl	12(%edx), %edx
	movl	%edx, 12(%eax)
.L8:
	.loc 2 18 0 discriminator 15
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	je	.L9
	.loc 2 18 0 discriminator 16
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	movl	8(%ebp), %edx
	movl	8(%edx), %edx
	movl	%edx, 8(%eax)
.L9:
	.loc 2 18 0 discriminator 18
	movl	list_active, %eax
	cmpl	8(%ebp), %eax
	jne	.L10
	.loc 2 18 0 discriminator 19
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	movl	%eax, list_active
.L10:
.LBB2:
	.loc 2 19 0 is_stmt 1
	cmpl	$0, 8(%ebp)
	jne	.L11
	.loc 2 19 0 is_stmt 0 discriminator 1
	pushl	$19
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC3
	call	assert_func
	addl	$16, %esp
.L11:
	.loc 2 19 0 discriminator 3
	movl	list_sleep, %eax
	testl	%eax, %eax
	jne	.L12
	.loc 2 19 0 discriminator 4
	movl	8(%ebp), %eax
	movl	%eax, list_sleep
	movl	8(%ebp), %eax
	movl	$0, 12(%eax)
	movl	8(%ebp), %eax
	movl	12(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%eax)
	jmp	.L13
.L12:
	.loc 2 19 0 discriminator 5
	movl	list_sleep, %eax
	movl	%eax, -16(%ebp)
	jmp	.L14
.L16:
	.loc 2 19 0 discriminator 10
	movl	list_sleep, %eax
	movl	12(%eax), %eax
	movl	%eax, list_sleep
.L14:
	.loc 2 19 0 discriminator 6
	movl	list_sleep, %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	je	.L15
	.loc 2 19 0 discriminator 8
	movl	8(%ebp), %eax
	movl	36(%eax), %edx
	movl	list_sleep, %eax
	movl	36(%eax), %eax
	cmpl	%eax, %edx
	ja	.L16
.L15:
	.loc 2 19 0 discriminator 11
	movl	8(%ebp), %eax
	movl	36(%eax), %edx
	movl	list_sleep, %eax
	movl	36(%eax), %eax
	cmpl	%eax, %edx
	jbe	.L17
	.loc 2 19 0 discriminator 12
	movl	8(%ebp), %eax
	movl	$0, 12(%eax)
	movl	list_sleep, %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	list_sleep, %eax
	movl	8(%ebp), %edx
	movl	%edx, 12(%eax)
	movl	-16(%ebp), %eax
	movl	%eax, list_sleep
	jmp	.L13
.L17:
	.loc 2 19 0 discriminator 13
	movl	list_sleep, %edx
	movl	8(%ebp), %eax
	movl	%edx, 12(%eax)
	movl	list_sleep, %eax
	movl	8(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	list_sleep, %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L18
	.loc 2 19 0 discriminator 14
	movl	list_sleep, %eax
	movl	8(%eax), %eax
	movl	8(%ebp), %edx
	movl	%edx, 12(%eax)
.L18:
	.loc 2 19 0 discriminator 16
	movl	list_sleep, %eax
	movl	8(%ebp), %edx
	movl	%edx, 8(%eax)
	movl	list_sleep, %eax
	cmpl	%eax, -16(%ebp)
	jne	.L19
	.loc 2 19 0 discriminator 17
	movl	8(%ebp), %eax
	movl	%eax, list_sleep
	jmp	.L13
.L19:
	.loc 2 19 0 discriminator 18
	movl	-16(%ebp), %eax
	movl	%eax, list_sleep
.L13:
.LBE2:
	.loc 2 21 0 is_stmt 1
	cmpl	$0, -12(%ebp)
	je	.L4
	.loc 2 21 0 is_stmt 0 discriminator 1
	call	sti
.L4:
	.loc 2 22 0 is_stmt 1
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE51:
	.size	active_sleep, .-active_sleep
	.globl	active_expire
	.type	active_expire, @function
active_expire:
.LFB52:
	.loc 2 24 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 2 25 0
	call	cli_ex
	movzbl	%al, %eax
	movl	%eax, -12(%ebp)
	.loc 2 27 0
	movl	list_active, %eax
	testl	%eax, %eax
	je	.L22
	.loc 2 27 0 is_stmt 0 discriminator 2
	cmpl	$0, 8(%ebp)
	jne	.L23
.L22:
	.loc 2 27 0 discriminator 3
	pushl	$27
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC1
	call	assert_func
	addl	$16, %esp
.L23:
	.loc 2 27 0 discriminator 5
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	jne	.L24
	.loc 2 27 0 discriminator 6
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	jne	.L24
	.loc 2 27 0 discriminator 8
	movl	list_active, %eax
	cmpl	8(%ebp), %eax
	je	.L24
	.loc 2 27 0 discriminator 10
	pushl	$27
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC2
	call	assert_func
	addl	$16, %esp
.L24:
	.loc 2 27 0 discriminator 12
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L25
	.loc 2 27 0 discriminator 13
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	8(%ebp), %edx
	movl	12(%edx), %edx
	movl	%edx, 12(%eax)
.L25:
	.loc 2 27 0 discriminator 15
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	je	.L26
	.loc 2 27 0 discriminator 16
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	movl	8(%ebp), %edx
	movl	8(%edx), %edx
	movl	%edx, 8(%eax)
.L26:
	.loc 2 27 0 discriminator 18
	movl	list_active, %eax
	cmpl	8(%ebp), %eax
	jne	.L27
	.loc 2 27 0 discriminator 19
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	movl	%eax, list_active
.L27:
.LBB3:
	.loc 2 28 0 is_stmt 1
	cmpl	$0, 8(%ebp)
	jne	.L28
	.loc 2 28 0 is_stmt 0 discriminator 1
	pushl	$28
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC3
	call	assert_func
	addl	$16, %esp
.L28:
	.loc 2 28 0 discriminator 3
	movl	list_expire, %eax
	testl	%eax, %eax
	jne	.L29
	.loc 2 28 0 discriminator 4
	movl	8(%ebp), %eax
	movl	%eax, list_expire
	movl	8(%ebp), %eax
	movl	$0, 12(%eax)
	movl	8(%ebp), %eax
	movl	12(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%eax)
	jmp	.L30
.L29:
	.loc 2 28 0 discriminator 5
	movl	list_expire, %eax
	movl	%eax, -16(%ebp)
	jmp	.L31
.L33:
	.loc 2 28 0 discriminator 10
	movl	list_expire, %eax
	movl	12(%eax), %eax
	movl	%eax, list_expire
.L31:
	.loc 2 28 0 discriminator 6
	movl	list_expire, %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	je	.L32
	.loc 2 28 0 discriminator 8
	movl	8(%ebp), %eax
	movl	36(%eax), %edx
	movl	list_expire, %eax
	movl	36(%eax), %eax
	cmpl	%eax, %edx
	ja	.L33
.L32:
	.loc 2 28 0 discriminator 11
	movl	8(%ebp), %eax
	movl	36(%eax), %edx
	movl	list_expire, %eax
	movl	36(%eax), %eax
	cmpl	%eax, %edx
	jbe	.L34
	.loc 2 28 0 discriminator 12
	movl	8(%ebp), %eax
	movl	$0, 12(%eax)
	movl	list_expire, %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	list_expire, %eax
	movl	8(%ebp), %edx
	movl	%edx, 12(%eax)
	movl	-16(%ebp), %eax
	movl	%eax, list_expire
	jmp	.L30
.L34:
	.loc 2 28 0 discriminator 13
	movl	list_expire, %edx
	movl	8(%ebp), %eax
	movl	%edx, 12(%eax)
	movl	list_expire, %eax
	movl	8(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	list_expire, %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L35
	.loc 2 28 0 discriminator 14
	movl	list_expire, %eax
	movl	8(%eax), %eax
	movl	8(%ebp), %edx
	movl	%edx, 12(%eax)
.L35:
	.loc 2 28 0 discriminator 16
	movl	list_expire, %eax
	movl	8(%ebp), %edx
	movl	%edx, 8(%eax)
	movl	list_expire, %eax
	cmpl	%eax, -16(%ebp)
	jne	.L36
	.loc 2 28 0 discriminator 17
	movl	8(%ebp), %eax
	movl	%eax, list_expire
	jmp	.L30
.L36:
	.loc 2 28 0 discriminator 18
	movl	-16(%ebp), %eax
	movl	%eax, list_expire
.L30:
.LBE3:
	.loc 2 30 0 is_stmt 1
	cmpl	$0, -12(%ebp)
	je	.L21
	.loc 2 30 0 is_stmt 0 discriminator 1
	call	sti
.L21:
	.loc 2 31 0 is_stmt 1
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE52:
	.size	active_expire, .-active_expire
	.section	.rodata
.LC4:
	.string	"list_sleep&&p"
	.align 4
.LC5:
	.string	"!(!p->next && !p->prev && (list_sleep!=p))"
	.text
	.globl	sleep_active
	.type	sleep_active, @function
sleep_active:
.LFB53:
	.loc 2 33 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 2 34 0
	call	cli_ex
	movzbl	%al, %eax
	movl	%eax, -12(%ebp)
	.loc 2 36 0
	movl	list_sleep, %eax
	testl	%eax, %eax
	je	.L39
	.loc 2 36 0 is_stmt 0 discriminator 2
	cmpl	$0, 8(%ebp)
	jne	.L40
.L39:
	.loc 2 36 0 discriminator 3
	pushl	$36
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC4
	call	assert_func
	addl	$16, %esp
.L40:
	.loc 2 36 0 discriminator 5
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	jne	.L41
	.loc 2 36 0 discriminator 6
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	jne	.L41
	.loc 2 36 0 discriminator 8
	movl	list_sleep, %eax
	cmpl	8(%ebp), %eax
	je	.L41
	.loc 2 36 0 discriminator 10
	pushl	$36
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC5
	call	assert_func
	addl	$16, %esp
.L41:
	.loc 2 36 0 discriminator 12
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L42
	.loc 2 36 0 discriminator 13
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	8(%ebp), %edx
	movl	12(%edx), %edx
	movl	%edx, 12(%eax)
.L42:
	.loc 2 36 0 discriminator 15
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	je	.L43
	.loc 2 36 0 discriminator 16
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	movl	8(%ebp), %edx
	movl	8(%edx), %edx
	movl	%edx, 8(%eax)
.L43:
	.loc 2 36 0 discriminator 18
	movl	list_sleep, %eax
	cmpl	8(%ebp), %eax
	jne	.L44
	.loc 2 36 0 discriminator 19
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	movl	%eax, list_sleep
.L44:
.LBB4:
	.loc 2 37 0 is_stmt 1
	cmpl	$0, 8(%ebp)
	jne	.L45
	.loc 2 37 0 is_stmt 0 discriminator 1
	pushl	$37
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC3
	call	assert_func
	addl	$16, %esp
.L45:
	.loc 2 37 0 discriminator 3
	movl	list_active, %eax
	testl	%eax, %eax
	jne	.L46
	.loc 2 37 0 discriminator 4
	movl	8(%ebp), %eax
	movl	%eax, list_active
	movl	8(%ebp), %eax
	movl	$0, 12(%eax)
	movl	8(%ebp), %eax
	movl	12(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%eax)
	jmp	.L47
.L46:
	.loc 2 37 0 discriminator 5
	movl	list_active, %eax
	movl	%eax, -16(%ebp)
	jmp	.L48
.L50:
	.loc 2 37 0 discriminator 10
	movl	list_active, %eax
	movl	12(%eax), %eax
	movl	%eax, list_active
.L48:
	.loc 2 37 0 discriminator 6
	movl	list_active, %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	je	.L49
	.loc 2 37 0 discriminator 8
	movl	8(%ebp), %eax
	movl	36(%eax), %edx
	movl	list_active, %eax
	movl	36(%eax), %eax
	cmpl	%eax, %edx
	ja	.L50
.L49:
	.loc 2 37 0 discriminator 11
	movl	8(%ebp), %eax
	movl	36(%eax), %edx
	movl	list_active, %eax
	movl	36(%eax), %eax
	cmpl	%eax, %edx
	jbe	.L51
	.loc 2 37 0 discriminator 12
	movl	8(%ebp), %eax
	movl	$0, 12(%eax)
	movl	list_active, %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	list_active, %eax
	movl	8(%ebp), %edx
	movl	%edx, 12(%eax)
	movl	-16(%ebp), %eax
	movl	%eax, list_active
	jmp	.L47
.L51:
	.loc 2 37 0 discriminator 13
	movl	list_active, %edx
	movl	8(%ebp), %eax
	movl	%edx, 12(%eax)
	movl	list_active, %eax
	movl	8(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	list_active, %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L52
	.loc 2 37 0 discriminator 14
	movl	list_active, %eax
	movl	8(%eax), %eax
	movl	8(%ebp), %edx
	movl	%edx, 12(%eax)
.L52:
	.loc 2 37 0 discriminator 16
	movl	list_active, %eax
	movl	8(%ebp), %edx
	movl	%edx, 8(%eax)
	movl	list_active, %eax
	cmpl	%eax, -16(%ebp)
	jne	.L53
	.loc 2 37 0 discriminator 17
	movl	8(%ebp), %eax
	movl	%eax, list_active
	jmp	.L47
.L53:
	.loc 2 37 0 discriminator 18
	movl	-16(%ebp), %eax
	movl	%eax, list_active
.L47:
.LBE4:
	.loc 2 39 0 is_stmt 1
	movl	8(%ebp), %eax
	movl	$0, 48(%eax)
	.loc 2 41 0
	cmpl	$0, -12(%ebp)
	je	.L38
	.loc 2 41 0 is_stmt 0 discriminator 1
	call	sti
.L38:
	.loc 2 42 0 is_stmt 1
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE53:
	.size	sleep_active, .-sleep_active
	.globl	sleep_expire
	.type	sleep_expire, @function
sleep_expire:
.LFB54:
	.loc 2 44 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	.loc 2 45 0
	call	cli_ex
	movzbl	%al, %eax
	movl	%eax, -12(%ebp)
	.loc 2 47 0
	movl	list_sleep, %eax
	testl	%eax, %eax
	je	.L56
	.loc 2 47 0 is_stmt 0 discriminator 2
	cmpl	$0, 8(%ebp)
	jne	.L57
.L56:
	.loc 2 47 0 discriminator 3
	pushl	$47
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC4
	call	assert_func
	addl	$16, %esp
.L57:
	.loc 2 47 0 discriminator 5
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	jne	.L58
	.loc 2 47 0 discriminator 6
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	jne	.L58
	.loc 2 47 0 discriminator 8
	movl	list_sleep, %eax
	cmpl	8(%ebp), %eax
	je	.L58
	.loc 2 47 0 discriminator 10
	pushl	$47
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC5
	call	assert_func
	addl	$16, %esp
.L58:
	.loc 2 47 0 discriminator 12
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L59
	.loc 2 47 0 discriminator 13
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	8(%ebp), %edx
	movl	12(%edx), %edx
	movl	%edx, 12(%eax)
.L59:
	.loc 2 47 0 discriminator 15
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	je	.L60
	.loc 2 47 0 discriminator 16
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	movl	8(%ebp), %edx
	movl	8(%edx), %edx
	movl	%edx, 8(%eax)
.L60:
	.loc 2 47 0 discriminator 18
	movl	list_sleep, %eax
	cmpl	8(%ebp), %eax
	jne	.L61
	.loc 2 47 0 discriminator 19
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	movl	%eax, list_sleep
.L61:
.LBB5:
	.loc 2 48 0 is_stmt 1
	cmpl	$0, 8(%ebp)
	jne	.L62
	.loc 2 48 0 is_stmt 0 discriminator 1
	pushl	$48
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC3
	call	assert_func
	addl	$16, %esp
.L62:
	.loc 2 48 0 discriminator 3
	movl	list_expire, %eax
	testl	%eax, %eax
	jne	.L63
	.loc 2 48 0 discriminator 4
	movl	8(%ebp), %eax
	movl	%eax, list_expire
	movl	8(%ebp), %eax
	movl	$0, 12(%eax)
	movl	8(%ebp), %eax
	movl	12(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%eax)
	jmp	.L64
.L63:
	.loc 2 48 0 discriminator 5
	movl	list_expire, %eax
	movl	%eax, -16(%ebp)
	jmp	.L65
.L67:
	.loc 2 48 0 discriminator 10
	movl	list_expire, %eax
	movl	12(%eax), %eax
	movl	%eax, list_expire
.L65:
	.loc 2 48 0 discriminator 6
	movl	list_expire, %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	je	.L66
	.loc 2 48 0 discriminator 8
	movl	8(%ebp), %eax
	movl	36(%eax), %edx
	movl	list_expire, %eax
	movl	36(%eax), %eax
	cmpl	%eax, %edx
	ja	.L67
.L66:
	.loc 2 48 0 discriminator 11
	movl	8(%ebp), %eax
	movl	36(%eax), %edx
	movl	list_expire, %eax
	movl	36(%eax), %eax
	cmpl	%eax, %edx
	jbe	.L68
	.loc 2 48 0 discriminator 12
	movl	8(%ebp), %eax
	movl	$0, 12(%eax)
	movl	list_expire, %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	list_expire, %eax
	movl	8(%ebp), %edx
	movl	%edx, 12(%eax)
	movl	-16(%ebp), %eax
	movl	%eax, list_expire
	jmp	.L64
.L68:
	.loc 2 48 0 discriminator 13
	movl	list_expire, %edx
	movl	8(%ebp), %eax
	movl	%edx, 12(%eax)
	movl	list_expire, %eax
	movl	8(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	list_expire, %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L69
	.loc 2 48 0 discriminator 14
	movl	list_expire, %eax
	movl	8(%eax), %eax
	movl	8(%ebp), %edx
	movl	%edx, 12(%eax)
.L69:
	.loc 2 48 0 discriminator 16
	movl	list_expire, %eax
	movl	8(%ebp), %edx
	movl	%edx, 8(%eax)
	movl	list_expire, %eax
	cmpl	%eax, -16(%ebp)
	jne	.L70
	.loc 2 48 0 discriminator 17
	movl	8(%ebp), %eax
	movl	%eax, list_expire
	jmp	.L64
.L70:
	.loc 2 48 0 discriminator 18
	movl	-16(%ebp), %eax
	movl	%eax, list_expire
.L64:
.LBE5:
	.loc 2 49 0 is_stmt 1
	movl	8(%ebp), %eax
	movl	$0, 48(%eax)
	.loc 2 51 0
	cmpl	$0, -12(%ebp)
	je	.L55
	.loc 2 51 0 is_stmt 0 discriminator 1
	call	sti
.L55:
	.loc 2 52 0 is_stmt 1
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE54:
	.size	sleep_expire, .-sleep_expire
	.section	.rodata
.LC6:
	.string	"%u"
.LC7:
	.string	"^"
.LC8:
	.string	"current->time_slice > 0"
.LC9:
	.string	"switch"
.LC10:
	.string	"%x"
.LC11:
	.string	"#"
	.text
	.globl	do_timer
	.type	do_timer, @function
do_timer:
.LFB55:
	.loc 2 53 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	.loc 2 56 0
	movl	ticks, %eax
	addl	$1, %eax
	movl	%eax, ticks
	.loc 2 57 0
	movl	ticks, %ecx
	movl	$1374389535, %edx
	movl	%ecx, %eax
	mull	%edx
	movl	%edx, %eax
	shrl	$5, %eax
	imull	$100, %eax, %eax
	subl	%eax, %ecx
	movl	%ecx, %eax
	testl	%eax, %eax
	jne	.L73
.LBB6:
	.loc 2 58 0
	movl	$0, -48(%ebp)
	movl	$0, -44(%ebp)
	movl	$0, -40(%ebp)
	movl	$0, -36(%ebp)
	movb	$-108, -48(%ebp)
	movb	$32, -47(%ebp)
	.loc 2 59 0
	movl	ticks, %eax
	movl	$1374389535, %edx
	mull	%edx
	movl	%edx, %eax
	shrl	$5, %eax
	subl	$4, %esp
	pushl	%eax
	pushl	$.LC6
	leal	-32(%ebp), %eax
	pushl	%eax
	call	sprintf
	addl	$16, %esp
	.loc 2 60 0
	leal	-32(%ebp), %eax
	pushl	%eax
	leal	-48(%ebp), %eax
	pushl	%eax
	pushl	$0
	pushl	$0
	call	write_bar
	addl	$16, %esp
.L73:
.LBE6:
	.loc 2 62 0
	movl	ticks, %ecx
	movl	$458129845, %edx
	movl	%ecx, %eax
	mull	%edx
	movl	%edx, %eax
	shrl	$5, %eax
	imull	$300, %eax, %eax
	subl	%eax, %ecx
	movl	%ecx, %eax
	testl	%eax, %eax
	jne	.L74
	.loc 2 62 0 is_stmt 0 discriminator 1
	subl	$12, %esp
	pushl	$.LC7
	call	oprintf
	addl	$16, %esp
.L74:
	.loc 2 64 0 is_stmt 1
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	andl	$3, %eax
	testl	%eax, %eax
	je	.L75
	.loc 2 65 0
	call	get_current
	movl	40(%eax), %eax
	testl	%eax, %eax
	jne	.L76
	.loc 2 65 0 is_stmt 0 discriminator 1
	pushl	$65
	pushl	$.LC0
	pushl	$.LC0
	pushl	$.LC8
	call	assert_func
	addl	$16, %esp
.L76:
	.loc 2 66 0 is_stmt 1
	call	get_current
	movl	40(%eax), %edx
	subl	$1, %edx
	movl	%edx, 40(%eax)
	movl	40(%eax), %eax
	testl	%eax, %eax
	jne	.L75
	.loc 2 67 0
	subl	$12, %esp
	pushl	$.LC9
	call	oprintf
	addl	$16, %esp
	.loc 2 68 0
	call	get_current
	subl	$12, %esp
	pushl	%eax
	call	active_expire
	addl	$16, %esp
	.loc 2 69 0
	call	get_current
	movl	$1, (%eax)
.L75:
	.loc 2 72 0
	call	get_current
	movl	40(%eax), %eax
	subl	$4, %esp
	pushl	%eax
	pushl	$.LC10
	leal	-32(%ebp), %eax
	pushl	%eax
	call	sprintf
	addl	$16, %esp
	.loc 2 73 0
	leal	-32(%ebp), %eax
	pushl	%eax
	pushl	$.LC11
	pushl	$1
	pushl	$0
	call	write_bar
	addl	$16, %esp
	.loc 2 76 0
	movl	list_sleep, %eax
	movl	%eax, -12(%ebp)
	.loc 2 77 0
	jmp	.L77
.L80:
.LBB7:
	.loc 2 79 0
	movl	-12(%ebp), %eax
	movl	12(%eax), %eax
	movl	%eax, -16(%ebp)
	.loc 2 80 0
	movl	-12(%ebp), %eax
	movl	48(%eax), %eax
	cmpl	$255, %eax
	jne	.L78
	.loc 2 81 0
	movl	-12(%ebp), %eax
	movl	52(%eax), %eax
	leal	-1(%eax), %edx
	movl	-12(%ebp), %eax
	movl	%edx, 52(%eax)
	.loc 2 83 0
	movl	-12(%ebp), %eax
	movl	52(%eax), %eax
	testl	%eax, %eax
	jne	.L78
	.loc 2 88 0
	movl	-12(%ebp), %eax
	movl	40(%eax), %eax
	testl	%eax, %eax
	je	.L79
	.loc 2 89 0
	subl	$12, %esp
	pushl	-12(%ebp)
	call	sleep_active
	addl	$16, %esp
	.loc 2 91 0
	call	get_current
	movl	$1, (%eax)
	jmp	.L78
.L79:
	.loc 2 93 0
	subl	$12, %esp
	pushl	-12(%ebp)
	call	sleep_expire
	addl	$16, %esp
.L78:
	.loc 2 96 0
	movl	-16(%ebp), %eax
	movl	%eax, -12(%ebp)
.L77:
.LBE7:
	.loc 2 77 0
	cmpl	$0, -12(%ebp)
	jne	.L80
	.loc 2 99 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE55:
	.size	do_timer, .-do_timer
	.globl	schedule
	.type	schedule, @function
schedule:
.LFB56:
	.loc 2 105 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$28, %esp
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	.loc 2 107 0
	call	cli_ex
	movzbl	%al, %eax
	movl	%eax, -36(%ebp)
	.loc 2 110 0
	call	get_current
	movl	$0, (%eax)
	.loc 2 111 0
	movl	$0, -28(%ebp)
	.loc 2 120 0
	movl	list_active, %eax
	testl	%eax, %eax
	jne	.L82
	.loc 2 120 0 is_stmt 0 discriminator 1
	movl	list_expire, %eax
	testl	%eax, %eax
	je	.L82
.LBB8:
	.loc 2 121 0 is_stmt 1
	movl	list_expire, %eax
	movl	%eax, -32(%ebp)
	.loc 2 122 0
	jmp	.L83
.L84:
	.loc 2 123 0
	movl	-32(%ebp), %eax
	movl	44(%eax), %edx
	movl	-32(%ebp), %eax
	movl	%edx, 40(%eax)
	.loc 2 124 0
	movl	-32(%ebp), %eax
	movl	12(%eax), %eax
	movl	%eax, -32(%ebp)
.L83:
	.loc 2 122 0
	cmpl	$0, -32(%ebp)
	jne	.L84
.LBB9:
	.loc 2 126 0
	movl	list_active, %eax
	movl	%eax, -40(%ebp)
	movl	list_expire, %eax
	movl	%eax, list_active
	movl	-40(%ebp), %eax
	movl	%eax, list_expire
.L82:
.LBE9:
.LBE8:
	.loc 2 129 0
	movl	list_active, %eax
	testl	%eax, %eax
	je	.L85
	.loc 2 129 0 is_stmt 0 discriminator 1
	movl	list_active, %eax
	movl	%eax, -28(%ebp)
	jmp	.L86
.L85:
	.loc 2 131 0 is_stmt 1
	movl	idle, %eax
	movl	%eax, -28(%ebp)
.L86:
	.loc 2 133 0
	call	get_current
	cmpl	-28(%ebp), %eax
	jne	.L87
	.loc 2 139 0
	jmp	.L81
.L87:
	.loc 2 146 0
	movl	-28(%ebp), %eax
	movl	56(%eax), %eax
	testl	%eax, %eax
	je	.L89
	.loc 2 156 0
	movl	-28(%ebp), %eax
	addl	$8192, %eax
	movl	%eax, base_tss+4
	.loc 2 161 0
	movl	-28(%ebp), %eax
	movl	56(%eax), %eax
	movl	(%eax), %eax
	.loc 2 159 0
#APP
# 159 "schedule.c" 1
	movl %eax, %cr3
	
# 0 "" 2
#NO_APP
.L89:
	.loc 2 192 0
	call	get_current
	movl	%eax, %esi
	call	get_current
	movl	%eax, %edi
	.loc 2 193 0
	call	get_current
	movl	%eax, %ecx
	.loc 2 171 0
	movl	-28(%ebp), %eax
	movl	-28(%ebp), %edx
	movl	%ecx, %ebx
#APP
# 171 "schedule.c" 1
	pushfl
	pushl %esi
	pushl %edi
	pushl %ebp
	movl %esp, 60(%esi)
	movl $1f, 64(%edi)
	movl 60(%eax), %esp
	jmp *64(%edx)
	1:
	popl %ebp
	popl %edi
	popl %esi
	popfl
	
# 0 "" 2
	.loc 2 195 0
#NO_APP
	cmpl	$0, -36(%ebp)
	je	.L90
	.loc 2 195 0 is_stmt 0 discriminator 1
	call	sti
.L90:
	.loc 2 198 0 is_stmt 1 discriminator 2
	nop
.L81:
	.loc 2 199 0
	addl	$28, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE56:
	.size	schedule, .-schedule
	.globl	schedule_timeout
	.type	schedule_timeout, @function
schedule_timeout:
.LFB57:
	.loc 2 202 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$20, %esp
	.cfi_offset 3, -12
	.loc 2 203 0
	movl	8(%ebp), %eax
	subl	$1, %eax
	movl	$-858993459, %edx
	mull	%edx
	movl	%edx, %eax
	shrl	$3, %eax
	addl	$1, %eax
	movl	%eax, -12(%ebp)
	.loc 2 204 0
	movl	-12(%ebp), %ebx
	call	get_current
	subl	$4, %esp
	pushl	%ebx
	pushl	$255
	pushl	%eax
	call	active_sleep
	addl	$16, %esp
	.loc 2 205 0
	call	schedule
	.loc 2 206 0
	movl	-12(%ebp), %eax
	.loc 2 207 0
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE57:
	.size	schedule_timeout, .-schedule_timeout
	.globl	kp_sleep
	.type	kp_sleep, @function
kp_sleep:
.LFB58:
	.loc 2 212 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 2 213 0
	call	get_current
	subl	$4, %esp
	pushl	12(%ebp)
	pushl	8(%ebp)
	pushl	%eax
	call	active_sleep
	addl	$16, %esp
	.loc 2 214 0
	call	schedule
	.loc 2 223 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE58:
	.size	kp_sleep, .-kp_sleep
	.globl	wake_up
	.type	wake_up, @function
wake_up:
.LFB59:
	.loc 2 225 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 2 226 0
	subl	$12, %esp
	pushl	8(%ebp)
	call	sleep_active
	addl	$16, %esp
	.loc 2 227 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE59:
	.size	wake_up, .-wake_up
	.globl	kthread_sleep
	.type	kthread_sleep, @function
kthread_sleep:
.LFB60:
	.loc 2 228 0
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	.loc 2 229 0
	call	get_current
	subl	$4, %esp
	pushl	12(%ebp)
	pushl	8(%ebp)
	pushl	%eax
	call	active_sleep
	addl	$16, %esp
	.loc 2 230 0
#APP
# 230 "schedule.c" 1
	int $0x81
# 0 "" 2
	.loc 2 231 0
#NO_APP
	nop
	.loc 2 232 0
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE60:
	.size	kthread_sleep, .-kthread_sleep
.Letext0:
	.file 3 "./include/old/valType.h"
	.file 4 "./include/old/list.h"
	.file 5 "./arch/x86/include/asm/page.h"
	.file 6 "./include/old/mmzone.h"
	.file 7 "./include/linux/sched.h"
	.file 8 "./include/linux/mm.h"
	.file 9 "./include/linux/fs.h"
	.file 10 "./include/asm/resource.h"
	.file 11 "./include/old/proc.h"
	.file 12 "./include/linux/dcache.h"
	.file 13 "./include/linux/mount.h"
	.file 14 "./include/old/schedule.h"
	.file 15 "./include/old/ku_utils.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x1400
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.long	.LASF590
	.byte	0x1
	.long	.LASF591
	.long	.LASF592
	.long	.Ltext0
	.long	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.long	.Ldebug_macro0
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF391
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF392
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.long	.LASF393
	.uleb128 0x3
	.string	"u16"
	.byte	0x3
	.byte	0x10
	.long	0x49
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.long	.LASF394
	.uleb128 0x3
	.string	"u32"
	.byte	0x3
	.byte	0x11
	.long	0x5b
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF395
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF396
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.long	.LASF397
	.uleb128 0x4
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.long	.LASF398
	.uleb128 0x5
	.long	.LASF419
	.byte	0x8
	.byte	0x4
	.byte	0x6
	.long	0xa3
	.uleb128 0x6
	.long	.LASF399
	.byte	0x4
	.byte	0x7
	.long	0xa3
	.byte	0
	.uleb128 0x6
	.long	.LASF400
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
	.long	.LASF401
	.byte	0x5
	.byte	0x2d
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0
	.uleb128 0x9
	.long	.LASF402
	.byte	0x5
	.byte	0x2e
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0
	.uleb128 0x9
	.long	.LASF403
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
	.long	.LASF404
	.byte	0x5
	.byte	0x32
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1a
	.byte	0
	.uleb128 0x9
	.long	.LASF405
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
	.long	.LASF406
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
	.long	.LASF407
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
	.long	.LASF408
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
	.long	.LASF406
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
	.long	.LASF408
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
	.long	.LASF409
	.byte	0x5
	.byte	0x52
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0
	.uleb128 0x9
	.long	.LASF410
	.byte	0x5
	.byte	0x53
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0
	.uleb128 0x9
	.long	.LASF411
	.byte	0x5
	.byte	0x54
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1d
	.byte	0
	.uleb128 0x9
	.long	.LASF412
	.byte	0x5
	.byte	0x55
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1c
	.byte	0
	.uleb128 0x9
	.long	.LASF413
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
	.long	.LASF414
	.byte	0x5
	.byte	0x5a
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0
	.uleb128 0x9
	.long	.LASF415
	.byte	0x5
	.byte	0x5b
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0
	.uleb128 0x9
	.long	.LASF416
	.byte	0x5
	.byte	0x5c
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1d
	.byte	0
	.uleb128 0x9
	.long	.LASF417
	.byte	0x5
	.byte	0x5e
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1b
	.byte	0
	.byte	0
	.uleb128 0xe
	.long	.LASF418
	.byte	0x4
	.byte	0x5
	.byte	0x4f
	.long	0x263
	.uleb128 0xc
	.long	.LASF408
	.byte	0x5
	.byte	0x50
	.long	0x50
	.uleb128 0xd
	.long	0x1a8
	.uleb128 0xd
	.long	0x1fc
	.byte	0
	.uleb128 0x5
	.long	.LASF420
	.byte	0x18
	.byte	0x6
	.byte	0x8
	.long	0x2eb
	.uleb128 0xf
	.string	"lru"
	.byte	0x6
	.byte	0x9
	.long	0x7e
	.byte	0
	.uleb128 0x6
	.long	.LASF421
	.byte	0x6
	.byte	0xa
	.long	0x70
	.byte	0x8
	.uleb128 0x6
	.long	.LASF422
	.byte	0x6
	.byte	0xb
	.long	0x70
	.byte	0xc
	.uleb128 0x6
	.long	.LASF423
	.byte	0x6
	.byte	0x10
	.long	0x70
	.byte	0x10
	.uleb128 0x9
	.long	.LASF424
	.byte	0x6
	.byte	0x11
	.long	0x70
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0x14
	.uleb128 0x9
	.long	.LASF425
	.byte	0x6
	.byte	0x12
	.long	0x70
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0x14
	.uleb128 0x9
	.long	.LASF426
	.byte	0x6
	.byte	0x13
	.long	0x5b
	.byte	0x4
	.byte	0x2
	.byte	0x1c
	.byte	0x14
	.uleb128 0x9
	.long	.LASF427
	.byte	0x6
	.byte	0x14
	.long	0x5b
	.byte	0x4
	.byte	0x8
	.byte	0x14
	.byte	0x14
	.uleb128 0x9
	.long	.LASF428
	.byte	0x6
	.byte	0x15
	.long	0x70
	.byte	0x4
	.byte	0x14
	.byte	0
	.byte	0x14
	.byte	0
	.uleb128 0x5
	.long	.LASF429
	.byte	0x14
	.byte	0x6
	.byte	0x31
	.long	0x328
	.uleb128 0x6
	.long	.LASF430
	.byte	0x6
	.byte	0x32
	.long	0x7e
	.byte	0
	.uleb128 0x6
	.long	.LASF431
	.byte	0x6
	.byte	0x33
	.long	0x70
	.byte	0x8
	.uleb128 0x6
	.long	.LASF432
	.byte	0x6
	.byte	0x34
	.long	0x70
	.byte	0xc
	.uleb128 0x6
	.long	.LASF433
	.byte	0x6
	.byte	0x34
	.long	0x70
	.byte	0x10
	.byte	0
	.uleb128 0x10
	.long	.LASF434
	.byte	0x6
	.byte	0x35
	.long	0x2eb
	.uleb128 0x5
	.long	.LASF435
	.byte	0xf0
	.byte	0x6
	.byte	0x37
	.long	0x388
	.uleb128 0x6
	.long	.LASF436
	.byte	0x6
	.byte	0x39
	.long	0x5b
	.byte	0
	.uleb128 0x6
	.long	.LASF437
	.byte	0x6
	.byte	0x3a
	.long	0x388
	.byte	0x4
	.uleb128 0x6
	.long	.LASF438
	.byte	0x6
	.byte	0x3b
	.long	0x39f
	.byte	0xe0
	.uleb128 0x6
	.long	.LASF439
	.byte	0x6
	.byte	0x3c
	.long	0x5b
	.byte	0xe4
	.uleb128 0x6
	.long	.LASF433
	.byte	0x6
	.byte	0x3d
	.long	0x70
	.byte	0xe8
	.uleb128 0x6
	.long	.LASF432
	.byte	0x6
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
	.long	.LASF440
	.uleb128 0x7
	.byte	0x4
	.long	0x263
	.uleb128 0x10
	.long	.LASF441
	.byte	0x6
	.byte	0x3e
	.long	0x333
	.uleb128 0x13
	.string	"mm"
	.byte	0x24
	.byte	0x7
	.byte	0x10
	.long	0x428
	.uleb128 0xf
	.string	"cr3"
	.byte	0x7
	.byte	0x11
	.long	0x18b
	.byte	0
	.uleb128 0xf
	.string	"vma"
	.byte	0x7
	.byte	0x12
	.long	0x4ac
	.byte	0x4
	.uleb128 0x6
	.long	.LASF442
	.byte	0x7
	.byte	0x14
	.long	0x29
	.byte	0x8
	.uleb128 0x6
	.long	.LASF443
	.byte	0x7
	.byte	0x14
	.long	0x29
	.byte	0xc
	.uleb128 0x6
	.long	.LASF444
	.byte	0x7
	.byte	0x15
	.long	0x29
	.byte	0x10
	.uleb128 0x6
	.long	.LASF445
	.byte	0x7
	.byte	0x15
	.long	0x29
	.byte	0x14
	.uleb128 0x6
	.long	.LASF446
	.byte	0x7
	.byte	0x16
	.long	0x29
	.byte	0x18
	.uleb128 0xf
	.string	"brk"
	.byte	0x7
	.byte	0x16
	.long	0x29
	.byte	0x1c
	.uleb128 0x6
	.long	.LASF447
	.byte	0x7
	.byte	0x17
	.long	0x70
	.byte	0x20
	.byte	0
	.uleb128 0x5
	.long	.LASF448
	.byte	0x28
	.byte	0x8
	.byte	0x57
	.long	0x4ac
	.uleb128 0xf
	.string	"mm"
	.byte	0x8
	.byte	0x58
	.long	0x5ed
	.byte	0
	.uleb128 0x6
	.long	.LASF449
	.byte	0x8
	.byte	0x59
	.long	0x50
	.byte	0x4
	.uleb128 0xf
	.string	"end"
	.byte	0x8
	.byte	0x5a
	.long	0x50
	.byte	0x8
	.uleb128 0x6
	.long	.LASF450
	.byte	0x8
	.byte	0x5b
	.long	0x151
	.byte	0xc
	.uleb128 0x6
	.long	.LASF407
	.byte	0x8
	.byte	0x5f
	.long	0x56f
	.byte	0x10
	.uleb128 0x6
	.long	.LASF399
	.byte	0x8
	.byte	0x61
	.long	0x4ac
	.byte	0x14
	.uleb128 0x6
	.long	.LASF400
	.byte	0x8
	.byte	0x61
	.long	0x4ac
	.byte	0x18
	.uleb128 0xf
	.string	"ops"
	.byte	0x8
	.byte	0x62
	.long	0x5f3
	.byte	0x1c
	.uleb128 0x6
	.long	.LASF451
	.byte	0x8
	.byte	0x63
	.long	0x64e
	.byte	0x20
	.uleb128 0x6
	.long	.LASF452
	.byte	0x8
	.byte	0x64
	.long	0x50
	.byte	0x24
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x428
	.uleb128 0x8
	.byte	0x2
	.byte	0x8
	.byte	0x24
	.long	0x56f
	.uleb128 0x9
	.long	.LASF453
	.byte	0x8
	.byte	0x25
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1f
	.byte	0
	.uleb128 0x9
	.long	.LASF402
	.byte	0x8
	.byte	0x26
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1e
	.byte	0
	.uleb128 0x9
	.long	.LASF454
	.byte	0x8
	.byte	0x27
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1d
	.byte	0
	.uleb128 0x9
	.long	.LASF455
	.byte	0x8
	.byte	0x28
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1c
	.byte	0
	.uleb128 0x9
	.long	.LASF456
	.byte	0x8
	.byte	0x2a
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1b
	.byte	0
	.uleb128 0x9
	.long	.LASF457
	.byte	0x8
	.byte	0x2b
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x1a
	.byte	0
	.uleb128 0x9
	.long	.LASF458
	.byte	0x8
	.byte	0x2c
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x19
	.byte	0
	.uleb128 0x9
	.long	.LASF459
	.byte	0x8
	.byte	0x2d
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x18
	.byte	0
	.uleb128 0x9
	.long	.LASF460
	.byte	0x8
	.byte	0x2f
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x17
	.byte	0
	.uleb128 0x9
	.long	.LASF461
	.byte	0x8
	.byte	0x30
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x16
	.byte	0
	.uleb128 0x9
	.long	.LASF462
	.byte	0x8
	.byte	0x31
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x15
	.byte	0
	.uleb128 0x9
	.long	.LASF463
	.byte	0x8
	.byte	0x32
	.long	0x5b
	.byte	0x4
	.byte	0x1
	.byte	0x14
	.byte	0
	.byte	0
	.uleb128 0xe
	.long	.LASF464
	.byte	0x4
	.byte	0x8
	.byte	0x23
	.long	0x58c
	.uleb128 0xd
	.long	0x4b2
	.uleb128 0xc
	.long	.LASF408
	.byte	0x8
	.byte	0x34
	.long	0x5b
	.byte	0
	.uleb128 0x5
	.long	.LASF465
	.byte	0xc
	.byte	0x8
	.byte	0x51
	.long	0x5bd
	.uleb128 0x6
	.long	.LASF466
	.byte	0x8
	.byte	0x52
	.long	0x5c8
	.byte	0
	.uleb128 0x6
	.long	.LASF467
	.byte	0x8
	.byte	0x53
	.long	0x5c8
	.byte	0x4
	.uleb128 0x6
	.long	.LASF468
	.byte	0x8
	.byte	0x54
	.long	0x5e7
	.byte	0x8
	.byte	0
	.uleb128 0x14
	.long	0x5c8
	.uleb128 0x15
	.long	0x4ac
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x5bd
	.uleb128 0x16
	.long	0x39f
	.long	0x5e7
	.uleb128 0x15
	.long	0x4ac
	.uleb128 0x15
	.long	0x50
	.uleb128 0x15
	.long	0x241
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x5ce
	.uleb128 0x7
	.byte	0x4
	.long	0x3b0
	.uleb128 0x7
	.byte	0x4
	.long	0x58c
	.uleb128 0x5
	.long	.LASF451
	.byte	0x18
	.byte	0x9
	.byte	0x48
	.long	0x64e
	.uleb128 0x6
	.long	.LASF469
	.byte	0x9
	.byte	0x49
	.long	0x766
	.byte	0
	.uleb128 0xf
	.string	"pos"
	.byte	0x9
	.byte	0x4a
	.long	0x5b
	.byte	0x4
	.uleb128 0x6
	.long	.LASF407
	.byte	0x9
	.byte	0x4b
	.long	0x5b
	.byte	0x8
	.uleb128 0x6
	.long	.LASF470
	.byte	0x9
	.byte	0x4c
	.long	0x5b
	.byte	0xc
	.uleb128 0x6
	.long	.LASF447
	.byte	0x9
	.byte	0x4e
	.long	0x70
	.byte	0x10
	.uleb128 0x6
	.long	.LASF471
	.byte	0x9
	.byte	0x4f
	.long	0xcdc
	.byte	0x14
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x5f9
	.uleb128 0x17
	.byte	0x4
	.byte	0xa
	.byte	0x3
	.long	0x675
	.uleb128 0x18
	.long	.LASF472
	.sleb128 0
	.uleb128 0x18
	.long	.LASF473
	.sleb128 1
	.uleb128 0x18
	.long	.LASF474
	.sleb128 2
	.uleb128 0x18
	.long	.LASF475
	.sleb128 3
	.byte	0
	.uleb128 0x5
	.long	.LASF476
	.byte	0x8
	.byte	0xa
	.byte	0xc
	.long	0x69a
	.uleb128 0xf
	.string	"cur"
	.byte	0xa
	.byte	0xd
	.long	0x5b
	.byte	0
	.uleb128 0xf
	.string	"max"
	.byte	0xa
	.byte	0xe
	.long	0x5b
	.byte	0x4
	.byte	0
	.uleb128 0x11
	.long	0x6aa
	.long	0x6aa
	.uleb128 0x12
	.long	0x398
	.byte	0xf
	.byte	0
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF477
	.uleb128 0x5
	.long	.LASF478
	.byte	0x14
	.byte	0xb
	.byte	0x25
	.long	0x6fa
	.uleb128 0x6
	.long	.LASF447
	.byte	0xb
	.byte	0x26
	.long	0x70
	.byte	0
	.uleb128 0x6
	.long	.LASF479
	.byte	0xb
	.byte	0x27
	.long	0x766
	.byte	0x4
	.uleb128 0xf
	.string	"pwd"
	.byte	0xb
	.byte	0x27
	.long	0x766
	.byte	0x8
	.uleb128 0x6
	.long	.LASF480
	.byte	0xb
	.byte	0x28
	.long	0x7cc
	.byte	0xc
	.uleb128 0x6
	.long	.LASF481
	.byte	0xb
	.byte	0x28
	.long	0x7cc
	.byte	0x10
	.byte	0
	.uleb128 0x5
	.long	.LASF469
	.byte	0x30
	.byte	0xc
	.byte	0x11
	.long	0x766
	.uleb128 0x6
	.long	.LASF482
	.byte	0xc
	.byte	0x12
	.long	0xbff
	.byte	0
	.uleb128 0x6
	.long	.LASF483
	.byte	0xc
	.byte	0x13
	.long	0x766
	.byte	0x4
	.uleb128 0xf
	.string	"sb"
	.byte	0xc
	.byte	0x14
	.long	0xaf4
	.byte	0x8
	.uleb128 0x6
	.long	.LASF484
	.byte	0xc
	.byte	0x15
	.long	0xafa
	.byte	0xc
	.uleb128 0x6
	.long	.LASF485
	.byte	0xc
	.byte	0x16
	.long	0xc05
	.byte	0x18
	.uleb128 0x6
	.long	.LASF486
	.byte	0xc
	.byte	0x17
	.long	0x7e
	.byte	0x1c
	.uleb128 0x6
	.long	.LASF447
	.byte	0xc
	.byte	0x18
	.long	0x70
	.byte	0x24
	.uleb128 0x6
	.long	.LASF487
	.byte	0xc
	.byte	0x1a
	.long	0x7e
	.byte	0x28
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x6fa
	.uleb128 0x5
	.long	.LASF486
	.byte	0x20
	.byte	0xd
	.byte	0x6
	.long	0x7cc
	.uleb128 0xf
	.string	"dev"
	.byte	0xd
	.byte	0x7
	.long	0x3e
	.byte	0
	.uleb128 0xf
	.string	"sb"
	.byte	0xd
	.byte	0x8
	.long	0xaf4
	.byte	0x4
	.uleb128 0x6
	.long	.LASF488
	.byte	0xd
	.byte	0x9
	.long	0x766
	.byte	0x8
	.uleb128 0x6
	.long	.LASF489
	.byte	0xd
	.byte	0xa
	.long	0x766
	.byte	0xc
	.uleb128 0x6
	.long	.LASF483
	.byte	0xd
	.byte	0xb
	.long	0x7cc
	.byte	0x10
	.uleb128 0x6
	.long	.LASF490
	.byte	0xd
	.byte	0xc
	.long	0x7e
	.byte	0x14
	.uleb128 0x6
	.long	.LASF447
	.byte	0xd
	.byte	0xd
	.long	0x70
	.byte	0x1c
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x76c
	.uleb128 0x5
	.long	.LASF491
	.byte	0x8c
	.byte	0xb
	.byte	0x30
	.long	0x80f
	.uleb128 0x6
	.long	.LASF492
	.byte	0xb
	.byte	0x35
	.long	0x70
	.byte	0
	.uleb128 0x6
	.long	.LASF493
	.byte	0xb
	.byte	0x36
	.long	0x80f
	.byte	0x4
	.uleb128 0x6
	.long	.LASF494
	.byte	0xb
	.byte	0x37
	.long	0x815
	.byte	0x8
	.uleb128 0x6
	.long	.LASF447
	.byte	0xb
	.byte	0x38
	.long	0x70
	.byte	0x88
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x64e
	.uleb128 0x11
	.long	0x64e
	.long	0x825
	.uleb128 0x12
	.long	0x398
	.byte	0x1f
	.byte	0
	.uleb128 0x5
	.long	.LASF495
	.byte	0x8
	.byte	0xb
	.byte	0x3b
	.long	0x84a
	.uleb128 0xf
	.string	"esp"
	.byte	0xb
	.byte	0x3c
	.long	0x5b
	.byte	0
	.uleb128 0xf
	.string	"eip"
	.byte	0xb
	.byte	0x3d
	.long	0x5b
	.byte	0x4
	.byte	0
	.uleb128 0x5
	.long	.LASF496
	.byte	0x44
	.byte	0xb
	.byte	0x41
	.long	0x91d
	.uleb128 0xf
	.string	"ebx"
	.byte	0xb
	.byte	0x42
	.long	0x50
	.byte	0
	.uleb128 0xf
	.string	"ecx"
	.byte	0xb
	.byte	0x42
	.long	0x50
	.byte	0x4
	.uleb128 0xf
	.string	"edx"
	.byte	0xb
	.byte	0x42
	.long	0x50
	.byte	0x8
	.uleb128 0xf
	.string	"esi"
	.byte	0xb
	.byte	0x42
	.long	0x50
	.byte	0xc
	.uleb128 0xf
	.string	"edi"
	.byte	0xb
	.byte	0x43
	.long	0x50
	.byte	0x10
	.uleb128 0xf
	.string	"ebp"
	.byte	0xb
	.byte	0x43
	.long	0x50
	.byte	0x14
	.uleb128 0xf
	.string	"eax"
	.byte	0xb
	.byte	0x43
	.long	0x50
	.byte	0x18
	.uleb128 0xf
	.string	"ds"
	.byte	0xb
	.byte	0x44
	.long	0x50
	.byte	0x1c
	.uleb128 0xf
	.string	"es"
	.byte	0xb
	.byte	0x44
	.long	0x50
	.byte	0x20
	.uleb128 0xf
	.string	"gs"
	.byte	0xb
	.byte	0x44
	.long	0x50
	.byte	0x24
	.uleb128 0xf
	.string	"fs"
	.byte	0xb
	.byte	0x44
	.long	0x50
	.byte	0x28
	.uleb128 0x6
	.long	.LASF497
	.byte	0xb
	.byte	0x45
	.long	0x50
	.byte	0x2c
	.uleb128 0xf
	.string	"eip"
	.byte	0xb
	.byte	0x46
	.long	0x50
	.byte	0x30
	.uleb128 0xf
	.string	"cs"
	.byte	0xb
	.byte	0x46
	.long	0x50
	.byte	0x34
	.uleb128 0x6
	.long	.LASF498
	.byte	0xb
	.byte	0x46
	.long	0x50
	.byte	0x38
	.uleb128 0xf
	.string	"esp"
	.byte	0xb
	.byte	0x46
	.long	0x50
	.byte	0x3c
	.uleb128 0xf
	.string	"ss"
	.byte	0xb
	.byte	0x46
	.long	0x50
	.byte	0x40
	.byte	0
	.uleb128 0x10
	.long	.LASF499
	.byte	0xb
	.byte	0x47
	.long	0x84a
	.uleb128 0x5
	.long	.LASF500
	.byte	0x24
	.byte	0xb
	.byte	0x4a
	.long	0x94d
	.uleb128 0x6
	.long	.LASF501
	.byte	0xb
	.byte	0x4b
	.long	0x94d
	.byte	0
	.uleb128 0xf
	.string	"esp"
	.byte	0xb
	.byte	0x4c
	.long	0x70
	.byte	0x20
	.byte	0
	.uleb128 0x11
	.long	0x70
	.long	0x95d
	.uleb128 0x12
	.long	0x398
	.byte	0x7
	.byte	0
	.uleb128 0x8
	.byte	0x90
	.byte	0xb
	.byte	0x54
	.long	0xa48
	.uleb128 0x6
	.long	.LASF502
	.byte	0xb
	.byte	0x55
	.long	0x70
	.byte	0
	.uleb128 0x6
	.long	.LASF503
	.byte	0xb
	.byte	0x56
	.long	0x70
	.byte	0x4
	.uleb128 0x6
	.long	.LASF399
	.byte	0xb
	.byte	0x57
	.long	0xa69
	.byte	0x8
	.uleb128 0x6
	.long	.LASF400
	.byte	0xb
	.byte	0x58
	.long	0xa69
	.byte	0xc
	.uleb128 0xf
	.string	"pid"
	.byte	0xb
	.byte	0x59
	.long	0x50
	.byte	0x10
	.uleb128 0x6
	.long	.LASF504
	.byte	0xb
	.byte	0x5a
	.long	0x69a
	.byte	0x14
	.uleb128 0x6
	.long	.LASF505
	.byte	0xb
	.byte	0x5b
	.long	0x50
	.byte	0x24
	.uleb128 0x6
	.long	.LASF506
	.byte	0xb
	.byte	0x5c
	.long	0x50
	.byte	0x28
	.uleb128 0x6
	.long	.LASF507
	.byte	0xb
	.byte	0x5c
	.long	0x50
	.byte	0x2c
	.uleb128 0x6
	.long	.LASF508
	.byte	0xb
	.byte	0x5d
	.long	0x50
	.byte	0x30
	.uleb128 0x6
	.long	.LASF509
	.byte	0xb
	.byte	0x5d
	.long	0x50
	.byte	0x34
	.uleb128 0xf
	.string	"mm"
	.byte	0xb
	.byte	0x5e
	.long	0x5ed
	.byte	0x38
	.uleb128 0x6
	.long	.LASF495
	.byte	0xb
	.byte	0x5f
	.long	0x825
	.byte	0x3c
	.uleb128 0xf
	.string	"fs"
	.byte	0xb
	.byte	0x60
	.long	0xa6f
	.byte	0x44
	.uleb128 0x6
	.long	.LASF510
	.byte	0xb
	.byte	0x61
	.long	0xa75
	.byte	0x48
	.uleb128 0x6
	.long	.LASF511
	.byte	0xb
	.byte	0x62
	.long	0xa7b
	.byte	0x4c
	.uleb128 0x6
	.long	.LASF512
	.byte	0xb
	.byte	0x63
	.long	0x928
	.byte	0x64
	.uleb128 0x6
	.long	.LASF513
	.byte	0xb
	.byte	0x64
	.long	0x50
	.byte	0x88
	.uleb128 0x6
	.long	.LASF514
	.byte	0xb
	.byte	0x65
	.long	0x50
	.byte	0x8c
	.byte	0
	.uleb128 0x19
	.string	"pcb"
	.value	0x2000
	.byte	0xb
	.byte	0x52
	.long	0xa69
	.uleb128 0x1a
	.long	0xa8b
	.byte	0
	.uleb128 0x1b
	.long	.LASF515
	.byte	0xb
	.byte	0x69
	.long	0x91d
	.value	0x1fbc
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xa48
	.uleb128 0x7
	.byte	0x4
	.long	0x6b1
	.uleb128 0x7
	.byte	0x4
	.long	0x7d2
	.uleb128 0x11
	.long	0x675
	.long	0xa8b
	.uleb128 0x12
	.long	0x398
	.byte	0x2
	.byte	0
	.uleb128 0x1c
	.value	0x1fbc
	.byte	0xb
	.byte	0x53
	.long	0xaa5
	.uleb128 0xd
	.long	0x95d
	.uleb128 0xc
	.long	.LASF428
	.byte	0xb
	.byte	0x67
	.long	0xaa5
	.byte	0
	.uleb128 0x11
	.long	0x6aa
	.long	0xab6
	.uleb128 0x1d
	.long	0x398
	.value	0x1fbb
	.byte	0
	.uleb128 0x1e
	.long	.LASF516
	.value	0x20c
	.byte	0x9
	.byte	0x33
	.long	0xaf4
	.uleb128 0x6
	.long	.LASF485
	.byte	0x9
	.byte	0x34
	.long	0xcc5
	.byte	0
	.uleb128 0x6
	.long	.LASF479
	.byte	0x9
	.byte	0x35
	.long	0x766
	.byte	0x4
	.uleb128 0xf
	.string	"dev"
	.byte	0x9
	.byte	0x36
	.long	0x3e
	.byte	0x8
	.uleb128 0x6
	.long	.LASF517
	.byte	0x9
	.byte	0x37
	.long	0xccb
	.byte	0xa
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xab6
	.uleb128 0x5
	.long	.LASF518
	.byte	0xc
	.byte	0xc
	.byte	0x9
	.long	0xb2b
	.uleb128 0x6
	.long	.LASF484
	.byte	0xc
	.byte	0xa
	.long	0xb2b
	.byte	0
	.uleb128 0xf
	.string	"len"
	.byte	0xc
	.byte	0xb
	.long	0x70
	.byte	0x4
	.uleb128 0x6
	.long	.LASF487
	.byte	0xc
	.byte	0xc
	.long	0x5b
	.byte	0x8
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xb31
	.uleb128 0x1f
	.long	0x6aa
	.uleb128 0x5
	.long	.LASF519
	.byte	0x4
	.byte	0xc
	.byte	0xe
	.long	0xb4f
	.uleb128 0x6
	.long	.LASF520
	.byte	0xc
	.byte	0xf
	.long	0xb69
	.byte	0
	.byte	0
	.uleb128 0x16
	.long	0x70
	.long	0xb63
	.uleb128 0x15
	.long	0xb63
	.uleb128 0x15
	.long	0xb63
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xafa
	.uleb128 0x7
	.byte	0x4
	.long	0xb4f
	.uleb128 0x5
	.long	.LASF482
	.byte	0xa8
	.byte	0x9
	.byte	0x20
	.long	0xbff
	.uleb128 0xf
	.string	"ino"
	.byte	0x9
	.byte	0x21
	.long	0x5b
	.byte	0
	.uleb128 0xf
	.string	"dev"
	.byte	0x9
	.byte	0x22
	.long	0x3e
	.byte	0x4
	.uleb128 0x6
	.long	.LASF521
	.byte	0x9
	.byte	0x23
	.long	0x3e
	.byte	0x6
	.uleb128 0x6
	.long	.LASF522
	.byte	0x9
	.byte	0x24
	.long	0x50
	.byte	0x8
	.uleb128 0x6
	.long	.LASF523
	.byte	0x9
	.byte	0x25
	.long	0x50
	.byte	0xc
	.uleb128 0x6
	.long	.LASF524
	.byte	0x9
	.byte	0x26
	.long	0x50
	.byte	0x10
	.uleb128 0xf
	.string	"sb"
	.byte	0x9
	.byte	0x27
	.long	0xaf4
	.byte	0x14
	.uleb128 0x6
	.long	.LASF485
	.byte	0x9
	.byte	0x28
	.long	0xc3e
	.byte	0x18
	.uleb128 0x6
	.long	.LASF525
	.byte	0x9
	.byte	0x29
	.long	0xc81
	.byte	0x1c
	.uleb128 0x6
	.long	.LASF487
	.byte	0x9
	.byte	0x2a
	.long	0x7e
	.byte	0x20
	.uleb128 0x6
	.long	.LASF517
	.byte	0x9
	.byte	0x2d
	.long	0xc87
	.byte	0x28
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xb6f
	.uleb128 0x7
	.byte	0x4
	.long	0xb36
	.uleb128 0x5
	.long	.LASF526
	.byte	0x4
	.byte	0x9
	.byte	0x11
	.long	0xc24
	.uleb128 0x6
	.long	.LASF527
	.byte	0x9
	.byte	0x1a
	.long	0xc38
	.byte	0
	.byte	0
	.uleb128 0x16
	.long	0x70
	.long	0xc38
	.uleb128 0x15
	.long	0xbff
	.uleb128 0x15
	.long	0x766
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xc24
	.uleb128 0x7
	.byte	0x4
	.long	0xc0b
	.uleb128 0x5
	.long	.LASF528
	.byte	0x10
	.byte	0x9
	.byte	0x55
	.long	0xc81
	.uleb128 0x6
	.long	.LASF529
	.byte	0x9
	.byte	0x56
	.long	0xcf7
	.byte	0
	.uleb128 0x6
	.long	.LASF530
	.byte	0x9
	.byte	0x57
	.long	0xd27
	.byte	0x4
	.uleb128 0x6
	.long	.LASF466
	.byte	0x9
	.byte	0x59
	.long	0xd41
	.byte	0x8
	.uleb128 0x6
	.long	.LASF531
	.byte	0x9
	.byte	0x5a
	.long	0xd56
	.byte	0xc
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xc44
	.uleb128 0x11
	.long	0x6aa
	.long	0xc97
	.uleb128 0x12
	.long	0x398
	.byte	0x7f
	.byte	0
	.uleb128 0x5
	.long	.LASF532
	.byte	0x4
	.byte	0x9
	.byte	0x30
	.long	0xcb0
	.uleb128 0x6
	.long	.LASF533
	.byte	0x9
	.byte	0x31
	.long	0xcbf
	.byte	0
	.byte	0
	.uleb128 0x16
	.long	0x70
	.long	0xcbf
	.uleb128 0x15
	.long	0xbff
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xcb0
	.uleb128 0x7
	.byte	0x4
	.long	0xc97
	.uleb128 0x11
	.long	0x6aa
	.long	0xcdc
	.uleb128 0x1d
	.long	0x398
	.value	0x1ff
	.byte	0
	.uleb128 0x20
	.byte	0x4
	.uleb128 0x16
	.long	0x70
	.long	0xcf7
	.uleb128 0x15
	.long	0x64e
	.uleb128 0x15
	.long	0x70
	.uleb128 0x15
	.long	0x5b
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xcde
	.uleb128 0x16
	.long	0x70
	.long	0xd1b
	.uleb128 0x15
	.long	0x64e
	.uleb128 0x15
	.long	0xd1b
	.uleb128 0x15
	.long	0x5b
	.uleb128 0x15
	.long	0xd21
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x6aa
	.uleb128 0x7
	.byte	0x4
	.long	0x5b
	.uleb128 0x7
	.byte	0x4
	.long	0xcfd
	.uleb128 0x16
	.long	0x70
	.long	0xd41
	.uleb128 0x15
	.long	0xbff
	.uleb128 0x15
	.long	0x64e
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xd2d
	.uleb128 0x16
	.long	0x70
	.long	0xd56
	.uleb128 0x15
	.long	0x64e
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xd47
	.uleb128 0x13
	.string	"tss"
	.byte	0x7c
	.byte	0xb
	.byte	0x71
	.long	0xf37
	.uleb128 0x6
	.long	.LASF534
	.byte	0xb
	.byte	0x72
	.long	0x49
	.byte	0
	.uleb128 0x6
	.long	.LASF535
	.byte	0xb
	.byte	0x72
	.long	0x49
	.byte	0x2
	.uleb128 0x6
	.long	.LASF536
	.byte	0xb
	.byte	0x73
	.long	0x29
	.byte	0x4
	.uleb128 0xf
	.string	"ss0"
	.byte	0xb
	.byte	0x74
	.long	0x49
	.byte	0x8
	.uleb128 0x6
	.long	.LASF537
	.byte	0xb
	.byte	0x74
	.long	0x49
	.byte	0xa
	.uleb128 0x6
	.long	.LASF538
	.byte	0xb
	.byte	0x75
	.long	0x29
	.byte	0xc
	.uleb128 0xf
	.string	"ss1"
	.byte	0xb
	.byte	0x76
	.long	0x49
	.byte	0x10
	.uleb128 0x6
	.long	.LASF539
	.byte	0xb
	.byte	0x76
	.long	0x49
	.byte	0x12
	.uleb128 0x6
	.long	.LASF540
	.byte	0xb
	.byte	0x77
	.long	0x29
	.byte	0x14
	.uleb128 0xf
	.string	"ss2"
	.byte	0xb
	.byte	0x78
	.long	0x49
	.byte	0x18
	.uleb128 0x6
	.long	.LASF541
	.byte	0xb
	.byte	0x78
	.long	0x49
	.byte	0x1a
	.uleb128 0xf
	.string	"cr3"
	.byte	0xb
	.byte	0x79
	.long	0x29
	.byte	0x1c
	.uleb128 0xf
	.string	"eip"
	.byte	0xb
	.byte	0x7a
	.long	0x29
	.byte	0x20
	.uleb128 0x6
	.long	.LASF498
	.byte	0xb
	.byte	0x7b
	.long	0x29
	.byte	0x24
	.uleb128 0xf
	.string	"eax"
	.byte	0xb
	.byte	0x7c
	.long	0x29
	.byte	0x28
	.uleb128 0xf
	.string	"ecx"
	.byte	0xb
	.byte	0x7c
	.long	0x29
	.byte	0x2c
	.uleb128 0xf
	.string	"edx"
	.byte	0xb
	.byte	0x7c
	.long	0x29
	.byte	0x30
	.uleb128 0xf
	.string	"ebx"
	.byte	0xb
	.byte	0x7c
	.long	0x29
	.byte	0x34
	.uleb128 0xf
	.string	"esp"
	.byte	0xb
	.byte	0x7d
	.long	0x29
	.byte	0x38
	.uleb128 0xf
	.string	"ebp"
	.byte	0xb
	.byte	0x7e
	.long	0x29
	.byte	0x3c
	.uleb128 0xf
	.string	"esi"
	.byte	0xb
	.byte	0x7f
	.long	0x29
	.byte	0x40
	.uleb128 0x6
	.long	.LASF542
	.byte	0xb
	.byte	0x80
	.long	0x29
	.byte	0x44
	.uleb128 0xf
	.string	"es"
	.byte	0xb
	.byte	0x81
	.long	0x49
	.byte	0x48
	.uleb128 0x6
	.long	.LASF543
	.byte	0xb
	.byte	0x81
	.long	0x49
	.byte	0x4a
	.uleb128 0xf
	.string	"cs"
	.byte	0xb
	.byte	0x82
	.long	0x49
	.byte	0x4c
	.uleb128 0x6
	.long	.LASF544
	.byte	0xb
	.byte	0x82
	.long	0x49
	.byte	0x4e
	.uleb128 0xf
	.string	"ss"
	.byte	0xb
	.byte	0x83
	.long	0x49
	.byte	0x50
	.uleb128 0x6
	.long	.LASF545
	.byte	0xb
	.byte	0x83
	.long	0x49
	.byte	0x52
	.uleb128 0xf
	.string	"ds"
	.byte	0xb
	.byte	0x84
	.long	0x49
	.byte	0x54
	.uleb128 0x6
	.long	.LASF546
	.byte	0xb
	.byte	0x84
	.long	0x49
	.byte	0x56
	.uleb128 0xf
	.string	"fs"
	.byte	0xb
	.byte	0x85
	.long	0x49
	.byte	0x58
	.uleb128 0x6
	.long	.LASF547
	.byte	0xb
	.byte	0x85
	.long	0x49
	.byte	0x5a
	.uleb128 0xf
	.string	"gs"
	.byte	0xb
	.byte	0x86
	.long	0x49
	.byte	0x5c
	.uleb128 0x6
	.long	.LASF548
	.byte	0xb
	.byte	0x86
	.long	0x49
	.byte	0x5e
	.uleb128 0xf
	.string	"ldt"
	.byte	0xb
	.byte	0x87
	.long	0x49
	.byte	0x60
	.uleb128 0x6
	.long	.LASF549
	.byte	0xb
	.byte	0x87
	.long	0x49
	.byte	0x62
	.uleb128 0x6
	.long	.LASF550
	.byte	0xb
	.byte	0x88
	.long	0x49
	.byte	0x64
	.uleb128 0x6
	.long	.LASF551
	.byte	0xb
	.byte	0x88
	.long	0x49
	.byte	0x66
	.uleb128 0x6
	.long	.LASF552
	.byte	0xb
	.byte	0x89
	.long	0xf37
	.byte	0x68
	.byte	0
	.uleb128 0x11
	.long	0x29
	.long	0xf47
	.uleb128 0x12
	.long	0x398
	.byte	0x4
	.byte	0
	.uleb128 0x21
	.string	"sti"
	.byte	0x1
	.byte	0xc2
	.long	.LFB34
	.long	.LFE34-.LFB34
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x22
	.long	.LASF593
	.byte	0x1
	.byte	0xca
	.long	0xf7f
	.long	.LFB35
	.long	.LFE35-.LFB35
	.uleb128 0x1
	.byte	0x9c
	.long	0xf7f
	.uleb128 0x23
	.string	"IF"
	.byte	0x1
	.byte	0xcb
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x2
	.byte	0x1
	.byte	0x2
	.long	.LASF553
	.uleb128 0x24
	.long	.LASF554
	.byte	0x2
	.byte	0xd
	.long	.LFB51
	.long	.LFE51-.LFB51
	.uleb128 0x1
	.byte	0x9c
	.long	0xfe9
	.uleb128 0x25
	.string	"p"
	.byte	0x2
	.byte	0xd
	.long	0xa69
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x26
	.long	.LASF508
	.byte	0x2
	.byte	0xd
	.long	0x50
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.uleb128 0x26
	.long	.LASF509
	.byte	0x2
	.byte	0xd
	.long	0x50
	.uleb128 0x2
	.byte	0x91
	.sleb128 8
	.uleb128 0x23
	.string	"IF"
	.byte	0x2
	.byte	0xe
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x27
	.long	.LBB2
	.long	.LBE2-.LBB2
	.uleb128 0x28
	.long	.LASF479
	.byte	0x2
	.byte	0x13
	.long	0xcdc
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.byte	0
	.uleb128 0x24
	.long	.LASF555
	.byte	0x2
	.byte	0x18
	.long	.LFB52
	.long	.LFE52-.LFB52
	.uleb128 0x1
	.byte	0x9c
	.long	0x1030
	.uleb128 0x25
	.string	"p"
	.byte	0x2
	.byte	0x18
	.long	0xa69
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x23
	.string	"IF"
	.byte	0x2
	.byte	0x19
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x27
	.long	.LBB3
	.long	.LBE3-.LBB3
	.uleb128 0x28
	.long	.LASF479
	.byte	0x2
	.byte	0x1c
	.long	0xcdc
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.byte	0
	.uleb128 0x24
	.long	.LASF556
	.byte	0x2
	.byte	0x21
	.long	.LFB53
	.long	.LFE53-.LFB53
	.uleb128 0x1
	.byte	0x9c
	.long	0x1077
	.uleb128 0x25
	.string	"p"
	.byte	0x2
	.byte	0x21
	.long	0xa69
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x23
	.string	"IF"
	.byte	0x2
	.byte	0x22
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x27
	.long	.LBB4
	.long	.LBE4-.LBB4
	.uleb128 0x28
	.long	.LASF479
	.byte	0x2
	.byte	0x25
	.long	0xcdc
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.byte	0
	.uleb128 0x24
	.long	.LASF557
	.byte	0x2
	.byte	0x2c
	.long	.LFB54
	.long	.LFE54-.LFB54
	.uleb128 0x1
	.byte	0x9c
	.long	0x10be
	.uleb128 0x25
	.string	"p"
	.byte	0x2
	.byte	0x2c
	.long	0xa69
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x23
	.string	"IF"
	.byte	0x2
	.byte	0x2d
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x27
	.long	.LBB5
	.long	.LBE5-.LBB5
	.uleb128 0x28
	.long	.LASF479
	.byte	0x2
	.byte	0x30
	.long	0xcdc
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.byte	0
	.uleb128 0x24
	.long	.LASF558
	.byte	0x2
	.byte	0x35
	.long	.LFB55
	.long	.LFE55-.LFB55
	.uleb128 0x1
	.byte	0x9c
	.long	0x1132
	.uleb128 0x26
	.long	.LASF559
	.byte	0x2
	.byte	0x35
	.long	0x1132
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x28
	.long	.LASF560
	.byte	0x2
	.byte	0x36
	.long	0x69a
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x28
	.long	.LASF561
	.byte	0x2
	.byte	0x4c
	.long	0xa69
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0x29
	.long	.LBB6
	.long	.LBE6-.LBB6
	.long	0x1119
	.uleb128 0x28
	.long	.LASF562
	.byte	0x2
	.byte	0x3a
	.long	0x69a
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.byte	0
	.uleb128 0x27
	.long	.LBB7
	.long	.LBE7-.LBB7
	.uleb128 0x28
	.long	.LASF400
	.byte	0x2
	.byte	0x4f
	.long	0xa69
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x84a
	.uleb128 0x24
	.long	.LASF563
	.byte	0x2
	.byte	0x69
	.long	.LFB56
	.long	.LFE56-.LFB56
	.uleb128 0x1
	.byte	0x9c
	.long	0x1197
	.uleb128 0x23
	.string	"IF"
	.byte	0x2
	.byte	0x6a
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 -44
	.uleb128 0x28
	.long	.LASF400
	.byte	0x2
	.byte	0x6f
	.long	0xa69
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x27
	.long	.LBB8
	.long	.LBE8-.LBB8
	.uleb128 0x23
	.string	"p"
	.byte	0x2
	.byte	0x79
	.long	0xa69
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x27
	.long	.LBB9
	.long	.LBE9-.LBB9
	.uleb128 0x23
	.string	"tmp"
	.byte	0x2
	.byte	0x7e
	.long	0xcdc
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x2a
	.long	.LASF594
	.byte	0x2
	.byte	0xca
	.long	0x70
	.long	.LFB57
	.long	.LFE57-.LFB57
	.uleb128 0x1
	.byte	0x9c
	.long	0x11cd
	.uleb128 0x26
	.long	.LASF564
	.byte	0x2
	.byte	0xca
	.long	0x5b
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x28
	.long	.LASF565
	.byte	0x2
	.byte	0xcb
	.long	0x70
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0x24
	.long	.LASF566
	.byte	0x2
	.byte	0xd4
	.long	.LFB58
	.long	.LFE58-.LFB58
	.uleb128 0x1
	.byte	0x9c
	.long	0x11ff
	.uleb128 0x26
	.long	.LASF508
	.byte	0x2
	.byte	0xd4
	.long	0x50
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x26
	.long	.LASF509
	.byte	0x2
	.byte	0xd4
	.long	0x50
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.byte	0
	.uleb128 0x24
	.long	.LASF567
	.byte	0x2
	.byte	0xe1
	.long	.LFB59
	.long	.LFE59-.LFB59
	.uleb128 0x1
	.byte	0x9c
	.long	0x1221
	.uleb128 0x25
	.string	"p"
	.byte	0x2
	.byte	0xe1
	.long	0xa69
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.byte	0
	.uleb128 0x24
	.long	.LASF568
	.byte	0x2
	.byte	0xe4
	.long	.LFB60
	.long	.LFE60-.LFB60
	.uleb128 0x1
	.byte	0x9c
	.long	0x1253
	.uleb128 0x26
	.long	.LASF508
	.byte	0x2
	.byte	0xe4
	.long	0x50
	.uleb128 0x2
	.byte	0x91
	.sleb128 0
	.uleb128 0x26
	.long	.LASF509
	.byte	0x2
	.byte	0xe4
	.long	0x50
	.uleb128 0x2
	.byte	0x91
	.sleb128 4
	.byte	0
	.uleb128 0x2b
	.long	.LASF595
	.uleb128 0x28
	.long	.LASF569
	.byte	0x2
	.byte	0xb
	.long	0xa69
	.uleb128 0x5
	.byte	0x3
	.long	list_sleep
	.uleb128 0x2c
	.long	.LASF570
	.byte	0x2
	.byte	0x7
	.long	0x5b
	.uleb128 0x5
	.byte	0x3
	.long	ticks
	.uleb128 0x2d
	.long	.LASF571
	.byte	0xe
	.byte	0x5
	.long	0xa69
	.uleb128 0x2c
	.long	.LASF572
	.byte	0xe
	.byte	0x9
	.long	0xa69
	.uleb128 0x5
	.byte	0x3
	.long	list_active
	.uleb128 0x2c
	.long	.LASF573
	.byte	0xe
	.byte	0xe
	.long	0xa69
	.uleb128 0x5
	.byte	0x3
	.long	list_expire
	.uleb128 0x11
	.long	0x6aa
	.long	0x12b7
	.uleb128 0x12
	.long	0x398
	.byte	0x3
	.byte	0
	.uleb128 0x2c
	.long	.LASF574
	.byte	0xf
	.byte	0x35
	.long	0x12a7
	.uleb128 0x5
	.byte	0x3
	.long	mem_entity
	.uleb128 0x2c
	.long	.LASF575
	.byte	0x6
	.byte	0x1e
	.long	0x39f
	.uleb128 0x5
	.byte	0x3
	.long	mem_map
	.uleb128 0x2c
	.long	.LASF576
	.byte	0x6
	.byte	0x40
	.long	0x3a5
	.uleb128 0x5
	.byte	0x3
	.long	zone_dma
	.uleb128 0x2c
	.long	.LASF577
	.byte	0x6
	.byte	0x41
	.long	0x3a5
	.uleb128 0x5
	.byte	0x3
	.long	zone_normal
	.uleb128 0x2c
	.long	.LASF578
	.byte	0x6
	.byte	0x42
	.long	0x3a5
	.uleb128 0x5
	.byte	0x3
	.long	zone_highmem
	.uleb128 0x11
	.long	0x131c
	.long	0x131c
	.uleb128 0x12
	.long	0x398
	.byte	0x2
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0x3a5
	.uleb128 0x2c
	.long	.LASF579
	.byte	0x6
	.byte	0x43
	.long	0x130c
	.uleb128 0x5
	.byte	0x3
	.long	__zones
	.uleb128 0x11
	.long	0x5b
	.long	0x1343
	.uleb128 0x12
	.long	0x398
	.byte	0x2
	.byte	0
	.uleb128 0x2c
	.long	.LASF580
	.byte	0x6
	.byte	0x44
	.long	0x1333
	.uleb128 0x5
	.byte	0x3
	.long	size_of_zone
	.uleb128 0x2d
	.long	.LASF581
	.byte	0xb
	.byte	0xb
	.long	0xd5c
	.uleb128 0x2c
	.long	.LASF582
	.byte	0xb
	.byte	0x10
	.long	0xa69
	.uleb128 0x5
	.byte	0x3
	.long	__hs_pcb
	.uleb128 0x2c
	.long	.LASF583
	.byte	0xb
	.byte	0x11
	.long	0xa69
	.uleb128 0x5
	.byte	0x3
	.long	__ext_pcb
	.uleb128 0x2c
	.long	.LASF584
	.byte	0xc
	.byte	0x6
	.long	0xa3
	.uleb128 0x5
	.byte	0x3
	.long	dentry_hashtable
	.uleb128 0x2c
	.long	.LASF585
	.byte	0xc
	.byte	0x9e
	.long	0x13a3
	.uleb128 0x5
	.byte	0x3
	.long	dentry_cache
	.uleb128 0x7
	.byte	0x4
	.long	0x1253
	.uleb128 0x2c
	.long	.LASF586
	.byte	0x9
	.byte	0x45
	.long	0xa3
	.uleb128 0x5
	.byte	0x3
	.long	inode_hashtable
	.uleb128 0x2c
	.long	.LASF587
	.byte	0x9
	.byte	0x73
	.long	0x13a3
	.uleb128 0x5
	.byte	0x3
	.long	inode_cache
	.uleb128 0x2c
	.long	.LASF588
	.byte	0x9
	.byte	0x74
	.long	0x13a3
	.uleb128 0x5
	.byte	0x3
	.long	file_cache
	.uleb128 0x11
	.long	0x13ec
	.long	0x13ec
	.uleb128 0x12
	.long	0x398
	.byte	0x2
	.byte	0
	.uleb128 0x7
	.byte	0x4
	.long	0xa69
	.uleb128 0x2c
	.long	.LASF589
	.byte	0x2
	.byte	0xc
	.long	0x13dc
	.uleb128 0x5
	.byte	0x3
	.long	pcb_lists
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
	.uleb128 0x22
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
	.uleb128 0x25
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
	.uleb128 0x26
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
	.uleb128 0x29
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
	.uleb128 0x2a
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
	.uleb128 0x2d
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
	.uleb128 0xe
	.byte	0x5
	.uleb128 0x2
	.long	.LASF228
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x3
	.byte	0x7
	.long	.Ldebug_macro1
	.byte	0x4
	.byte	0x5
	.uleb128 0x13
	.long	.LASF242
	.byte	0x4
	.byte	0x3
	.uleb128 0x2
	.uleb128 0xb
	.byte	0x5
	.uleb128 0x2
	.long	.LASF243
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x3
	.byte	0x4
	.byte	0x3
	.uleb128 0x4
	.uleb128 0x1
	.byte	0x5
	.uleb128 0x2
	.long	.LASF244
	.byte	0x3
	.uleb128 0x3
	.uleb128 0xf
	.byte	0x7
	.long	.Ldebug_macro2
	.byte	0x4
	.file 16 "./include/linux/mylist.h"
	.byte	0x3
	.uleb128 0x4
	.uleb128 0x10
	.byte	0x7
	.long	.Ldebug_macro3
	.byte	0x4
	.file 17 "./include/linux/assert.h"
	.byte	0x3
	.uleb128 0x6
	.uleb128 0x11
	.byte	0x7
	.long	.Ldebug_macro4
	.byte	0x4
	.file 18 "./include/linux/byteorder/generic.h"
	.byte	0x3
	.uleb128 0x7
	.uleb128 0x12
	.byte	0x7
	.long	.Ldebug_macro5
	.byte	0x4
	.file 19 "./include/linux/string.h"
	.byte	0x3
	.uleb128 0x8
	.uleb128 0x13
	.byte	0x5
	.uleb128 0x2
	.long	.LASF282
	.byte	0x4
	.file 20 "./include/old/mm.h"
	.byte	0x3
	.uleb128 0x3c
	.uleb128 0x14
	.byte	0x5
	.uleb128 0x2
	.long	.LASF283
	.byte	0x3
	.uleb128 0x3
	.uleb128 0x8
	.byte	0x5
	.uleb128 0x2
	.long	.LASF284
	.byte	0x3
	.uleb128 0x5
	.uleb128 0x1
	.byte	0x4
	.byte	0x3
	.uleb128 0x6
	.uleb128 0x4
	.byte	0x7
	.long	.Ldebug_macro6
	.byte	0x4
	.byte	0x3
	.uleb128 0x7
	.uleb128 0x6
	.byte	0x5
	.uleb128 0x2
	.long	.LASF289
	.byte	0x3
	.uleb128 0x4
	.uleb128 0x8
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
	.file 21 "./include/old/pmm.h"
	.byte	0x3
	.uleb128 0x8
	.uleb128 0x15
	.byte	0x7
	.long	.Ldebug_macro9
	.byte	0x4
	.byte	0x3
	.uleb128 0x9
	.uleb128 0x7
	.byte	0x7
	.long	.Ldebug_macro10
	.byte	0x4
	.byte	0x5
	.uleb128 0x82
	.long	.LASF339
	.byte	0x4
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro11
	.byte	0x4
	.file 22 "./include/old/ku_proc.h"
	.byte	0x3
	.uleb128 0x5
	.uleb128 0x16
	.byte	0x7
	.long	.Ldebug_macro12
	.byte	0x4
	.byte	0x3
	.uleb128 0x7
	.uleb128 0xa
	.byte	0x5
	.uleb128 0x2
	.long	.LASF361
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro13
	.byte	0x3
	.uleb128 0x70
	.uleb128 0x9
	.byte	0x5
	.uleb128 0x2
	.long	.LASF370
	.byte	0x3
	.uleb128 0x3
	.uleb128 0xc
	.byte	0x5
	.uleb128 0x2
	.long	.LASF371
	.byte	0x3
	.uleb128 0x4
	.uleb128 0xd
	.byte	0x5
	.uleb128 0x2
	.long	.LASF372
	.byte	0x3
	.uleb128 0x3
	.uleb128 0xc
	.byte	0x4
	.byte	0x4
	.byte	0x5
	.uleb128 0x7
	.long	.LASF373
	.file 23 "./include/linux/slab.h"
	.byte	0x3
	.uleb128 0x9d
	.uleb128 0x17
	.byte	0x7
	.long	.Ldebug_macro14
	.byte	0x4
	.byte	0x4
	.byte	0x3
	.uleb128 0x4
	.uleb128 0xb
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro15
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro16
	.byte	0x4
	.file 24 "./include/linux/printf.h"
	.byte	0x3
	.uleb128 0x5
	.uleb128 0x18
	.byte	0x5
	.uleb128 0x2
	.long	.LASF390
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
	.section	.debug_macro,"G",@progbits,wm4.ku_utils.h.2.5922a71b1df9dd5ef65a03e03d1ab8b0,comdat
.Ldebug_macro2:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF245
	.byte	0x5
	.uleb128 0x4
	.long	.LASF246
	.byte	0x5
	.uleb128 0x5
	.long	.LASF247
	.byte	0x5
	.uleb128 0x8
	.long	.LASF248
	.byte	0x5
	.uleb128 0x1f
	.long	.LASF249
	.byte	0x5
	.uleb128 0x2c
	.long	.LASF250
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.mylist.h.2.6dffd1aa01612dc930709a466e043124,comdat
.Ldebug_macro3:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF251
	.byte	0x5
	.uleb128 0x12
	.long	.LASF252
	.byte	0x5
	.uleb128 0x1b
	.long	.LASF253
	.byte	0x5
	.uleb128 0x2c
	.long	.LASF254
	.byte	0x5
	.uleb128 0x58
	.long	.LASF255
	.byte	0x5
	.uleb128 0x68
	.long	.LASF256
	.byte	0x5
	.uleb128 0x76
	.long	.LASF257
	.byte	0x5
	.uleb128 0x7f
	.long	.LASF258
	.byte	0x5
	.uleb128 0x94
	.long	.LASF259
	.byte	0x5
	.uleb128 0xaf
	.long	.LASF260
	.byte	0x5
	.uleb128 0xc8
	.long	.LASF261
	.byte	0x5
	.uleb128 0xd1
	.long	.LASF262
	.byte	0x5
	.uleb128 0xdb
	.long	.LASF263
	.byte	0x5
	.uleb128 0xe5
	.long	.LASF264
	.byte	0x5
	.uleb128 0xf2
	.long	.LASF265
	.byte	0x5
	.uleb128 0xfb
	.long	.LASF266
	.byte	0x5
	.uleb128 0x103
	.long	.LASF267
	.byte	0x5
	.uleb128 0x112
	.long	.LASF268
	.byte	0x5
	.uleb128 0x125
	.long	.LASF269
	.byte	0x5
	.uleb128 0x12d
	.long	.LASF270
	.byte	0x5
	.uleb128 0x144
	.long	.LASF271
	.byte	0x5
	.uleb128 0x155
	.long	.LASF272
	.byte	0x5
	.uleb128 0x163
	.long	.LASF273
	.byte	0x5
	.uleb128 0x16c
	.long	.LASF274
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.assert.h.2.04d8cd0d4ab92c4edaf5ee8e3da38922,comdat
.Ldebug_macro4:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF275
	.byte	0x5
	.uleb128 0x6
	.long	.LASF276
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.generic.h.2.080a533b5efade0c3c025e01b2a9592c,comdat
.Ldebug_macro5:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF277
	.byte	0x5
	.uleb128 0x13
	.long	.LASF278
	.byte	0x5
	.uleb128 0x14
	.long	.LASF279
	.byte	0x5
	.uleb128 0x16
	.long	.LASF280
	.byte	0x5
	.uleb128 0x17
	.long	.LASF281
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.list.h.2.c01f29f9717739ede2f0953eaf2ad283,comdat
.Ldebug_macro6:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF285
	.byte	0x5
	.uleb128 0xb
	.long	.LASF286
	.byte	0x5
	.uleb128 0x46
	.long	.LASF287
	.byte	0x5
	.uleb128 0x57
	.long	.LASF288
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.page.h.2.207eb50c0e81a8bc7de8e22e9a0f0426,comdat
.Ldebug_macro7:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF290
	.byte	0x5
	.uleb128 0x5
	.long	.LASF291
	.byte	0x5
	.uleb128 0x6
	.long	.LASF292
	.byte	0x5
	.uleb128 0x7
	.long	.LASF293
	.byte	0x5
	.uleb128 0x8
	.long	.LASF294
	.byte	0x5
	.uleb128 0x9
	.long	.LASF295
	.byte	0x5
	.uleb128 0xb
	.long	.LASF296
	.byte	0x5
	.uleb128 0xc
	.long	.LASF297
	.byte	0x5
	.uleb128 0xd
	.long	.LASF298
	.byte	0x5
	.uleb128 0xf
	.long	.LASF299
	.byte	0x5
	.uleb128 0x10
	.long	.LASF300
	.byte	0x5
	.uleb128 0x16
	.long	.LASF301
	.byte	0x5
	.uleb128 0x1c
	.long	.LASF302
	.byte	0x5
	.uleb128 0x1d
	.long	.LASF303
	.byte	0x5
	.uleb128 0x20
	.long	.LASF304
	.byte	0x5
	.uleb128 0x21
	.long	.LASF305
	.byte	0x5
	.uleb128 0x64
	.long	.LASF306
	.byte	0x5
	.uleb128 0x65
	.long	.LASF307
	.byte	0x5
	.uleb128 0x66
	.long	.LASF308
	.byte	0x5
	.uleb128 0x6f
	.long	.LASF309
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.mmzone.h.7.e3c9150cc58cba9f45f09d3f9a9fdf77,comdat
.Ldebug_macro8:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x7
	.long	.LASF310
	.byte	0x5
	.uleb128 0x18
	.long	.LASF311
	.byte	0x5
	.uleb128 0x19
	.long	.LASF312
	.byte	0x5
	.uleb128 0x1a
	.long	.LASF313
	.byte	0x5
	.uleb128 0x1b
	.long	.LASF314
	.byte	0x5
	.uleb128 0x1c
	.long	.LASF315
	.byte	0x5
	.uleb128 0x1d
	.long	.LASF316
	.byte	0x5
	.uleb128 0x20
	.long	.LASF317
	.byte	0x5
	.uleb128 0x22
	.long	.LASF318
	.byte	0x5
	.uleb128 0x23
	.long	.LASF319
	.byte	0x5
	.uleb128 0x24
	.long	.LASF320
	.byte	0x5
	.uleb128 0x25
	.long	.LASF321
	.byte	0x5
	.uleb128 0x26
	.long	.LASF322
	.byte	0x5
	.uleb128 0x28
	.long	.LASF323
	.byte	0x5
	.uleb128 0x29
	.long	.LASF324
	.byte	0x5
	.uleb128 0x2a
	.long	.LASF325
	.byte	0x5
	.uleb128 0x2b
	.long	.LASF326
	.byte	0x5
	.uleb128 0x2d
	.long	.LASF327
	.byte	0x5
	.uleb128 0x2e
	.long	.LASF328
	.byte	0x5
	.uleb128 0x2f
	.long	.LASF329
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.pmm.h.2.0ed63dcb6cf5b539e5b580d439a8fe22,comdat
.Ldebug_macro9:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF330
	.byte	0x5
	.uleb128 0x8
	.long	.LASF331
	.byte	0x5
	.uleb128 0x9
	.long	.LASF332
	.byte	0x5
	.uleb128 0xf
	.long	.LASF333
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.sched.h.2.5f20ed4187e2b315e38086c6f42d15cd,comdat
.Ldebug_macro10:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF334
	.byte	0x5
	.uleb128 0xa
	.long	.LASF335
	.byte	0x5
	.uleb128 0xb
	.long	.LASF336
	.byte	0x5
	.uleb128 0xc
	.long	.LASF337
	.byte	0x5
	.uleb128 0xd
	.long	.LASF338
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.utils.h.64.4303da2b831b2923c55728136f07b37e,comdat
.Ldebug_macro11:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x40
	.long	.LASF340
	.byte	0x5
	.uleb128 0x41
	.long	.LASF341
	.byte	0x5
	.uleb128 0x7a
	.long	.LASF342
	.byte	0x5
	.uleb128 0x7f
	.long	.LASF343
	.byte	0x5
	.uleb128 0x80
	.long	.LASF344
	.byte	0x5
	.uleb128 0x81
	.long	.LASF345
	.byte	0x5
	.uleb128 0x82
	.long	.LASF346
	.byte	0x5
	.uleb128 0x96
	.long	.LASF347
	.byte	0x5
	.uleb128 0xe6
	.long	.LASF348
	.byte	0x5
	.uleb128 0xf0
	.long	.LASF349
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.ku_proc.h.3.dde670f70c5d84b57ae6d3e9345b9deb,comdat
.Ldebug_macro12:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x3
	.long	.LASF350
	.byte	0x5
	.uleb128 0x5
	.long	.LASF351
	.byte	0x5
	.uleb128 0x6
	.long	.LASF352
	.byte	0x5
	.uleb128 0x7
	.long	.LASF353
	.byte	0x5
	.uleb128 0x8
	.long	.LASF354
	.byte	0x5
	.uleb128 0x9
	.long	.LASF355
	.byte	0x5
	.uleb128 0xa
	.long	.LASF356
	.byte	0x5
	.uleb128 0xb
	.long	.LASF357
	.byte	0x5
	.uleb128 0xc
	.long	.LASF358
	.byte	0x5
	.uleb128 0xd
	.long	.LASF359
	.byte	0x5
	.uleb128 0xe
	.long	.LASF360
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.proc.h.9.787373a02089489eee7b84d8741fae40,comdat
.Ldebug_macro13:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x9
	.long	.LASF362
	.byte	0x5
	.uleb128 0xc
	.long	.LASF363
	.byte	0x5
	.uleb128 0x16
	.long	.LASF364
	.byte	0x5
	.uleb128 0x2b
	.long	.LASF365
	.byte	0x5
	.uleb128 0x49
	.long	.LASF366
	.byte	0x5
	.uleb128 0x4e
	.long	.LASF367
	.byte	0x5
	.uleb128 0x4f
	.long	.LASF368
	.byte	0x5
	.uleb128 0x6d
	.long	.LASF369
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.slab.h.2.e2f5bf1bbed146f27a60b3aa1d730158,comdat
.Ldebug_macro14:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF374
	.byte	0x5
	.uleb128 0x5
	.long	.LASF375
	.byte	0x5
	.uleb128 0x6
	.long	.LASF376
	.byte	0x5
	.uleb128 0x7
	.long	.LASF377
	.byte	0x5
	.uleb128 0x9
	.long	.LASF378
	.byte	0x5
	.uleb128 0xa
	.long	.LASF379
	.byte	0x5
	.uleb128 0x12
	.long	.LASF380
	.byte	0x5
	.uleb128 0x1c
	.long	.LASF381
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.fs.h.11.a65a17799966213b91b406978697ab7b,comdat
.Ldebug_macro15:
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
	.section	.debug_macro,"G",@progbits,wm4.proc.h.141.8c77b34ef2b417fda52f0c261904a280,comdat
.Ldebug_macro16:
	.value	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x8d
	.long	.LASF388
	.byte	0x5
	.uleb128 0xa1
	.long	.LASF389
	.byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF77:
	.string	"__PTRDIFF_MAX__ 2147483647"
.LASF580:
	.string	"size_of_zone"
.LASF179:
	.string	"__DEC64_SUBNORMAL_MIN__ 0.000000000000001E-383DD"
.LASF144:
	.string	"__DBL_DECIMAL_DIG__ 17"
.LASF121:
	.string	"__FLT_EVAL_METHOD__ 2"
.LASF532:
	.string	"super_operations"
.LASF132:
	.string	"__FLT_MIN__ 1.17549435082228750797e-38F"
.LASF422:
	.string	"cow_shared"
.LASF91:
	.string	"__UINT32_MAX__ 4294967295U"
.LASF427:
	.string	"debug"
.LASF205:
	.string	"__GCC_ATOMIC_TEST_AND_SET_TRUEVAL 1"
.LASF450:
	.string	"empty_pte"
.LASF478:
	.string	"fs_struct"
.LASF356:
	.string	"MSGTYPE_HS_READY 4"
.LASF93:
	.string	"__INT_LEAST8_MAX__ 127"
.LASF255:
	.ascii	"LL_INSERT(list,location,new) do{ assert( ( (list) == (locati"
	.ascii	"on) ) || ( (list) &"
	.string	"& (location) ) ); assert((new)); if(!list && !location) { list = new; new->next = new->prev = 0; break; } new->next=location; new->prev=location->prev; if(location->prev) location->prev->next=new; location->prev=new; if(list==location) list=new; } while(0)"
.LASF85:
	.string	"__INT8_MAX__ 127"
.LASF522:
	.string	"mktime"
.LASF102:
	.string	"__UINT8_C(c) c"
.LASF274:
	.string	"O_APPEND_SAFE(root,new) ({ if(!root){ root = new; new->prev = new->next = new; } else O_APPEND(root, new); })"
.LASF453:
	.string	"readable"
.LASF71:
	.string	"__LONG_MAX__ 2147483647L"
.LASF480:
	.string	"rootmnt"
.LASF342:
	.string	"DSI(str,i) dispStr(str,0x400);dispInt(i);"
.LASF443:
	.string	"end_code"
.LASF340:
	.string	"return_say(msg) do{oprintf(\"%s\",msg);return;} while(0)"
.LASF556:
	.string	"sleep_active"
.LASF140:
	.string	"__DBL_MIN_EXP__ (-1021)"
.LASF99:
	.string	"__INT_LEAST64_MAX__ 9223372036854775807LL"
.LASF407:
	.string	"flags"
.LASF311:
	.string	"page_idx(page_t) ((unsigned)((page_t) - mem_map))"
.LASF210:
	.string	"__SIZEOF_WINT_T__ 4"
.LASF211:
	.string	"__SIZEOF_PTRDIFF_T__ 4"
.LASF321:
	.string	"__GFP_HIGHMEM (1<<2)"
.LASF581:
	.string	"base_tss"
.LASF409:
	.string	"protection"
.LASF273:
	.string	"O_APPEND(root,new) ({ (new)->next = root; (new)->prev = root->prev; (root)->prev->next = new; (root)->prev = new; })"
.LASF162:
	.string	"__LDBL_DENORM_MIN__ 3.64519953188247460253e-4951L"
.LASF278:
	.string	"ntohs(x) htons(x)"
.LASF319:
	.string	"__GFP_ZERO (1<<0)"
.LASF395:
	.string	"unsigned int"
.LASF400:
	.string	"next"
.LASF303:
	.string	"__pa2page_t(paddr) (mem_map + ((paddr) >> 12))"
.LASF21:
	.string	"__SIZEOF_SIZE_T__ 4"
.LASF36:
	.string	"__CHAR16_TYPE__ short unsigned int"
.LASF537:
	.string	"__ss0h"
.LASF25:
	.string	"__ORDER_BIG_ENDIAN__ 4321"
.LASF481:
	.string	"pwdmnt"
.LASF446:
	.string	"start_brk"
.LASF375:
	.string	"SLAB_HWCACHE_ALIGN 1"
.LASF502:
	.string	"need_resched"
.LASF138:
	.string	"__DBL_MANT_DIG__ 53"
.LASF54:
	.string	"__UINT_LEAST64_TYPE__ long long unsigned int"
.LASF362:
	.string	"P_NAME_MAX 16"
.LASF444:
	.string	"start_data"
.LASF10:
	.string	"__ATOMIC_RELEASE 3"
.LASF312:
	.string	"pte_pfn(pte) ((pte)>>PAGE_SHIFT)"
.LASF78:
	.string	"__SIZE_MAX__ 4294967295U"
.LASF412:
	.string	"dirty_rsv"
.LASF491:
	.string	"files_struct"
.LASF40:
	.string	"__INT16_TYPE__ short int"
.LASF171:
	.string	"__DEC32_EPSILON__ 1E-6DF"
.LASF355:
	.string	"MSGTYPE_HD_DONE 3"
.LASF309:
	.string	"KV __va"
.LASF308:
	.string	"__va(paddr) ((unsigned)(paddr) + PAGE_OFFSET)"
.LASF448:
	.string	"vm_area"
.LASF8:
	.string	"__ATOMIC_SEQ_CST 5"
.LASF265:
	.string	"LL_SCAN_ON_kEY_B(root,key,value) ({ typeof(root) curr = root; while(curr && curr->key <= (value) ) curr = curr->next; curr; })"
.LASF492:
	.string	"max_fds"
.LASF17:
	.string	"__SIZEOF_SHORT__ 2"
.LASF456:
	.string	"mayread"
.LASF547:
	.string	"__fsh"
.LASF47:
	.string	"__INT_LEAST8_TYPE__ signed char"
.LASF583:
	.string	"__ext_pcb"
.LASF287:
	.ascii	"LIST_FIND2(stru"
	.string	"_t,mb_t,root,key,value,result) do{ struct list_head * node = root->next; stru_t *obj; while(node != root){ *obj = MB2STRU(stru_t, node, mb_t); if( (obj)->key == value ) break; node = node->next; } if(node == root) result = 0; else result = obj; } while(0);"
.LASF82:
	.string	"__UINTMAX_C(c) c ## ULL"
.LASF435:
	.string	"zone_struct"
.LASF586:
	.string	"inode_hashtable"
.LASF27:
	.string	"__BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__"
.LASF101:
	.string	"__UINT_LEAST8_MAX__ 255"
.LASF470:
	.string	"mode"
.LASF565:
	.string	"slice"
.LASF257:
	.string	"LL_I2(root,new) do{ assert(root); if(root->next) root->next->prev = new; new->next = root->next; new->prev = root; root->next = new; }while(0)"
.LASF399:
	.string	"prev"
.LASF74:
	.string	"__WCHAR_MIN__ (-__WCHAR_MAX__ - 1)"
.LASF459:
	.string	"mayshare"
.LASF542:
	.string	"edii"
.LASF349:
	.string	"ARR_CELLS(array,stru_t) ( sizeof(array) / sizeof(stru_t))"
.LASF51:
	.string	"__UINT_LEAST8_TYPE__ unsigned char"
.LASF548:
	.string	"__gsh"
.LASF539:
	.string	"__ss1h"
.LASF186:
	.string	"__DEC128_SUBNORMAL_MIN__ 0.000000000000000000000000000000001E-6143DL"
.LASF248:
	.ascii	"eat_hex(pt,x) char*__pt=(pt); x=0; if(*__pt!='0'||*(__pt+1)!"
	.ascii	"='x'){ x=-1; goto donothing; } __pt+=2; if(!((*__pt>='0'&&*_"
	.ascii	"_pt<='9'"
	.string	")||(*__pt>='a'&&*__pt<='f'))){ x=-1; goto donothing; } while((*__pt>='0'&&*__pt<='9')||(*__pt>='a'&&*__pt<='f')) __pt++; __pt--; int __len=__pt-pt+1-2; for(int __i=0;__i<__len;__i++){ x+=hex_int(*__pt)*pow_int(16,__i); __pt--; } (pt)+=(2+__len);donothing:;"
.LASF452:
	.string	"pgoff"
.LASF512:
	.string	"fstack"
.LASF515:
	.string	"regs"
.LASF322:
	.string	"__GFP_NORMAL (1<<3)"
.LASF209:
	.string	"__SIZEOF_WCHAR_T__ 4"
.LASF66:
	.string	"__has_include_next(STR) __has_include_next__(STR)"
.LASF243:
	.string	"PROC_H "
.LASF414:
	.string	"$nopage"
.LASF296:
	.string	"PG_P 1"
.LASF363:
	.string	"g_tss (&base_tss)"
.LASF227:
	.string	"__DECIMAL_BID_FORMAT__ 1"
.LASF351:
	.string	"MSGTYPE_TIMER 255"
.LASF386:
	.string	"I_HASHTABLE_LEN 4096"
.LASF92:
	.string	"__UINT64_MAX__ 18446744073709551615ULL"
.LASF58:
	.string	"__INT_FAST64_TYPE__ long long int"
.LASF336:
	.string	"CLONE_VM 0x100"
.LASF94:
	.string	"__INT8_C(c) c"
.LASF289:
	.string	"MMZONE_H "
.LASF562:
	.string	"title"
.LASF575:
	.string	"mem_map"
.LASF68:
	.string	"__SCHAR_MAX__ 127"
.LASF485:
	.string	"operations"
.LASF388:
	.string	"SET_PID_EAX(pid,return_val) pcb_table[pid].regs.eax=return_val"
.LASF216:
	.string	"__i686 1"
.LASF87:
	.string	"__INT32_MAX__ 2147483647"
.LASF315:
	.string	"page_va(page) __va( (page - mem_map) << PAGE_SHIFT)"
.LASF113:
	.string	"__UINT_FAST8_MAX__ 255"
.LASF64:
	.string	"__UINTPTR_TYPE__ unsigned int"
.LASF345:
	.string	"EXCHG_PTR(a,b) do { void *tmp = a; a = b; b = tmp; } while(0)"
.LASF254:
	.ascii	"LL2_DEL(ll2,node) do{ assert( (ll2) && (node) && (ll2)->root"
	.ascii	" && (ll2)->tail ); i"
	.string	"f( (node)->prev ){ (node)->prev->next = (node)->next; } else{ assert( (ll2)->root == node ); (ll2)->root = (node)->next; } if( (node)->next ){ (node)->next->prev = (node)->prev; } else{ assert( (ll2)->tail == node ); (ll2)->tail = (node)->prev; } }while(0)"
.LASF225:
	.string	"__unix__ 1"
.LASF192:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 1"
.LASF530:
	.string	"read"
.LASF367:
	.string	"PCB_SIZE 0x2000"
.LASF245:
	.string	"KU_UTILS_H "
.LASF385:
	.string	"INODE_COMMON_SIZE 128"
.LASF507:
	.string	"time_slice_full"
.LASF288:
	.string	"MB2STRU(stru_type,mb_addr,mb_name) (stru_type *)( (u32)(mb_addr)- (u32)&((stru_type *)0)->mb_name )"
.LASF541:
	.string	"__ss2h"
.LASF228:
	.string	"SCHEDULE_H "
.LASF501:
	.string	"base"
.LASF447:
	.string	"count"
.LASF146:
	.string	"__DBL_MIN__ ((double)2.22507385850720138309e-308L)"
.LASF169:
	.string	"__DEC32_MIN__ 1E-95DF"
.LASF275:
	.string	"ASSERT_H "
.LASF299:
	.string	"PG_H10(pg_id) (pg_id>>10)"
.LASF161:
	.string	"__LDBL_EPSILON__ 1.08420217248550443401e-19L"
.LASF313:
	.string	"pfn_page(pfn) (mem_map + (pfn))"
.LASF327:
	.string	"ZONE_DMA_PA 0"
.LASF170:
	.string	"__DEC32_MAX__ 9.999999E96DF"
.LASF328:
	.string	"ZONE_NORMAL_PA 0X1000000"
.LASF398:
	.string	"long long unsigned int"
.LASF181:
	.string	"__DEC128_MIN_EXP__ (-6142)"
.LASF451:
	.string	"file"
.LASF381:
	.string	"static_cursor_up "
.LASF339:
	.string	"PGDIR_OF_MM(mm) ( (union pte *)__va(mm->cr3.value & PAGE_MASK) )"
.LASF185:
	.string	"__DEC128_EPSILON__ 1E-33DL"
.LASF111:
	.string	"__INT_FAST32_MAX__ 2147483647"
.LASF550:
	.string	"trace"
.LASF253:
	.ascii	"LL2_A(ll2,node) do{ assert( (ll2) &&"
	.string	" (node) ); assert( ( (ll2)->root == 0 && (ll2)->tail == 0 ) || ( (ll2)->root != 0 && (ll2)->tail != 0) ); (node)->prev = (ll2)->tail; if( (ll2)->tail ){ (ll2)->tail->next = node; } else{ (ll2)->root = node; } (node)->next = 0; (ll2)->tail = node; }while(0)"
.LASF517:
	.string	"common"
.LASF123:
	.string	"__FLT_RADIX__ 2"
.LASF20:
	.string	"__SIZEOF_LONG_DOUBLE__ 12"
.LASF421:
	.string	"_count"
.LASF107:
	.string	"__UINT_LEAST64_MAX__ 18446744073709551615ULL"
.LASF415:
	.string	"$on_read"
.LASF573:
	.string	"list_expire"
.LASF369:
	.string	"current (get_current())"
.LASF60:
	.string	"__UINT_FAST16_TYPE__ unsigned int"
.LASF212:
	.string	"__i386 1"
.LASF215:
	.string	"__ATOMIC_HLE_RELEASE 131072"
.LASF516:
	.string	"super_block"
.LASF156:
	.string	"__LDBL_MAX_EXP__ 16384"
.LASF591:
	.string	"schedule.c"
.LASF241:
	.string	"__3G 0xc0000000"
.LASF425:
	.string	"PG_private"
.LASF390:
	.string	"PRINTF_H "
.LASF177:
	.string	"__DEC64_MAX__ 9.999999999999999E384DD"
.LASF110:
	.string	"__INT_FAST16_MAX__ 2147483647"
.LASF134:
	.string	"__FLT_DENORM_MIN__ 1.40129846432481707092e-45F"
.LASF202:
	.string	"__GCC_ATOMIC_INT_LOCK_FREE 2"
.LASF417:
	.string	"$data"
.LASF344:
	.string	"EXCHG_U32(a,b) do{unsigned c=a;a=b;b=c;} while(0)"
.LASF514:
	.string	"__task_struct_end"
.LASF109:
	.string	"__INT_FAST8_MAX__ 127"
.LASF408:
	.string	"value"
.LASF468:
	.string	"nopage"
.LASF357:
	.string	"MSGTYPE_HS_DONE 5"
.LASF244:
	.string	"UTILS_H "
.LASF410:
	.string	"on_write"
.LASF588:
	.string	"file_cache"
.LASF373:
	.string	"D_HASHTABLE_LEN 1024"
.LASF533:
	.string	"read_inode"
.LASF511:
	.string	"rlimits"
.LASF151:
	.string	"__DBL_HAS_QUIET_NAN__ 1"
.LASF41:
	.string	"__INT32_TYPE__ int"
.LASF558:
	.string	"do_timer"
.LASF499:
	.string	"stack_frame"
.LASF277:
	.string	"BYTEORDER_GENERIC_H "
.LASF461:
	.string	"growsup"
.LASF168:
	.string	"__DEC32_MAX_EXP__ 97"
.LASF286:
	.string	"INIT_LIST_HEAD(l) do{ (l)->prev = (l)->next = l; } while(0)"
.LASF3:
	.string	"__GNUC__ 4"
.LASF131:
	.string	"__FLT_MAX__ 3.40282346638528859812e+38F"
.LASF384:
	.string	"FMODE_SEEK 4"
.LASF326:
	.string	"ZONE_MAX 3"
.LASF237:
	.string	"__8K 0x2000"
.LASF145:
	.string	"__DBL_MAX__ ((double)1.79769313486231570815e+308L)"
.LASF404:
	.string	"accessed"
.LASF95:
	.string	"__INT_LEAST16_MAX__ 32767"
.LASF553:
	.string	"_Bool"
.LASF232:
	.string	"true 1"
.LASF24:
	.string	"__ORDER_LITTLE_ENDIAN__ 1234"
.LASF329:
	.string	"ZONE_HIGHMEM_PA (896*0x100000)"
.LASF67:
	.string	"__GXX_ABI_VERSION 1002"
.LASF376:
	.string	"SLAB_CACHE_DMA 2"
.LASF366:
	.string	"EFLAGS_STACK_LEN 7"
.LASF114:
	.string	"__UINT_FAST16_MAX__ 4294967295U"
.LASF350:
	.string	"KU_PROC_H "
.LASF402:
	.string	"writable"
.LASF559:
	.string	"pregs"
.LASF418:
	.string	"pgerr_code"
.LASF56:
	.string	"__INT_FAST16_TYPE__ int"
.LASF543:
	.string	"__esh"
.LASF301:
	.string	"FLUSH_TLB __asm__ __volatile__(\"mov %%cr3, %0\\n\\t\" \"mov %0, %%cr3\\n\\t\" : :\"r\"(0))"
.LASF213:
	.string	"__i386__ 1"
.LASF44:
	.string	"__UINT16_TYPE__ short unsigned int"
.LASF500:
	.string	"eflags_stack"
.LASF4:
	.string	"__GNUC_MINOR__ 9"
.LASF189:
	.string	"__GNUC_STDC_INLINE__ 1"
.LASF53:
	.string	"__UINT_LEAST32_TYPE__ unsigned int"
.LASF42:
	.string	"__INT64_TYPE__ long long int"
.LASF129:
	.string	"__FLT_MAX_10_EXP__ 38"
.LASF164:
	.string	"__LDBL_HAS_INFINITY__ 1"
.LASF568:
	.string	"kthread_sleep"
.LASF426:
	.string	"PG_zid"
.LASF465:
	.string	"vm_operations"
.LASF552:
	.string	"__cacheline_filler"
.LASF190:
	.string	"__NO_INLINE__ 1"
.LASF587:
	.string	"inode_cache"
.LASF124:
	.string	"__FLT_MANT_DIG__ 24"
.LASF570:
	.string	"ticks"
.LASF148:
	.string	"__DBL_DENORM_MIN__ ((double)4.94065645841246544177e-324L)"
.LASF331:
	.string	"HEAP_BASE 18*0x100000"
.LASF187:
	.string	"__REGISTER_PREFIX__ "
.LASF46:
	.string	"__UINT64_TYPE__ long long unsigned int"
.LASF230:
	.string	"bool _Bool"
.LASF180:
	.string	"__DEC128_MANT_DIG__ 34"
.LASF281:
	.string	"BYTE_ENDIAN_FLIP4(x) x = htonl(x)"
.LASF337:
	.string	"CLONE_FS 0x200"
.LASF122:
	.string	"__DEC_EVAL_METHOD__ 2"
.LASF560:
	.string	"barbuf"
.LASF494:
	.string	"origin_filep"
.LASF141:
	.string	"__DBL_MIN_10_EXP__ (-307)"
.LASF477:
	.string	"char"
.LASF63:
	.string	"__INTPTR_TYPE__ int"
.LASF250:
	.string	"eat_dec_with_len(pt,x,x_len) char*__pt=(pt); while(*(__pt+1)>='0'&&*(__pt+1)<='9') __pt++; len=__pt-(pt)+1; for(int __i=0;__i<x_len;__i++){ x+=(*__pt-48)*pow_int(10,__i); __pt--; } (pt)+=x_len;"
.LASF155:
	.string	"__LDBL_MIN_10_EXP__ (-4931)"
.LASF528:
	.string	"file_operations"
.LASF263:
	.string	"LL_ASSIGN(list,attr,value) do{ void *root = list; while(list){ list->attr=value; list=list->next; } list = root; } while(0)"
.LASF554:
	.string	"active_sleep"
.LASF463:
	.string	"dontcopy"
.LASF458:
	.string	"mayexec"
.LASF229:
	.string	"VALTYPE_H "
.LASF467:
	.string	"close"
.LASF318:
	.string	"__GFP_DEFAULT 0"
.LASF377:
	.string	"SLAB_ZERO 4"
.LASF411:
	.string	"from_user"
.LASF471:
	.string	"data"
.LASF204:
	.string	"__GCC_ATOMIC_LLONG_LOCK_FREE 2"
.LASF360:
	.string	"MSGTYPE_FS_DONE 7"
.LASF527:
	.string	"lookup"
.LASF348:
	.string	"MAKE_IP(a,b,c,d) (((a)<<24) + ((b)<<16) + ((c)<<8) + d)"
.LASF276:
	.string	"assert(exp) do{ if(!(exp)) assert_func(#exp,__FILE__,__BASE_FILE__,__LINE__); } while(0)"
.LASF529:
	.string	"lseek"
.LASF294:
	.string	"pa_idx(paddr) ((paddr)>>PAGE_SHIFT)"
.LASF497:
	.string	"err_code"
.LASF401:
	.string	"present"
.LASF563:
	.string	"schedule"
.LASF380:
	.string	"kmem_cache_create register_slab_type"
.LASF368:
	.string	"THREAD_SIZE 0x2000"
.LASF48:
	.string	"__INT_LEAST16_TYPE__ short int"
.LASF221:
	.string	"__gnu_linux__ 1"
.LASF416:
	.string	"$in_kernel"
.LASF197:
	.string	"__GCC_ATOMIC_CHAR_LOCK_FREE 2"
.LASF359:
	.string	"MSGTYPE_USR_ASK 6"
.LASF584:
	.string	"dentry_hashtable"
.LASF198:
	.string	"__GCC_ATOMIC_CHAR16_T_LOCK_FREE 2"
.LASF157:
	.string	"__LDBL_MAX_10_EXP__ 4932"
.LASF431:
	.string	"nr_free"
.LASF429:
	.string	"free_area_struct"
.LASF203:
	.string	"__GCC_ATOMIC_LONG_LOCK_FREE 2"
.LASF455:
	.string	"shared"
.LASF103:
	.string	"__UINT_LEAST16_MAX__ 65535"
.LASF266:
	.string	"LL_SCAN_ON_KEY_S(root,key,value) ({ typeof(root) curr = root; while(curr && curr->key >= (value) ) curr = curr->next; curr; })"
.LASF302:
	.string	"__va2page_t(vaddr) (mem_map + (((vaddr) - PAGE_OFFSET) >> 12))"
.LASF531:
	.string	"onclose"
.LASF361:
	.string	"RESOURCE_H "
.LASF86:
	.string	"__INT16_MAX__ 32767"
.LASF392:
	.string	"long long int"
.LASF22:
	.string	"__CHAR_BIT__ 8"
.LASF557:
	.string	"sleep_expire"
.LASF555:
	.string	"active_expire"
.LASF196:
	.string	"__GCC_ATOMIC_BOOL_LOCK_FREE 2"
.LASF13:
	.string	"__FINITE_MATH_ONLY__ 0"
.LASF460:
	.string	"growsdown"
.LASF482:
	.string	"inode"
.LASF534:
	.string	"back_link"
.LASF43:
	.string	"__UINT8_TYPE__ unsigned char"
.LASF306:
	.string	"PAGE_OFFSET 0XC0000000"
.LASF69:
	.string	"__SHRT_MAX__ 32767"
.LASF314:
	.string	"pte_page(pte) ( pfn_page( pte_pfn(pte) ) )"
.LASF297:
	.string	"PG_USU 4"
.LASF280:
	.string	"BYTE_ENDIAN_FLIP2(x) x = htons(x)"
.LASF383:
	.string	"FMODE_WRITE 2"
.LASF226:
	.string	"__ELF__ 1"
.LASF283:
	.string	"MM_H "
.LASF96:
	.string	"__INT16_C(c) c"
.LASF207:
	.string	"__GCC_HAVE_DWARF2_CFI_ASM 1"
.LASF261:
	.ascii	"LL_DEL(list,location) d"
	.string	"o{ assert(list&&location); assert(!(!location->next && !location->prev && (list!=location))); if(location->prev) location->prev->next=location->next; if(location->next) location->next->prev=location->prev; if(list==location) list=location->next; } while(0)"
.LASF18:
	.string	"__SIZEOF_FLOAT__ 4"
.LASF31:
	.string	"__PTRDIFF_TYPE__ int"
.LASF178:
	.string	"__DEC64_EPSILON__ 1E-15DD"
.LASF136:
	.string	"__FLT_HAS_INFINITY__ 1"
.LASF49:
	.string	"__INT_LEAST32_TYPE__ int"
.LASF525:
	.string	"file_ops"
.LASF279:
	.string	"ntohl(x) htonl(x)"
.LASF439:
	.string	"spanned_pages"
.LASF0:
	.string	"__STDC__ 1"
.LASF15:
	.string	"__SIZEOF_LONG__ 4"
.LASF271:
	.string	"O_INSERT_INCRE_ON(root,new,mb) ({ assert(root && new); __typeof__(root) leftone = root->prev; while(new->mb > leftone->mb){ leftone = leftone->prev; if(leftone == root->prev){ root = new; break; } } O_INSERT_AFTER(leftone, new); })"
.LASF442:
	.string	"start_code"
.LASF523:
	.string	"chgtime"
.LASF12:
	.string	"__ATOMIC_CONSUME 1"
.LASF438:
	.string	"zone_mem_map"
.LASF158:
	.string	"__DECIMAL_DIG__ 21"
.LASF33:
	.string	"__WINT_TYPE__ unsigned int"
.LASF117:
	.string	"__INTPTR_MAX__ 2147483647"
.LASF524:
	.string	"size"
.LASF106:
	.string	"__UINT32_C(c) c ## U"
.LASF520:
	.string	"compare"
.LASF549:
	.string	"__ldth"
.LASF19:
	.string	"__SIZEOF_DOUBLE__ 8"
.LASF323:
	.string	"ZONE_DMA 0"
.LASF433:
	.string	"allocs"
.LASF544:
	.string	"__csh"
.LASF76:
	.string	"__WINT_MIN__ 0U"
.LASF358:
	.string	"MSGTYPE_FS_READY 8"
.LASF152:
	.string	"__LDBL_MANT_DIG__ 64"
.LASF153:
	.string	"__LDBL_DIG__ 18"
.LASF589:
	.string	"pcb_lists"
.LASF486:
	.string	"vfsmount"
.LASF577:
	.string	"zone_normal"
.LASF346:
	.string	"EXCHG_U16(a,b) do{ u16 tmp = a; a = b; b = tmp; } while(0)"
.LASF270:
	.string	"O_INSERT_BEFORE(Next,new) ({ new->next = Next; new->prev = Next->prev; Next->prev->next = new; Next->prev = new; })"
.LASF423:
	.string	"private"
.LASF260:
	.ascii	"LL_I_DECRE(list,new,attr) do{ assert(new); if(!list){ list=n"
	.ascii	"ew; new->prev=new->next=0; break; } void*root=list; while(li"
	.ascii	"st->next && new->at"
	.string	"tr < list->attr) list=list->next; if(new->attr < list->attr){ new->next = 0; list->next=new; new->prev=list; list=root; } else{ new->next=list; new->prev=list->prev; if(list->prev) list->prev->next=new; list->prev=new; if(root==list) list=new; } } while(0)"
.LASF473:
	.string	"RLIMIT_FSIZE"
.LASF62:
	.string	"__UINT_FAST64_TYPE__ long long unsigned int"
.LASF120:
	.string	"__GCC_IEC_559_COMPLEX 2"
.LASF235:
	.string	"NULL 0"
.LASF72:
	.string	"__LONG_LONG_MAX__ 9223372036854775807LL"
.LASF428:
	.string	"padden"
.LASF334:
	.string	"LINUX_SCHED_H "
.LASF28:
	.string	"__FLOAT_WORD_ORDER__ __ORDER_LITTLE_ENDIAN__"
.LASF193:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 1"
.LASF352:
	.string	"MSGTYPE_DEEP 0"
.LASF166:
	.string	"__DEC32_MANT_DIG__ 7"
.LASF174:
	.string	"__DEC64_MIN_EXP__ (-382)"
.LASF84:
	.string	"__SIG_ATOMIC_MIN__ (-__SIG_ATOMIC_MAX__ - 1)"
.LASF505:
	.string	"prio"
.LASF73:
	.string	"__WCHAR_MAX__ 2147483647L"
.LASF9:
	.string	"__ATOMIC_ACQUIRE 2"
.LASF104:
	.string	"__UINT16_C(c) c"
.LASF234:
	.string	"__DEBUG "
.LASF298:
	.string	"PG_RWW 2"
.LASF258:
	.string	"LL_REPLACE(root,old,new) do{ new->prev = old->prev; new->next = old->next; if(new->prev) new->prev->next = new; if(new->next) new->next->prev = new; if(root == old) root = new; }while(0)"
.LASF405:
	.string	"dirty"
.LASF504:
	.string	"p_name"
.LASF513:
	.string	"magic"
.LASF292:
	.string	"PAGE_SIZE 0x1000"
.LASF406:
	.string	"physical"
.LASF441:
	.string	"zone_t"
.LASF571:
	.string	"idle"
.LASF218:
	.string	"__pentiumpro 1"
.LASF35:
	.string	"__UINTMAX_TYPE__ long long unsigned int"
.LASF521:
	.string	"rdev"
.LASF236:
	.string	"__4K 0x1000"
.LASF208:
	.string	"__PRAGMA_REDEFINE_EXTNAME 1"
.LASF374:
	.string	"SLAB_H "
.LASF89:
	.string	"__UINT8_MAX__ 255"
.LASF338:
	.string	"CLONE_FD 0x400"
.LASF200:
	.string	"__GCC_ATOMIC_WCHAR_T_LOCK_FREE 2"
.LASF26:
	.string	"__ORDER_PDP_ENDIAN__ 3412"
.LASF75:
	.string	"__WINT_MAX__ 4294967295U"
.LASF479:
	.string	"root"
.LASF220:
	.string	"__code_model_32__ 1"
.LASF475:
	.string	"RLIMIT_MAX"
.LASF476:
	.string	"rlimit"
.LASF154:
	.string	"__LDBL_MIN_EXP__ (-16381)"
.LASF184:
	.string	"__DEC128_MAX__ 9.999999999999999999999999999999999E6144DL"
.LASF430:
	.string	"free_list"
.LASF564:
	.string	"msec"
.LASF483:
	.string	"parent"
.LASF115:
	.string	"__UINT_FAST32_MAX__ 4294967295U"
.LASF472:
	.string	"RLIMIT_CPU"
.LASF397:
	.string	"short int"
.LASF413:
	.string	"instruction"
.LASF175:
	.string	"__DEC64_MAX_EXP__ 385"
.LASF194:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 1"
.LASF239:
	.string	"__4M 0x400000"
.LASF462:
	.string	"denywrite"
.LASF561:
	.string	"curr"
.LASF61:
	.string	"__UINT_FAST32_TYPE__ unsigned int"
.LASF498:
	.string	"eflags"
.LASF272:
	.string	"O_SCAN_UNTIL_MEET_LARGER(root,mb,value) ({ assert( (root) ); __typeof__(root) node = root; do{ if( (node)->mb > value) break; node = node->next; if(node != root) continue; node = 0; break; }while(1); node; })"
.LASF290:
	.string	"X86_PAGE_H "
.LASF37:
	.string	"__CHAR32_TYPE__ unsigned int"
.LASF372:
	.string	"MOUNT_H "
.LASF183:
	.string	"__DEC128_MIN__ 1E-6143DL"
.LASF182:
	.string	"__DEC128_MAX_EXP__ 6145"
.LASF420:
	.string	"page"
.LASF295:
	.string	"pa_pg pa_idx"
.LASF268:
	.ascii	"LL_I_"
	.string	"INCRE_ON(root,new,mb) ({ new->prev = 0; new->next = root; while(new->next && new->next->mb < new->mb){ new->prev = new->next; new->next = new->next->next; } if(new->next) new->next->prev = new; if(new->prev) new->prev->next = new; else root = new->next; })"
.LASF291:
	.string	"PAGE_SHIFT 12"
.LASF59:
	.string	"__UINT_FAST8_TYPE__ unsigned char"
.LASF98:
	.string	"__INT32_C(c) c"
.LASF165:
	.string	"__LDBL_HAS_QUIET_NAN__ 1"
.LASF39:
	.string	"__INT8_TYPE__ signed char"
.LASF464:
	.string	"vm_flags"
.LASF572:
	.string	"list_active"
.LASF535:
	.string	"__blh"
.LASF379:
	.string	"BYTES_PER_WORD 4"
.LASF493:
	.string	"filep"
.LASF389:
	.string	"__fstack (current->fstack)"
.LASF510:
	.string	"files"
.LASF45:
	.string	"__UINT32_TYPE__ unsigned int"
.LASF354:
	.string	"MSGTYPE_FS_ASK 2"
.LASF378:
	.string	"L1_CACHLINE_SIZE 32"
.LASF88:
	.string	"__INT64_MAX__ 9223372036854775807LL"
.LASF55:
	.string	"__INT_FAST8_TYPE__ signed char"
.LASF100:
	.string	"__INT64_C(c) c ## LL"
.LASF267:
	.string	"LL_CHECK(root,node) do{ void *backup = root; while(root){ if(root == node) break; root = root->next; } assert(root && \"can not find node in that list\"); root = backup; }while(0)"
.LASF262:
	.string	"LL_INFO(list,attr) do{ void*root=list; while(list){ printf(\"%d \",list->attr); list=list->next; } list=root; } while(0)"
.LASF97:
	.string	"__INT_LEAST32_MAX__ 2147483647"
.LASF16:
	.string	"__SIZEOF_LONG_LONG__ 8"
.LASF324:
	.string	"ZONE_NORMAL 1"
.LASF590:
	.string	"GNU C 4.9.2 -mtune=generic -march=i686 -g3 -std=c99 -fno-builtin -fno-stack-protector"
.LASF424:
	.string	"PG_highmem"
.LASF387:
	.string	"get_file(file) ( (file)->count++ )"
.LASF50:
	.string	"__INT_LEAST64_TYPE__ long long int"
.LASF445:
	.string	"end_data"
.LASF488:
	.string	"small_root"
.LASF364:
	.string	"size_buffer 16"
.LASF484:
	.string	"name"
.LASF449:
	.string	"start"
.LASF29:
	.string	"__SIZEOF_POINTER__ 4"
.LASF240:
	.string	"__1G 0x40000000"
.LASF252:
	.string	"LL2_POP(ll2) do{ assert( (ll2 && (ll2)->root && (ll2)->tail)); ll2->root = ll2->root->next; if(ll2->root) ll2->root->prev = 0; else ll2->tail = ll2->root; }while(0)"
.LASF466:
	.string	"open"
.LASF508:
	.string	"msg_type"
.LASF247:
	.string	"MAX(x,y) ((x)>(y)?(x):(y))"
.LASF307:
	.string	"__pa(vaddr) ((unsigned)(vaddr) - PAGE_OFFSET)"
.LASF574:
	.string	"mem_entity"
.LASF83:
	.string	"__SIG_ATOMIC_MAX__ 2147483647"
.LASF474:
	.string	"RLIMIT_NOFILE"
.LASF199:
	.string	"__GCC_ATOMIC_CHAR32_T_LOCK_FREE 2"
.LASF506:
	.string	"time_slice"
.LASF440:
	.string	"sizetype"
.LASF188:
	.string	"__USER_LABEL_PREFIX__ "
.LASF391:
	.string	"long unsigned int"
.LASF118:
	.string	"__UINTPTR_MAX__ 4294967295U"
.LASF496:
	.string	"pt_regs"
.LASF1:
	.string	"__STDC_VERSION__ 199901L"
.LASF224:
	.string	"__unix 1"
.LASF90:
	.string	"__UINT16_MAX__ 65535"
.LASF593:
	.string	"cli_ex"
.LASF365:
	.string	"NR_OPEN_DEFAULT 32"
.LASF7:
	.string	"__ATOMIC_RELAXED 0"
.LASF343:
	.string	"POINTER_SHIFT(pt,type,len) (type*)((u32)pt+len)"
.LASF2:
	.string	"__STDC_HOSTED__ 1"
.LASF576:
	.string	"zone_dma"
.LASF79:
	.string	"__INTMAX_MAX__ 9223372036854775807LL"
.LASF495:
	.string	"thread"
.LASF65:
	.string	"__has_include(STR) __has_include__(STR)"
.LASF112:
	.string	"__INT_FAST64_MAX__ 9223372036854775807LL"
.LASF206:
	.string	"__GCC_ATOMIC_POINTER_LOCK_FREE 2"
.LASF341:
	.string	"returnx_say(x,msg) do{oprintf(\"%s\",msg);return x;} while(0)"
.LASF125:
	.string	"__FLT_DIG__ 6"
.LASF217:
	.string	"__i686__ 1"
.LASF579:
	.string	"__zones"
.LASF585:
	.string	"dentry_cache"
.LASF128:
	.string	"__FLT_MAX_EXP__ 128"
.LASF11:
	.string	"__ATOMIC_ACQ_REL 4"
.LASF393:
	.string	"unsigned char"
.LASF167:
	.string	"__DEC32_MIN_EXP__ (-94)"
.LASF551:
	.string	"bitmap"
.LASF256:
	.string	"LL_I(root,new) do{ if(root){ new->prev = root; new->next = root->next; if(root->next) root->next->prev = new; root->next = new; } else{ root = new; new->prev = new->next = 0; } }while(0)"
.LASF333:
	.string	"BLOCK_DATA_END(block) ((int)((char*)block+sizeof(EMPTY_BLOCK)+block->size-1))"
.LASF592:
	.string	"/home/wws/lab/yanqi/src"
.LASF293:
	.string	"PAGE_MASK (~0xfff)"
.LASF536:
	.string	"esp0"
.LASF538:
	.string	"esp1"
.LASF540:
	.string	"esp2"
.LASF159:
	.string	"__LDBL_MAX__ 1.18973149535723176502e+4932L"
.LASF5:
	.string	"__GNUC_PATCHLEVEL__ 2"
.LASF223:
	.string	"__linux__ 1"
.LASF316:
	.string	"virt_to_page(vaddr) pfn_page( __pa(vaddr) >> PAGE_SHIFT)"
.LASF231:
	.string	"boolean _Bool"
.LASF116:
	.string	"__UINT_FAST64_MAX__ 18446744073709551615ULL"
.LASF30:
	.string	"__SIZE_TYPE__ unsigned int"
.LASF242:
	.ascii	"__SAVE() __asm__ __volatile__("
	.string	" \"pushl $0\\n\\t\" \"pushl %%fs\\n\\t\" \"pushl %%gs\\n\\t\" \"pushl %%es\\n\\t\" \"pushl %%ds\\n\\t\" \"pushl %%eax\\n\\t\" \"pushl %%ebp\\n\\t\" \"pushl %%edi\\n\\t\" \"pushl %%esi\\n\\t\" \"pushl %%edx\\n\\t\" \"pushl %%ecx\\n\\t\" \"pushl %%ebx\\n\\t\" \"movl %%esp, %0\\n\\t\" :\"=m\"(current->pregs) : )"
.LASF133:
	.string	"__FLT_EPSILON__ 1.19209289550781250000e-7F"
.LASF284:
	.string	"LINUX_MM_H "
.LASF142:
	.string	"__DBL_MAX_EXP__ 1024"
.LASF419:
	.string	"list_head"
.LASF335:
	.string	"CSIGNAL 0xff"
.LASF325:
	.string	"ZONE_HIGHMEM 2"
.LASF201:
	.string	"__GCC_ATOMIC_SHORT_LOCK_FREE 2"
.LASF347:
	.string	"MEMBER_OFFSET(stru_type,member_name) ( (unsigned)&(((stru_type *)0)->member_name) )"
.LASF457:
	.string	"maywrite"
.LASF490:
	.string	"clash"
.LASF127:
	.string	"__FLT_MIN_10_EXP__ (-37)"
.LASF566:
	.string	"kp_sleep"
.LASF150:
	.string	"__DBL_HAS_INFINITY__ 1"
.LASF487:
	.string	"hash"
.LASF305:
	.string	"pte2page_t(pte) ( mem_map + (pte).physical )"
.LASF105:
	.string	"__UINT_LEAST32_MAX__ 4294967295U"
.LASF57:
	.string	"__INT_FAST32_TYPE__ int"
.LASF160:
	.string	"__LDBL_MIN__ 3.36210314311209350626e-4932L"
.LASF332:
	.string	"HEAP_SIZE (64*0x100000)"
.LASF14:
	.string	"__SIZEOF_INT__ 4"
.LASF34:
	.string	"__INTMAX_TYPE__ long long int"
.LASF80:
	.string	"__INTMAX_C(c) c ## LL"
.LASF310:
	.string	"G_PGNUM (gmemsize>>12)"
.LASF300:
	.string	"PG_L10(pg_id) (pg_id&(0x400-1))"
.LASF259:
	.ascii	"LL_I_INCRE(list,new,attr) do{ assert(new); if(!list){ list=n"
	.ascii	"ew; new->prev=new->next=0; break; } void*root=list; while(li"
	.ascii	"st->next && new->attr > list->attr) list=list"
	.string	"->next; if(new->attr > list->attr){ new->next = 0; new->prev=list; list->next = new; list=root; } else{ new->next = list; new->prev = list->prev; if(list->prev) list->prev->next = new; list->prev=new; if(root==list) list=new; else list = root; } } while(0)"
.LASF509:
	.string	"msg_bind"
.LASF595:
	.string	"slab_head"
.LASF396:
	.string	"signed char"
.LASF436:
	.string	"free_pages"
.LASF317:
	.string	"MAX_ORDER 10"
.LASF143:
	.string	"__DBL_MAX_10_EXP__ 308"
.LASF545:
	.string	"__ssh"
.LASF569:
	.string	"list_sleep"
.LASF582:
	.string	"__hs_pcb"
.LASF394:
	.string	"short unsigned int"
.LASF371:
	.string	"DCACHE_H "
.LASF172:
	.string	"__DEC32_SUBNORMAL_MIN__ 0.000001E-95DF"
.LASF264:
	.string	"LL_SCAN_ON_KEY(root,key,value,result) do{ result = root; while(result){ if( (result)->key == (value) ){ break; } result = (result)->next; } }while(0)"
.LASF23:
	.string	"__BIGGEST_ALIGNMENT__ 16"
.LASF269:
	.string	"O_INSERT_AFTER(_prev,new) ({ new->next = _prev->next; new->prev = _prev; _prev->next->prev = new; _prev->next = new; })"
.LASF52:
	.string	"__UINT_LEAST16_TYPE__ short unsigned int"
.LASF137:
	.string	"__FLT_HAS_QUIET_NAN__ 1"
.LASF147:
	.string	"__DBL_EPSILON__ ((double)2.22044604925031308085e-16L)"
.LASF126:
	.string	"__FLT_MIN_EXP__ (-125)"
.LASF249:
	.string	"eat_dec(pt,x) if(*pt<'0'||*pt>'9') goto donothing; x=0; char*__pt=(pt); while(*(__pt+1)>='0'&&*(__pt+1)<='9') __pt++; int __len=__pt-(pt)+1; for(int __i=0;__i<__len;__i++){ x+=(*__pt-48)*pow_int(10,__i); __pt--; } (pt)+=__len;donothing:;"
.LASF434:
	.string	"free_area_t"
.LASF594:
	.string	"schedule_timeout"
.LASF214:
	.string	"__ATOMIC_HLE_ACQUIRE 65536"
.LASF219:
	.string	"__pentiumpro__ 1"
.LASF370:
	.string	"FS_H "
.LASF578:
	.string	"zone_highmem"
.LASF469:
	.string	"dentry"
.LASF191:
	.string	"__STRICT_ANSI__ 1"
.LASF382:
	.string	"FMODE_READ 1"
.LASF320:
	.string	"__GFP_DMA (1<<1)"
.LASF353:
	.string	"MSGTYPE_CHAR 1"
.LASF251:
	.string	"MYLIST_H "
.LASF526:
	.string	"inode_operations"
.LASF149:
	.string	"__DBL_HAS_DENORM__ 1"
.LASF437:
	.string	"free_area"
.LASF81:
	.string	"__UINTMAX_MAX__ 18446744073709551615ULL"
.LASF403:
	.string	"user"
.LASF519:
	.string	"dentry_operations"
.LASF32:
	.string	"__WCHAR_TYPE__ long int"
.LASF489:
	.string	"mountpoint"
.LASF546:
	.string	"__dsh"
.LASF330:
	.string	"PMM_H "
.LASF238:
	.string	"__1M 0x100000"
.LASF282:
	.string	"LINUX_STRING_H "
.LASF233:
	.string	"false 0"
.LASF432:
	.string	"frees"
.LASF108:
	.string	"__UINT64_C(c) c ## ULL"
.LASF176:
	.string	"__DEC64_MIN__ 1E-383DD"
.LASF454:
	.string	"executable"
.LASF70:
	.string	"__INT_MAX__ 2147483647"
.LASF38:
	.string	"__SIG_ATOMIC_TYPE__ int"
.LASF503:
	.string	"sigpending"
.LASF246:
	.string	"min(x,y) ((x)<(y)?(x):(y))"
.LASF195:
	.string	"__GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 1"
.LASF304:
	.string	"pte2page(pte) ((void *)__va((pte).value & PAGE_MASK))"
.LASF567:
	.string	"wake_up"
.LASF222:
	.string	"__linux 1"
.LASF163:
	.string	"__LDBL_HAS_DENORM__ 1"
.LASF285:
	.string	"LIST_H "
.LASF518:
	.string	"qstr"
.LASF130:
	.string	"__FLT_DECIMAL_DIG__ 9"
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
