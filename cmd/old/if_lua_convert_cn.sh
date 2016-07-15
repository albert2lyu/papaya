#!/bin/bash
#/opt/bin/vim -e -s -c "luafile ./han2pinyin.lua" -c "w %!" -c "q!" 
echo $1
/opt/bin/vim -R -e -s -c "luafile /home/wws/lab/yanqi/cmd/han2pinyin.lua" -c "w! %:p:r.cc" -c "q!"  $1
exit 0
