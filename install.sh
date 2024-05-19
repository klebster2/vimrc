#!/bin/bash

install_fonts() {
    fonts_dir="${HOME}/.local/share/fonts"
    if [ ! -d "${fonts_dir}" ]; then
        echo "mkdir -p $fonts_dir"
        mkdir -p "${fonts_dir}"
    else
        echo "Found fonts dir $fonts_dir"
    fi

    version=5.2
    zip=Fira_Code_v${version}.zip
    curl --fail --location --show-error https://github.com/tonsky/FiraCode/releases/download/${version}/${zip} --output ${zip}
    unzip -o -q -d "${fonts_dir}" ${zip}
    rm ${zip}

    echo "fc-cache -f"
    fc-cache -f
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
    printf "%s" "$_human_readable_message "
    read -rp " (y/n/q)? " y_n_q
    msg="option selected"
    case "$y_n_q" in
        y|Y|Yes|yes ) echo "'${y_n_q}' $msg'"; $_command ;;
        n|N|No|no ) echo "'${y_n_q}' $msg, skipping";;
        q|Q|Quit|quit ) echo "'${y_n_q}' $msg, quitting"; return;;
        * ) echo "invalid";;
    esac
}

symlink_vim_runtime_nvim_to_nvim_loc() {
    local _nvim_loc="$1"
    _nvim_loc_parent="$(dirname "${_nvim_loc}")"
    if [ ! -L "${_nvim_loc}" ]; then
        echo "Adding symlink as ${_nvim_loc}..."
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
    # from the neovim docs
    ./nvim.appimage --appimage-extract
    ./squashfs-root/AppRun --version

    # Optional: exposing nvim globally.
    sudo mv squashfs-root /
    sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
    nvim
    _command="mv -v squashfs-root/usr/bin/nvim /usr/bin/nvim"
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


main() {
    # sudo add-apt-repository universe
    # sudo apt install libfuse2
    # sudo apt install jq unzip

    # Install gruvbox for terminal using gogh
    #bash -c "$(wget -qO- https://git.io/vQgMr)"
    #npm_check="$(npm -l)"
    #if ! (echo $npm_check | grep npm@ &>/dev/null) ; then
    #    printf "npm is needed for this neovim setup.\nplease install before continuing\n" && exit 1
    #fi
    #
    for tool in jq curl; do
        if ! $tool -V 2>/dev/null ; then
            printf "$tool is needed for this neovim setup.\nplease install before continuing\n" && exit 1
        fi
    done
    bash -c "$(curl -so- "https://github.com/Gogh-Co/Gogh/blob/master/installs/gruvbox-dark.sh")"

    echo "* Running nvim setup..."

    echo "* Checking whether nvim is already installed..."
    appimage_target_directory="/usr/bin"
    if check_nvim_is_installed; then
        printf "* Found nvim already installed at %s\n" "$(which nvim)"
    else
        install_nvim_appimage "${appimage_target_directory}"
    fi

    if ! (check_conda_is_installed); then
        prompt_to_install_conda
        echo "Please rerun the installation script after first running . ${HOME}/.bashrc to see if the base conda env is activated"
        # cleanup
        rm ./Miniconda*.sh
        exit
    else
        echo "Conda installation found"
        create_pynvim_conda_env
        source "${HOME}/.bashrc"
        conda activate pynvim
    fi

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

    #install_lua_ls

    echo "Setting adding paths to ${HOME}/.vimrc"

    echo "Installing dependencies for vim configuration."
    git clone https://github.com/github/copilot.vim.git "${HOME}/.config/nvim/pack/github/start/copilot.vim" --depth 1

    install_fonts

    pynvim_loc="$(conda env list | grep "pynvim" | head -n1 | sed -r 's/pynvim *(\/.*)/\1/g')"

    { echo "vim.api.nvim_exec([[";
    printf "  g:python3_host_prog=%s/bin/python3\n" "$pynvim_loc";
    echo "]], true)"; } >> ./nvim/lua/miniconda-python-loc.lua
    echo "Installed dependencies for vim configuration successfully."

    echo "Installing Plugins via PackerSync..."
    nvim +PackerSync +qall

    echo "Installing Language servers via LspInstall..."
    nvim --headless +"LspInstall awk_ls bashls dockerls pyright grammarly" +qall
    echo

    rm ./*.zip*
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
