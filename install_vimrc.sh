#!/bin/bash
install_lua_ls() {
    # clone project
    lua_ls="$HOME/.local/bin/lua-language-server"
    base_url_path="/sumneko/lua-language-server/releases";
    latest_release_url=$(curl "https://github.com$base_url_path" 2> /dev/null \
        | grep -Po "href=(\"$base_url_path/download[A-Za-z0-9\/\.\-]+\")" \
        | sed -re 's|href="|https://github.com|g;s/"//g' \
        | grep ".*linux-$(uname -p | sed 's/86_//g').*" \
        | head -n1)
    echo "latest release of sumneko/lua-language-server: $latest_release_url"

    wget $latest_release_url -O `basename $latest_release_url` 

    tar -xvzf `basename $latest_release_url` -C ./lua-language-server
}

main() {
    echo "Starting vimrc setup..."

    sudo apt-get update -y
    sudo apt install build-essential cmake vim-nox python3-dev -y
    sudo apt-get install jq mono-complete golang nodejs default-jdk npm -y

    mkdir -p ${HOME}/.local/bin

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

    nvim -v >/dev/null

    if [ $? -ne 0 ]; then
        curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
        chgrp sudo nvim.appimage
        chmod ugo+x nvim.appimage
        for _option in "/usr/bin/nvim"; do
            echo "Do you want to add neovim to /usr/bin/ ?"
            decision="mv ./nvim.appimage ${_option} "
            printf "$decision"
            read -p "Change ${_option} (y/n/q)? " y_n_q
            msg="option selected"
            case "$y_n_q" in
                y|Y|Yes|yes ) echo "'${y_n_q}' $msg'"; $decision > /dev/null 2>&1 || sudo $decision ;;
                n|N|No|no ) echo "'${y_n_q}' $msg, skipping";;
                q|Q|Quit|quit ) echo "'${y_n_q}' $msg, quitting"; break;;
                * ) echo "invalid";;
            esac
        done
    else
        printf "found nvim already installed at $(which nvim)"
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

    if [ -d "$environment_location" ]; then
        path_to_env="$environment_location"
        for _option in "$path_to_env"; do
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

    # lua-language-server
    echo "$(uname -p)" | grep -Pq "x86_64" && \
        wget "https://github.com/sumneko/lua-language-server/releases/download/3.1.0/lua-language-server-3.1.0-linux-x64.tar.gz" \
            -O lua-language-server-3.1.0-linux-x64.tar.gz && \

    conda env create -f pynvim-env.yaml -n pynvim \
        >(tee -a conda_env_stdout.log) # 2> >(tee -a conda_env_stderr.log >&2)

    conda_env_python_path="$environment_location/bin/python3"

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
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
