all: clean ll_rw_blk.o buffer.o


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
