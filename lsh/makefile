options=-std=c99 -g -Wall -Wno-char-subscripts -Wno-unused-function  -funsigned-char
lshopt=-I./lua  -lm -ldl -lreadline 

CORE_O=	./lua/lapi.o ./lua/lcode.o ./lua/ldebug.o ./lua/ldo.o ./lua/ldump.o ./lua/lfunc.o ./lua/lgc.o ./lua/llex.o ./lua/lmem.o \
	./lua/lobject.o ./lua/lopcodes.o ./lua/lparser.o ./lua/lstate.o ./lua/lstring.o ./lua/ltable.o ./lua/ltm.o  \
	./lua/lundump.o ./lua/lvm.o ./lua/lzio.o
LIB_O=	./lua/lauxlib.o ./lua/lbaselib.o ./lua/ldblib.o ./lua/liolib.o ./lua/lmathlib.o ./lua/loslib.o ./lua/ltablib.o \
	./lua/lstrlib.o ./lua/loadlib.o ./lua/linit.o
all:
	make -C ./lua linux
	gcc -c -o utils.o utils.c $(options)
	gcc -c -o vi.o vi.c $(options)
	gcc -c -o lsh.o lsh.c $(options) $(lshopt) 
	gcc -c -o han2pinyin.o han2pinyin.c $(options)
	gcc -c -o file.o file.c $(options)
	gcc -o lsh lsh.o vi.o utils.o file.o $(LIB_O) $(CORE_O) $(options) $(lshopt) -Wl,-export-dynamic
	gcc -o han2pinyin han2pinyin.o vi.o utils.o file.o $(LIB_O) $(CORE_O) $(options) $(lshopt) -Wl,-export-dynamic
#gcc -o lsh lsh.o vi.o utils.o $(LIB_O) $(CORE_O) $(options) $(lshopt) 
	touch ../.lsh.history


clean:
	make -C ./lua clean
	-rm *.o
	-rm lsh
	-rm han2pinyin
#gcc -c -o main.o main.c $(options)
#gcc -o t main.o vi.o utils.o $(options)
