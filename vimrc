" act like vim not vi
set nocompatible

" experiment - vundle instead of pathogen
set rtp+=~/.vim/Vundle.vim
call vundle#rc()
Bundle 'godlygeek/tabular'
Bundle 'SirVer/ultisnips'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-fugitive'
Plugin 'rust-lang/rust.vim'
"Bundle 'elixir-lang/vim-elixir'
"Bundle 'gmarik/vundle'
"Bundle 'vim-scripts/localvimrc'

" whitelist lvimrc files under our git repo
if isdirectory(expand("~/dotfiles/lvimrc"))
    let g:localvimrc_whitelist=expand("~/dotfiles/lvimrc/.\\*")
    let g:localvimrc_sandbox=0
endif

" allow dirty buffers
set hidden

" proper encoding
set encoding=utf-8

" allow backspace in insert mode
set backspace=indent,eol,start

" sane tab settings
set expandtab
set tabstop=4
set shiftwidth=4

" go stuff
if isdirectory("/usr/local/go/misc/vim")
    set rtp+=/usr/local/go/misc/vim
elseif isdirectory("/usr/share/go/misc/vim")
    set rtp+=/usr/share/go/misc/vim
elseif isdirectory("/usr/local/Cellar/go/1.0.3/misc/vim")
    set rtp+=/usr/local/Cellar/go/1.0.3/misc/vim
endif

" make ESC work for command-T
let g:CommandTCancelMap=['<ESC>','<C-c>']

" see more lines
set scrolloff=3

" allow mouse usage in terminal, and make it more responsive
"set mouse=a
"set ttyfast

" make leaving insert mode faster
set ttimeout
set ttimeoutlen=1
set timeout
set timeoutlen=1000

" explicitly set leader
let mapleader = ","

" sortcut to kill trailing whitespace
nmap <silent> ,ww :%s/^\s\+$//<cr> :%s/\s\+$//<cr>

" filetype stuff
filetype plugin indent on

" autoindenting
set autoindent

" syntax highlighting
syntax on

" don't update display while executing macros
set lazyredraw

" display
set showmode

" better menu completion
set wildmenu
set wildmode=longest,list:longest
set wildignore+=*.pyc

" show $ in change mode
" set cpoptions+=$

" edit vimrc with ,ev and resource it with ,sv
nmap <silent> ,ev :e $MYVIMRC<cr>
nmap <silent> ,sv :so $MYVIMRC<cr>

" line numbers
set number

" experiment: try relative line numbering
" don't like it
"set relativenumber

" case sensitive, highlit searches that match incrementally
set noignorecase
set smartcase
set hlsearch
set incsearch

" ,cl to clear the search highlighting
nmap <silent> ,cl :nohlsearch<cr>

" highlight long lines
set colorcolumn=100

" gui display stuff
set guifont="DejaVu Sans Mono 9"
set t_Co=256
"colorscheme morning
colorscheme wombat256mod

" visual bell (no sound)
set vb

" useful status line
set stl=%f\ %m\ %r\ Line:\ %l/%L[%p%%]\ Col:\ %c\ Buf:\ #%n\ [%b][0x%B]
set laststatus=2

" turn off most GUI trappings
set guioptions=aecg

" allow cursor to go to nonexistant places
set virtualedit=block

" faster vertical split (select new window)
nnoremap <leader>v <C-w>v<C-w>l

" faster window movement
noremap <silent> ,h :wincmd h<cr>
noremap <silent> ,j :wincmd j<cr>
noremap <silent> ,k :wincmd k<cr>
noremap <silent> ,l :wincmd l<cr>

" emacs-line editing of the command
cnoremap <C-A> <Home>
cnoremap <C-B> <Left>
cnoremap <C-F> <Right>
cnoremap <C-E> <End>
cnoremap <C-P> <Up>

" highlight extra whitespace
"highlight ExtraWhitespace guibg=red
"au ColorScheme * highlight ExtraWhitespace guibg=red
"au BufEnter * match ExtraWhitespace /\s\+$/
"au InsertEnter * match ExtraWhitespace /\s\+\%\#\@<!$/
"au InsertLeave * match ExtraWhitespace /\s\+$/

" make ]] and friends work with K&R style
nmap <silent> [[ ?{<cr>w99[{
nmap <silent> ][ /}<cr>b99]}
nmap <silent> ]] j0[[%/{<cr>
nmap <silent> [] k$][%?}<cr>

" show tabs and trailing spaces
set listchars=tab:>-,trail:-
set list

" Change cursor to red in insert mode, or use cursor shape if possible
if exists('$SSH_CONNECTION')
    " Highlight line we're on
    au InsertEnter,InsertLeave * set cul!
else
    " Change cursor to red in insert mode, or use cursor shape if possible
    if exists('$TMUX')
        if exists('$ITERM_PROFILE') || exists('$KONSOLE_DBUS_SESSION')
            let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
            let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
        else
            let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]12;black\x9c\<Esc>\\"
            let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]12;red\x9c\<Esc>\\"
        endif
    elseif &term =~ "256-color"
        if exists('$ITERM_PROFILE') || exists('$KONSOLE_DBUS_SESSION')
            let &t_EI = "\<Esc>]50;CursorShape=0\x7"
            let &t_SI = "\<Esc>]50;CursorShape=1\x7"
        else
            let &t_EI = "\<Esc>]12;black\x9c"
            let &t_SI = "\<Esc>]12;red\x9c"
        endif
    endif
endif
