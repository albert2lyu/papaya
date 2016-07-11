#@usage format: ll proot
define ll
	set $proot = (struct list_head *)($arg0)
	set $cur = $proot->next
	set $prev = $proot
	while($cur != $proot)
		if($cur->prev != $prev) 
			printf "->prev:%x != prev:%x detected, exit\n", $cur->prev, $prev
			exit
		end
		printf " %x ==>", $cur

		set $prev = $cur
		set $cur = $cur->next
	end
	if($cur->prev != $prev) 
		printf "TAIL--Head ERR ->prev:%x != prev:%x detected, exit\n", $cur->prev, $prev
		exit
	end
	printf "O\n"
end

# @usage format: lls stru_t mb_t proot
define lls
	set $proot = (struct list_head *)($arg2)
	set $cur = $proot->next
	set $prev = $proot
	while($cur != $proot)
		if($cur->prev != $prev) 
			printf "->prev:%x != prev:%x detected, exit\n", $cur->prev, $prev
			exit
		end
		#printf " %x ==>", $cur
		set $mb_offset = (int)&(((struct $arg0 *)0)->$arg1)
		set $mother = (struct $arg0 *)((unsigned)$cur - $mb_offset)
		p/x *$mother

		set $prev = $cur
		set $cur = $cur->next
	end

	if($cur->prev != $prev) 
		printf "TAIL--Head ERR ->prev:%x != prev:%x detected, exit\n", $cur->prev, $prev
		exit
	end
	printf "O\n"
end
define str
	set $arr=$arg0
	set $len=$arg1
	set $i=0
	while($i<$len)
		if($arr[$i]<32 || $arr[$i] >127)
			printf "| "
		else
			printf "%-2c", $arr[$i]
		end
		set $i++		
	end

	printf "\n"
	set $i=0
	while($i<$len)
		printf "%-2x", $arr[$i]
		set $i++		
	end
end

define parr2
	set $arr=$arg0 
	set $start=$arg1
	set $len=$arg2
	set $i=0
	while $i<$len
		set $i++
		p $arr[$start+$i]
	end
end
