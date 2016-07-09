all: clean arp.o ip.o icmp.o udp.o


%.o:%.c
	@gcc -c -o $@ $< $(cflags)

clean:
	@rm  -f *.o;

.PHONY:all
