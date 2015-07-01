cheader_path=-I../include/ -I./usr/include/
cflags=$(cheader_path) -Wall -std=c99 -fno-builtin -Wno-implicit-function-declaration -g


all:asmtask.o  utils.o unistd.o sys_call.o

%.o:%.asm
	nasm -felf -o ../lib/$@ $<

%.o:%.c
	gcc -c -o ../lib/$@ $< $(cflags) $(cheader_path)




























