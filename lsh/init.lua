require "lfs"
vim = Vi:new()
vim:set("")
__Env={
	PATH = "/usr/bin:/bin",
}
Env={}		--for temporary usage
Env.lshmod={lua=0;cmd=1;vi=2}
local lshmod = Env.lshmod
lshmod.default = lshmod.cmd

function lfs.collect(path)
	local dir = {}
	for filename in lfs.dir(path) do
		if filename ~= "." and filename ~= ".." then
			local _fullpath = path .. "/" .. filename
			local attr = lfs.attributes(_fullpath)
			local file = {name = filename; mode = attr.mode, fullpath = _fullpath}	
			dir[#dir + 1] = file
		end
	end
	return dir
end

function lfs.rmdir(path)
	for fname in lfs.dir(path) do
		print("del " .. fname .. "?")
	end
end

function table.print(tbl)
	print(">>>>>>>>>>>>>")
	for _k, _v in pairs(tbl) do
		print(_k, _v)
	end
	print("<<<<<<<<<<<<<")
end

table.__index = table
function table:push(value)
	self[#self+1] = value
	return value
end
function new(...)
	setmetatable(arg, table)
	return arg
end
