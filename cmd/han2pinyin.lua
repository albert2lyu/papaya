--1, 可能在word.lua里找不到某个unicode所对应的pinyin,那样的话，lua会报错,concat 
--	 nil value

--[[
	占用3个字节的范围(52156 个)
	U+2E80 - U+2EF3 : 0xE2 0xBA 0x80 - 0xE2 0xBB 0xB3      共 115 个
	U+2F00 - U+2FD5 : 0xE2 0xBC 0x80 - 0xE2 0xBF 0x95      共 213 个
	U+3005 - U+3029 : 0xE3 0x80 0x85 - 0xE3 0x80 0xA9      共 36 个
	U+3038 - U+4DB5 : 0xE3 0x80 0xB8 - 0xE4 0xB6 0xB5      共 7549 个
	U+4E00 - U+FA6A : 0xE4 0xB8 0x80 - 0xEF 0xA9 0xAA      共 44138 个
	U+FA70 - U+FAD9 : 0xEF 0xA9 0xB0 - 0xEF 0xAB 0x99      共 105 个


	占用4个字节的范围(64029 个)
	U+20000 - U+2FA1D : 0xF0 0xA0 0x80 0x80 - 0xF0 0xAF 0xA8 0x9D    共 64029 个
--]]

require "bit"
require "word"
local tobyte = string.byte
for key, value in pairs(bit)do 
	--print(key, value)
end

function printx(value)
	print( string.format("%x", value) )
end
function is_utf8_leader(byte)
	return bit.band(byte, 0xf0) == 0xe0
end

--TODO check validation and return nil
function utf8_to_unicode(high, mid, low)
	if bit.band(high , 0xf0) ~= 0xe0 or
	   bit.band(mid, 0xc0) ~= 0x80 or
	   bit.band(low, 0xc0) ~= 0x80 then 
	   print("utf8_to_unicode failed, ckeck them:", high, mid, low)
	   return nil 
	end

	local high = high % 0x10
	local mid = mid % 0x40
	local low = low % 0x40
	local unicode = low + bit.lshift(mid, 6) + bit.lshift(high, 12)
	return unicode
end

function utf8_to_pinyin(str)
	local py_str = ""
	local i = 1
	--#str -2 ,we must guarantee the last operation won't touch out of boundray
	while i <= #str - 2 do
		if is_utf8_leader(string.byte(str, i)) then 
			local unicode = utf8_to_unicode(string.byte(str, i),
											string.byte(str, i+1),
											string.byte(str, i+2))
			if unicode then 
				--printx(unicode)
				local word = pinyin_of[unicode]
				if word == nil then printx(unicode) end
				py_str = py_str .. "_" .. word
			else
				print("a valid utf8 leader, but bad result")
			end
		else
			--@return2 how many characters converted, we skip them
			--print("not UTF8 any more..")
			return py_str, i-1 	--we meet a non-utf8 leader character
		end
		i = i + 3
	end

	--print("EOF")
	return py_str, i-1		--very lucky, the whole string is UTF8 encoded
end

function convert_line(str)
	local text = ""
	local i = 1
	local seg_start = 1
	while i <= #str -2 do
		if is_utf8_leader( string.byte(str, i) ) then 
			local remain = string.sub(str, i, -1)
			local pinyin_str, skip = utf8_to_pinyin(remain)
			local seg = string.sub(str, seg_start, i-1)
			text = text .. seg .. pinyin_str
			--ok, we move to next segment
			seg_start = i + skip
			i = seg_start
		else
			i = i + 1
		end
	end
	local final_seg = string.sub(str, seg_start, -1)
	text = text .. final_seg
	return text
end
--local str = string.format("%x", bit.bor(0x123, bit.lshift(0x234, 16)))
--print( str)
--local unicode = utf8_to_unicode("好")
--print(pinyin_of[unicode])
--printx( unicode)
--local pystr, skipnum = utf8_to_pinyin("你好吗")
--print(pystr, skipnum)
--local line = convert_line("int 数量 = 3;")
--print(line)
local buffer = vim.buffer()
--print(#buffer)

function han2pinyin()
	local in_comment  = false
	for i = 1, #buffer do 
		local line = buffer[i]
		local first, second, tail, tail_ = string.byte(line, 1, 2, -1, -2)
		if first == tobyte('/') and second == tobyte('/') then
			--这一行是//注释
		elseif first == tobyte('/') and second == tobyte('*') then 
			--这一行是/*开端
			in_comment = true;
		elseif tail == tobyte('/') and  tail_ == tobyte('*') then
			--*/结尾
			in_comment = false;

		else	--这一行不是注释开端，也不是注释结尾
			if in_comment == false then 	--是不是在注释里呢
				buffer[i] = convert_line(line)
			end
		end
	end
end

han2pinyin()
