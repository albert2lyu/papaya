#!/bin/lsh
if argc < 2 then
	print("commit which ?");
	return
end

	
`git add "$(argv[1])"
if errno ~= 0 then 
	print("git add failed , stop ")
	return
end

local date = `date`
local cmt_info = argv[2] or date
`git commit -m "$(cmt_info)"

if errno ~= 0 then 
	print("git commit -m failed , stop ")
	return
end

`git push -u origin master
