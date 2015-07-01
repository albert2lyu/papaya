;these functions are declared and commented(some basic explanation) in utils.h
%include "utils.inc"
global in_byte,out_byte,port_read,send_hd_eoi,port_write,detect_cpu,in_dw,out_dw,update_eflags,bitset,bitclear,bitsset,bitsclear,bitscan0, bitscan32,ap_init,ap_init_end
extern cpu_string,oldeflags
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

bitscan32:		;int bitscan32(u32 addr ,int num_111);
	mov eax,[esp+4]
	bsf ecx,[eax]
	mov ebx,ecx	;backup promise return value
	jz .fail
.suspect:
	mov edx,[eax]
	shr edx,cl
	mov ecx,[esp+8]
	mov eax,0xffffffff
	shl eax,cl
	or edx,eax
	cmp edx,0xffffffff
	jz .success
.fail:
	mov eax,-1
	ret
.success:
	mov eax,ebx
	ret

;this function has bugs now.	bug appears in such case:
;char a[10000]; a[2048] = 7; int x=bitscan1111(a,3,513);  => return a bad value -1(should be 16384)
bitscan111:		;int bitscan111(u32 addr, int num_111, int scope);   buggy
	push ebp
	mov ebp,esp
	add ebp,8
	push esi	;backup ecx
	push ebx
	
	mov edx,[ebp]
	mov ecx,[ebp+8]
	;if(num_111 ==0 || scope == 0) just return
	cmp dword [ebp+4],0
	je .fail
	cmp dword [ebp+8],0
	je .fail
.next_cell:
	mov eax,[edx]
	mov esi,ecx
	bsf ecx,eax
	jz .continue
.suspect_cell:
	shr eax,cl
	mov ebx,0xffffffff
	mov ecx,[ebp+4]
	shl ebx,cl
	or eax,ebx
	cmp eax,0xffffffff
	je .success
.continue:
	inc edx
	mov ecx,esi
	loop .next_cell
.fail:
	mov eax,-1
	jmp .return
.success:
	bsf eax,[edx]
	sub edx,[ebp]
	shl edx,3
	add eax,edx
.return:
	pop ebx
	pop esi
	pop ebp
	ret

bitset:;void bitset(char*addr,int bit_off);
	mov ebx,[esp+4]
	mov eax,[esp+8]
	bts [ebx],eax
	ret 

bitclear:;void bitclear(char*addr,int bit_off);
	mov ebx,[esp+4]
	mov eax,[esp+8]
	btr [ebx],eax
	ret 

bitsset:;void bitsset(u32 addr, int bit_off, int num);
	;if(num == 0) just return
	cmp dword [esp+12],0
	je .return
	mov ecx,[esp+12]
	mov eax,[esp+8]
	mov ebx,[esp+4]
.loop:
	bts [ebx],eax
	inc eax
	loop .loop
.return:
	ret

bitsclear:;void bitsclear(u32 addr, int bit_off, int num);
	;if(num == 0) just return
	cmp  dword [esp+12],0
	je .return
	mov ecx,[esp+12]
	mov eax,[esp+8]
	mov ebx,[esp+4]
.loop:
	btr [ebx],eax
	inc eax
	loop .loop
.return:
	ret

;the following two functions are not exported at present, more interfaces,more disorders.
bitscan:;int bitscan(char*addr,int bits_scope);
	jmp .entrance
	.return:
	add eax,edx
	ret
	.entrance:
	mov ecx,[esp+8];ERR bits_scope must %8=0
	shr ecx,5;ecx/=32,convert bit-scope to byte scope
	mov edx,0
	mov ebx,[esp+4]
	.1:
	bsf eax,[ebx]
	jnz .return
	add ebx,4
	add edx,32
	loop .1
	;can not scan out a 1-bit
	mov edx,0
	mov eax,-1;is a special digit meaning can not find value-1-bit.
	jmp .return

bitscan0:;int bitscan0(char*addr,int bits_scope);
	jmp .entrance
	.return:
	add eax,edx
	ret
	.entrance:
	mov ecx,[esp+8];ERR bits_scope must %8=0
	shr ecx,5;ecx/=32,convert bit-scope to byte scope
	mov edx,0
	mov esi,[esp+4]
	.1:
	mov ebx,[esi]
	xor ebx,0xffffffff	
;	xor ebx,0
	bsf eax,ebx
	jnz .return
	add esi,4
	add edx,32
	loop .1
	;can not scan out a 1-bit
	mov edx,0
	mov eax,-1;is a special digit meaning can not find value-1-bit.
	jmp .return
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
send_hd_eoi:
	mov al,20h
	out 20h,al
	out 0xa0,al
	iodelay
	ret

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
	mov al,10111111b;		arg meaing:[AT hard-disk irq open]  
	out 0a1h,al
	iodelay
	ret

init8253:
	mov al,0x34
	out 0x43,al

	mov ax,[esp+4]
	out 0x40,al
	mov al,ah
	out 0x40,al
	ret

update_eflags:
	pushfd
	cli
	pop dword [oldeflags]
	ret







