#!/bin/lsh
if argc < 2 then
	print("commit which ?");
	return
end

vi2 = Vi:new()
if argv[1] == "wc" then
	local files = lfs.collect("./src", 10)	
	local lines = 0
	for i, file in pairs(files) do 
		if  string.find(file.path, ".asm$") or 
			string.find(file.path, ".cn$") or 
			string.find(file.path, ".c$") and 
			string.find(file.path, "pci_vendor.c") == nil
		then
			print(file.path)
			vim:open(file.path)
			lines = lines + vim.lmax
		end
	end
	print(lines)
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
