#! /bin/sh
#
# config.sh
# Copyright (C) 2018 Daniel Santiago <dspelaez@gmail>
#
# Distributed under terms of the GNU/GPL license.
#

# ===================================================================
#   Setting up Ubuntu for scientific use
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
    gcc
    vim
    neovim
    tmux
    tmuxinator
    imagemagick
    pandoc
    markdown
    htop
    ffmpeg
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
    brave-browser
    skim
    spotify
    dropbox
    google-backup-and-sync
    google-drive-file-stream
    docker
    iterm2
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
    $HOME/.miniconda/bin/conda config --add channels conda-forge
  fi
}
# --- }}}

# 4. change default shell by zsh {{{
# ===============================
config_zsh () {
  printf "\nInstalling Oh-my-zsh? [y/n] "; read OK
  if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
  then
    printf "\n Exiting installation...\n"
    exit 0
  else
    #
    # download oh-my-zsh and spaceship
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    curl -fsSL https://starship.rs/install.sh | bash
    #
  fi
}
# --- }}}

# 5. copy dotfiles {{{
# ==============================
copy_dotfiles () {
  printf "\nAdd dotfiles [y/n] "; read OK
  if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
  then
    printf "\n Exiting installation...\n"
    exit 0
  else
    #
    # clone repository and copy files to $HOME
    rm -rf $HOME/dotfiles
    git clone https://github.com/dspelaez/dotfiles.git
    cd dotfiles && cp -r dotfiles $HOME/.dotfiles
    #
    # make symbolic links
    sh ./symlink.sh
    cd $HOME
  fi
}
# --- }}}

# 6. config neovim and tmux {{{
# ==============================
config_vim () {
  printf "\nConfig neovim? [y/n] "; read OK
  if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
  then
    printf "\n Exiting installation...\n"
    exit 0
  else
    #
    # create virtual environment including neovim and jedi
    # TODO: include flake8 or pylint or something
    printf "\nCreating virtual environment for neovim\n";
    $HOME/.miniconda/bin/conda create -n neovim python=3.8
    $HOME/.miniconda/bin/conda install -c conda-forge -n neovim neovim jedi unidecode

    # config neovim and vim
    nvim +PlugInstall +PlugUpgrade +PlugUpdate +PlugClean! +UpdateRemotePlugins +qall
    vim +PlugInstall +PlugUpgrade +PlugUpdate +PlugClean! +UpdateRemotePlugins +qall
  fi

  printf "\nConfig tmux & tmuxinator? [y/n] "; read OK
  if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
  then
    printf "\n Exiting installation...\n"
    exit 0
  else
    # config tmux
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    tmux source $HOME/.tmux.conf
  fi
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
  elif [ $arg == "zsh" ]; then
    config_zsh
  #
  elif [ $arg == "dotfiles" ]; then
    copy_dotfiles
  #
  elif [ $arg == "vim" ]; then
    config_vim
  #
  elif [ $# -eq 0 ]; then
    install_xcode
    install_homebrew
    install_conda
    config_zsh
    copy_dotfiles
    config_vim
  #
  else
    printf "\n Invalid argument. Exiting installation...\n"
    exit 0
  #
  fi

fi
# cd ../ && rm -rf tmp

# --- end of file ---
