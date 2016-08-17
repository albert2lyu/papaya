#!/home/wws/software/lsh
if argc < 2 then
	print("commit which ?");
	return
end

	
`git add "$(argv[1])"
if last_ret ~= 0 then 
	print("git add failed , stop ")
	return
end

`date|
`git commit -m "$(last_ret)"

if last_ret ~= 0 then 
	print("git commit -m failed , stop ")
	return
end

`git push -u origin master
