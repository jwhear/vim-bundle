
set number
set nocompatible   " disable vi-compatibility
set laststatus=2
set encoding=utf-8

set autoindent

" Disabled while using smartinput plugin
"set smartindent
set autochdir
set hidden

set tabstop=4
set shiftwidth=4

set showmatch
set foldmethod=syntax
set foldlevelstart=20

" Start scrolling when near the top or bottom of the window
set scrolloff=3

" Use very magic mode by default when searching
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set hlsearch
set incsearch

" Show a line at 85 chars
set colorcolumn=85

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

set ruler
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
if (!has("gui_running"))
	hi NonText ctermfg=8 guifg=gray
	hi SpecialKey ctermfg=8 guifg=gray
endif


" toggle light/dark with F12
call togglebg#map("<F12>")

" make sure whitespace is distinct
highlight NoText ctermfg=white
highlight SpecialKey ctermfg=white


" Set UltiSnip's snippet search directory
let g:UltiSnipsSnippetDirectories = ['UltiSnips', 'snippets']

" Light theme
"colorscheme palladio

" fanciness via Powerline:
let g:Powerline_symbols = 'fancy'
call Pl#Theme#InsertSegment('fugitive', 'after', 'filename')

" vim-pad notes directory
let g:pad_dir = '~/.vim/bundle/pad-notes/'

" enable gist plugin
let g:gist_use_password_in_gitconfig = 1

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

" Get rid of search highlighting quickly
nmap <silent> <leader>/ :noh<CR>

" Allow spell-checking to be enable/disabled quickly
nmap <silent> <F9> :setlocal spell! spelllang=en_us<CR>

" Map my D REPL plugin to <F4>
nmap <silent> <F4> :call RunDCode()<CR>

" Improved handling for really big files
let g:LargeFile=100

if !exists("large_file_loaded")
	let large_file_loaded = 1
	let g:LargeFile = 1024 * 1024 * 100
	augroup LargeFile
		autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set eventignore+=FileType | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | else | set eventignore-=FileType | endif
	augroup END
endif
