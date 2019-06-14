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
			exec "!python3 %<.py"
		elseif &filetype == "java"
			exec "!java %<"
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

" START setting from www.jianshu.com/p/510924f5723b -------- {{{
syn on					  "语法支持
set ruler				   "在编辑过程中，在右下角显示光标位置的状态行
set incsearch			   " 输入搜索内容时就显示搜索结果
set showcmd				 " 输入的命令显示出来，看的清楚些
set ignorecase smartcase	" 搜索时忽略大小写，但在有一个或以上大写字母时仍保持对大小写敏感
set smartindent			 " 开启新行时使用智能自动缩进
set autoindent			  " 使用自动对起，即把当前行的对起格式应用到下一行
set laststatus=2			" 显示状态栏 (默认值为 1, 无法显示状态栏)
set history=1000			"设置VIM记录的历史数
set si					  "自动缩进
set bs=2					"在insert模式下用退格键删除
set showmatch			   "代码匹配
set laststatus=2			"总是显示状态行
set noexpandtab			   "以下三个配置配合使用，设置tab和缩进空格数
set tabstop=4
set shiftwidth=4
"set cursorline			  "为光标所在行加下划线
set number				  "显示行号
" set autoread				"文件在Vim之外修改过，自动重新读入
set hidden					" Required by CtrlSpace
set ignorecase			  "检索时忽略大小写
set hls					 "检索时高亮显示匹配项
set foldmethod=syntax	   "代码折叠
set foldcolumn=1			"Display folder column
" END setting from www.jianshu.com/p/510924f5723b -------- }}}

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
Plugin 'szw/vim-ctrlspace'
Plugin 'tpope/vim-surround.git'
Plugin 'tpope/vim-repeat'
Plugin 'raimondi/delimitmate'
Plugin 'gregsexton/MatchTag'
Plugin 'iamcco/mathjax-support-for-mkdp'
Plugin 'iamcco/markdown-preview.vim'
Plugin 'PROgram52bc/vim_potion'
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
nnoremap <C-n> :NERDTree<CR>
let g:syntastic_python_checkers = ['python']
let g:syntastic_python_python_exec = 'python3'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
let g:syntastic_mode_map = {"mode": "active", "passive_filetypes": ["asm"]}
let g:delimitMate_expand_cr = 2
let g:delimitMate_expand_space = 1
let g:closetag_filenames = '*.vtl,*.html,*.xhtml,*.phtml,*.vue'
let g:ctrlp_map='<c-p>'
let g:ctrlp_cmd = 'CtrlP'
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
