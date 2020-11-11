#!/bin/bash

set -xe
echo "Starting vimrc setup..."
mkdir -p ~/.vim/undodir


curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "set runtimepath+=~/.vim_runtime
source ~/.vim_runtime/vimrcs/basic.vim
" > ~/.vimrc

vim +PlugInstall +qall

pushd ~/.vim/plugged/YouCompleteMe
./install.py --all
popd

echo "Installed dependencies for vim configuration successfully."
