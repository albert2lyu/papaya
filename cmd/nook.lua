#!/bin/lsh
local filepath = "/media/wws/NOOK/Books/tmp/3.txt"
`touch $(filepath)
if errno ~= 0 then 
	print("can not access NOOK device")
	return
end

--`rm $(filepath)
`gedit $(filepath)
`sync
`sync
