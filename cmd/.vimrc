source ~/.vim/macros/gdb_mappings.vim
set backspace=indent,eol,start
syntax on
set noic
set ruler
set mouse=a
set autoindent
set tabstop=4
set shiftwidth=4
highlight Pmenu ctermbg=white
highlight PmenuSel  ctermbg=white  ctermfg=red
highlight MatchParen ctermbg=white ctermfg=blue
set hlsearch

function! Doo()
	:r!ls %<CR>
	:normal gUU<CR>
endfunction
map <C-h> :r!ls %<CR>ggdd:normal gUU<CR>$hr_F/d0xywi#ifndef <Esc>o#define <Esc>po#endif<Esc>O
map ;n :q<CR>
" make -s似乎有bug，定位文件时后找不到
map ;m :make<CR>
map ;w :w<CR>
map ;s :!
map ;q ^i--<Esc>
"for quickfix hot key
"copen 10	cclose
map <C-n> <C-w>j:cn<CR>
map <C-p> <C-w>j:cp<CR>
map <C-m> :MRU<CR>
imap <C-b> {<CR>}<Esc>O
imap <C-j> <Esc>la
imap ( ()<Esc>i
imap [ []<Esc>i

function! Pragma()
	:normal i#pragma pack(push
	:normal o#pragma pack(1
	:normal o#pragma pack(pop
endfunction

function! Sp(segnum)
	:luafile draw.lua
endfunction

function! Pinyin()
	:luafile han2pinyin.lua
endfunction
