# klebster2's .vimrc

Inspired by https://github.com/amix/vimrc.git and ThePrimeagen

This setup assumes that you are also setting up vim

first clone repo with history depth=1 to directory `~/.vim_runtime`

`git clone --depth=1 https://github.com/klebster2/myvimrc ~/.vim_runtime`

change directory to `~/.vim_runtime`

`cd ~/.vim_runtime`

next run dependency installer (assumes you are using Ubuntu)

`sudo make dependencies`

finally run the installer

`./install_vimrc.sh`

you could also just use

`sudo make dependencies && ./install_vimrc.sh`
