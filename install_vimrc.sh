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
    echo "* Latest release of sumneko/lua-language-server: $latest_release_url"
    wget $latest_release_url -O `basename $latest_release_url` > /dev/null 2>&1
    mkdir -p "$HOME/.vim_runtime/nvim/lua-language-server"
    tar -xvzf `basename $latest_release_url` -C "$HOME/.vim_runtime/nvim/lua-language-server" > /dev/null 2>&1
    echo "* Downloaded sumneko/lua-language-server $latest_release_url to $HOME/.vim_runtime/nvim/lua-language-server"
    rm `basename $latest_release_url`
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
    mkdir -pv "$HOME/.local/share/fonts"
    pushd "$HOME/.local/share/fonts" && \
        curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" \
        "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf" \
        > /dev/null 2>&1
    popd
}

install_packer() {
    local _dest="$1"
    echo "making packer path..."
    mkdir -pv "$(dirname "$_dest")"
    git clone --depth 1 "https://github.com/wbthomason/packer.nvim" "$_dest"
        
}

check_sudo_needed() {
    local _dir="$1"
    diruser=$(ls -alF "$_dir" | grep " \.\/" | awk -F ' ' '{print$3}')
    if [ "$diruser" == "root" ] && [ "$diruser" != "$USER" ]; then
        echo "true"
    else
        echo "false"
    fi
}

check_decision() {
    local _human_readable_message="$1" _command="$2"
    echo "Do you want to run \"$_command\" ?"
    printf "$_human_readable_message "
    read -p " (y/n/q)? " y_n_q
    msg="option selected"
    case "$y_n_q" in
        y|Y|Yes|yes ) echo "'${y_n_q}' $msg'"; $_command ;;
        n|N|No|no ) echo "'${y_n_q}' $msg, skipping";;
        q|Q|Quit|quit ) echo "'${y_n_q}' $msg, quitting"; break;;
        * ) echo "invalid";;
    esac
}

symlink_vim_runtime_nvim_to_nvim_loc() {
    local _nvim_loc="$1"
    _nvim_loc_parent="$(dirname "${_nvim_loc}")"
    if [ ! -L "${_nvim_loc}" ]; then
        echo "Adding symlink as "${_nvim_loc}"..."
        ln -s "$HOME/.vim_runtime/nvim" "${_nvim_loc_parent}"  2> /dev/null
        if [ $? -ne 0 ]; then
            # Nuke "$_nvim_loc"
            cmd="rm -r \"${_nvim_loc}\" && ln -s \"$HOME/.vim_runtime/nvim\" \"${_nvim_loc_parent}\" 2> /dev/null" 
            check_decision "Overwrite ${_nvim_loc}" "$cmd"
        fi
    fi

}

check_make_undo_tree() {
    local _undotree_path="$1"
    echo "* Checking whether ${_undotree_path} exists"
    if [ ! -d "$_undotree_path" ]; then
        echo "** No undo dir found..."
        mkdir -v "$_undotree_path"
    fi
}

check_nvim_is_installed() {
    nvim -v > /dev/null 2>&1
}

install_nvim_appimage() {
    local _appimage_target_directory="$1"
    ## sudo may be needed - only use priviledges if needed to mkdir
    curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
    chgrp sudo nvim.appimage
    chmod ugo+x nvim.appimage
    human_readable_message="Do you want to add neovim to /usr/bin/ ?"
    need_sudo="$(check_sudo_needed "$(dirname "/usr/bin")")"
    echo "* sudo needed to create tmpdir in $(dirname "$output_path") $need_sudo"
    _command="mv -v ./nvim.appimage \"${_appimage_target_directory}\""
    $need_sudo && _command="sudo ${_command}"
    check_decision "$human_readable_message" "$_command"
}

mkdir_p_verbose() {
    local _dir="$1"
    [ ! -d "$_dir" ] && \
        mkdir -pv "$_dir" && \
        echo "made $_dir" || \
        echo "$_dir found"
}

prompt_to_install_conda() {
    os2kernel="$(uname -a | sed -r 's|.* (.*) .*?\/(.*)$|\2-\1|g')"
    installer_name="Miniconda3-latest-${os2kernel}.sh"
    url_conda_target="https://repo.continuum.io/miniconda/${installer}"
    cmd="curl -Lo ${installer} \"${url_conda_target}\" && bash ${installer} || exit 1"
    check_decision "Install miniconda?" "${cmd}"
}

check_conda_is_installed() {
    conda -V >/dev/null 2>&1
}

create_pynvim_conda_env() {
    echo "* Checking for conda environment location"
    if [ -d "$environment_location" ]; then
        human_readable_message="Do you want to remove $path_to_env before reinstalling?"
        _command="rm -r \"${environment_location}\""
        need_sudo="$(check_sudo_needed "$(dirname "${environment_location}")")"
        $need_sudo && _command="sudo ${_command}"
        check_decision "${human_readable_message}" "${_command}"
    fi

    conda env create -f pynvim-env.yaml -n pynvim
    if [ $? -ne 0 ]; then
        echo "* Assuming pynvim conda env already exists..."
        environment_location=$(conda env create -f pynvim-env.yaml -n pynvim 2>&1 | grep -v "^$" | sed 's/.*exists: //g')
        [ ! -z "$environment_location" ] && echo "* Found $environment_location" || echo "No conda environment location found"
    fi
    export CONDA_PYNVIM_ENV_PYTHON_PATH="$environment_location/bin/python3"

}


main() {
    echo "* Running nvim setup..."

    echo "* Checking whether nvim is installed..."
    appimage_target_directory="/usr/bin"
    check_nvim_is_installed && \
        printf "* Found nvim already installed at $(which nvim)\n" || \
        install_nvim_appimage "${appimage_target_directory}"

    check_conda_is_installed && \
        create_pynvim_conda_env || \
        ( prompt_to_install_conda && create_pynvim_conda_env )

    nvim_loc="${HOME}/.config/nvim"
    nvim_loc_parent="$(dirname "${nvim_loc}")"
    packer_path="$HOME/.local/share/nvim/site/pack/packer"

    mkdir_p_verbose "${nvim_loc_parent}"
    mkdir_p_verbose "${HOME}/.local/bin"

    echo "* Symlink ~/.vim_runtime/nvim to ~/.config/nvim"
    symlink_vim_runtime_nvim_to_nvim_loc "${nvim_loc}"
    check_make_undo_tree "${nvim_loc}/.undotree" 

    [ -d "${packer_path}/start/packer.nvim" ] || \
        install_packer "${packer_path}/start/packer.nvim"

    install_lua_ls

    echo "Setting adding paths to ${HOME}/.vimrc"

    echo "set runtimepath+=${HOME}/.vim_runtime
    let g:python3_host_prog='${CONDA_PYNVIM_ENV_PYTHON_PATH}'
    " > "${HOME}/.vimrc"

    [ -d "${HOME}/.local/share/nvim/lsp_servers/grammarly" ] || install_grammarly

    install_fonts # TODO configure correctly

    echo "Installing Plugins via PackerSync..."
    nvim +PackerSync +qall
    echo "Installing Language servers via LspInstall..."
    nvim --headless +"LspInstall awk_ls bashls dockerls grammarly"  +qall
    echo

    echo "Installed dependencies for vim configuration successfully."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
