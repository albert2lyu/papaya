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
	make -f makefile2

clean:
	rm *.d -f
	rm *.o -f
	rm .*.swp -f
	rm ../lib/* -f
	rm  drivers/block/*.o -f
	rm  drivers/block/.*.swp -f
	rm drives/ide/*.o -f
	rm drives/ide/.*.swp -f
	rm fs/*.o -f
	rm fs/.*.swp -f
	rm fs/cell/*.o -f
	rm fs/cell/.*.swp -f
	rm mm/*.o -f
	rm mm/.*.swp -f
	rm ../cmd/.*.swp -f

git:
	mv book* ~/Documents/tmp_for_git/
	mv ../cmd/400m.img ~/Documents/tmp_for_git/
	mv ../cmd/cell.img ~/Documents/tmp_for_git/
	mv ../cmd/dimg ~/Documents/tmp_for_git/
	mv ../cmd/init ~/Documents/tmp_for_git/
	mv ../cmd/cell ~/Documents/tmp_for_git/
	mv ../cmd/bochsout.txt ~/Documents/tmp_for_git/
	rm ../cmd/*.o

tig:
	mv ~/Documents/tmp_for_git/book* ./
	mv ~/Documents/tmp_for_git/* ../cmd/

