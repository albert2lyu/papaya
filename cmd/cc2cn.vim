function! Redirect()
	let l:cnpath = expand("%:p:r")
	let l:cnpath = l:cnpath . ".cn"
	execute "e" . l:cnpath
	set syntax=c
endfunction

au! BufEnter *.cc call Redirect()

