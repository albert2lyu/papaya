# 这个makefile供src下的makefile调用。他能更新完dimg的依赖后再调用这儿的make。
# 所以，如果你在cmd下运行这个make,一定要保证它的依赖都已经解决。
user_program_cflags = -fno-builtin -std=c99 -g -fno-stack-protector
so_flags = -std=c99 -g -Wall -fPIC -fno-builtin  -fno-stack-protector
cc = gcc

target = cell _dimg cat init
target2 = ld.so t    printf.so string.so lib1.so lib2.so lib3.so lib4.so lib5.so lib6.so go
all:$(target)

init:init.c
	$(cc) -c -o init.o init.c -std=c99  -g  -fno-builtin -fno-stack-protector
	ld -o init init.o -einit



t:t.c
	$(cc) -o t t.c -std=c99 -Wall
	#$(cc) -o t t.c -std=c99 -Wl,-I/home/wws/lab/yanqi/cmd/ld.so -Wall

ld.so: ld.c lib1.so lib2.so
	$(cc) -c ld.c -o ld.o -std=c99 -g -Wall -fPIC -fno-builtin  -I../src/include -fno-stack-protector
	ld -shared -o ld.so ld.o lib1.so lib2.so -e__start 

go:go.c
	$(cc) -c go.c -o go.o -std=c99 -g -Wall -fPIC -fno-builtin  -I../src/include -fno-stack-protector
	ld -o go go.o  lib1.so lib2.so  printf.so -rpath=. -enomain --dynamic-linker=./ld.so

#如果图方便，直接用gcc生成最终的libx.so，是会依赖libc.so.6的．
#使得.rel.got和.rel.plt变脏
%.o:%.c
	$(cc) -c $< -o $@  $(so_flags)

lib1.so: lib1.o lib3.so lib4.so
	ld -shared -o $@ $^

lib2.so: lib2.o lib5.so lib6.so
	ld -shared -o $@ $^
	
lib3.so: lib3.o printf.so
	ld -shared -o $@ $^

lib4.so: lib4.o printf.so
	ld -shared -o $@ $^

lib5.so: lib5.o printf.so
	ld -shared -o $@ $^

lib6.so: lib6.o printf.so
	ld -shared -o $@ $^

printf.so: printf.o string.so
	ld -shared -o $@ $^

string.so: string.o
	ld -shared -o $@ $^

cat:cat.c
	$(cc) -c cat.c $(user_program_cflags)
	ld -static -e cat -o cat cat.o

_dimg:_dimg.c ../src/boot.asm
	$(cc) -c _dimg.c -o _dimg.o -std=c99 -Wno-implicit-function-declaration -g
	$(cc) -o  _dimg  _dimg.o ../lib/bootinfo.asmo

cell:cell.c
	$(cc) -o cell cell.c -std=c99 -Wno-format-extra-args -g

clean:
	rm $(target) -f
	rm $(target2) -f
	rm *.o -f
	rm *~ -f

400m.img.tar.bz2: 400m.img
	tar -cjf 400m.img.tar.bz2 400m.img		

# 直接clean。 然后把不需要上传的文件挪出"工程目录"
_git:
	make 400m.img.tar.bz2 
	make clean
	cp ~/.bashrc ./
	cp ~/.vimrc ./
	-mv *.img ~/Documents/tmpcmd_for_git/
	-mv bochsout.txt ~/Documents/tmpcmd_for_git/
	-mv tags ~/Documents/tmpcmd_for_git/
	-mv *.out ~/Documents/tmpsrc_for_git/

# 把git动作里挪走的文件搬回来
_tig:
	-mv ~/Documents/tmpcmd_for_git/* ../cmd/


#foobar:foobar.c
	#$(cc)   -o foobar foobar.c
	#ld -static -o foobar.so foobar.o -ebar

#doado: doado.c
#	$(cc) -c doado.c  $(user_program_cflags)
#	ld -static -e doado -o doado doado.o

#foobar.o:foobar.c
	#$(cc) -c foobar.c -o foobar.o  -Wall -fPIC 
