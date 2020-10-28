#!/bin/bash

set -xe

#if [ -d ~/.vim ]; then
#    rm -r ~/.vim
#fi

#mkdir ~/.vim
mkdir -p ~/.vim/undodir

echo "Installed vim configuration successfully."

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "set runtimepath+=~/.vim_runtime
source ~/.vim_runtime/vimrcs/basic.vim
" > ~/.vimrc


vim +PlugInstall +qall

pushd ~/.vim/plugged/YouCompleteMe
./install.py --all
popd
