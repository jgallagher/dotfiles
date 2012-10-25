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

# if we have git-completion, sets $gitps1 for inclusion in PS1 below
function add_git_ps1() {
    for file (
        /usr/share/git/completion/git-completion.bash
        /usr/share/git-core/git-completion.bash
        $HOME/.git-completion.sh
        )
    do
        if [ -f $file ]; then
            export GIT_PS1_SHOWSTASHSTATE=1
            export GIT_PS1_SHOWDIRTYSTATE=1
            source $file
            gitps1='%F{cyan}$(__git_ps1 " (%s)")%f'
            return
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

# look for homebrew
if [[ -d /usr/local ]]; then
    path=(/usr/local/bin /usr/local/sbin $path)
    export MANPATH=$MANPATH:/usr/local/share/man
fi

# look for Postgres.app
if [[ -d /Applications/Postgres.app/Contents/MacOS/bin ]]; then
    path=(/Applications/Postgres.app/Contents/MacOS/bin $path)
fi

# look for macvim
if [[ -f /usr/local/bin/mvim ]]; then
    alias vim='mvim -v'
fi

# generic environment
export EDITOR=vim
export PAGER=less
export LESS=-r
