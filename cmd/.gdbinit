handle SIGSEGV nostop noprint ignore

define hp
end

define pte
	set $p = $arg1	
	set $cr3 = $p->mm.cr3
	set $pgdir = (union pte *)( ($cr3.value & ~0xfff) + 0xc0000000 )

	set $vaddr = $arg0
	set $tbl_idx = ($vaddr >> 12) & 0x3ff
	set $dir_idx = $vaddr >> 22
	set $pde = $pgdir[$dir_idx]
	set $pgtbl = (union pte *)( ($pde.value & ~0xfff) + 0xc0000000 )
	set $pte = $pgtbl[$tbl_idx]
	set $kaddr = (union pte *)( ($pte.value & ~0xfff) + 0xc0000000 )

	printf "entry: %x writtable:%u, present:%u, user:%u, kaddr:%x\n", $pte.value, $pte.writable, $pte.present, $pte.user, $kaddr
end

define LL
	set $root = $arg0
	set $p = $root
	while $p
		printf "=> %s ", $p->p_name
		set $p = $p->next	
	end
	printf "=> 0\n" 
end


define list 
	set $root = $arg0 
	if $root == 0
		printf "0!\n"
		exit
	end

	printf "%x =>", $root
	set $curr = $root->next
	while $curr != $root 
		if $curr == 0 
			loop_break
		else
			printf " %x =>", $curr
		end

		set $curr = $curr->next
	end


	if $curr 
		printf ")\n"
	else
		printf "0\n"
	end
end


define LL3
	printf "active:  "
	LL list_active
	printf "expire:  "
	LL list_expire
	printf "sleep:   "
	LL list_sleep
end

define child 
	set $father = $arg0
	set $root = &$father->children
	set $node = $root->next
	while $node != $root 
		set $task = (struct pcb *)((unsigned)$node - (unsigned)&((struct pcb *)0)->sibling)
		printf "=> %s ", $task->p_name
		set $node = $node->next
	end
	printf"=> )\n"
end


define addsyms
	set $i = right
	while $i >= 0
		set $so = mmap_of_so[$i]
		set $filename = $so->filename
		set $address = (unsigned)$so->text
		eval "add-symbol-file %s 0x%x", $filename, $address
		set $i--
	end
end

define infosym
	
end

define origin
	set $mmap = $arg0.mmap
	set $dynsym = $arg0.symbol
	printf "%s: %s (0x%x)\n", $mmap->filename ,$mmap->dynstr + $dynsym->st_name, (unsigned)$mmap->eheader + $dynsym->st_value
end

#从一个地址开始向右扫描, 直到遇到0. byte unit of u32.
define scan0
	set $start = (unsigned *)$arg0
	set $i = 0
	while $start[$i]
		set $i++
		#printf "%x ", $start[$i]
	end
	printf "stop at %x, %x(%d) cells offset,  %x(%d) bytes offset\n", &$start[$i], $i, $i, $i*4,$i*4 
end






