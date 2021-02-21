# klebster2's vimrc

Inspired by https://github.com/amix/vimrc.git and ThePrimeagen

Ubuntu Setup
============
klebnoel@gmail.com
First clone repo with history depth=1 to directory `~/.vim_runtime` and change directory to `~/.vim_runtime`:

```bash
git clone https://github.com/klebster2/myvimrc ~/.vim_runtime && cd ~/.vim_runtime
```

Next install dependencies (This step assumes you are using Ubuntu)

```bash
sudo make dependencies
```

Finally run the installer

``` bash
./install_vimrc.sh
```

Windows Terminal Setup
======================

Assuming that you have already installed Vim and Windows terminal from chocolatey
```powershell
git clone --depth=1 https://github.com/klebster2/myvimrc $HOME/.vim_runtime; cd $HOME/.vim_runtime
```

Run
```
powershell -file install_vimrc.ps1
```


