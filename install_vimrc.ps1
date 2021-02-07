iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni $HOME/vimfiles/autoload/plug.vim -Force

Remove-Item $HOME\.vimrc

Add-Content $HOME\.vimrc "set runtimepath+=$HOME\.vim_runtime`r`n`r`nsource $HOME\.vim_runtime\vimrcs\plugins.vim"

vim +'PlugInstall --sync' +qall

Add-Content $HOME\.vimrc "source $HOME\.vim_runtime\vimrcs\basic.vim"
