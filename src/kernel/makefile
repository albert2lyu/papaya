all: clean bh.o bh.o


%.o:%.c
	@gcc -c -o $@ $< $(cflags)

clean:
	@rm  -f *.o;

.PHONY:all
