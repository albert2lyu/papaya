options=-std=c99 -g -Wall -Wno-char-subscripts -Wno-unused-function  -funsigned-char -I/usr/include/i386-linux-gnu/ -I/usr/include/　-g3 -gdwarf-2

lshopt=-I./lua -lm -ldl -lreadline 
luasrc=./lua/src

all:
	make -C ./lua linux
	gcc -c -o utils.o utils.c $(options)
	gcc -c -o vi.o vi.c $(options)
	gcc -c -o lsh.o lsh.c $(options) $(lshopt) 
	gcc -c -o han2pinyin.o han2pinyin.c $(options)
	gcc -c -o file.o file.c $(options)
	gcc -o lsh lsh.o vi.o utils.o file.o $(luasrc)/liblua.a $(options) $(lshopt) -Wl,-export-dynamic
	gcc -o han2pinyin han2pinyin.o vi.o utils.o file.o $(luasrc)/liblua.a $(options) $(lshopt) -Wl,-export-dynamic
	touch ../.lsh.history
	mv lsh /home/wws/lsh/


#注意lua目录是不被clena的
clean:
	make clean -C lfs
	rm *.o -f
	rm lsh -f
	rm han2pinyin -f
	rm *~ -f

_git:
	make clean
	-mv $(luasrc)/*.o ~/Documents/tmplua_for_git/
	-mv $(luasrc)/*.a ~/Documents/tmplua_for_git/
	-mv $(luasrc)/*.so ~/Documents/tmplua_for_git/

_tig:
	-mv ~/Documents/tmplua_for_git/* $(luasrc)
