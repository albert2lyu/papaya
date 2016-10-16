#!/bin/sh
find . -name "*.h" -o -name "*.c" -o -name "*.asm" -o -name "*.cn"\
		>csfeed.out
cscope -bkq -i csfeed.out
ctags -R
