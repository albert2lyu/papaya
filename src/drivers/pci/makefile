all: clean pci.o pci_vendor.o


%.o:%.c
	@gcc -c -o $@ $< $(cflags)

clean:
	@rm  -f *.o;

.PHONY:all
