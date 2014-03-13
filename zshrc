# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="af-magic"
DEFAULT_USER="kimlai"

# Solarized ls
[[ -f ~/.dircolors ]] && eval `dircolors ~/.dircolors`

# Tmuxinator
EDITOR='vim'
[[ -f ~/.local/bin/tmuxinator.zsh ]] && source ~/.local/bin/tmuxinator.zsh

# oh-my-zsh options
DISABLE_AUTO_TITLE="true" # disable autosetting terminal title.
COMPLETION_WAITING_DOTS="true" # red dots to be displayed while waiting for completion
plugins=(git virtualenv z debian vagrant)

source $ZSH/oh-my-zsh.sh

ZSH_THEME_GIT_PROMPT_PREFIX="$FG[075]("

# Aliases
alias cim="vim"
alias git='LANG=en_GB.utf8 git' # git in English, cause vim doesn't display the proper colors in French
alias rg="rgrep . -e "
alias tmux='env TERM="screen-256color" tmux' #make gnome-terminal, tmux, solarized and vim play nice together

unalias please
funtion please() {
    last_command=$history[$[HISTCMD-1]]
    eval sudo $last_command
}
alias plz='please'

# cat, but with colors !
function pygmentize_cat {
    for arg in "$@"; do
        pygmentize -g "${arg}" 2> /dev/null || /bin/cat "${arg}"
    done
}
command -v pygmentize > /dev/null && alias cat=pygmentize_cat

# Customize to your needs...
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:~/.scripts

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Allow local modifications in ~/.zshrc.local
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
