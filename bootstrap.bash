#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y git vim zsh tmux tig httpie

#zsh
chsh -s $(which zsh)
wget --no-check-certificate https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh

##dotfiles
DOTFILES_DIR=$HOME/Code/dotfiles
mkdir -p $DOTFILES_DIR
git clone https://github.com/kimlai/dotfiles.git $DOTFILES_DIR

for configFile in $(ls -I bootstrap.bash -I rcrc -I README.md $DOTFILES_DIR)
do
    ln -snf $DOTFILES_DIR/$configFile .$configFile
done

##vim
git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
