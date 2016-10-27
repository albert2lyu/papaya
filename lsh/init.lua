local homedir = os.getenv("HOME")
package.cpath= homedir .. '/lsh/?.so;'
require "lfs"

vim = Vi:new()
vim:set("initialized in init.lua")

--环境变量就命名为Env
--TODO 考虑用户修改它时，触发ｃ语言调用setenv，而不是每次在execve之前暴力setenv
--TODO 可不可以直接在lua里就解决呢？不去ｃ里。因为有os.getenv，考虑os.setenv
Env={}		--for temporary usage
--TODO 把lshmod放在Env里，合适吗?
Env.lshmod={lua=0;cmd=1;vi=2}
--TODO 1,大小写?  2,允许分开?
--我不太想这样，因为用户需要知道此处的大小写，以及不能分开，是系统API级别的。
--就是说，顺便让他们了解setenv,getenv。有什么不好。
Env.PATH = "/usr/bin:/bin:/usr/local/bin/"
Env.PATH = Env.PATH .. ":/home/wws/software/"
local lshmod = Env.lshmod
lshmod.default = lshmod.cmd

--path, depth, dir
function lfs.collect(path, ...)
	arg = {...}
	local depth = arg[1] or 0
	local holder = arg[2] or {}
	for filename in lfs.dir(path) do
		if filename ~= "." and filename ~= ".." then
			local _fullpath = path .. "/" .. filename
			local attribute = lfs.attributes(_fullpath)
			local file = {name = filename; attr = attribute, path = _fullpath}	
			holder[#holder + 1] = file
			if attribute.mode == "directory" and depth >= 1 then 
				lfs.collect(_fullpath, depth-1, holder)	
			end
		end
	end
	return holder
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
