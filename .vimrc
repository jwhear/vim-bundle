
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

" No swap-files please
set noswapfile

set tabstop=4
set shiftwidth=4

set showmatch
set foldlevelstart=20

" Use very magic mode by default when searching
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set hlsearch
set incsearch

" Flip colon and semi-colon (avoid having to do SHIFT-;)
nmap ; :

" Show the right margin guide
set colorcolumn=80

"
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

" enable if using solarized
if !has("gui_running")
	"set t_Co=16
	set t_Co=256
endif

" make sure whitespace is distinct
highlight NoText ctermfg=white
highlight SpecialKey ctermfg=white


" Set UltiSnip's snippet search directory
let g:UltiSnipsSnippetDirectories = ['UltiSnips']
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Brace matching can be annoying in the terminal
hi MatchParen cterm=underline ctermbg=none ctermfg=blue

" Let Airline use fancy unicode symbols
let g:airline_section_warning = ''
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_left_sep = '»'
let g:airline_left_sep = '▒░'
let g:airline_right_sep = '«'
let g:airline_right_sep = '░▒'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" enable gist plugin
let g:gist_use_password_in_gitconfig = 1

" include database configurations
" source /home/justin/dbext_connections

" Make space toggle folds
nmap <Space> za

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

nmap <silent> <M-Left> ;bp<CR>
nmap <silent> <M-Right> ;bn<CR>

" Get rid of search highlighting quickly
nmap <silent> <leader>/ :noh<CR>

" Allow spell-checking to be enable/disabled quickly
nmap <silent> <F9> :setlocal spell! spelllang=en_us<CR>

" Sideways plugin provides some new text objects
nnoremap <c-h> :SidewaysLeft<cr>
nnoremap <c-l> :SidewaysRight<cr>
omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI

" Properly indent braces with delimitMate
let g:delimitMate_expand_cr = 1

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

" Some online help for D code
function! OnlineDoc()
  if &ft == "d"
    let s:urlTemplate = "google.com/search?q=site:dlang.org+*"
  else
    return
  endif
  let s:browser = "google-chrome"
  let s:wordUnderCursor = expand("<cword>")
  let s:url = substitute(s:urlTemplate, "*", s:wordUnderCursor, "g")
  let s:cmd = "silent !" . s:browser . " " . s:url . "&"
  execute s:cmd
endfunction

" Online doc search.
map <silent> <M-d> :call OnlineDoc()<CR>

" DCD completion
let g:dcd_importPath=['/home/justin/.dvm/compilers/dmd-2.065.0/src/phobos/','/home/justin/.dvm/compilers/dmd-2.065.0/src/druntime/import']
nmap <silent> <leader>l :DCDsymbolLocation<CR>

" Handy for editing Diet templates
autocmd BufNewFile,BufRead *.html.dt set ft=jade

" D interface files
au BufNewFile,BufRead *.di set filetype=d

" Thematic color schemes
let g:thematic#defaults = {
\ 'background': 'dark',
\ 'typeface': 'Ubuntu Mono',
\ 'font-size': 15
\ }

let g:thematic#themes = {
\ 'hybrid'   : { 'colorscheme': 'hybrid',
\              },
\ 'hybrid-light': { 'colorscheme': 'hybrid-light',
\                   'background': 'light'
\              },
\ 'matrix'   : { 'colorscheme': 'matrix',
\                'typeface': 'Dot Matrix',
\                'font-size': 15
\              },
\ 'prose'    : { 'colorscheme': 'pencil',
\                'background': 'light',
\                'linespace':2,
\                'airline-theme': 'base16'
\              }
\ }

let g:thematic#theme_name = 'hybrid'

" vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
nmap <Leader>a <Plug>(EasyAlign)
