#在源码树里新建一个目录时，需要在这里添加相应的编译行和clean行。clean行很重要，因为总的
#不是通过递归的make -C clean完成的。
ROOT=/home/wws/lab/yanqi
export ROOT
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
	make -f makefile2

clean:
	rm *.d -f
	rm *.o -f
	rm ../lib/* -f
	rm  drivers/block/*.o -f
	rm drives/ide/*.o -f
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

git:
	mv ../cmd/400m.img ~/Documents/tmp_for_git/
	mv ../cmd/cell.img ~/Documents/tmp_for_git/
	mv ../cmd/dimg ~/Documents/tmp_for_git/
	mv ../cmd/init ~/Documents/tmp_for_git/
	mv ../cmd/cell ~/Documents/tmp_for_git/
	mv ../cmd/bochsout.txt ~/Documents/tmp_for_git/
	rm ../cmd/*.o
	rm ../cmd/*~

tig:
	mv ~/Documents/tmp_for_git/* ../cmd/

