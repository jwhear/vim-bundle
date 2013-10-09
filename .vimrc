
set relativenumber
set number
set nocompatible   " disable vi-compatibility
set laststatus=2
set encoding=utf-8

set autoindent
set backspace=indent,eol,start

" Disabled while using smartinput plugin
set smartindent
set autochdir
set hidden

set tabstop=4
set shiftwidth=4

set showmatch
set foldmethod=syntax
set foldlevelstart=20

" Try to keep the current line centered on the screen
set scrolloff=999

" Use very magic mode by default when searching
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set hlsearch
set incsearch

" Show the right margin guide
set colorcolumn=80

syntax enable

" Allow whitespace toggling with F6
set list listchars=tab:▸\ ,trail:⋅,nbsp:⋅
nnoremap <silent> <F6> :set nolist!<CR> 
" Turn whitespace off by default (we'll enable in .gvimrc)
set nolist!

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
if !has("gui_running")
	"set t_Co=16
	set t_Co=256
endif
colorscheme jellybeans
set background=dark

" make sure whitespace is distinct
highlight NoText ctermfg=white
highlight SpecialKey ctermfg=white


" Set UltiSnip's snippet search directory
let g:UltiSnipsSnippetDirectories = ['UltiSnips', 'snippets']
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Light theme
"colorscheme palladio

" Let Airline use fancy Powerline fonts
let g:airline_powerline_fonts = 1

" enable gist plugin
let g:gist_use_password_in_gitconfig = 1

" include database configurations
source /home/justin/dbext_connections

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

" Need sudo to write?
cmap w!! %!sudo tee > /dev/null %

" Improved handling for really big files
let g:LargeFile=100

if !exists("large_file_loaded")
	let large_file_loaded = 1
	let g:LargeFile = 1024 * 1024 * 100
	augroup LargeFile
		autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set eventignore+=FileType | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | else | set eventignore-=FileType | endif
	augroup END
endif
