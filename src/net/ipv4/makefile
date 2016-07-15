#注意,这个文件里的当前路径是/home/wws/lab/yanqi/src/net/ipv4/.因为它是由make -C
#执行的.
all: clean arp.o ip.o icmp.o udp.o tcp.o


%.o:%.c
	@gcc -c -o $@ $< $(cflags)

# 1, 中间文件的后缀名设定为cc，但gcc会把它当做c++，所以用-xc强制指定。
# 2, action里不能再用%.o和%.cn了，只能用:做简单替换。
%.o:%.cn
	@/home/wws/lab/yanqi/lsh/han2pinyin $<
	gcc -x c -c -o $@ $(@:.o=.cc) $(cflags)

clean:
	@rm  -f *.o;

.PHONY:all
