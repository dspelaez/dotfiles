#! /bin/sh
#
# symlink.sh
# Copyright (C) 2018 Daniel Santiago <dspelaez@gmail.com>
#
# Distributed under terms of the GNU/GPL license.


DOTFILES=$HOME/.dotfiles
CONFIG=$HOME/.config

# latex
ln -sf $DOTFILES/latex/latexmkrc $HOME/.latexmkrc

# python 
ln -sf $DOTFILES/python/condarc $HOME/.condarc
ln -sf $DOTFILES/python/matplotlibrc $CONFIG/matplotlib/matplotlibrc

# shell
ln -sf $DOTFILES/shell/gitconfig $HOME/.gitconfig
ln -sf $DOTFILES/shell/zshrc $HOME/.zshrc

# tmux
ln -sf $DOTFILES/tmux/tmux.conf $HOME/.tmux.conf
ln -sf $DOTFILES/tmux/tmuxinator $CONFIG/

# vim
ln -sf $DOTFILES/vim/init.vim $CONFIG/nvim/init.vim
ln -sf $DOTFILES/vim/spell $CONFIG/nvim/spell
ln -sf $DOTFILES/vim/templates $CONFIG/nvim/
ln -sf $DOTFILES/vim/ultisnips $CONFIG/nvim/

