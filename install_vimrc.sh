#!/bin/bash
echo "Starting vimrc setup..."

sudo apt-get update
sudo apt install build-essential cmake vim-nox python3-dev -y
sudo apt-get install jq mono-complete golang nodejs default-jdk npm -y

mkdir -p ${HOME}/.local/bin

install_lua_ls() {
    # clone project
    lua_ls="$HOME/.local/lua-language-server"
    gcc --version
    ninja -V > /dev/null | apt-get install ninja-build

    git clone "https://github.com/sumneko/lua-language-server" "$lua_ls"
    pushd "$lua_ls"
    git submodule update --init --recursive
    sudo apt-get install ninja-build
    pushd 3rd/luamake
    ./compile/install.sh
    cd ../..
    ./3rd/luamake/luamake rebuild
)


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

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage

mv "./nvim.appimage" "${HOME}/.local/bin/nvim"

chmod u+x "${HOME}/.local/bin/nvim"

mkdir -p "${HOME}/.config/nvim/"{ftdetect,syntax}

echo "* Setting up neovim"
conda -V \
    || curl -Lo Miniconda3-latest-Linux-x86_64.sh \
    "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" \
    && chmod +x ./Miniconda3-latest-Linux-x86_64.sh \
    && ./Miniconda3-latest-Linux-x86_64.sh
echo "** Setting up miniconda3 env"

#conda create -n pynvim python=3.7 pip > \
#    >(tee -a conda_env_stdout.log) 2> >(tee -a conda_env_stderr.log >&2)

grep "prefix:" pynvim-env.yaml ||
    echo "prefix: $HOME/miniconda3/envs/pynvim" >> pynvim-env.yaml

:>conda_env_stdout.log
conda env create -f pynvim-env.yaml \
     >(tee -a conda_env_stdout.log) # 2> >(tee -a conda_env_stderr.log >&2)


environment_location="$(cat conda_env_stdout.log \
    | grep "environment location" | cut -d : -f2-)"
conda_env_python_path="$HOME/miniconda3/envs/pynvim/bin/python3"

echo "Setting adding paths to ${HOME}/.vimrc"

echo "set runtimepath+=${HOME}/.vim_runtime
source ${HOME}/.vim_runtime/vimrcs/plugins.vim
source ${HOME}/.vim_runtime/vimrcs/customcomplete.vim
source ${HOME}/.vim_runtime/vimrcs/coc.vim
let g:python3_host_prog='${conda_env_python_path}'
" > "${HOME}/.vimrc"

ln -s "$HOME/.vim_runtime/nvim" "$HOME/.config" # CONFIG CREATION

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
