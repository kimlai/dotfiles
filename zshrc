# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="af-magic"
DEFAULT_USER="kimlai"

# Aliases
alias cim="vim"
alias git='LANG=en_GB.utf8 git' # git in English, cause vim doesn't display the proper colors in French
alias rg="rgrep . -e "
alias tmux='env TERM="screen-256color" tmux' #make gnome-terminal, tmux, solarized and vim play nice together

# Tmuxinator
EDITOR='vim'
source ~/.local/bin/tmuxinator.zsh

# z
_Z_DATA=~/.zdata
. ~/.z/z.sh

# oh-my-zsh options
DISABLE_AUTO_TITLE="true" # disable autosetting terminal title.
COMPLETION_WAITING_DOTS="true" # red dots to be displayed while waiting for completion
plugins=(git virtualenv)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:~/.scripts

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
