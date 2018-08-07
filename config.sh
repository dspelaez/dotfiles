#! /bin/sh
#
# config.sh
# Copyright (C) 2018 Daniel Santiago <dpelaez@cicese.edu.mx>
#
# Distributed under terms of the GNU/GPL license.
#

# ===================================================================
#   Setting up OSX for scientific use
# -------------------------------------------------------------------
#     Daniel Santiago
#     github/dspelaez
# ===================================================================

set -e

# 0. set env variables and dirs
# ===============================
mkdir $HOME/tmp/
cd $HOME/tmp


# 1. install xcode and x11
# ===============================
if [[ "$(xcode-select -p)" == "" ]]; then
  printf "\nInstalling Xcode\n"
  xcode-select --install
fi


# 2. change default shell by zsh
# ===============================


# 3. homebrew
# ===============================
if ! command -v brew > /dev/null 2>&1; then
  printf "\nInstalling Homebrew\n"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# 3.1. update homebrew
# -------------------------------
brew update
brew update
brew upgrade

# 3.2. install some taps
# -------------------------------
brew install vim neovim tmux z fortune cowsay coreutiles \
             imagemagick pandoc markdown syncthing htop  \
             ffmpeg reattach-to-user-namespace m4 ranger \
             node git wget 

# 3.4. install some casks
# -------------------------------
apps=(
  google-chrome
  google-drive-file-stream
  google-earth-pro
  firefox   
  spotify
  dropbox
  vlc
  skype
  iterm2
  mactex
  inkscape
  )
brew cask install --force --appdir="/Applications" ${apps[@]}
brew cleanup


# 5. install anaconda
# ===============================
wget -nc https://repo.anaconda.com/archive/Anaconda3-5.2.0-MacOSX-x86_64.sh
sh ./Anaconda3-5.2.0-MacOSX-x86_64.sh -p /usr/local/anaconda

# 5.1 install netcdf and cartopy
# ------------------------------
/usr/local/anaconda/bin/conda install netCDF4 cartopy


# 7. copy dotfiles
# ==============================

# git configuration
git config --global user.name "Daniel Santiago"
git config --global user.email dspelaez@gmail.com

# clone repository
git clone ...

# make symbolic links
cp -r dotfiles $HOME/.dotfiles
ln -sf $HOME/.dotfiles/latexmk $HOME/.latexmk
ln -sf $HOME/.dotfiles/matplotlibrc $HOME/.matplotlib/matplotlibrc


# 8. vim neovim, tmux conf
# ==============================

# vim-plug for neovim
if [ ! -e ~/.config/nvim/autoload/plug.vim ]; then
  printf "\nInstalling vim-plug"
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
ln -sf $HOME/.dotfiles/vimrc $HOME/.vimrc
ln -sf $HOME/.dotfiles/init.vim $HOME/.config/nvim/init.vim
nvim +PlugInstall +PlugUpgrade +PlugUpdate +PlugClean! +UpdateRemotePlugins +qall


# clean up
# ==============================
cd ../
rm -rf tmp



# --- end of file ---
