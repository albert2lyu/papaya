local function mk_piece(len, head, padden)
	for i = 1, len - 1 do 
		head = head .. padden
	end
	return head
end
local segnum = vim.eval('a:segnum')
print("segnum"..segnum)
local currl = vim.window().line
local thisline = vim.buffer()[currl]
local seglen = math.floor( #thisline/ segnum )
local newline = ""
local piece = mk_piece(seglen, "|", " ")
for seg = 1, segnum do 
	newline = newline .. piece
end
newline = newline .. "|"

vim.buffer()[currl] = newline

