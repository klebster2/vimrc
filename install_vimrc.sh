#!/bin/bash

set -xe
echo "Starting vimrc setup..."

mkdir -p ~/.vim/undodir

if [ ! -d "~/.vim/autoload/plug.vim" ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo "Downloading proverbs from wikiquote"

cat <(curl -vs "https://en.wikiquote.org/wiki/English_proverbs" 2>&1 \
    | xpath -q -e '//div[@id="mw-content-text"]//*[name()="ul"]//*[(name()="b")]//text()' ./English_proverbs \
    | grep -Pv "^( |[^A-Z])|([^\.\?\!]$)" ) \
    <(curl -vs "https://en.wikipedia.org/wiki/List_of_proverbial_phrases" 2>&1 \
    | xpath -q -e "//div[@class='mw-parser-output']/ul/li/text()" \
    | grep -Pv "^( |[^A-Z])|[0-9]" ) \
    | sort -u \
    > ~/.vim_runtime/proverbs.txt

echo "set runtimepath+=~/.vim_runtime
source ~/.vim_runtime/vimrcs/plugins.vim
" > ~/.vimrc

vim +PlugInstall +qall

echo "source ~/.vim_runtime/vimrcs/basic.vim
" >> ~/.vimrc

echo "Installed dependencies for vim configuration successfully."
