ROOT=/home/wws/lab/yanqi
export ROOT
all:
	make -C drivers/block/
	make -C drivers/ide/
	make -C fs/
	make -C fs/cell/
	make -f makefile2

clean:
	rm *.d -f
	rm *.o -f
	rm ../lib/* -f
	rm  drivers/block/*.o -f
	rm drives/ide/*.o -f
	rm fs/*.o -f
	rm fs/cell/*.o -f

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

