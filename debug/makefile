#BUG if two or more directories has this makefile and these cfiles include
#a same header path, then exchanging betwwen 'file' and 'stdfile' will be 
#a nightmare.

#NOTE
#1 all directory path must end up with '/',for example, write '-I../'
#instead of '-I..'

SHELL=/bin/bash
target=t
sources=pdb.c stab.c
libo=/home/wws/src/.*.oo
linkobjs=$(sources:%.c=.%.oo)

#1, header path must end with '/'
#2, for libs written using sf-syntax,you should not
#only supply .o lib file on linking,but also supply
#the lib's header path for compilation
Isflib_h=-I/home/wws/include/
Icommon_h= -I./ -Iinclude/


Ih=$(Isflib_h) $(Icommon_h)
sflib_hpath =$(Isflib_h:-I%=%)
common_hpath=$(Icommon_h:-I%=%)
hpath=$(Ih:-I%=%)

cflags=$(Ih) -Wall -fno-builtin -gstabs -fpermissive -DCMPLER_C_PLUS -Wno-return-type -Wno-unused-function -Wno-sign-compare -Wno-unused-variable
objs=$(sources:%.c=.%.oo)
stds=$(sources:%.c=.%.cstd)

#we only delete common header files, and let out the#sf-lib header file
del_hstd=$(common_hpath:%=%.*hstd)

warn:
	@echo do not use 'make' directly, use script 'makeoo'
update_std:$(stds)
	
std_front:
	exchg_std $(hpath)
	
compile:$(objs)
	
std_retire:
	exchg_std $(hpath)
	
link:
	g++ -o $(target) $(linkobjs) $(libo)
	
#only for debug usage
clean:
	make cleanh;\
	make cleanc

cleanh:
	-rm $(del_hstd)

cleanc:
	-rm   .*.cstd .*.d .*.oo 

include $(sources:%.c=.%.d)
#rules list
.%.d:%.c
	set -e;\
	gcc -MM $< $(Ih) > tmpfile;\
	sftool --makerule tmpfile > $@;

.%.oo:%.c
	gcc -x c++ -c -o $@ $< $(cflags)

#infact, strufunc should use sflib_hpath(not Isflib_
#h) as how sftool does, but it doesn't for old code
#in previous version
.%.cstd:%.c
	strufunc $< $(Icommon_h)

.PHONY:update_std std_front compile std_retire link clean
.PRECIOUS:$(stds) $(sources:.c=.d) 

#update log
#10,april
#sftool --exchg encounter a bug:"mv:/home/wws/includ
#e/stringparser.h is not a directory", thus,std_reti
#re failed. i can fix it and so use shell script 'ex#chg_std' to replace sftool on this job
