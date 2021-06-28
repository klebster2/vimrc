#!/bin/bash
set -xe
echo "Starting vimrc setup..."

#sudo apt-get update 
sudo apt-get install build-essential cmake neovim curl python3-dev jq -y

printf "Checking for ~/.new_words..."
if [ -d ~/.new_words ]; then
    echo " Found ~/.new_words"
    printf "Checking for ~/.vim_runtime/new_words symlink..."
    if [ ! -f ~/.vim_runtime/new_words ]; then
        echo " Didn't find symbolic link... making symlink"
        ln -s ~/.new_words/new_words ~/.vim_runtime/new_words
    else
        echo " Found symlink."
    fi
else
    echo " Didn't find ~/.new_words"
fi


echo "Making undodir..."
mkdir -p ~/.vim/undodir

echo "curling vim plug"
if [ ! -f "~/.vim/autoload/plug.vim" ]; then
    curl -fLo ${HOME}/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if (cat /etc/os-release | grep ID_LIKE | cut -d '=' -f2 | grep -q "debian"); then
    if (dpkg --print-architecture | grep -q arm) && [ ! -e ripgrep-13.0.0-arm-unknown-linux-gnueabihf ]; then
        mkdir ripgrep-13.0.0-arm-unknown-linux-gnueabihf
        curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-arm-unknown-linux-gnueabihf.tar.gz"
        tar -xf "ripgrep-13.0.0-arm-unknown-linux-gnueabihf.tar.gz"
    elif (dpkg --print-architecture | grep -q amd); then
        sudo apt-get install fzf -y
        curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb"
        sudo dpkg -i "ripgrep_12.1.1_amd64.deb"
        rm "ripgrep_12.1.1_amd64.deb"
    fi
else
    echo "OS not known. Did not install ripgrep."
fi
mkdir -p $HOME/.config/nvim/{ftdetect,syntax}

ln -s $HOME/.vim_runtime/vimrcs/ftdetect/elp.vim $HOME/.config/nvim/ftdetect/elp.vim
ln -s $HOME/.vim_runtime/vimrcs/syntax/elp.vim $HOME/.config/nvim/syntax/elp.vim

echo "setting up vim"
echo "set runtimepath+=~/.vim_runtime
source ~/.vim_runtime/vimrcs/plugins.vim" > ~/.vimrc

echo "setting up neovim"
mkdir -p ~/.config/nvim
echo "set runtimepath^=~/.vim_runtime runtimepath+=~/.vim_runtime/after
let &packpath=&runtimepath
source ~/.vimrc" > ~/.config/nvim/init.vim

echo "Installing Plugins..."

nvim +PlugInstall +qall

echo "source ~/.vim_runtime/vimrcs/basic.vim" >> ~/.vimrc

echo "Installed dependencies for vim configuration successfully."
