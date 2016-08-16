# 这个makefile供src下的makefile调用。他能更新完dimg的依赖后再调用这儿的make。
# 所以，如果你在cmd下运行这个make,一定要保证它的依赖都已经解决。
all:cell _dimg

_dimg:_dimg.c ../src/boot.asm
	gcc -c _dimg.c -o _dimg.o -std=c99 -Wno-implicit-function-declaration -g
	gcc -o  _dimg  _dimg.o ../lib/bootinfo.asmo

cell:cell.c
	gcc -o cell cell.c -std=c99 -Wno-format-extra-args -g

clean:
	rm cell -f
	rm _dimg -f
	rm *.o -f
	rm *~ -f

# 直接clean。 然后把不需要上传的文件挪出"工程目录"
_git:
	make clean
	cp ~/.bashrc ./
	cp ~/.vimrc ./
	cp ~/.gdbinit ./
	-mv *.img ~/Documents/tmpcmd_for_git/
	-mv bochsout.txt ~/Documents/tmpcmd_for_git/

# 把git动作里挪走的文件搬回来
_tig:
	-mv ~/Documents/tmpcmd_for_git/* ../cmd/
