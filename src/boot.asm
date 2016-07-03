;1 single segment should be smaller than 64KB
;old 2 the LOAD-TYPE segment of kernel.elf should be smaller than (0x80000-0x30400=)300KB...for kernel-cache-room starts at 0x80000 and kernel-entry locates at 0x30400
;old 3 kernel-cache-room should be never merged...because debug-module will use .stab&.strstab section
;4 extend 13h can only load 120*2 sectors for temprory(i don't know why),so kernel-size is limited within 120KB		--确实，大概是128KB的样子，而且是１个dap128K,想读更多扇区，只好再用一个dap.
%include "bootinfo.asm"
%include "../include/pm.inc"
%include "../include/utils.inc"
DAP_SECTOR_COUNT equ  64
DAP_SECTOR_LIMIT equ 254 ;知道了，这应该是IDE端口的限制，一次最多255个扇区
DAP_MEM_COUNT equ (DAP_SECTOR_COUNT * 512)
org 0x7c00
addr_mbr_loaded equ (_base_kernel_loaded - 512 * (_bootbin_occupy_sectors + _fiximg_occupy_sectors))
[bits 16]
;用int 13h，要担心硬盘的磁头号大于1吗？
mbrHead:
	mov ax, 0xb800
	mov gs, ax
	read_floppy_side_o_sector_total_destsa_destea 0x80,0,0,2,(_bootbin_occupy_sectors + _fiximg_occupy_sectors - 1),0,0x7e00	;'-1' because bios has alreay loaded the first sector
	read_floppy_side_o_sector_total_destsa_destea 0x80, 0,0,1,63,(addr_mbr_loaded) >> 4, 0
	read_floppy_side_o_sector_total_destsa_destea 0x80, 1,0,1,63,(addr_mbr_loaded + 512 * 63) >> 4, 0
	read_floppy_side_o_sector_total_destsa_destea 0x80, 2,0,1,63,(addr_mbr_loaded + 512 * 63 * 2) >> 4, 0
	read_floppy_side_o_sector_total_destsa_destea 0x80, 3,0,1,63,(addr_mbr_loaded + 512 * 63 * 3) >> 4, 0
    jmp entrance

;[section .gdt]
; GDT
gdt:            Descriptor 0,   0,          0                         ; null descriptor
.desc_plain_c0: Descriptor 0,   0fffffh,    DA_32 + DA_C + DA_LIMIT_4K
.desc_plain_d0: Descriptor 0,   0fffffh,    DA_DRW | DA_LIMIT_4K + DA_32
; end of GDT

; the selector correspond to the two defined descriptor before
len_gdt             equ     $ - gdt                     ; gdt length
selector_plain_c0   equ     gdt.desc_plain_c0 - gdt 
selector_plain_d0   equ     gdt.desc_plain_d0 - gdt

gdtPtr:
	dw len_gdt - 1  ; gdt limits
	dd gdt          ; this indicates that gdt must locate at mbr


entrance:
	;load disk 1
    jmp read_ok

read_error:
	mov bx, 0xb800
	mov ds,bx
	mov al, '?'
	mov ah, '?'
	mov byte [0], al
	mov byte [2], ah
    jmp $

read_ok:
	mov ax, _base_kernel_loaded>>4
	mov es, ax
	mov di, 0
	mov cx, 255
	mov bx, 0xb800
	mov ds, bx
	mov bx, 0
show_elf:
	mov al, [es:di]
	mov byte [bx], al
	add bx, 2
	inc di
	loop show_elf

	;now get machine physical memory infomation
	xor ax, ax
	mov ds, ax
	mov es, ax
	get_memory_information:
	mov ebx,0
	mov di,_base_meminfo
.loop:
	mov eax,0E820h
	mov ecx,20
	mov edx,0534D4150h
	int 15h
	jc .fail
	add di,20
	inc dword [_memseg_num]
	cmp ebx,0
	jne .loop
	jmp .done
.fail:
mov al, 'X'
mov byte [gs:0], al
mov byte [gs:2], al
jmp $
.done:
	jmp mbr_extend
times 512-($-$$) db 0

mbr_extend:		;sector 2,3,4 => 0x7d00,0x7e00,0x7f00
; load gdt
mov ax,0
mov ds,ax
lgdt [gdtPtr]
;switch ds point to [.data] in kernel.asm

; close the interrupt, and open A20 to get the addressing ability beyond 1M.
cli
openA20:
	in   al,  92h
	or   al,  00000010b
	out 92h,  al

; switch to protection mode
switch_proMode:
	mov eax,    cr0
	or  eax,    1   ; set CR0's PE bit
	mov cr0,    eax	

mov ax, selector_plain_d0
mov ds,ax
mov es,ax
mov ss,ax
jmp dword selector_plain_c0:fix_kernel	;'jmp'-operation necessary?

[bits 32]
fix_kernel:
	mov edi, _base_kernel_loaded
	mov esi, (_fiximg_start_sector - 1) * 512 + 0x7c00
	xor eax, eax
	mov ecx, 0	; !boolean, indicates the last sector to fix
	.check_one:
		cmp byte [edi], al		;check magic number
		je fix_kernel.fix_it
		;magic number check failed, we still have a chance
		cmp byte [edi], 0xcc
		jne fix_kernel.bad
		;not the end, let us see how many sectors we fixed
		mov ecx, 1		;有些早，但没事，因为如果count核对失败，就死循环了。
		inc al		;assume have fixed this sector
		cmp byte [esi + 1], al
		je fix_kernel.fix_it
		.bad: jmp $
	.fix_it: 
		mov ah, [esi]
		mov [edi], ah
		inc esi 
		inc al
		add edi, 512
	jcxz fix_kernel.check_one	
	.done:

reset_kernel:
;clear RAM for .bss
mov edi,base_kernel_reset
mov eax,0
mov ecx,256*1024/4
cld
rep stosd
; load kernel from 0x8000h
mov ebx, _base_kernel_loaded
mov edx,0
mov dx, [ebx+42] ; e_phentsz
mov ecx,0
mov cx, [ebx+44] ; e_phnum
mov ebx, [ebx+28] 
search_ph_typeLoaded:
	cmp dword [_base_kernel_loaded + ebx], 1
	jne doNothing	
cySegment:
	push ecx
	mov  ecx,    [_base_kernel_loaded + ebx + 16]
	mov  esi,    [_base_kernel_loaded + ebx + 4]
	add esi, _base_kernel_loaded
	mov  edi,    [_base_kernel_loaded + ebx + 8]
	and edi,0x0fffffff	;mask '0xc003XXXX' to '0x0003XXXX'
	cld
	rep movsb
	pop ecx			
	
doNothing:
	add ebx,edx
loop search_ph_typeLoaded
kernel_pg_map:
cld
mov edi,_gpgdir_base+0xc00
mov ecx,224
mov eax,0x101000|PG_P|PG_USS|PG_RWW
.filldir:
	stosd
	add eax,0x1000
	loop .filldir
mov ecx,0x400*224
mov eax,0|PG_P|PG_USS|PG_RWW
mov edi,0x101000
.filltbl:
	stosd
	add eax,0x1000
	loop .filltbl
;map 0x7000~0x8fff now
tmp_tbl_addr equ 0x200000-0x1000
mov dword [_gpgdir_base],tmp_tbl_addr|PG_P|PG_USS|PG_RWW
mov dword [tmp_tbl_addr+7*4],0x7000|PG_P|PG_USS|PG_RWW
mov dword [tmp_tbl_addr+8*4],0x8000|PG_P|PG_USS|PG_RWW

mov eax,_gpgdir_base
mov cr3,eax		;page-map active now
mov eax,cr0
or eax,0x80000000
mov cr0,eax
jmp dword selector_plain_c0:_base_entrance_kernel
times 512-($-mbr_extend) db 0




;	--int 13h (leaf 8, test parameter)
;	mov ah, 8
;	mov dl, 0x80 
;	mov di, 0
;	mov es, di 
;	int 0x13
;
;	mov bx, 0xb800 
;	mov ds, bx
;	mov bx, 0
;
;	mov byte [bx],  'C'
;
;	mov ax, cx
;	add bx, 2
;	mov byte [bx], ah
;	shr al, 6
;	add bx, 2
;	mov byte [bx], al
;	add bx, 2
;	mov byte [bx],  'h'
;	add bx , 2
;	add dh, '0'
;	mov byte [bx], dh
;	add bx, 2
;	mov byte [bx], 'd'
;	add bx, 2
;	add dl, '0'
;	mov byte [bx], dl
;	add bx, 2
;	mov byte [bx], 's'
;	mov ax, cx
;	and al, 00111111b
;	add bx, 2
;	mov byte [bx], al
;	jmp $



;-----
;mov ebx, 0xb8000
;mov ax, cx 
;add al, '0'
;add ah, '0'
;mov byte [ebx], al
;mov byte [ebx + 2], ah
;jmp $
;-----
