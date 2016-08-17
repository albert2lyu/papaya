#!/home/wws/software/lsh
if argc < 2 then
	print("commit which ?");
	return
end

local dir = argv[1]
if dir == '.' or 
   dir == 'lsh' or 
   dir == 'cmd' then 
else 
	print("commit which")
end

	
`git add "$(dir)"
`date|
`git commit -m "$(last_ret)"
`git push -u origin master
