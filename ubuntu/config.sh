#! /bin/sh
#
# config.sh
# Copyright (C) 2018 Daniel Santiago <dspelaez@gmail.com>
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


# steps
# =====

# 1. install porgrams
#sudo apt update -y
#sudo apt upgrade -y

#sudo apt install wget git vim neovim tmux minicom imagemagick pandoc htop ffmpeg
#nodejs

#2. install conda


# 1. install xcode {{{
# ===============================
install_xcode () {
  clear
  if [[ "$(xcode-select -p)" == "" ]]; then
    printf "\nInstalling Xcode\n"
    xcode-select --install
  else
    printf "\nXcode Installed\n"
  fi
}
# --- }}}

# 2. homebrew {{{
# ===============================
install_homebrew () {
  clear
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

  # 3.2. install some apps
  # -------------------------------
  apps=(
    wget 
    git
    coreutils
    vim
    neovim
    tmux
    z
    fortune
    cowsay
    ranger
    minicom
    imagemagick
    pandoc
    markdown
    syncthing
    htop
    ffmpeg
    reattach-to-user-namespace
    m4
    node
    )

  printf "\nThe following formulae will be installed\n"
  printf '   - %s\n' "${apps[@]}"
  printf "\nContinue [y/n] "; read OK
  if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
  then
    continue
  else
    for app in "${apps[@]}"; do
      brew install ${app}
    done
  fi

  # 3.4. install some casks
  # -------------------------------
  apps=(
    firefox   
    google-chrome
    google-drive-file-stream
    google-earth-pro
    skim
    jabref
    spotify
    dropbox
    docker
    skype
    iterm2
    xquartz
    inkscape
    mactex
    )

  printf "\nThe following casks will be installed\n"
  printf '   - %s\n' "${apps[@]}"
  printf "\nContinue [y/n] "; read OK
  if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
  then
    printf "\n Exiting installation...\n"
    exit 0
  else
    for app in "${apps[@]}"; do
      brew cask install ${app}
    done
    brew cleanup
  fi
}
# --- }}}

# 3. install conda {{{
# ===============================
install_conda () {
  clear
  # TODO: Better ask for installing miniconda or anaconda
  printf "\nInstalling Miniconda? [y/n] "; read OK
  if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
  then
    printf "\n Exiting installation...\n"
    exit 0
  else
    wget -nc -nv https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
    bash ./Miniconda3-latest-MacOSX-x86_64.sh -s -b -p $HOME/.miniconda
    $HOME/.miniconda/bin/conda update -n base -c default conda
    # $HOME/.miniconda/bin/conda config --add channels conda-forge
  fi
}
# --- }}}

# 4. copy dotfiles {{{
# ==============================
copy_dotfiles () {
  printf "\nAdd dotfiles [y/n] "; read OK
  if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
  then
    printf "\n Exiting installation...\n"
    exit 0
  else
    #
    # git configuration
    git config --global user.name "Daniel Santiago"
    git config --global user.email dspelaez@gmail.com
    #
    # clone repository and copy files to $HOME
    rm -rf dotfiles
    git clone https://github.com/dspelaez/dotfiles.git
    cd dotfiles && cp -r dotfiles $HOME/.dotfiles
    #
    # make symbolic links
    mkdir -p $HOME/.matplotlib
    ln -sf $HOME/.dotfiles/profile $HOME/.profile
    ln -sf $HOME/.dotfiles/latexmk $HOME/.latexmk
    ln -sf $HOME/.dotfiles/tmux.conf $HOME/.tmux.conf
    ln -sf $HOME/.dotfiles/matplotlibrc $HOME/.matplotlib/matplotlibrc
    cd ..

  fi
}
# --- }}}

# 5. vim neovim, tmux conf {{{
# ==============================
config_vim () {

  # vim-plug for neovim
  if [ ! -e ~/.config/nvim/autoload/plug.vim ]; then
    printf "\nInstalling vim-plug for neovim"
    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
  
  # vim-plug for vim
  if [ ! -e ~/.vim/autoload/plug.vim ]; then
    printf "\nInstalling vim-plug for vim"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  # copy dotfiles
  printf "\nCopy dotfiles\n";
  ln -sf $HOME/.dotfiles/vimrc $HOME/.vimrc
  ln -sf $HOME/.dotfiles/init.vim $HOME/.config/nvim/init.vim

  # solarized color
  mkdir -p $HOME/.vim/colors
  wget -nc -nv https://raw.githubusercontent.com/flazz/vim-colorschemes/master/colors/solarized.vim \
    -O $HOME/.vim/colors/solarized.vim
  
  # create virtual environment including neovim and jedi
  # TODO: include flake8 or pylint or something
  printf "\nCreating virtual environment for neovim\n";
  $HOME/.miniconda/bin/conda create -n neovim python=3.6.5
  $HOME/.miniconda/bin/conda install -c conda-forge -n neovim neovim jedi unidecode

  # config neovim and vim
  nvim +PlugInstall +PlugUpgrade +PlugUpdate +PlugClean! +UpdateRemotePlugins +qall
  vim +PlugInstall +PlugUpgrade +PlugUpdate +PlugClean! +UpdateRemotePlugins +qall

  # config tmux
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  tmux source $HOME/.tmux.conf

  # install some fonts
  brew tap caskroom/fonts
  brew cask install font-source-code-pro font-inconsolata
}
# --- }}}

# 6. change default shell by zsh {{{
# ===============================
config_zsh () {
  printf "\nInstalling oh-my-zsh?\n"
  #
  # download ohmyzsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  #
  # add .profile to .zshrc
  echo "" >> $HOME/.zshrc
  echo "source $HOME/.profile" >> $HOME/.zshrc
}
# --- }}}



# parse the arguments to execute the program
# ===========================================

printf "\nSetting up you OSX\n"
printf "\nConitnue? [y/n] "; read OK
if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
then
  printf "\n Exiting installation...\n"
  exit 0
else

  # create main directory
  mkdir -p $HOME/tmp/
  cd $HOME/tmp

  # parse the argument
  arg=$1

  # install each part separately
  if [ $arg == "xcode" ]; then
    install_xcode
  #
  elif [ $arg == "homebrew" ]; then
    install_homebrew
  #
  elif [ $arg == "conda" ]; then
    install_conda
  #
  elif [ $arg == "dotfiles" ]; then
    copy_dotfiles
  #
  elif [ $arg == "vim" ]; then
    config_vim
  #
  elif [ $arg == "zsh" ]; then
    config_zsh
  #
  elif [ $# -eq 0 ]; then
    install_xcode
    install_homebrew
    install_conda
    copy_dotfiles
    config_vim
    config_zsh
  #
  else
    printf "\n Invalid argument. Exiting installation...\n"
    exit 0
  #
  fi

fi
# cd ../ && rm -rf tmp

# --- end of file ---
