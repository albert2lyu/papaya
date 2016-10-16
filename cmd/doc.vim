function! Inner()
	echo word
endfunction

function! CustomLoad()
	let word = expand("<cword>")
	echo '123'
	exec( "e " . word )
endfunction


nnoremap <2-LeftMouse> :call CustomLoad()<CR>
