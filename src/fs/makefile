all: clean dcache.o inode.o super.o namei.o

%.o:%.c
	@gcc -c -o $@ $< $(cflags)

clean:
	@rm  -f *.o;

.PHONY:all
