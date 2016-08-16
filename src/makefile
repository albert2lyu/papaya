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
	make -C ../cmd/

#整个项目总的clean
#但是不清除lsh目录，它跟papaya内核保持一定的独立性。make时也没有它
clean:
	make clean_others
	make clean_src
	make clean -C ../cmd/

clean_others:
	rm ../bin/*.bin -f
	rm ../bin/*.elf -f
	rm lib/*.o -f
	

#只clean src目录
clean_src:
	rm *.d -f
	rm *.o -f
	rm  drivers/block/*.o -f
	rm drivers/ide/*.o -f
	rm drivers/pci/*.o -f
	rm drivers/net/*.o -f
	rm fs/*.o -f
	rm fs/cell/*.o -f
	rm mm/*.o -f
	rm arch/x86/mm/*.o -f
	rm net/core/*.o -f
	rm net/ipv4/*.o -f
	rm kernel/*.o -f
	rm *~ -f

#暂时只搬一个tmp文件
_git:
	make clean_src
	-mv tmp ~/Documents/tmpsrc_for_git/

_tig:
	-mv ~/Documents/tmpsrc_for_git/* ./


#每个目录的make _git都会做make clean，所以这儿不宜再调用总的make clean。
#所以用clean_others清除剩余的就行了。
git:
	make clean_others
	make _git
	make _git -C ../cmd/
	make _git -C ../lsh/

tig:
	make _tig 
	make _tig -C ../cmd/
	make _tig -C ../lsh/


