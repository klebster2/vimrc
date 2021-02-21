#!/bin/bash

set -xe
echo "Starting vimrc setup..."

mkdir -p ~/.vim/undodir

if [ ! -d "~/.vim/autoload/plug.vim" ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo "set runtimepath+=~/.vim_runtime
source ~/.vim_runtime/vimrcs/plugins.vim
" > ~/.vimrc

vim +PlugInstall +qall

echo "source ~/.vim_runtime/vimrcs/basic.vim
" >> ~/.vimrc

echo "Installed dependencies for vim configuration successfully."
