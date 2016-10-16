#!/bin/lsh
local dirpath = "/media/wws/NOOK/Books/tmp/"
`touch $(dirpath)
if errno ~= 0 then 
	print("can not access NOOK device")
	return
else
	`nautilus $(dirpath)
end

local thatdir = lfs.collect(dirpath)
local id = 0
for key, file in pairs(thatdir) do
	--print(key, value)
	local fname = file.name
	vim:set(fname)
	vim:normal("f.d$")
	local stem = vim:out()
	local file_id = tonumber(stem)
	if file_id and  file_id > id then id = file_id end
	--print(stem)
end
id = id + 1
print(id)
local newfile = dirpath .. id .. ".txt"
`touch $(newfile)

--`rm $(filepath)
`gedit $(newfile)
`sync
`sync
