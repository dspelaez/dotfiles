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
#
#   Usage:
#      curl https://raw.githubusercontent.com/dspelaez/dotfiles/master/config.sh -o config.sh
#      sh ./config.sh 
#
#   Author:
#     Daniel Santiago
#     github/dspelaez
# ===================================================================


# 1. set env variables and dirs
# ===============================

# starting
clear
printf "\nSetting up your OSX\n"
printf "\nContinue? [y/n] "; read OK
if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
then
  printf "\n Exiting installation...\n"
  exit 0
fi

# create main directory
mkdir -p $HOME/tmp/
cd $HOME/tmp


# 2. install xcode
# ===============================
if [[ "$(xcode-select -p)" == "" ]]; then
  printf "\nInstalling Xcode\n"
  xcode-select --install
else
  printf "\nXcode Installed\n"
fi

# 3. homebrew
# ===============================
if ! command -v brew > /dev/null 2>&1; then
  printf "\nInstalling Homebrew\n"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  printf "\nHomebrew Installed\n"
fi

# 3.1. update homebrew
# -------------------------------
printf "\nUpdating Homebrew\n"
brew update 
brew update
brew upgrade

# 3.2. install some taps
# -------------------------------
taps=(
  vim
  neovim
  tmux
  z
  fortune
  cowsay
  ranger
  coreutils
  minicom
  imagemagick
  pandoc
  markdown
  syncthing
  htop
  ffmpeg
  reattach-to-user-namespace
  m4
  python
  node
  git
  wget 
  )

printf "\nThe following taps will be installed\n"
printf '   - %s\n' "${taps[@]}"
printf "\nContinue [y/n] "; read OK
if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
then
  printf "\n Exiting installation...\n"
  exit 0
else
  brew install ${taps[@]}
fi

# 3.4. install some casks
# -------------------------------
apps=(
  google-chrome
  google-drive-file-stream
  google-earth-pro
  skim
  jabref
  firefox   
  spotify
  dropbox
  docker
  skype
  iterm2
  mactex
  inkscape
  )

printf "\nThe following casks will be installed\n"
printf '   - %s\n' "${apps[@]}"
printf "\nContinue [y/n] "; read OK
if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
then
  printf "\n Exiting installation...\n"
  exit 0
else
  brew cask install --force --appdir="/Applications" ${apps[@]}
  brew cleanup
fi


# 4. install anaconda
# ===============================
printf "\nInstalling Anaconda 5.2? [y/n] "; read OK
if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
then
  printf "\n Exiting installation...\n"
  exit 0
else
  wget -nc -nv https://repo.anaconda.com/archive/Anaconda3-5.2.0-MacOSX-x86_64.sh
  sudo sh ./Anaconda3-5.2.0-MacOSX-x86_64.sh -s -b -p /usr/local/anaconda
  /usr/local/anaconda/bin/conda install netCDF4 cartopy pyserial
fi


# 5. copy dotfiles
# ==============================

printf "\nAdd dotfiles [y/n] "; read OK
if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
then
  printf "\n Exiting installation...\n"
  exit 0
fi

# git configuration
git config --global user.name "Daniel Santiago"
git config --global user.email dspelaez@gmail.com

# clone repository and copy files to $HOME
git clone https://github.com/dspelaez/dotfiles.git
cd dotfiles && cp -r dotfiles $HOME/.dotfiles

# make symbolic links
ln -sf $HOME/.dotfiles/profile $HOME/.profile
ln -sf $HOME/.dotfiles/latexmk $HOME/.latexmk
ln -sf $HOME/.dotfiles/matplotlibrc $HOME/.matplotlib/matplotlibrc
cd ..


# 6. vim neovim, tmux conf
# ==============================

# vim-plug for neovim
if [ ! -e ~/.config/nvim/autoload/plug.vim ]; then
  printf "\nInstalling vim-plug"
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
/usr/local/bin/pip install neovim
ln -sf $HOME/.dotfiles/vimrc $HOME/.vimrc
ln -sf $HOME/.dotfiles/init.vim $HOME/.config/nvim/init.vim
nvim +PlugInstall +PlugUpgrade +PlugUpdate +PlugClean! +UpdateRemotePlugins +qall


# 7. change default shell by zsh
# ===============================
printf "\nInstalling oh-my-zsh? [y/n] "; read OK
if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
then
  printf "\n Exiting installation...\n"
  exit 0
else
  #
  # download ohmyzsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  #
  # add .profile to .zshrc
  echo "" >> $HOME/.zshrc
  echo "source $HOME/.profile" >> $HOME/.zshrc
fi


# 8. clean up
# ==============================
cd ../ && rm -rf tmp

# --- end of file ---
