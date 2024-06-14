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
    environment_location="$(find / -mindepth 1 -maxdepth 3 -type d -iname "miniconda*" 2>/dev/null | head -n1)"
    if [ -d "$environment_location" ]; then
        human_readable_message="Do you want to remove ${environment_location} before reinstalling?"
        _command="rm -r \"${environment_location}\""
        check_decision "$human_readable_message" "$_command" || check_decision "$human_readable_message" "sudo ${_command}"
    fi

    if [ -d "${environment_location}/$(grep "name:" ./pynvim-env.yaml | awk '{print $2}')" ]; then
        conda env create -f pynvim-env.yaml -n pynvim
    else
        echo "* Assuming pynvim conda env already exists..."
        environment_location=$(conda env create -f pynvim-env.yaml -n pynvim 2>&1 | grep -v "^$" | sed 's/.*exists: //g')
        [ ! -z "$environment_location" ] && echo "* Found $environment_location" || echo "No conda environment location found"
        conda env update -f pynvim-env.yaml --prune
    fi
    export CONDA_PYNVIM_ENV_PYTHON_PATH="$environment_location/bin/python3"

}


main() {
    # sudo add-apt-repository universe
    set -eux pipefail

    for tool in jq curl; do
        if ! $tool -V 2>/dev/null ; then
            printf '%s is needed for this neovim setup.\nplease install before continuing\n' "$tool" && exit 1
        fi
    done
    # Check npm is installed
    # Given that `npm -h` returns 1

    npm_install_helper="# installs fnm (Fast Node Manager)\ncurl -fsSL https://fnm.vercel.app/install | bash\\\\\\\\\n# download and install Node.js\nfnm use --install-if-missing 20\n# verifies the right Node.js version is in the environment\nnode -v # should print \`v20.14.0\`\n# verifies the right NPM version is in the environment\nnpm -v # should print \`10.7.0\`"
    npm help 2>/dev/null
    if [ $? -eq 1 ] ; then
        printf 'npm is needed for this neovim setup.\nplease install before continuing\n\n%s' "${npm_install_helper}" && exit 1
    fi
    # bash -c "$(curl -so- "https://github.com/Gogh-Co/Gogh/blob/master/installs/gruvbox-dark.sh")"

    echo "* Running nvim setup..."

    echo "* Checking whether nvim is already installed..."
    appimage_target_directory="/usr/bin"
    if check_nvim_is_installed; then
        printf "* Found nvim already installed at %s\n" "$(which nvim)"
    else
        install_nvim_appimage "${appimage_target_directory}"
    fi

    set -x
    if ! (check_conda_is_installed); then
        prompt_to_install_conda
        echo "Please rerun the installation script after first running . ${HOME}/.bashrc to see if the base conda env is activated"
        # cleanup
        rm ./Miniconda*.sh
        exit
    else
        echo "Conda installation found"
        environment_location="$(find / -mindepth 1 -maxdepth 3 -type d -iname "miniconda*" 2>/dev/null | head -n1)"
        if [ -d "${environment_location}/$(grep "name:" ./pynvim-env.yaml | awk '{print $2}')" ]; then
            echo "Found conda environment location: ${environment_location}";
        else
            create_pynvim_conda_env
        fi
        #source "${HOME}/.bashrc"
    fi

    nvim_loc="${HOME}/.config/nvim"
    nvim_loc_parent="$(dirname "${nvim_loc}")"

    packer_path="$HOME/.local/share/nvim/site/pack/packer"

    mkdir_p_verbose "${nvim_loc_parent}"
    mkdir_p_verbose "${HOME}/.local/bin"

    echo "* Symlink ~/.vim_runtime/nvim to ~/.config/nvim"
    symlink_vim_runtime_nvim_to_nvim_loc "${nvim_loc}"

    check_make_undo_tree "${nvim_loc}/.undotree"

#    [ -d "${packer_path}/start/packer.nvim" ] || \
#        install_packer "${packer_path}/start/packer.nvim"

    echo "Setting adding paths to ${HOME}/.vimrc"

    echo "Installing dependencies for vim configuration."
    [ -d "${HOME}/.config/nvim/pack/github/start/copilot.vim" ] || \
        git clone https://github.com/github/copilot.vim.git "${HOME}/.config/nvim/pack/github/start/copilot.vim" --depth 1

    install_fonts

    echo "Installed dependencies for vim configuration successfully."

    echo "Installing Plugins via PackerSync..."
    nvim +PackerSync +qall

    echo "Installing Language servers via LspInstall..."
    nvim --headless +"LspInstall awk_ls bashls dockerls pyright grammarly" +qall
    echo

    for file in ./*.zip*; do
        if [ -f "$file" ]; then
            echo "Cleaning up zip files..."
            rm ./*.zip*
        fi
    done
    if [ -f ./nvim.appimage ]; then
        echo "Cleaning up appimage..."
        rm ./nvim.appimage
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
