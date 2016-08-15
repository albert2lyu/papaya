#1, 在源码树添加目录时，要在这里添加相应的编译行和clean行。clean行很重要，
#   因为总的不是通过递归的make -C clean完成的。
# 增加一个新的C文件时要做的：
# 1, 如果要顺便给它分配目录，就拷过去一个makefile。
# 2, 在那个makefile的target里添加xx.o。
# 3, 在这个makefile里添加make -C行和clean行。
# 4, 在makefile2里添加xxx.o用于链接。

ROOT=/home/wws/lab/yanqi
cheader_path=-I$(ROOT)/src/include/ -I$(ROOT)/include/ -I$(ROOT)/src/arch/x86/include/ 

cflags=$(cheader_path) -Wall -std=c99 -fno-builtin -g -fno-stack-protector -nostdinc

#-Wno-implicit-function-declaration 
export cflags
all:
	make -C drivers/block/
	make -C drivers/ide/
	make -C fs/
	make -C fs/cell/
	make -C mm/
	make -C drivers/pci/
	make -C drivers/net/
	make -C net/core
	make -C kernel
	make -C net/ipv4
	make -C lib/
	make -f makefile2

clean:
	rm ../bin/*.bin
	rm ../bin/*.elf
	rm *.d -f
	rm *.o -f
	rm ../lib/* -f
	rm  drivers/block/*.o -f
	rm drivers/ide/*.o -f
	rm drivers/pci/*.o -f
	rm drivers/net/*.o -f
	rm fs/*.o -f
	rm fs/cell/*.o -f
	rm mm/*.o -f
	rm arch/x86/mm/*.o -f
	rm ../cmd/*.o -f
	rm net/core/*.o -f
	rm net/ipv4/*.o -f
	rm kernel/*.o -f
	rm lib/*.o -f

git:
	cp ~/.bashrc ../cmd/
	cp ~/.vimrc ../cmd/
	cp ~/.gdbinit ../cmd/
	mv ../cmd/*.img ~/Documents/tmp_for_git/
	mv ../cmd/_dimg ~/Documents/tmp_for_git/
	mv ../cmd/init ~/Documents/tmp_for_git/
	mv ../cmd/cell ~/Documents/tmp_for_git/
	mv ../cmd/bochsout.txt ~/Documents/tmp_for_git/
	rm ../cmd/*.o
	rm ../cmd/*~

tig:
	mv ~/Documents/tmp_for_git/* ../cmd/

