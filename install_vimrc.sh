#!/bin/bash

set -e
echo "Starting vimrc setup..."

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

echo "curling plug.vim..."
if [ ! -d "~/.vim/autoload/plug.vim" ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo "set runtimepath+=~/.vim_runtime
source ~/.vim_runtime/vimrcs/plugins.vim
" > ~/.vimrc

echo "Installing Plugins..."

vim +PlugInstall +qall

echo "source ~/.vim_runtime/vimrcs/basic.vim" >> ~/.vimrc

echo "Installed dependencies for vim configuration successfully."
