call plug#begin('~/.config/nvim/plugged')
Plug 'michalbachowski/vim-wombat256mod'
Plug 'tpope/vim-fugitive'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'wincent/command-t'
Plug 'rust-lang/rust.vim'
Plug 'sebastianmarkow/deoplete-rust'
Plug 'keith/swift.vim'
Plug 'othree/xml.vim'
Plug 'fatih/vim-go'
Plug 'zchee/deoplete-go', { 'do': 'make'}
call plug#end()

" plugin configuration
colorscheme wombat256mod
"let $RUST_SRC_PATH="/Users/john/.multirust/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src"
"let g:racer_cmd = "/Users/john/.cargo/bin/racer"
"let g:racer_experimental_completer = 1
let g:deoplete#sources#rust#racer_binary='/Users/john/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path='/Users/john/.multirust/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src'

" deoplete-go settings
let g:deoplete#sources#go#gocode_binary='/Users/john/go/bin/gocode'
call deoplete#enable()

" disable mouse interaction
set mouse=

" allow dirty buffers
set hidden

" sane tab settings
set expandtab
set tabstop=4
set shiftwidth=4

" explicitly set leader
let mapleader = ","

" syntax highlighting
syntax on

" don't update display while executing macros
set lazyredraw

" line numbers
set number

" case sensitive, highlit searches that match incrementally
set noignorecase
set smartcase
set hlsearch
set incsearch

" ,cl to clear the search highlighting
nmap <silent> ,cl :nohlsearch<cr>

" ,f to run RustFmt
" -> moved to ftdetect
"nmap <silent> ,f :RustFmt<cr>

" highlight long lines
set colorcolumn=100

" useful status line
set stl=%f\ %m\ %r\ Line:\ %l/%L[%p%%]\ Col:\ %c\ %{fugitive#statusline()}
set laststatus=2

" turn off most GUI trappings
"set guioptions=aecg

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

" show tabs and trailing spaces
set listchars=tab:>-,trail:-
set list

" ignore target directory (cargo/rust) in command-t
let g:CommandTWildIgnore=&wildignore . ",*/target"

" Change cursor to red in insert mode, or use cursor shape if possible
"if exists('$SSH_CONNECTION')
"    " Highlight line we're on
"    au InsertEnter,InsertLeave * set cul!
"else
"    " Change cursor to red in insert mode, or use cursor shape if possible
"    if exists('$TMUX')
"        if exists('$ITERM_PROFILE') || exists('$KONSOLE_DBUS_SESSION')
"            let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
"            let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"        elseif str2nr($VTE_VERSION) >= 3400
"            if has("autocmd")
"                au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
"                au InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
"                au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
"            endif
"        else
"            let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]12;black\x9c\<Esc>\\"
"            let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]12;red\x9c\<Esc>\\"
"        endif
"    elseif &term =~ "256-color"
"        if exists('$ITERM_PROFILE') || exists('$KONSOLE_DBUS_SESSION')
"            let &t_EI = "\<Esc>]50;CursorShape=0\x7"
"            let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"        else
"            let &t_EI = "\<Esc>]12;black\x9c"
"            let &t_SI = "\<Esc>]12;red\x9c"
"        endif
"    endif
"endif
