#!/bin/bash

# HOW TO USE:
# Run:
# CUSTOM_INSTALL_PATH=/home/user ./install_vimrc.sh

sudo curl -Lo "/usr/bin/nvim" https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
sudo chmod u+x "/usr/bin/nvim"

echo "Starting vimrc setup..."
[ -z "$CUSTOM_INSTALL_PATH" ] || CUSTOM_INSTALL_PATH="${HOME}"

sudo apt-get update
sudo apt-get install build-essential cmake neovim vim-nox curl python3-dev jq \
   mono-complete golang nodejs default-jdk npm -y

printf "Checking for .new_words..."

# _check for new_words
if [ -d "${HOME}/.new_words" ]; then
    ln -sf "${1}/.new_words/new_words" "${1}/.vim_runtime/new_words"
elif [ -d "${CUSTOM_INSTALL_PATH}/.new_words" ]; then
    ln -sf "${CUSTOM_INSTALL_PATH}/.new_words/new_words" "${HOME}/.vim_runtime/new_words"
else
    echo " Didn't find ${HOME}/.new_words"
fi

echo "Making undodir..."
mkdir -p "${HOME}/.vim/undodir"

echo "Curling vim plug"
if [ ! -f "${CUSTOM_INSTALL_PATH}/.local/share/nvim/site/autoload/plug.vim" ];
    then
    curl -fLo \
        "${CUSTOM_INSTALL_PATH}/.local/share/nvim/site/autoload/plug.vim" \
        --create-dirs \
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

    ln -sf "${CUSTOM_INSTALL_PATH}/.local/share/nvim" "${HOME}/.local/share/nvim"
fi

if (cat /etc/os-release | grep ID_LIKE | cut -d '=' -f2 | grep -q "debian"); then
    if (dpkg --print-architecture | grep -q arm) && [ ! -e ripgrep-13.0.0-arm-unknown-linux-gnueabihf ]; then
        # arm
        mkdir ripgrep-13.0.0-arm-unknown-linux-gnueabihf
        curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-arm-unknown-linux-gnueabihf.tar.gz"
        tar -xf "ripgrep-13.0.0-arm-unknown-linux-gnueabihf.tar.gz"
    elif (dpkg --print-architecture | grep -q amd); then
        # amd
        curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb"
        sudo dpkg -i "ripgrep_12.1.1_amd64.deb"
        rm "ripgrep_12.1.1_amd64.deb"
    else
        # try anyway
        sudo apt-get install fzf -y
    fi
else
    echo "OS not known. Did not install ripgrep."
fi
mkdir -p "${HOME}/.config/nvim/"{ftdetect,syntax}

ln -fs "${HOME}/.vim_runtime/vimrcs/ftdetect/elp.vim" \
    "${HOME}/.config/nvim/ftdetect/elp.vim"
ln -fs "${HOME}/.vim_runtime/vimrcs/syntax/elp.vim" \
    "${HOME}/.config/nvim/syntax/elp.vim"

echo "Setting up vimrc"
echo "set runtimepath+=${HOME}/.vim_runtime
source ${HOME}/.vim_runtime/vimrcs/plugins.vim
source ${HOME}/.vim_runtime/vimrcs/customcomplete.vim
" > "${HOME}/.vimrc"

echo "Setting up neovim"
mkdir -p "${HOME}/.config/nvim"
echo "set runtimepath^=${HOME}/.vim_runtime runtimepath+=${HOME}/.vim_runtime/after
let &packpath=&runtimepath
source ${HOME}/.vimrc" > "${HOME}/.config/nvim/init.vim"

echo "Installing Plugins..."
nvim +PlugInstall +qall

echo "source ${HOME}/.vim_runtime/vimrcs/basic.vim" >> "${HOME}/.vimrc"

echo "Installed dependencies for vim configuration successfully."
