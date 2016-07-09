; 1, 这个文件定义了启动时的关键参数：例如从哪个扇区加载fix.img，从哪个扇区开始
;    加载kernel.elf。
; 2, 这些参数是以汇编equ label的形式存在的，它们到了C语言里就是变量。
;    bootinfo.asm同时参与boot.bin和kernel.elf的生成。 他使得C语言能访问初始
;    化阶段的一些信息。

; [Name Convention]
; nasm下equ形式的label, 像比abc equ 0x7c00， 最终跟C语言链接时，abc相当于c语言
; 里普通的变量标签。 在C语言里，我们声明 extern int abc; printf("%d", abc); 
; 打印出来的就是0x7c00处的一个dword。 
; 所以我们约定， 从汇编往C里传变量时，如果想传递的就是一个变量，那无所谓。
; 但如果想传递的是这个标签本身的value，就要命名成_xxx的形式。前下划线。到了 
; C里我们这样用它, #define xxx (unsigned)&(_xxx)
; See also bootinfo.h

%include "../include/utils.inc"
;                         0x6104    <=====         0x6004  <===    0x6000
;+----------------------------------------------------------------+
;                          |           256 bytes         | 4bytes |
;                          |_____________________________|________|
;                          |                             |        |
;|                         |        mem_seginfo          | segnum |
;                          |                             |        |
;+----------------------------------------------------------------+
;nasm的结构体并不实用，这儿只是用它增加可读性。
struc realmod_info_stru
	.mem_segnum: 		resb 4
	.mem_seginfo_arr: 		resb 256
endstruc

gequ realmod_info, 0x6000
mem_segnum  equ realmod_info + realmod_info_stru.mem_segnum
mem_seginfo_arr equ  realmod_info + realmod_info_stru.mem_seginfo_arr

;扇区是从1开始计数的，到了dimg.c里要减1，因为dd是从0开始计数的。
;这个示意图要随着下面数据的变动及时同步。
;+------------------------------------------------------------------------+
;      _______________________________________________________________________
;sector|  1   |  2   |  3   |   4  |   5  |  6   |   7  |      |      |      |
;      |______boot.bin______|_fix__|_____kernel.elf__________________________| 
;+------------------------------------------------------------------------+

gequ _bootbin_start_sector, 1
gequ _bootbin_occupy_sectors,3
gequ _fiximg_start_sector, _bootbin_start_sector + _bootbin_occupy_sectors
gequ _fiximg_occupy_sectors, 1
gequ _kernel_image_start_sector, (_fiximg_start_sector + _fiximg_occupy_sectors)

gequ _gpgdir_base,0x100000

lequ _base_kernel_loaded,0x80000
base_kernel_reset equ 0x30400
lequ _base_entrance_kernel,base_kernel_reset+0xc0000000

gequ RAMDISK_BASE, 0x10000
