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
	elseif &filetype == "dot"
		exec "!dot -Tpng % | magick display png:-"
	elseif &filetype == "haskell"
		exec "!ghc -outputdir build %"
	" TODO: parameterize antlr4 path,
	" possibly turning it into a mini-plugin <2021-02-25, David Deng> "
	elseif &filetype == "antlr4"
		exec "!java -Xmx500M -cp \"/usr/local/lib/antlr-4.9-complete.jar:$CLASSPATH\" org.antlr.v4.Tool -o build % && javac build/%<*.java"
	endif
endfunc

func! RunResult(...)
	exec "w"
	if search("mpi\.h") != 0
		let cmd = "!mpirun -np 4 ./%<"
	elseif &filetype == "cpp" ||
				\ &filetype == "c" ||
				\ &filetype == "ada"
		if expand("%<") =~ "^/"
			let cmd = "! %<"
		else
			let cmd = "! ./%<"
		endif
	elseif &filetype == "python"
		let cmd = "!python3 %"
	elseif &filetype == "scala"
		let cmd = "!scala -nc %"
	elseif &filetype == "haskell"
		let cmd = "!ghci %"
	elseif &filetype == "java"
		let cmd = "!java %<"
	elseif &filetype == "sh"
		let cmd = "!bash %"
	elseif &filetype == "dart"
		let cmd = "!dart %"
	elseif &filetype == "vb"
		let cmd = "!mono %<.exe"
	elseif &filetype == "cs"
		let cmd = "!mono %<.exe"
	elseif &filetype == "prolog"
		let cmd = "!prolog -s %"
	elseif &filetype == "antlr4"
		" TODO: parameterize the tree/gui option and the antlr command <2021-02-25, David Deng> "
		let l:target = input("Target name: ")
		let cmd = "!java -Xmx500M -cp \"/usr/local/lib/antlr-4.9-complete.jar:$CLASSPATH:build\" org.antlr.v4.gui.TestRig %< " . l:target . " -gui"
	elseif &filetype == "perl"
		let cmd = "!perl %"
	endif
	let args = get(a:, 1, "")
	if args =~# '\S'
		let cmd .= " " . args
	endif
	exec cmd
endfunc

func! RunResultWithArguments()
	let args = input("Arguments: ")
	call RunResult(args)
endfunc

map <F5> :call CompileCode()<CR>
imap <F5> <ESC>:call CompileCode()<CR>
vmap <F5> <ESC>:call CompileCode()<CR>
map <F6> :call RunResult()<CR>
map <S-F6> :call RunResultWithArguments()<CR>
" END compile function -------- }}}

" START Custom commands -------- {{{

command! Term :botright terminal ++rows=10
command! BuildCtags :!ctags -R .

" END Custom commands -------- }}}

" START Common settings -------- {{{
syntax on					" display syntax
set background=dark			" dark background
set number relativenumber	" display relative line number
set incsearch				" dynamically show result while typing the search
set ignorecase				" ignore case in search
set smartcase				" ignore case, but not when there is upper case in searched word
set autoindent				" apply current indent to the new line
set smartindent				" c-style autoindent on new line
set laststatus=2			" always show status line
set history=1000			" maximum commandline entries remembered
set backspace=2				" same as set backspace="indent,eol,start". allow backspace over original text in insert mode
set showmatch				" show matching parenthesis briefly when paired up
set noexpandtab				" set tab behavior
set tabstop=4
set shiftwidth=4
set autoread				" auto read in when file is edited out of vim
set hidden					" keep closed buffers. required by CtrlSpace
set hlsearch				" highlight search
set foldmethod=syntax		" fold according to syntax highlighting items
set foldcolumn=1			" display folder column

set noautochdir				" automatically change the current directory to that of the opened file
set path+=**				" search all subdirectories recursively
set wildignore+=			" ignored paths in expanding wildcards
			\ */node_modules/*
			\ */venv/*
			\ */__pycache__/*
set wildmenu				" display option list when using tab completion
set tags=tags;/				" keep searching up for tag files until root

"set ruler					" show status line at the bottom, this is automatically enabled by vim-airline
"set showcmd				" show the command typed. no effect when vim-airline is enabled
"set cursorline				" add visual cues for the cursor poisition
"set cursorcolumn

" END Common settings --------- }}}

" START Plug setting -------- {{{
" set the runtime path to include Vundle and initialize

call plug#begin('~/.vim/bundle')

" Display
Plug 'bling/vim-airline'

" Formatting
" Plug 'prettier/vim-prettier', { 'branch': 'release/1.x', 'do': 'npm install' }
" Plug 'scrooloose/syntastic'
" Plug 'mtscout6/syntastic-local-eslint.vim'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'tell-k/vim-autopep8', { 'do': 'pip install --user --upgrade autopep8' }
Plug 'junegunn/vim-easy-align'

" Integration
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'vim-test/vim-test'
Plug 'whonore/Coqtail'

" Text objects
Plug 'machakann/vim-sandwich'
Plug 'thinca/vim-visualstar'
Plug 'gregsexton/MatchTag'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-abolish'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'wellle/targets.vim'
Plug 'machakann/vim-swap'
Plug 'coderifous/textobj-word-column.vim'

" Completion/snippets
Plug 'raimondi/delimitmate'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-commentary'
Plug 'alvan/vim-closetag'
if has('python3')
	Plug 'SirVer/ultisnips'
endif

" Filetypes
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown' }
Plug 'iamcco/mathjax-support-for-mkdp', { 'for': 'markdown' }
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'posva/vim-vue', { 'for': 'vue' }
Plug 'PROgram52bc/wmgraphviz.vim'
Plug 'dart-lang/dart-vim-plugin'
Plug 'dylon/vim-antlr'
Plug 'sheerun/vim-polyglot' " A language pack for many languages
Plug 'tfnico/vim-gradle'
Plug '~/.vim/bundle/vim-scl'
" Plug 'leafOfTree/vim-vue-plugin' 		"Alternative plugin for vue

" File Management
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeFind' }

" Internals
Plug 'tpope/vim-repeat'
Plug 'aymericbeaumet/vim-symlink'			"Automatically resolve the symlink
Plug 'junegunn/vim-plug'
call plug#end()

" END Plug setting -------- }}}

" START Plugins settings -------- {{{
runtime macros/sandwich/keymap/surround.vim

" let g:syntastic_python_checkers = ['python']
" let g:syntastic_python_python_exec = 'python3'
" let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
" let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_javascript_eslint_exec = ['yarn lint -- ']
" let g:syntastic_mode_map = {"mode": "active", "passive_filetypes": ["asm", "dart"]}
let g:coc_disable_startup_warning = 1
if has('nvim-0.4.0') || has('patch-8.2.0750')
	nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
	inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
	vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

let g:delimitMate_expand_cr = 2
let g:delimitMate_expand_space = 1
let g:closetag_filenames = '*.vtl,*.html,*.xhtml,*.phtml,*.vue,*.md'

" easy-align settings
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" ctrlp settings
let g:ctrlp_map                 = '<c-p>'
let g:ctrlp_cmd                 = 'CtrlP'
let g:ctrlp_custom_ignore       = {
			\ 'dir':  '\v[\/](build|bin|__pycache__|node_modules|\.git|lib)$',
			\ 'file': '\v\.(pyc|swp|o)$',
			\ }
let g:ctrlp_show_hidden         = 1
let g:ctrlp_open_multiple_files = '1ij'

" nerdtree settings
nnoremap <C-n> :NERDTreeFind<CR>
let g:NERDTreeChDirMode = 3
let g:NERDTreeQuitOnOpen = 1

" airline settings
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

let g:airline_symbols.branch = '⎇'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#switch_buffers_and_tabs = 1

" START Prettier settings ------ {{{
let g:prettier#quickfix_enabled = 1 " Display the quickfix box for errors
let g:prettier#autoformat = 0 " Don't automatically format
let g:prettier#autoformat_config_present = 1 " Automatically format when there is a config file
" Below removed temporarily for project-wise config files to take effect
" let g:prettier#config#tab_width = 4 " number of spaces per indentation level
" let g:prettier#config#use_tabs = 'true' " use tabs over spaces
" let g:prettier#config#bracket_spacing = 'true' " print spaces between brackets
" let g:prettier#config#semi = 'true' " print semicolons
" let g:prettier#config#single_quote = 'true' " single quotes over double quotes
" let g:prettier#config#jsx_bracket_same_line = 'true' " put > on the last line instead of new line
" END Prettier settings }}}

" START autopep8 settings ------ {{{
let g:autopep8_disable_show_diff = 1
" let g:autopep8_on_save = 1
" autocmd Filetype python set equalprg=autopep8\ - " doesn't look at context
" END autopep8 settings }}}

" START Sandwich settings ------ {{{
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
let g:sandwich#recipes += [
			\   {'buns': ['{ ', ' }'], 'nesting': 1, 'match_syntax': 1,
			\    'kind': ['add', 'replace'], 'action': ['add'], 'input': ['{']},
			\   {
			\     'buns'        : ['{', '}'],
			\     'motionwise'  : ['line'],
			\     'kind'        : ['add'],
			\     'linewise'    : 1,
			\     'command'     : ["'[+1,']-1normal! >>"],
			\   },
			\   {'buns': ['[ ', ' ]'], 'nesting': 1, 'match_syntax': 1,
			\    'kind': ['add', 'replace'], 'action': ['add'], 'input': ['[']},
			\
			\   {'buns': ['( ', ' )'], 'nesting': 1, 'match_syntax': 1,
			\    'kind': ['add', 'replace'], 'action': ['add'], 'input': ['(']},
			\
			\   {'buns': ['{\s*', '\s*}'],   'nesting': 1, 'regex': 1,
			\    'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
			\    'action': ['delete'], 'input': ['{']},
			\
			\   {'buns': ['\[\s*', '\s*\]'], 'nesting': 1, 'regex': 1,
			\    'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
			\    'action': ['delete'], 'input': ['[']},
			\
			\   {'buns': ['(\s*', '\s*)'],   'nesting': 1, 'regex': 1,
			\    'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'],
			\    'action': ['delete'], 'input': ['(']},
			\ ]
" END Sandwich settings }}}

" START vimtex settings ------ {{{
" Output directory for build
let g:vimtex_compiler_latexmk = {
			\ 'build_dir' : 'build',
			\}
" Add custom imaps binding
" Map <localleader>/ to \div
if exists('*vimtex#imaps#add_map')
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
let g:tex_flavor = 'latex'

" END vimtex settings }}}

let g:vue_pre_processors = [] "Make vue processing faster

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

" testing
let g:test#strategy = {
			\ 'nearest': 'dispatch',
			\ 'last':	   'dispatch',
			\ 'file':    'dispatch_background',
			\}
let g:test#java#runner = 'gradletest'

" vim-table-mode
let g:table_mode_corner='|'

" END Plugins settings -------- }}}

" START autocmd settings -------- {{{

augroup prettier_related
	autocmd!
	autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue,*.yaml PrettierAsync
	" autocmd BufWritePre *.html PrettierAsync
augroup END
augroup html_related
	autocmd!
	autocmd FileType vtl let b:syntax=html
	autocmd FileType vtl,html,xhtml,phtml,vue let b:delimitMate_matchpairs = "(:),[:],{:}"
	autocmd FileType vtl,html,xhtml,phtml,vue set iskeyword+=-
	" allow block formatting
	autocmd FileType markdown,typescript,vue,html,js vnoremap <buffer> <leader>p :PrettierAsync<cr>
augroup END
augroup python_related
	autocmd!
	autocmd FileType python set tabstop=4
	autocmd FileType python noremap <buffer> <leader>p :Autopep8 -a -a<cr>
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
	" TODO: override in latex file the target '{' to be '\{\}'. Investigate
	" how to combine FileType and User autocmd
	" https://github.com/wellle/targets.vim#targetsmappingsextend <2020-04-28, David Deng> "
	" autocmd FileType tex autocmd User targets#mappings#user call targets#mappings#extend({
	" \ '{': {'pair': [{'o':'\\{', '\\}':')'}]}
	" \ })
augroup END
augroup terminal_buffer
	autocmd!
	autocmd BufWinEnter * if &buftype == 'terminal' | setlocal nobuflisted | endif
augroup END
augroup dart
	autocmd!
	autocmd FileType dart setlocal expandtab
augroup END
augroup java
	autocmd!
	autocmd FileType java setlocal makeprg=gradle
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
nnoremap <leader>co :copen<CR>
nnoremap <leader>cl :cclose<CR>

nnoremap <leader>u :UltiSnipsEdit<CR>
nnoremap <leader>U :UltiSnipsEdit!<CR>

func! OpenNewTerminal()
	" TODO: Add terminal environment detection and activate only if
	" gnome-terminal is available <2020-04-04, David Deng> "
	exec "!gnome-terminal --working-directory='%:p:h'"
endfunc

func! OpenNewWindow()
	" Assuming nautilus is the file explorer
	exec "!nautilus %:p:h &"
endfunc
nnoremap <leader>t :call OpenNewTerminal()<CR>
nnoremap <leader>w :call OpenNewWindow()<CR>

nnoremap <silent> <leader>tn :cclose<Bar>TestNearest<CR>
nnoremap <silent> <leader>tf :cclose<Bar>TestFile<CR>
nnoremap <silent> <leader>tl :cclose<Bar>TestLast<CR>

" 4gb => switch to buffer 4
" ,bn => switch to next buffer
nnoremap gb 		:<C-U>exe (v:count ? "b ".v:count : "bnext")<CR>
nnoremap <leader>bn :<C-U>exe (v:count ? "b ".v:count : "bnext")<CR>

" go to previous buffer
nnoremap gB :bN<CR>
nnoremap <leader>bN :bNext<CR>

" go to last accessed buffer
nnoremap gp :b#<CR>
nnoremap <leader>bp :b#<CR>

" list all buffers
nnoremap <leader>bl :ls<CR>

" 4,bd => delete buffer 4
" ,bd => delete current buffer
nnoremap <silent> <leader>bd 	:<C-U>exe (v:count ? "bd ".v:count : "bn\|bd #")<CR>
nnoremap <silent> gd 			:<C-U>exe (v:count ? "bd ".v:count : "bn\|bd #")<CR>

" match next email address
" onoremap in@ :exec "normal! /[[:alnum:]_-]\\+@[[:alnum:]-]\\+\\.[[:alpha:]]\\{2,3}\r:noh\rgn"<CR>

" echo the visual selected text
vnoremap <leader>e y:echo getreg('"')<CR>

" trim trailing spaces
function! s:TrimTrailingSpace()
	let v:errmsg = ""
	normal m`
	let l:msg = execute('%s/\s\+$//g', "silent!")
	normal ``
	if v:errmsg != ""
		echom "no trailing spaces detected"
	else
		echom l:msg == ""
					\ ? "trailing spaces removed"
					\ : substitute(l:msg,
					\ '\v.*\d+ substitutions on (\d+) lines.*',
					\ 'removed trailing spaces on \1 lines',
					\ "")
	endif
endfunction
nnoremap <silent> <leader><space> :call <SID>TrimTrailingSpace()<CR>

" toggle between tabs and spaces
" nnoremap <silent> <leader>< :echo "HI!"<CR> :echo "YOU"<CR>

" START url encode/decode -------- {{{

nnoremap <silent> gee :set opfunc=<SID>encodeUrlOpfunc<CR>g@
nnoremap <silent> ged :set opfunc=<SID>DecodeUrlOpfunc<CR>g@
vnoremap <silent> gee d:silent exe "normal!" "\"=\<SID>ProcessedUrl(0, @@)\rP"<CR>
vnoremap <silent> ged d:silent exe "normal!" "\"=\<SID>ProcessedUrl(1, @@)\rP"<CR>

function! s:DecodeUrlOpfunc(type)
	call s:ReplaceWithProcessedUrl(a:type, 1)
endfunction

function! s:EncodeUrlOpfunc(type)
	call s:ReplaceWithProcessedUrl(a:type, 0)
endfunction

" replace the region bounded by '[ '] with the encoded/decoded result
function! s:ReplaceWithProcessedUrl(type, decode)
	let sel_save = &selection
	let reg_save = @"
	let &selection = "inclusive" 	" cursor can past line, last char included
	if a:type == "line"				" linewise motion
		silent exe "normal! '[V']d"
	else							" if a:type == 'char' character wise motion
		silent exe "normal! `[v`]d"
	endif
	let result = s:ProcessedUrl(a:decode, @")
	silent exe "normal!" "\"=result\<cr>P"
	let @" = reg_save
	let &selection = sel_save
endfunction

" encode or decode text
function! s:ProcessedUrl(decode, text)
	python3 << EOF
from urllib.parse import quote, unquote
import vim
if vim.eval("a:decode") != "0":
	func = unquote
else:
	func = quote
vim.command("let result = '%s'" % func(vim.eval("a:text")))
EOF
	return result
endfunction
" END url encode/decode -------- }}}

" terminal mode mappings
tnoremap <C-J> <C-W><C-J>
tnoremap <C-K> <C-W><C-K>
tnoremap <C-H> <C-W><C-H>
tnoremap <C-L> <C-W><C-L>
" kill the line
tnoremap <C-W><C-K> <C-K>
" kill the terminal
tnoremap <silent> <C-W><C-D> <C-W>:bw!<CR>

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
function! Eslint(...)
	if a:0 == 0
		let l:entry = expand("%") 	" if no arguments, lint only the current file
		let l:options = ""
	else
		let l:entry = a:1			" otherwise, search for vue and js files
		let l:options = "--ext js,vue "
	endif
	let l:cmd = "npx eslint -f unix " . l:options . shellescape(l:entry)
	cexpr system(l:cmd)				" populate the quickfix list
	if len(getqflist())
		copen
		let w:quickfix_title = l:cmd
	else
		echom "No linting error found :)"
	endif
endfunction

function! SetupEnvironment()
	let l:path = expand("%:p")
	" for corpus christi project
	if l:path =~ 'corpus-christi'
		command! -nargs=? -complete=file Eslint call Eslint(<f-args>)
		nnoremap <leader>e :Eslint<cr>
		" autocmd BufWritePost *.vue make
		setlocal expandtab " Use space instead of tabs in the project
		if &filetype == 'vue' ||
					\ &filetype == 'javascript' ||
					\ &filetype == 'yaml' ||
					\ &filetype == 'json' ||
					\ &filetype == 'typescript' " for vue/js/yaml files, tab is 2 spaces
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
