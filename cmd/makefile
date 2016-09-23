# 这个makefile供src下的makefile调用。他能更新完dimg的依赖后再调用这儿的make。
# 所以，如果你在cmd下运行这个make,一定要保证它的依赖都已经解决。
all:cell _dimg doado ld.so t  foobar.o foobar.so foobar

foobar.o:foobar.c
	gcc -c foobar.c -o foobar.o  -Wall -fPIC 

foobar:foobar.c
	#gcc   -o foobar foobar.c
	#ld -static -o foobar.so foobar.o -ebar

t:t.c
	gcc -o t t.c -std=c99 -Wl,-I/home/wws/lab/yanqi/cmd/ld.so -Wall

ld.so: ld.c
	gcc -c ld.c -o ld.o -fno-builtin -std=c99 -g -Wall -fPIC 
	ld -shared -o ld.so ld.o 
	#ld -shared  -o ld.so ld.o 

doado: doado.c
	gcc -c doado.c -fno-builtin -std=c99 -g
	ld -static -e doado -o doado doado.o

_dimg:_dimg.c ../src/boot.asm
	gcc -c _dimg.c -o _dimg.o -std=c99 -Wno-implicit-function-declaration -g
	gcc -o  _dimg  _dimg.o ../lib/bootinfo.asmo

cell:cell.c
	gcc -o cell cell.c -std=c99 -Wno-format-extra-args -g

clean:
	rm cell -f
	rm _dimg -f
	rm doado -f
	rm t ld.so -f
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


