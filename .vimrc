" START Custom function -------- {{{

" START compile function -------- {{{
func! CompileGcc()
	exec "w"
	let compilecmd="!gcc "
	let compileflag="-o %< "
	if search("mpi\.h") != 0
		let compilecmd = "!mpicc "
	endif
	if search("glut\.h") != 0
		let compileflag .= " -lglut -lGLU -lGL "
	endif
	if search("cv\.h") != 0
		let compileflag .= " -lcv -lhighgui -lcvaux "
	endif
	if search("omp\.h") != 0
		let compileflag .= " -fopenmp "
	endif
	if search("math\.h") != 0
		let compileflag .= " -lm "
	endif
	if search("plot\.h") != 0
		let compileflag .= " -lplot -lXaw -lXmu -lXt -lSM -lICE -lXext -lX11 -lpng -lz -lm"
	endif
	exec compilecmd." % ".compileflag
endfunc
func! CompileGpp()
	exec "w"
	let compilecmd="!g++ "
	let compileflag="-std=c++11 -o %< "
	if search("mpi\.h") != 0
		let compilecmd = "!mpic++ "
	endif
	if search("glut\.h") != 0
		let compileflag .= " -lglut -lGLU -lGL "
	endif
	if search("cv\.h") != 0
		let compileflag .= " -lcv -lhighgui -lcvaux "
	endif
	if search("omp\.h") != 0
		let compileflag .= " -fopenmp "
	endif
	if search("math\.h") != 0
		let compileflag .= " -lm "
	endif
	if search("plotter\.h") != 0
		let compileflag .= " -lplotter -lXaw -lXmu -lXt -lSM -lICE -lXext -lX11 -lpng -lz -lm "
	endif
	if search("//DEBUG") != 0
		let compileflag .= " -g "
	endif
	if search("<thread>") != 0
		let compileflag .= " -pthread "
	endif
	exec compilecmd." % ".compileflag
endfunc

func! CompileCode()
		exec "w"
		if &filetype == "cpp"
			exec "call CompileGpp()"
		elseif &filetype == "c"
			exec "call CompileGcc()"
		elseif &filetype == "vb"
			exec "!vbnc %"
		elseif &filetype == "cs"
			exec "!mcs %"
		elseif &filetype == "java"
			exec "!javac %"
		endif
endfunc

func! RunResult()
		exec "w"
		if search("mpi\.h") != 0
			exec "!mpirun -np 4 ./%<"
		elseif &filetype == "cpp"
			if expand("%<") =~ "^/"
				exec "! %<"
			else
				exec "! ./%<"
			endif
		elseif &filetype == "c"
			if expand("%<") =~ "^/"
				exec "! %<"
			else
				exec "! ./%<"
			endif
		elseif &filetype == "python"
			exec "!python3 %"
		elseif &filetype == "java"
			exec "!java %<"
		elseif &filetype == "sh"
			exec "!bash %"
		elseif &filetype == "vb"
			exec "!mono %<.exe"
		elseif &filetype == "cs"
			exec "!mono %<.exe"
		endif
endfunc
map <F5> :call CompileCode()<CR>
imap <F5> <ESC>:call CompileCode()<CR>
vmap <F5> <ESC>:call CompileCode()<CR>
map <F6> :call RunResult()<CR>
" END compile function -------- }}}

" START Terminal function -------- {{{
func! OpenNewTerminal()
	" TODO: Add terminal environment detection and activate only if
	" gnome-terminal is available <2020-04-04, David Deng> "
	exec "!gnome-terminal --working-directory='%:p:h'"
endfunc

func! OpenNewWindow()
    " Assuming nautilus is the file explorer
    exec "!nautilus %:p:h &"
endfunc


" END Terminal function -------- }}}
" END Custom function -------- }}}

" START Common settings -------- {{{
syntax on					" display syntax
set background=dark			" dark background
set number				  	" display line number
set incsearch			   	" dynamically show result while typing the search
set ignorecase			  	" ignore case in search
set smartcase				" ignore case, but not when there is upper case in searched word
set autoindent			  	" apply current indent to the new line
set smartindent			 	" c-style autoindent on new line
set laststatus=2			" always show status line
set history=1000			" maximum commandline entries remembered
set backspace=2				" same as set backspace="indent,eol,start". allow backspace over original text in insert mode 
set showmatch			   	" show matching parenthesis briefly when paired up
set noexpandtab			   	" set tab behavior
set tabstop=4
set shiftwidth=4
set autoread				" auto read in when file is edited out of vim
set hidden					" keep closed buffers. required by CtrlSpace
set hlsearch				" highlight search
set foldmethod=syntax	   	" fold according to syntax highlighting items
set foldcolumn=1			" display folder column

"set ruler				   	" show status line at the bottom, this is automatically enabled by vim-airline
"set showcmd				" show the command typed. no effect when vim-airline is enabled
"set cursorline			  	" add visual cues for the cursor poisition
"set cursorcolumn

" END Common settings --------- }}}

" START Vundle setting -------- {{{
" set the runtime path to include Vundle and initialize
set nocompatible
filetype off				  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}

Plugin 'posva/vim-vue'
Plugin 'alvan/vim-closetag'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim.git'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-surround.git'
Plugin 'tpope/vim-repeat'
Plugin 'raimondi/delimitmate'
Plugin 'gregsexton/MatchTag'
Plugin 'iamcco/mathjax-support-for-mkdp'
Plugin 'iamcco/markdown-preview.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'prettier/vim-prettier'
Plugin 'thinca/vim-visualstar'
Plugin 'lervag/vimtex'
Plugin 'aymericbeaumet/vim-symlink'			"Automatically resolve the symlink
if has('python3')
	Plugin 'SirVer/ultisnips'
endif
Plugin 'honza/vim-snippets'
" Plugin 'szw/vim-ctrlspace' 				"Too big, bug on open in tabs
" Plugin 'shepherdwind/vim-velocity'
" Plugin 'jiangmiao/auto-pairs.git'
" Plugin 'harenome/vim-mipssyntax' 			"For MIPS syntax

" The compile & analysis in Youcompleteme give errors, so don't enable it
" unless you know what you are doing
" Plugin 'Valloric/YouCompleteMe'


" All of your Plugins must be added before the following line
call vundle#end()			" required
filetype plugin indent on	" required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList	   - lists configured plugins
" :PluginInstall	- installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean	  - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" END Vundle setting -------- }}}

" START Plugin settings -------- {{{
nnoremap <C-n> :NERDTreeFind<CR>
let g:syntastic_python_checkers = ['python']
let g:syntastic_python_python_exec = 'python3'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
let g:syntastic_mode_map = {"mode": "active", "passive_filetypes": ["asm"]}
let g:delimitMate_expand_cr = 2
let g:delimitMate_expand_space = 1
let g:closetag_filenames = '*.vtl,*.html,*.xhtml,*.phtml,*.vue,*.md'
let g:ctrlp_map='<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](__pycache__|node_modules|\.git|lib)$',
  \ 'file': '\v\.(pyc|swp)$',
  \ }
let g:ctrlp_show_hidden = 1

" airline settings
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_symbols.branch = '⎇'

" START Prettier settings ------ {{{
let g:prettier#quickfix_enabled = 1 " Display the quickfix box for errors 
let g:prettier#autoformat = 0 " Don't automatically format
autocmd BufWritePre *.md,*.vue,*.yaml PrettierAsync " Auto run only on those files
let g:prettier#config#tab_width = 4 " number of spaces per indentation level
let g:prettier#config#use_tabs = 'true' " use tabs over spaces
let g:prettier#config#bracket_spacing = 'true' " print spaces between brackets
let g:prettier#config#semi = 'true' " print semicolons
let g:prettier#config#single_quote = 'true' " single quotes over double quotes
let g:prettier#config#jsx_bracket_same_line = 'true' " put > on the last line instead of new line

" END Prettier settings }}}

" START vimtex settings ------ {{{
" Output directory for build
let g:vimtex_compiler_latexmk = {
	\ 'build_dir' : 'build',
\}
" Add custom imaps binding
" Map <localleader>/ to \div
if exists('vimtex#imaps#add_map')
	call vimtex#imaps#add_map({
				\ 'lhs' : '/',
				\ 'rhs' : '\div',
				\ 'wrapper' : 'vimtex#imaps#wrap_math'
				\})
	" Map <localleader>- to \over
	call vimtex#imaps#add_map({
				\ 'lhs' : '-',
				\ 'rhs' : '\over',
				\ 'wrapper' : 'vimtex#imaps#wrap_math'
				\})
endif

" END vimtex settings }}}

" START ultisnips settings ------ {{{

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsSnippetDirectories=["UltiSnips"]

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" set author
let g:snips_author="David Deng"


" END UltiSnips settings -------- }}}

" END Plugin settings -------- }}}

" START autocmd settings -------- {{{

augroup html_related
	autocmd!
	autocmd FileType vtl let b:syntax=html
	autocmd FileType vtl,html,xhtml,phtml,vue let b:delimitMate_matchpairs = "(:),[:],{:}"
augroup END
augroup python_related
	autocmd!
	autocmd FileType python set tabstop=4
augroup END
augroup vim_related
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
	"autocmd FileType vim inoremap augroup augroup<c-o>ma<cr>augroup END<c-o>`a
	"abbreviation for creating a new augroup
	autocmd FileType vim inoreabbrev augroup augroup maautocmd!augroup END`a
augroup END
augroup md_related
	autocmd!
	autocmd FileType markdown nnoremap <F7> :MarkdownPreview<CR>
	autocmd FileType markdown let b:delimitMate_matchpairs = "(:),[:],{:}"
augroup END
augroup latex_related 
	autocmd!
	autocmd FileType tex nnoremap <F7> :LLPStartPreview<CR>
	autocmd FileType tex let b:delimitMate_autoclose = 0
augroup END

" END autocmd settings -------- }}}

" START common map settings -------- {{{
function! ToggleFoldcolumn(...)
	" Toggles the folder indication column
	let width = get(a:000,0,0) " width of the column, default to 0
	" if no width specified, do normal toggle
	if ! width
		let &l:foldcolumn = &l:foldcolumn ? 0 : 1
		echom "Toggling foldcolumn"
	" else display the specified width
	else
		let &l:foldcolumn = width
		echom "Setting foldcolumn to ".width
	endif
endfunction
let mapleader = ','
nnoremap <leader>f :<C-U>call ToggleFoldcolumn(v:count)<CR>
" mapping for changing tabs
" nnoremap <C-l> gt
" nnoremap <C-h> gT
" END tab settings
" mapping the split
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>
inoremap jk <esc>
" inoremap <esc> <nop> " Well... maybe not yet
" mapping the quickfix window
nnoremap <leader>n :cnext<CR>
nnoremap <leader>N :cprevious<CR>
nnoremap <leader>ln :lnext<CR>
nnoremap <leader>lp :lprevious<CR>

nnoremap <leader>u :UltiSnipsEdit<CR>
nnoremap <leader>U :UltiSnipsEdit!<CR>

vnoremap <leader>p :PrettierAsync<cr> " allow block formatting
nnoremap <leader>t :call OpenNewTerminal()<CR>
nnoremap <leader>w :call OpenNewWindow()<CR>
" END common map settings -------- }}}


" START vim programming practice/notes -------- {{{

" Try ':echo var1' and ':echo var2'
if "string" ==? "STRING"
	let var1 = "==? is the case-insensitive comparator in VIM"
endif
if "string" ==# "string"
	let var2 = "==# is the case-sensitive comparator in VIM"
endif
if "string" ==# "STRING"
	unlet var2
endif

" Try ':call PrintArgs("a","b","c")"
" Note: 'function !' redefines a function if it already exists
function! PrintArgs(bar,...)
	echom "named argument: ".a:bar
	echom "unamed argument length: ".a:0
	echom "first unamed argument: ".a:1
	echo "a list of unamed arguments: " | echo a:000
endfunction

" A string is 'falsy'
if 'string'
	let var3 = 'string is truthy'
else
	let var3 = 'string is falsy'
endif

" ':normal! <cmd>' executes a sequence <cmd> in normal mode, escaping any mappings
" Try ':normal! gg' followed by ':normal! '''

" Note: When using marks, backtip (`) + <mark> takes you to the exact character of your mark, while
" single quote (') + <mark> takes you to the beginning of the line

" Try typing 'makr me up' in insert mode
inoreabbrev makr mark

" END vim programming practice/notes -------- }}}

" START project specific settings -------- {{{
function! SetupEnvironment()
	let l:path = expand("%:p")
	" for corpus christi project
	if l:path =~ '/home/wallet/Documents/Taylor/corpus-christi'
		setlocal expandtab " Use space instead of tabs in the project
		if &filetype == 'vue' || &filetype == 'javascript' " for vue/js files, tab is 2 spaces
			setlocal tabstop=2 shiftwidth=2
		else " for other(e.g. python) files, tab is 4 spaces
			setlocal tabstop=4 shiftwidth=4
		endif
		echo "Enabled project specific setting for corpus christi"
	endif
endfunction
augroup project_related
	autocmd!
	autocmd BufEnter * call SetupEnvironment()
augroup END

" END project specific settings -------- }}}
