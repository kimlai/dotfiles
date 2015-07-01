# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="af-magic"
DEFAULT_USER="kimlai"

# Solarized ls
[[ -f ~/.dircolors ]] && eval `dircolors ~/.dircolors`

# Tmuxinator
EDITOR='vim'

# oh-my-zsh options
DISABLE_AUTO_TITLE="true" # disable autosetting terminal title.
COMPLETION_WAITING_DOTS="true" # red dots to be displayed while waiting for completion
plugins=(git z)

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

# Customize to your needs...
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:~/.scripts

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Allow local modifications in ~/.zshrc.local
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
