
set number
set nocompatible   " disable vi-compatibility
set laststatus=2
set encoding=utf-8

set autoindent
set smartindent
set autochdir
set hidden

set tabstop=4
set shiftwidth=4

set showmatch
set foldmethod=syntax
set foldlevelstart=20

" Start scrolling when near the top or bottom of the window
set scrolloff=3

" Allow whitespace toggling with F6
"set listchars=tab:>-,trail:·,eol:$
set list listchars=tab:▸\ ,trail:⋅,nbsp:⋅
nnoremap <silent> <F6> :set nolist!<CR> 

" start up pathogen
call pathogen#infect()

:filetype plugin on


" If we don't have an omnicomplete plugin, use the highlighting info
if has("autocmd") && exists("+omnifunc")
	autocmd Filetype *
			\	if &omnifunc == "" |
		    \		setlocal omnifunc=syntaxcomplete#Complete |
		    \	endif
    endif

" Don't beep on errors
"set vb t_vb=

set ruler
set incsearch

set virtualedit=all

" allow fast editing of .vimrc
map <leader>e :e! ~/.vimrc
autocmd! bufwritepost vimrc source ~/.vimrc

" Handy for editing Diet templates
autocmd BufNewFile,BufRead *.html.dt set ft=jade

" enable if using solarized
"set t_Co=16
set t_Co=256
colorscheme jellybeans
set background=dark

" toggle light/dark with F12
call togglebg#map("<F12>")


" make sure whitespace is distinct
highlight NoText ctermfg=white
highlight SpecialKey ctermfg=white


" Set UltiSnip's snippet search directory
let g:UltiSnipsSnippetDirectories = ['UltiSnips', 'snippets']

" Dark theme
" colorscheme wombat

" Light theme
"colorscheme palladio

" fanciness via Powerline:
let g:Powerline_symbols = 'fancy'
call Pl#Theme#InsertSegment('fugitive', 'after', 'filename')

" vim-pad notes directory
let g:pad_dir = '~/.vim/bundle/pad-notes/'

"here is a more exotic version of my original Kwbd script
"delete the buffer; keep windows; create a scratch buffer if no buffers left
function s:Kwbd(kwbdStage)
	if(a:kwbdStage == 1)
    	if(!buflisted(winbufnr(0)))
      		bd!
		    return
		endif
		let s:kwbdBufNum = bufnr("%")
		let s:kwbdWinNum = winnr()
		windo call s:Kwbd(2)
		execute s:kwbdWinNum . 'wincmd w'
		let s:buflistedLeft = 0
		let s:bufFinalJump = 0
		let l:nBufs = bufnr("$")
		let l:i = 1
		while(l:i <= l:nBufs)
			if(l:i != s:kwbdBufNum)
				if(buflisted(l:i))
					let s:buflistedLeft = s:buflistedLeft + 1
				else
					if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
						let s:bufFinalJump = l:i
					endif
			    endif
			endif
			let l:i = l:i + 1
		endwhile
		if(!s:buflistedLeft)
			if(s:bufFinalJump)
				windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
			else
				enew
				let l:newBuf = bufnr("%")
				windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
			endif
			execute s:kwbdWinNum . 'wincmd w'
		endif
		if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
			execute "bd! " . s:kwbdBufNum
		endif
		if(!s:buflistedLeft)
			set buflisted
			set bufhidden=delete
			set buftype=nofile
			setlocal noswapfile
		endif
	else
		if(bufnr("%") == s:kwbdBufNum)
			let prevbufvar = bufnr("#")
			if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
				b #
			else
				bn
			endif
		endif
	endif
	endfunction

command! Bclose call <SID>Kwbd(1)
nnoremap <silent> <Plug>Kwbd :<C-u>Kwbd<CR>

" Show syntax highlighting groups for word under cursor
nmap <C-S-L> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
nmap <C-TAB> :Tlist<CR>

" running :Tidy
au FileType json command -range=% -nargs=* Tidy <line1>,<line2>! json_xs -f json -t json-pretty

noremap <buffer> <silent> <Up>	gk
noremap <buffer> <silent> <Down> gj

nmap <silent> <M-Left> :bp<CR>
nmap <silent> <M-Right> :bn<CR>

"set runtimepath^=~/.vim/bundle/ctrlp.vim
