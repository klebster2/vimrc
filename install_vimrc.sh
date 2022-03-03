#!/bin/bash
echo "Starting vimrc setup..."

sudo apt-get update -y
sudo apt install build-essential cmake vim-nox python3-dev -y
sudo apt-get install jq mono-complete golang nodejs default-jdk npm -y

printf "Checking for ${HOME}/.new_words..."
if [ -d "${HOME}/.new_words" ]; then
    echo " Found ${HOME}/.new_words"
    printf "Checking for ${HOME}/.vim_runtime/new_words symlink..."
    if [ ! -f "${HOME}/.vim_runtime/new_words" ]; then
        echo " Didn't find symbolic link... making symlink"
        ln -s "${HOME}/.new_words/new_words" "${HOME}/.vim_runtime/new_words"
    else
        echo " Found symlink."
    fi
else
    echo " Didn't find ${HOME}/.new_words"
fi


if [ ! -d "${HOME}/.vim/undodir" ]; then
    echo "* Making undodir..."
    mkdir "${HOME}/.vim/undodir"
fi

if [ ! -f "${HOME}/.local/share/nvim/site/autoload/plug.vim" ]; then
    echo "* Curling vim plug"
    curl -fLo "${HOME}/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
fi

if [ ! -e "/usr/local/bin/node" ]; then
    printf "* %s\n" "Installing nodejs"
    curl -sL install-node.vercel.app/lts | sudo bash
fi

if (cat /etc/os-release | grep ID_LIKE | cut -d '=' -f2 | grep -q "debian"); then
    printf ""
    if (dpkg --print-architecture | grep -q arm) && [ ! -e ripgrep-13.0.0-arm-unknown-linux-gnueabihf ]; then
        # arm
        mkdir ripgrep-13.0.0-arm-unknown-linux-gnueabihf
        curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-arm-unknown-linux-gnueabihf.tar.gz"
        tar -xf "ripgrep-13.0.0-arm-unknown-linux-gnueabihf.tar.gz"
    elif (dpkg --print-architecture | grep -q amd); then
        # amd
        curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb"
        sudo dpkg -i "ripgrep_12.1.1_amd64.deb"
        rm "ripgrep_12.1.1_amd64.deb"
    else
        # try anyway
        sudo apt-get install fzf -y
    fi
else
    echo "** OS not known. Did not install ripgrep."
fi
mkdir -p "${HOME}/.config/nvim/"{ftdetect,syntax}

echo "* Setting up neovim"
echo "** Setting up miniconda3 env"

miniconda_install="Miniconda3-latest-Linux-x86_64.sh"

if ! (conda >/dev/null); then
    curl -Lo "$miniconda_install" "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    chmod +x "$miniconda_install"
    "$miniconda_install"
fi
#conda create -n pynvim python=3.7 pip > \
#    >(tee -a conda_env_stdout.log) 2> >(tee -a conda_env_stderr.log >&2)

grep "prefix:" pynvim-env.yaml ||
    echo "prefix: $HOME/miniconda3/envs/pynvim" >> pynvim-env.yaml

:>conda_env_stdout.log

if [ -d "$HOME/miniconda3/envs/pynvim-install-vimrc" ]; then
    path_to_env="$HOME/miniconda3/envs/pynvim-install-vimrc"
    for _option in "$path_to_env ?"; do
        echo "Do you want to remove $path_to_env?"
        printf "rm -r ${_option} "
        read -p "Change ${_option} (y/n/q)? " y_n_q
        msg="option selected"
        case "$y_n_q" in
            y|Y|Yes|yes ) echo "'${y_n_q}' $msg'"; rm -r "$path_to_env" ;;
            n|N|No|no ) echo "'${y_n_q}' $msg, skipping";;
            q|Q|Quit|quit ) echo "'${y_n_q}' $msg, quitting"; break;;
            * ) echo "invalid";;
        esac
    done
fi

conda env create -f pynvim-env.yaml -n pynvim-install-vimrc \
    >(tee -a conda_env_stdout.log) # 2> >(tee -a conda_env_stderr.log >&2)

environment_location="$HOME/miniconda3/envs/pynvim-install-vimrc"
conda_env_python_path="$environment_location/bin/python3"

echo "Setting adding paths to ${HOME}/.vimrc"

echo "set runtimepath+=${HOME}/.vim_runtime
source ${HOME}/.vim_runtime/vimrcs/plugins.vim
source ${HOME}/.vim_runtime/vimrcs/customcomplete.vim
source ${HOME}/.vim_runtime/vimrcs/coc.vim
let g:python3_host_prog='${conda_env_python_path}'
" > "${HOME}/.vimrc"

mkdir -p "${HOME}/.config/nvim/plug-config"
echo "set runtimepath^=${HOME}/.vim_runtime \
runtimepath+=${HOME}/.vim_runtime/after \
runtimepath+=${HOME}/.vim
let &packpath=&runtimepath
source ${HOME}/.vimrc" > "${HOME}/.config/nvim/init.vim"

echo "Installing Plugins..."
nvim +PlugInstall +qall

echo "source ${HOME}/.vim_runtime/vimrcs/basic.vim" >> "${HOME}/.vimrc"

echo "Installed dependencies for vim configuration successfully."
