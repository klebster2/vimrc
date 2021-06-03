#!/bin/bash
set -e
echo "Starting vimrc setup..."

sudo apt-get update 
sudo apt-get install build-essential cmake neovim curl python3-dev jq fzf \
    ripgrep -y

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
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo "neovim creating plug symlink for neovim"
if [ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]; then 
    ln -s "~/.vim/autoload/plug.vim" \
        "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
fi


if $(cat /etc/os-release | grep ID_LIKE | cut -d '=' -f2 | grep -q "debian"); then
    curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb"
    sudo dpkg -i "ripgrep_12.1.1_amd64.deb"
    rm "ripgrep_12.1.1_amd64.deb"
else
    echo "OS not known. Did not install ripgrep."
fi

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
