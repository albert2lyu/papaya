all: clean dcache.o inode.o super.o namei.o exec.o pipe.o

%.o:%.c
	@gcc -c -o $@ $< $(cflags)

clean:
	@rm  -f *.o;
	@rm -f *.cc;

%.o:%.cn
	@/home/wws/lab/yanqi/lsh/han2pinyin $<
	gcc -x c -c -o $@ $(@:.o=.cc) $(cflags)

.PHONY:all
