#! /bin/sh
#
# symlink.sh
# Copyright (C) 2018 Daniel Santiago <dspelaez@gmail.com>
#
# Distributed under terms of the GNU/GPL license.


DOTFILES=$HOME/.dotfiles
CONFIG=$HOME/.config

#mkdir -p $CONFIG/{matplotlib,nvim/{spell,templates,ultisnips},tmuxinator}
mkdir -p $CONFIG/nvim $HOME/.matplotlib

# latex
ln -sf $DOTFILES/latex/latexmkrc $HOME/.latexmkrc

# python 
ln -sf $DOTFILES/python/condarc $HOME/.condarc
ln -sf $DOTFILES/python/matplotlibrc $HOME/.matplotlib/matplotlibrc

# shell
ln -sf $DOTFILES/shell/gitconfig $HOME/.gitconfig
ln -sf $DOTFILES/shell/zshrc $HOME/.zshrc
ln -sf $DOTFILES/shell/starship.toml $CONFIG/starship.toml

# vim
ln -sf $DOTFILES/vim/init.vim $CONFIG/nvim/init.vim
ln -sf $DOTFILES/vim/spell $CONFIG/nvim/spell
ln -sf $DOTFILES/vim/templates $CONFIG/nvim/
ln -sf $DOTFILES/vim/ultisnips $CONFIG/nvim/

# tmux
ln -sf $DOTFILES/tmux/tmux.conf $HOME/.tmux.conf
ln -sf $DOTFILES/tmux/tmuxinator $CONFIG/
