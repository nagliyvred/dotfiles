set nu
set number
set nocompatible
set showcmd
set autoindent
set ruler
set wrap
set smarttab
set showmatch
set hlsearch
set incsearch
set smartcase
set ignorecase
set expandtab

set cursorline
set nobackup
set noswapfile


"""" Pathogen settings """"""""""""""""""""""""""""""""""""""""""""""""""""""""
" speedup pathogen loading by temporarily disabling file type detection
filetype off

" add all plugins in ~/.vim/bundle/ to runtimepath (vim-pathogen)
if filereadable($HOME."/.vim/autoload/pathogen.vim")
    call pathogen#infect()
    call pathogen#helptags()
endif

" turn on syntax highlighting
if !exists("syntax_on")
    syntax on
endif

" turn file type detection back on
filetype plugin indent on

"""" Color sheme """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:solarized_termcolors = 256
let g:solarized_termtrans = 1
let g:solarized_visibility = "low"

" try to setup colorsheme
try
    colorscheme solarized
    " reload 'mark' plugin after colorscheme changed
    if filereadable($HOME."/.vim/plugin/mark.vim")
        source ~/.vim/plugin/mark.vim
    endif
catch /^Vim\%((\a\+)\)\=:E185/
    " pass
endtry

"set encoding=utf-8
"set termencoding=utf-8
"  (koi8-r, cp1251, cp866, utf8)
"set wildmenu
"set wcm=<Tab> 
""menu Encoding.koi8-r :e ++enc=koi8-r<CR>
""menu Encoding.windows-1251 :e ++enc=cp1251<CR>
""menu Encoding.cp866 :e ++enc=cp866<CR>
""menu Encoding.utf-8 :e ++enc=utf8 <CR>
""map <F8> :emenu Encoding.<TAB>

set history=500
set tabstop=4
set shiftwidth=4
set softtabstop=4
set undolevels=100
set laststatus=2
set sidescroll=5
"
"set listchars+=precedes:<,extends:>
"
"highlight Comment ctermfg=grey   
"
""colors slate
"
"" emacs style jump to end of line
""imap <C-e> <C-o>A
""imap <C-a> <C-o>I
"imap <C-Space> <C-N>
"
""imap { {<CR>}<Esc>O
"nmap <Home> ^
"imap <Home> <Esc>I
"
"nmap <F6> <C-W>k<C-W>_ " ???? ?????
"imap <F6> <Esc><C-W>k<C-W>_a " ???? ?????
"nmap <F7> <C-W>j<C-W>_ " ???? ????
"imap <F7> <Esc><C-W>j<C-W>_a " ???? ????
"
"imap <F2> <Esc>:bn!<CR>a
"nmap <F2> :bn!<CR>
""nmap <c-f> :cs find g <c-r>=expand("<cword>")<cr><cr>
" " ?????????? ?????
"imap <F3> <Esc>:bp!<CR>a
"nmap <F3> :bp!<CR>
"
"set keymap=russian-jcukenwin
"set iminsert=0
"set imsearch=0
""highlight lCursor guifg=NONE guibg=Cyan
""setlocal spell spelllang=ru_yo,en_us
"
""syntax on
"" , #perl # comments map ,# :s/^/#/<CR> 
"" " ,/ C/C++/C#/Java // comments map ,/ :s/^/\/\//<CR> 
"" " ,< HTML comment map ,< :s/^\(.*\)$//<CR><Esc>:nohlsearch<CR> 
"" " c++ java style comments map ,* :s/^\(.*\)$/\/\* \1
"" \*\//<CR><Esc>:nohlsearch<CR>
