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
    mkdir -p "$HOME/.vim_runtime/nvim/lua-language-server"
    tar -xvzf `basename $latest_release_url` -C "$HOME/.vim_runtime/nvim/lua-language-server" >/dev/null
    echo "downloaded sumneko/lua-language-server $latest_release_url to $HOME/.vim_runtime/nvim/lua-language-server"
}

install_grammarly() {
    echo "Install grammarly ls?"
    read -p "(y/n)?" y_n
    msg="option selected"
    case "$y_n" in
        y|Y|Yes|yes ) echo "'${y_n}' $msg -> installing grammarly'"; npm i -g @emacs-grammarly/unofficial-grammarly-language-server;;
        n|N|No|no ) echo "'${y_n}', $msg -> skipping";;
        * ) echo "";
    esac
}

install_fonts() {
    mkdir -p ~/.local/share/fonts
    pushd ~/.local/share/fonts && \
        curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" \
        "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf"
    popd
}

main() {
    echo "Starting vimrc setup..."

    mkdir -p ${HOME}/.local/bin

    if [ ! -d "${HOME}/.vim/undodir" ]; then
        echo "* Making undodir..."
        mkdir "${HOME}/.vim/undodir"
    fi

    nvim -v 2>/dev/null # TODO CONSIDER CHANGING TO USER INPUT RATHER THAN AUTOMAGIC

    if [ $? -ne 0 ]; then
        curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
        chgrp sudo nvim.appimage
        chmod ugo+x nvim.appimage
        for _option in "/usr/bin/nvim"; do
            echo "Do you want to add neovim to /usr/bin/ ?"
            decision="mv -v ./nvim.appimage ${_option} "
            printf "$decision"
            read -p "Change ${_option} (y/n/q)? " y_n_q
            msg="option selected"
            case "$y_n_q" in
            y|Y|Yes|yes ) echo "'${y_n_q}' $msg'"; $decision || sudo $decision ;;
            n|N|No|no ) echo "'${y_n_q}' $msg, skipping";;
            q|Q|Quit|quit ) echo "'${y_n_q}' $msg, quitting"; break;;
            * ) echo "invalid";;
            esac
        done
    else
        printf "found nvim already installed at $(which nvim)\n\n"
    fi

    printf "----------\n\n"

    # TODO CHECK FOR PYTHON3
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

    printf "----------\n\n"

    install_lua_ls

    conda env create -f pynvim-env.yaml -n pynvim
    conda_env_python_path="$environment_location/bin/python3"

    echo "Setting adding paths to ${HOME}/.vimrc"

    echo "set runtimepath+=${HOME}/.vim_runtime
    source ${HOME}/.vim_runtime/vimrcs/plugins.vim
    source ${HOME}/.vim_runtime/vimrcs/customcomplete.vim
    source ${HOME}/.vim_runtime/vimrcs/coc.vim
    let g:python3_host_prog='${conda_env_python_path}'
    " > "${HOME}/.vimrc"

    if [ ! -L "$HOME/.config/nvim" ]; then
        echo "Adding symlink as $HOME/.config/nvim"
        ln -s "$HOME/.vim_runtime/nvim" "$HOME/.config" 2> /dev/null # CONFIG CREATION
        if [ $? -ne 0 ]; then
	    echo "Path already found: $HOME/.config/nvim"
	    read -p "Overwrite? (y/n/q)?" y_n_q
            msg="option selected"
            case "$y_n_q" in
                y|Y|Yes|yes ) echo "'${y_n_q}' $msg -> removing symlink'"; rm -r "$HOME/.config/nvim"; ln -s "$HOME/.vim_runtime/nvim" "$HOME/.config" 2> /dev/null ;;
                n|N|No|no ) echo "'${y_n_q}', $msg -> skipping";;
                * ) echo "invalid";;
            esac
	fi
    fi

    # TODO Line below is unused
    echo "source ${HOME}/.vim_runtime/vimrcs/basic.vim" >> "${HOME}/.vimrc"

    install_grammarly
    install_fonts

    echo "Installing Plugins via PackerSync..."
    nvim +PackerSync +qall
    echo "Installing Language servers via LspInstall..."
    nvim --headless +"LspInstall awk_ls bashls dockerls grammarly"  +qall


    echo "Installed dependencies for vim configuration successfully."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
