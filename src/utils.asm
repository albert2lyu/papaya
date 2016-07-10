;these functions are declared and commented(some basic explanation) in utils.h
%include "utils.inc"
global in_byte,out_byte,port_read,port_write,detect_cpu,in_dw,out_dw,update_eflags,ap_init,ap_init_end, read_imr_of8259
global __bt, __bts, __btr, __bsc, __bs0s
extern cpu_string
global init8259A
global init8253
[section .text]
detect_cpu:;void detect_cpu(void);
	mov eax,0
	cpuid
	mov [cpu_string],ebx
	mov [cpu_string+4],edx
	mov [cpu_string+8],ecx
	ret

	
port_read:;void port_read(unsigned port,void*buf,unsigned byte);
	mov edx,[esp+4]
	mov edi,[esp+8]
	mov ecx,[esp+12]
	shr ecx,1
	cld
	rep insw	
	ret
port_write:;void port_write(unsigned port,void*buf,unsigned byte);
	mov edx,[esp+4]
	mov esi,[esp+8]
	mov ecx,[esp+12]
	shr ecx,1
	cld
	rep outsw
	ret

in_byte: ;char in_byte(int port)
	xor eax,eax
	mov dx,[esp+4]
	in al,dx
	iodelay
	ret
in_dw: ;u32 in_dw(int port)
	mov dx,[esp+4]
	in eax,dx
	ret
out_byte:;void out_byte(int port,unsigned value)
	mov dx,[esp+4]
	mov al,[esp+8]
	out dx,al
	ret
out_dw: ;void out_dw(int port,u32 value)
	mov dx,[esp+4]
	mov eax,[esp+8]
	out dx,eax
	ret
;void init8259A(int mask);
init8259A:
	mov al,11h
	out 20h,al		;send icw1 to 0x20		arg meaning:[icw4 needed]
	iodelay;io_delay belong to the same segment,so just call label(namely jmp near ptr label) is ok.
	out 0a0h,al		;send icw1 to 0xa0
	iodelay

	mov al,20h
	out 21h,al		;send icw2 to 0x21.		arg meaning:[irq0=0x20]
	iodelay
	mov al,28h
	out 0a1h,al		;send icw2 to 0xa1.		arg meaning:[irq8=0x28]
	iodelay

	mov al,4
	out 21h,al		;send icw3 to 0x21		arg meaning:[link slave chip at ir2]
	iodelay
	mov al,2
	out 0a1h,al 	;send icw3 to 0xa1		arg meaning:[link master chip from ir2]
	iodelay

	mov al,1
	out 21h,al		;arg meaning[80X86 mod,normal EOI]
	iodelay
	out 0a1h,al
	iodelay
	;initial word port finished..

	;send ocw1,set interrupt mash register
	mov al,[esp+4];ERR by default,all irq-port was masked
	out 21h,al
	iodelay
	mov al,11110011b;		arg meaing:[AT hard-disk irq open]  
	out 0a1h,al
	iodelay
	ret
read_imr_of8259:		;unsigned read_imr_of8259(void);
	xor eax,eax
	in al, 0a1h 
	mov ah, al 
	in al, 21h 
	ret

init8253:
	mov al,0x34
	out 0x43,al

	mov ax,[esp+4]
	out 0x40,al
	mov al,ah
	out 0x40,al
	ret


;;;;;;;;;;;;;;;;;;;;;	int __bt(void *base, int m);
__bt:	
	mov edx, [esp + 4]	 ;eax = base 
	mov ecx, [esp + 8]	 ;ebx = m
	xor eax, eax
	bt [edx], ecx
	adc eax, 0
	ret

;;;;;;;;;;;;;;;;;;;;	int __bts(void *base, int m);
__bts:	
	mov edx, [esp + 4]	 ;eax = base 
	mov ecx, [esp + 8]	 ;ebx = m
	xor eax, eax
	bts [edx], ecx
	adc eax, 0
	ret

;;;;;;;;;;;;;;;;;;;;	int __btr(void *base, int m);	@DESC bit test and reset
__btr:	
	mov edx, [esp + 4]	 ;eax = base 
	mov ecx, [esp + 8]	 ;ebx = m
	xor eax, eax
	btr [edx], ecx
	adc eax, 0
	ret

;;;;;;;;;;;;;;;;;;	int __bsc(char *addr);	 @DESC bit scan and reset
__bsr:
	mov edx, [esp + 4]		;edx = addr
	mov eax, [edx]			;eax = *addr, namely bit index
	bsf eax, eax
	jz .zero
	btr [edx], eax
	ret
	.zero:
	mov eax, -1
	ret
__bs0s:
	mov edx, [esp + 4]		;edx = addr
	mov eax, [edx]			;eax = *addr, namely bit index
	not eax			;eax = ~eax
	bsf eax, eax
	jz .zero
	bts [edx], eax
	ret
	.zero:
	mov eax, -1
	ret






