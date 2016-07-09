all: clean ll_rw_blk.o


%.o:%.c
	@gcc -c -o $@ $< $(cflags)

clean:
	@rm  -f *.o;

.PHONY:all
