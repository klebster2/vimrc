# klebster2's .vimrc

Inspired by https://github.com/amix/vimrc.git and ThePrimeagen

# Ubuntu Setup

First clone repo with history depth=1 to directory `~/.vim_runtime` and change directory to `~/.vim_runtime`:

`git clone --depth=1 https://github.com/klebster2/myvimrc ~/.vim_runtime && cd ~/.vim_runtime`

Next run the dependency installer (assumes you are using Ubuntu)

`sudo make dependencies`

Finally run the installer

`./install_vimrc.sh`

# Windows Terminal Setup

Assuming that you have already installed Vim and Windows terminal from Chocolatey

Run

`powershell -file install_vimrc.ps1`


