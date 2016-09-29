# 这个makefile供src下的makefile调用。他能更新完dimg的依赖后再调用这儿的make。
# 所以，如果你在cmd下运行这个make,一定要保证它的依赖都已经解决。
user_program_cflags = -fno-builtin -std=c99 -g -fno-stack-protector
target = cell _dimg ld.so t   cat init
all:$(target)

init:init.c
	gcc -c -o init.o init.c -std=c99  -g  -fno-builtin -fno-stack-protector
	ld -o init init.o -einit



t:t.c
	gcc -o t t.c -std=c99 -Wl,-I/home/wws/lab/yanqi/cmd/ld.so -Wall

ld.so: ld.c
	gcc -c ld.c -o ld.o -fno-builtin -std=c99 -g -Wall -fPIC 
	ld -shared -o ld.so ld.o 
	#ld -shared  -o ld.so ld.o 

cat:cat.c
	gcc -c cat.c $(user_program_cflags)
	ld -static -e cat -o cat cat.o

_dimg:_dimg.c ../src/boot.asm
	gcc -c _dimg.c -o _dimg.o -std=c99 -Wno-implicit-function-declaration -g
	gcc -o  _dimg  _dimg.o ../lib/bootinfo.asmo

cell:cell.c
	gcc -o cell cell.c -std=c99 -Wno-format-extra-args -g

clean:
	rm $(target) -f
	rm *.o -f
	rm *~ -f

400m.img.tar.bz2: 400m.img
	tar -cjf 400m.img.tar.bz2 400m.img		

# 直接clean。 然后把不需要上传的文件挪出"工程目录"
_git:
	make tar
	make clean
	cp ~/.bashrc ./
	cp ~/.vimrc ./
	-mv *.img ~/Documents/tmpcmd_for_git/
	-mv bochsout.txt ~/Documents/tmpcmd_for_git/

# 把git动作里挪走的文件搬回来
_tig:
	-mv ~/Documents/tmpcmd_for_git/* ../cmd/


#foobar:foobar.c
	#gcc   -o foobar foobar.c
	#ld -static -o foobar.so foobar.o -ebar

#doado: doado.c
#	gcc -c doado.c  $(user_program_cflags)
#	ld -static -e doado -o doado doado.o

#foobar.o:foobar.c
	#gcc -c foobar.c -o foobar.o  -Wall -fPIC 
