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






