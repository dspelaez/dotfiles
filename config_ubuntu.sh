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
#      curl https://raw.githubusercontent.com/dspelaez/dotfiles/master/config_ubuntu.sh -o config.sh
#      [sudo] sh ./config.sh 
#
#   Author:
#     Daniel Santiago
#     github/dspelaez
# ===================================================================


# 1. preliminary steps {{{
# ===============================
update_system () {
  clear
  printf "\nUpdating operating system\n"
  sudo apt -y update
  sudo apt -y upgrade
}
# --- }}}

# 2. install packages {{{
# ===============================
install_packages () {
  clear

  # 2.1. install some apps
  # -------------------------------
  apps=(
    wget 
    git
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
    nodejs
    zsh
    openssh-client
    openssh-server
    gnome-tweaks
    ubuntu-restricted-extras
    )

  printf "\nThe following apps will be installed\n"
  printf '   - %s\n' "${apps[@]}"
  printf "\nContinue [y/n] "; read OK
  if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
  then
    continue
  else
    for app in "${apps[@]}"; do
      sudo apt install -y ${app}
    done
  fi

  # 2.2. install some snaps
  # -------------------------------
  #apps=(
    #brave-browser
    #skim
    #spotify
    #dropbox
    #google-backup-and-sync
    #google-drive-file-stream
    #docker
    #iterm2
    #inkscape
    #mactex
    #)

  #printf "\nThe following casks will be installed\n"
  #printf '   - %s\n' "${apps[@]}"
  #printf "\nContinue [y/n] "; read OK
  #if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
  #then
    #printf "\n Exiting installation...\n"
    #exit 0
  #else
    #for app in "${apps[@]}"; do
      #snap install ${app}
    #done
  #fi
}
# --- }}}

# 3. install conda {{{
# ===============================
install_conda () {

  printf "\nInstalling Miniconda? [y/n] "; read OK
  if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
  then
    printf "\n Exiting installation...\n"
    exit 0
  else
    wget -nc -nv https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash ./Miniconda3-latest-Linux-x86_64.sh -s -b -p $HOME/.miniconda
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
    git clone https://github.com/dspelaez/dotfiles.git .dotfiles
    #
    # make symbolic links
    cd .dotfiles
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

printf "\nSetting up your Ubuntu\n"
printf "\nConitnue? [y/n] "; read OK
if [ "$OK" != "Y" ] && [ "$OK" != "y" ]
then
  printf "\n Exiting installation...\n"
  exit 0
else

  # parse the argument
  arg=$1

  # install each part separately
  if [ $arg == "update" ]; then
    update_system
  #
  elif [ $arg == "packages" ]; then
    install_packages
  #
  elif [ $arg == "conda" ]; then
    install_conda
  #
  elif [ $arg == "shell" ]; then
    config_zsh
  #
  elif [ $arg == "dotfiles" ]; then
    copy_dotfiles
  #
  elif [ $arg == "vim" ]; then
    config_vim
  #
  elif [ $# -eq 0 ]; then
    update_system
    install_packages
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
