#!/bin/bash

install_lua_ls() {
    #IF FRESH START:
    #rm -r $HOME/.vim_runtime/nvim/lua-language-server
    if [ -d "$HOME/.vim_runtime/nvim/lua-language-server" ]; then
        conda install -c conda-forge ninja
        git clone --depth=1 \
            "https://github.com/sumneko/lua-language-server" \
            "$HOME/.vim_runtime/nvim/lua-language-server"
        pushd "$HOME/.vim_runtime/nvim/lua-language-server"

        git submodule update --depth 1 --init --recursive
        pushd 3rd/luamake; ./compile/install.sh
        pushd ../..; ./3rd/luamake/luamake rebuild

        popd
        popd
        popd
    else
        echo "Found lua-language-server installed in $HOME/.vim_runtime/nvim/"
    fi
    }

install_fonts() {
    mkdir -pv "$HOME/.local/share/fonts"
    echo "Using https://github.com/ryanoasis/nerd-fonts"
    pushd "$HOME/.local/share/fonts" && \
        curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" \
        "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf" \
        > /dev/null 2>&1
    popd
}

install_packer() {
    local _dest="$1"
    echo
    echo "making packer path... in $(dirname "$_dest")"
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
            cmd="rm -r \"${_nvim_loc}\" && ln -s \"$HOME/.vim_runtime/nvim\" \"${_nvim_loc_parent}\" 2> /dev/null" 
            check_decision "Overwrite ${_nvim_loc}" "$cmd"
        fi
    fi

}

check_make_undo_tree() {
    local _undotree_path="$1"
    echo
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
    _command="mv -v ./nvim.appimage /usr/bin/nvim"
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
    IFS=', ' read -r -a array <<< "$(curl "https://repo.anaconda.com/miniconda/" \
        | awk -F'</*td>' '$2{print $2}' \
        | xargs -n5 | grep "${os2kernel}" | grep "py310" \
        | sed -re 's/href=(.*?)>.*<\/a>/\1/g;s/<a//g')"
    echo "Found conda installer: ${array[@]}"
    url_conda_target="https://repo.continuum.io/miniconda/${array[0]}"
    curl -Lo "${array[0]}" "${url_conda_target}"
    sudo chmod +x "${array[0]}"
    bash "${array[0]}" || exit 1
    check_decision "Install miniconda?" "${cmd}"
    rm "${array[0]}"
}

check_conda_is_installed() {
    conda -V >/dev/null 2>&1
}

create_pynvim_conda_env() {
    echo
    echo "* Checking for conda environment location"
    if [ -d "$environment_location" ]; then
        human_readable_message="Do you want to remove ${environment_location} before reinstalling?"
        _command="rm -r \"${environment_location}\""
        sudo ${_command}
    fi

    conda env create -f pynvim-env.yaml -n pynvim
    if [ $? -ne 0 ]; then
        echo "* Assuming pynvim conda env already exists..."
        environment_location=$(conda env create -f pynvim-env.yaml -n pynvim 2>&1 | grep -v "^$" | sed 's/.*exists: //g')
        [ ! -z "$environment_location" ] && echo "* Found $environment_location" || echo "No conda environment location found"
        conda env update --file pynvim-env.yaml --prune
        # TODO: remove lines 214-215, get pynvim loc in one shot.
    fi
    export CONDA_PYNVIM_ENV_PYTHON_PATH="$environment_location/bin/python3"

}

fasttext() {
    ./fasttext skipgram -input <(
        while IFS= read line; do 
            if [[ "$p2_line" != "$p_line" ]] && [[ "$p_line" != "$line" ]] ; then 
                echo "$p2_line $p_line $line"; 
            fi;
            p2_line="$p_line"; p_line="$line"; 
        done< <(cat "$file" | tail -n+2 | grep -Pv "Repeat [1-9]+|Chorus|[1-9]+x|:" \
            | grep -Pv "\[.*?\]" | tr '\\\n' '\n' | sed 's/^n//g' \
            | rev | cut -d ' ' -f1,2,3 | rev \
            | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g' | sed 's/[,\?\!)(]//g' ) \
    ) -output model
    # or maybe even    : ./fasttext supervised -input train.txt -output model -autotune-validation valid.txt -autotune-modelsize 2M
    # or using the args:                                                      -autotune-validation cooking.valid -autotune-duration 600
}


main() {
    # sudo add-apt-repository universe
    # sudo apt install libfuse2
    # sudo apt install jq unzip
    echo "* Running nvim setup..."

    echo "* Checking whether nvim is installed..."
    appimage_target_directory="/usr/bin"
    check_nvim_is_installed && \
        printf "* Found nvim already installed at $(which nvim)\n" || \
        install_nvim_appimage "${appimage_target_directory}"

    if !(check_conda_is_installed); then
        prompt_to_install_conda 
    fi
    create_pynvim_conda_env
    . $HOME/.bashrc
    conda activate pynvim

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

    #echo "set runtimepath+=${HOME}/.vim_runtime
    #let g:python3_host_prog='${CONDA_PYNVIM_ENV_PYTHON_PATH}'
    #" > "${HOME}/.vimrc"

    install_fonts # TODO configure correctly

    echo "Installing Plugins via PackerSync..."
    nvim +PackerSync +qall

    echo "Installing Language servers via LspInstall..."
    nvim --headless +"LspInstall awk_ls bashls dockerls pyright grammarly" +qall
    echo

    pynvim_loc="$(conda env list | grep "pynvim" | head -n1 | sed -r 's/pynvim *(\/.*)/\1/g')"

    echo "vim.api.nvim_exec([[" >> ./nvim/lua/miniconda-python-loc.lua
    printf "  g:python3_host_prog=%s/bin/python3\n" "$pynvim_loc" \
        >> ./nvim/lua/miniconda-python-loc.lua
    echo "]], true)" >> ./nvim/lua/miniconda-python-loc.lua

    echo "Installed dependencies for vim configuration successfully."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
