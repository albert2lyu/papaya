%ifndef UTILS_INC
%define UTILS_INC
tss_esp0_offset equ 4

%macro gequ 2	;eg: gequ lable 0x100 =>(label equ 0x100) (global label)
global %1
%1 equ %2
%endmacro

%macro lequ 2	;local equ
%1 equ %2
%endmacro

; use nop for some delay
%macro iodelay 0
nop
nop
nop
nop
%endmacro

%macro delay 1
mov ecx,%1
.l:
	inc ecx
	dec ecx
loop .l
%endmacro 

%macro recover 0
	pop ebx
	pop ecx
	pop edx
	pop esi
	pop edi
	pop ebp
	pop eax
	pop ds
	pop es
	pop gs
	pop fs
%endmacro
%macro RESTORE_ALL 0
	pop ebx
	pop ecx
	pop edx
	pop esi
	pop edi
	pop ebp
	pop eax
	pop ds
	pop es
	pop gs
	pop fs
	
	add esp, 4
	iretd
%endmacro
;**最后push的5个,对应linux上的寄存器参数约定,不能打乱顺序
%macro SAVE_ALL 0
	push fs
	push gs
	push es
	push ds
	push eax
	push ebp
	push edi
	push esi
	push edx
	push ecx
	push ebx
%endmacro

%macro SAVE_ALL_EXCEPT_FS 0
	push gs
	push es
	push ds
	push eax
	push ebp
	push edi
	push esi
	push edx
	push ecx
	push ebx
%endmacro

%define save SAVE_ALL

%macro SET_PREG 0
	mov esi, esp
	and esi, 0xffffe000
	mov [esi],esp
%endmacro

%macro GET_CURRENT 1
	mov %1, esp
	and %1, 0xffffe000
%endmacro

; define TSS1
%macro TSS1 6
;link ss0 esp0 ss1 esp1 ss2 esp2
%%tss_start:
	dd 0
	dd %2
	dd %1
	dd %4
	dd %3
	dd %6
	dd %5
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0
;	dw 0
;	dw $ - %%tss_start
;	db 0ffh
%endmacro

;only  digit or common reg can be used as the 6th and 7th arg
;this set of macros also read harddisk by specifying 'floppy' from 0x80
%macro write_floppy_side_o_sector_total_destsa_destea 7
	push ax
	push bx
	push cx
	push dx
	push es
	
	mov ah,3
	mov dl,%1
	mov dh,%2
	mov ch,%3
	mov cl,%4
	mov al,%5
	mov bx,%6
	mov es,bx
	mov bx,%7
	int 13h

	pop es
	pop dx
	pop cx
	pop bx
	pop ax
%endmacro
%macro read_floppy_side_o_sector_total_destsa_destea 7
	push ax
	push bx
	push cx
	push dx
	push es
	
	mov ah,2
	mov dl,%1
	mov dh,%2
	mov ch,%3
	mov cl,%4
	mov al,%5
	mov bx,%6
	mov es,bx
	mov bx,%7
	int 13h

	pop es
	pop dx
	pop cx
	pop bx
	pop ax
%endmacro

%macro OPRINTF 1
	push %1
	call oprintf
	add esp,4
%endmacro
%endif
