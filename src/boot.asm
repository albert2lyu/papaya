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

[bits 16]
mbrHead:
	read_floppy_side_o_sector_total_destsa_destea 0x80,0,0,2,(_bootbin_occupy_sectors-1),0,0x7e00	;'-1' because bios has alreay load the first sector
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

dap_s_count equ 2
dap_seg equ 6
dap_lba equ 8
dap:
	db  16		; packetsize ==16
	db  0		; reserved ==0
	dw  DAP_SECTOR_LIMIT	; sector count,some bios limit it within 256
	dw  0		; offset
	dw  _base_kernel_loaded>>4	; seg
	dd  _kernel_image_start_sector - 1		; start-sector,'-1' due to  dap-format
	dd  0

dap2:
	db  16		; packetsize ==16
	db  0		; reserved ==0
	dw  DAP_SECTOR_LIMIT	
	dw  0		; offset
	dw  RAMDISK_BASE>>4	; seg
	dd  0		; start sector lba
	dd  0

entrance:
	;load disk 1
    mov ax, 0
    mov ds, ax

    mov ah, 42h
    mov dl, 80h
    mov si, dap
    int 13h
    jc read_error

	;load disk 2
	;诡异的bug又消失了。同一个dap又可以多次int，没有限制了。有时间repeate it.
    mov ah, 42h
    mov dl, 81h
    mov si, dap2
    int 13h
    jnc read_ok

read_error:
	mov bx, 0xb800
	mov ds,bx
	add ah, 48
	mov byte [0], ah
    jmp $

read_ok:
	;now get machine physical memory infomation
	get_memory_information:
	mov ebx,0
	mov di,_base_meminfo
.loop:
	mov eax,0E820h
	mov ecx,20
	mov edx,0534D4150h
	int 15h
	je .fail
	add di,20
	inc dword [_memseg_num]
	cmp ebx,0
	jne .loop
	jmp .done
.fail:
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
jmp dword selector_plain_c0:reset_kernel	;'jmp'-operation necessary?

[bits 32]
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
mov eax,0x101000|PG_P|PG_USU|PG_RWW
.filldir:
	stosd
	add eax,0x1000
	loop .filldir
mov ecx,0x400*224
mov eax,0|PG_P|PG_USU|PG_RWW
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

[bits 16]
ap_init:		;sector 5 => 0x8000
get_lock:
		mov ax,0
		mov es,ax
		lock bts dword [es:lock_area],0
		jc get_lock

		mov ax,0xb800
		mov ds,ax
		btr dword [es:lock_area],0
	.1:
		inc byte [0]
		hlt
		jmp .1
	ap_init_end:
	lock_area:dd 0



