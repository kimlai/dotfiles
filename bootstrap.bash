#!/usr/bin/env bash

release=$(lsb_release -c | cut -f 2)

# latest git
[[ -f "/etc/apt/sources.list.d/git-core-ppa-$release.list" ]] || sudo add-apt-reository -y ppa:git-core/ppa

sudo apt-get update
sudo apt-get install git vim zsh

chsh -s $(which zsh)

# oh my zsh
wget --no-check-certificate https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh

# z
git clone git@github.com:rupa/z ~/.z
