#!/bin/bash
echo "Starting vimrc setup..."

#sudo apt-get update
sudo apt install build-essential cmake vim-nox python3-dev
sudo apt-get install jq mono-complete golang nodejs default-jdk npm -y

printf "Checking for ${HOME}/.new_words..."
if [ -d "${HOME}/.new_words" ]; then
    echo " Found ${HOME}/.new_words"
    printf "Checking for ${HOME}/.vim_runtime/new_words symlink..."
    if [ ! -f "${HOME}/.vim_runtime/new_words" ]; then
        echo " Didn't find symbolic link... making symlink"
        ln -s "${HOME}/.new_words/new_words" "${HOME}/.vim_runtime/new_words"
    else
        echo " Found symlink."
    fi
else
    echo " Didn't find ${HOME}/.new_words"
fi


echo "Making undodir..."
mkdir -p "${HOME}/.vim/undodir"

echo "curling vim plug"
if [ ! -f "${HOME}/.local/share/nvim/site/autoload/plug.vim" ]; then
    curl -fLo "${HOME}/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
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

echo "Setting up vim"
echo "set runtimepath+=${HOME}/.vim_runtime
source ${HOME}/.vim_runtime/vimrcs/plugins.vim
source ${HOME}/.vim_runtime/vimrcs/customcomplete.vim
" > "${HOME}/.vimrc"

echo "Setting up neovim"
mkdir -p "${HOME}/.config/nvim"
echo "set runtimepath^=${HOME}/.vim_runtime runtimepath+=${HOME}/.vim_runtime/after  runtimepath+=${HOME}/.vim
let &packpath=&runtimepath
source ${HOME}/.vimrc" > "${HOME}/.config/nvim/init.vim"

echo "Installing Plugins..."
vim +PlugInstall +qall
nvim +PlugInstall +qall

# YCM
pushd ${HOME}/.vim/plugged/YouCompleteMe
git submodule update --init --recursive
CXX="$(whereis c++ | cut -d ' ' -f 2)" ./install.py --clangd-completer
#popd
#EXTRA_CMAKE_ARGS=-DPATH_TO_LLVM_ROOT=/path/to/your/build/clang ./install.py
popd

echo "source ${HOME}/.vim_runtime/vimrcs/basic.vim" >> "${HOME}/.vimrc"

echo "Installed dependencies for vim configuration successfully."
