all: clean bh.o bh.o
#'make' will search target-file and rely-file according through VPATH,if she
#failed under current directory.
VPATH=../lib/ ../bin/
#header_path will be used when 'gcc -M'.you can not use '$(cflags)' instead of
#'$(head_path)' under this case,because other unrelated cflags may affect the 
#operation of 'gcc -M',according to test.
cheader_path=-I$(ROOT)/include/ -I$(ROOT)/src/include/ -I$(ROOT)/src/arch/x86/include/
cflags=$(cheader_path) -Wall -std=c99 -fno-builtin -Wno-implicit-function-declaration -g -fno-stack-protector

%.o:%.c
	@gcc -c -o $@ $< $(cflags)

clean:
	@rm  -f *.o;

.PHONY:all
