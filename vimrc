" act like vim not vi
set nocompatible

" allow dirty buffers
set hidden

" go stuff
set rtp+=/usr/local/go/misc/vim

" make ESC work for command-T
let g:CommandTCancelMap=['<ESC>','<C-c>']

" allow mouse usage in terminal
set mouse=a

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

" syntax highlighting
syntax on

" don't update display while executing macros
set lazyredraw

" display
set showmode

" better menu completion
set wildmenu
set wildmode=longest,list
set wildignore+=*.pyc

" show $ in change mode
set cpoptions+=$

" edit vimrc with ,ev and resource it with ,sv
nmap <silent> ,ev :e $MYVIMRC<cr>
nmap <silent> ,sv :so $MYVIMRC<cr>

" line numbers
set nu

" case sensitive, highlit searches that match incrementally
set noignorecase
set hls
set incsearch

" ,cl to clear the search highlighting
nmap <silent> ,cl :nohlsearch<cr>

" highlight long lines
set colorcolumn=80

" gui display stuff
set guifont="DejaVu Sans Mono 9"
set t_Co=256
colorscheme morning

" visual bell (no sound)
set vb

" useful status line
set stl=%f\ %m\ %r\ Line:\ %l/%L[%p%%]\ Col:\ %c\ Buf:\ #%n\ [%b][0x%B]
set laststatus=2

" turn off most GUI trappings
set guioptions=aecg

" allow cursor to go to nonexistant places
set virtualedit=block

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

" Go stuff
function! Goformat()
    let regel=line(".")
    %!gofmt
    call cursor(regel, 1)
endfunction

autocmd Filetype go command! Fmt call Goformat()

" Change cursor to red in insert mode
"if &term =~ "screen"
"if &term =~ "rxvt-unicode-256color"
if exists('$TMUX')
    if exists('$ITERM_PROFILE') || exists('$KONSOLE_DBUS_SESSION')
        let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
        let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    else
        let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]12;black\x9c\<Esc>\\"
        let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]12;red\x9c\<Esc>\\"
    endif
else
    if exists('$ITERM_PROFILE') || exists('$KONSOLE_DBUS_SESSION')
        let &t_EI = "\<Esc>]50;CursorShape=0\x7"
        let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    else
        let &t_EI = "\<Esc>]12;black\x9c"
        let &t_SI = "\<Esc>]12;red\x9c"
    endif
endif
