# history configuration
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE # ignore commands that begin with space
setopt APPEND_HISTORY    # all zsh instaces append to .zsh_history
setopt EXTENDED_HISTORY  # add timestamps to .zsh_history
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

# cd without typing cd
setopt AUTO_CD

# Make alt-h work on shell builtins.
if [[ -d "$HOME/.zsh/help" ]]; then
    unalias run-help
    autoload run-help
    HELPDIR=$HOME/.zsh/help
fi

# Force tmux to use 256 colors
alias tmux='tmux -2'

# Make ctrl-s forward history search instead of stopping tty flow
setopt NO_FLOW_CONTROL

# Report background job completion immediately.
setopt NOTIFY

# Use emacs keybindings for line editing.
autoload -U select-word-style && select-word-style bash
bindkey -e
bindkey '^[f' emacs-forward-word # default (forward-word) skips to next word

# Let us see what !! and friends is about to do.
bindkey ' ' magic-space

# autocompletion
autoload -Uz compinit && compinit

# make "source" and "." *not* look in PATH
# technically this breaks POSIX for "."
my_source_completer() {
    if [[ CURRENT -ge 3 ]]; then
        compset -n 2
        _normal
    else
        _files
    fi
}
compdef my_source_completer source .

# detect Linux/OS X
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
    platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
    platform='osx'
fi

# get colored "ls" output
if [[ $platform == 'linux' ]]; then
    alias ls="ls -F --color"
elif [[ $platform == 'osx' ]]; then
    export CLICOLOR=1
    export LSCOLORS='exfxcxdxcxegedabagacad'
    alias ls="ls -F"
fi

# get colored tab-complete lists
LS_COLORS='rs=0:di=34:ln=36:mh=00:pi=40;33:so=35:do=35:bd=40;33:cd=40;33:or=40;31:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=32:'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# make tab-completion bash-like
#setopt BASH_AUTO_LIST # list after two tabs
setopt NO_AUTO_MENU    # don't cycle through options
#setopt NO_ALWAYS_LAST_PROMPT  # return to prompt after listing

# see if we have a zsh _git completion file already
if [ -f /usr/local/share/zsh/site-functions/_git ]; then
    fpath=(/usr/local/share/zsh/site-functions $fpath)
else
    # look for git-completion script
    for file (
        $HOME/.git-completion.sh
        /usr/share/git-core/git-completion.bash
        /usr/share/git/completion/git-completion.bash
        )
    do
        if [ -f $file ]; then
            source $file
            break
        fi
    done
fi

# if we can find git-prompt.sh, sets $gitps1 for inclusion in PS1 below
function add_git_ps1() {
    for file (
        $HOME/.git-prompt.zsh
        /etc/bash_completion.d/git-prompt
        /usr/local/etc/bash_completion.d/git-prompt.sh
        /usr/share/git/completion/git-prompt.sh
        /usr/share/git-core/git-prompt.sh
        )
    do
        if [ -f $file ]; then
            export GIT_PS1_SHOWSTASHSTATE=1
            export GIT_PS1_SHOWDIRTYSTATE=1
            export GIT_PS1_SHOWUNTRACKEDFILES=1
            export GIT_PS1_SHOWUPSTREAM=auto
            source $file
            gitps1='%F{cyan}$(__git_ps1 " (%s)")%f'
            break
        fi
    done
}
add_git_ps1
unfunction add_git_ps1 # cleanup shell function namespace

# set up prompt
setopt PROMPT_SUBST
PS1=''

# Put $PWD in our urxvt window title - need extra escape for tmux
if [ -n "${TMUX+x}" ]; then
    PS1=$'%{\033Ptmux;\033\033]0;%/\007\033\\%}'
else
    PS1=$'%{\033]0;%/\007%}'
fi

# normal prompt stuff
PS1+="[%F{blue}%! %F{green}%n@%m%f %3~${gitps1}]%# "
export PS1

# prevent duplicate PATH entries
declare -U path

# look for go
if [[ -d /usr/local/go/bin ]]; then
    path=($path /usr/local/go/bin)
fi
if [[ -d $HOME/gocode ]]; then
    export GOPATH=$HOME/gocode
fi

# look for ~/bin
if [[ -d $HOME/bin ]]; then
    path=($path $HOME/bin)
fi

# look for Postgres.app
if [[ -d /Applications/Postgres.app/Contents/MacOS/bin ]]; then
    path=(/Applications/Postgres.app/Contents/MacOS/bin $path)
fi

# look for homebrew
if [[ -d /usr/local ]]; then
    path=(/usr/local/bin /usr/local/sbin $path)
    export MANPATH=/usr/local/share/man:$MANPATH
    if [[ -d /usr/local/share/npm/bin ]]; then
        path=($path /usr/local/share/npm/bin)
    fi
fi

# look for homebrew's llvm
if [[ -d /usr/local/opt/llvm/bin ]]; then
    path=(/usr/local/opt/llvm/bin $path)
fi

# look for multirust
if [[ -d $HOME/multirust/bin ]]; then
    path=($HOME/multirust/bin $path)
fi
#if [[ -d /usr/local/lib/rustlib/x86_64-apple-darwin/lib ]]; then
#    export DYLD_LIBRARY_PATH=/usr/local/lib/rustlib/x86_64-apple-darwin/lib:$DYLD_LIBRARY_PATH
#fi

# look for rubygem binaries
if [[ -d /usr/local/opt/ruby/bin ]]; then
    path=(/usr/local/opt/ruby/bin $path)
fi

# configure rbenv
if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi

# look for raspberry pi cross compile tools
if [[ -d $HOME/pi-tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin ]]; then
    path=($path $HOME/pi-tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin)
fi

# look for macvim
if [[ -f /usr/local/bin/mvim ]]; then
    alias vim='mvim -v'
fi

# look for mysql
if [[ -d /usr/local/mysql/bin ]]; then
    path=($path /usr/local/mysql/bin)
fi

# look for `cargo install`'d binaries
if [[ -d $HOME/.multirust/toolchains/nightly/cargo/bin ]]; then
    path=($path $HOME/.multirust/toolchains/nightly/cargo/bin)
fi

# generic environment
export EDITOR=vim
export PAGER=less
export LESS=-r

# attach to running xcode
xcode-debug() {
    lldb -p `ps aux | grep 'Xcode$' | grep -v grep | awk '{print $2}'`
}

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh
