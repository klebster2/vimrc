#!/bin/bash

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

prompt_to_install_conda() {
    os2kernel="$(uname -a | sed -r 's|.* (.*) .*?\/(.*)$|\2-\1|g')"
    IFS=', ' read -r -a array <<< "$(curl "https://repo.anaconda.com/miniconda/" \
        | awk -F'</*td>' '$2{print $2}' \
        | xargs -n5 | grep "${os2kernel}" | grep "py310" \
        | sed -re 's/href=(.*?)>.*<\/a>/\1/g;s/<a//g')"
    # shellcheck disable=SC2145
    printf "Found conda installer: %s\n" "${array[@]}"
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
    local _REINSTALL_CONDA="$1"
    echo
    echo "* Checking for conda environment location"
    environment_location="$(find / -mindepth 1 -maxdepth 3 -type d -iname "miniconda*" | head -n1)"
    if [ -d "$environment_location" ] && $_REINSTALL_CONDA; then
        human_readable_message="Do you want to remove ${environment_location} before reinstalling?"
        _command="rm -r \"${environment_location}\""
        check_decision "$human_readable_message" "$_command" || check_decision "$human_readable_message" "sudo ${_command}"
    fi

    if [ -d "${environment_location}/$(grep "name:" ./pynvim-env.yaml | awk '{print $2}')" ]; then
        conda env create -f pynvim-env.yaml -n pynvim
    else
        echo "* Assuming pynvim conda env already exists..."
        environment_location=$(conda env create -f pynvim-env.yaml -n pynvim 2>&1 | grep -v "^$" | sed 's/.*exists: //g')
        [ -n "$environment_location" ] && echo "* Found $environment_location" || echo "No conda environment location found"
        conda env update -f pynvim-env.yaml --prune
    fi
    export CONDA_PYNVIM_ENV_PYTHON_PATH="$environment_location/bin/python3"
}


main() {
    set -euo pipefail
    REINSTALL_CONDA=false
    echo "* Running nvim setup..."
    echo "* Checking whether nvim is already installed..."
    if nvim -v > /dev/null 2>&1; then
        printf "* Found nvim already installed at %s\n" "$(which nvim)"
    else
        local _appimage_target_directory="$1"
        curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
        chgrp sudo nvim.appimage
        chmod ugo+x nvim.appimage
        ./nvim.appimage --appimage-extract
        ./squashfs-root/AppRun --version
        mv squashfs-root / || sudo mv squashfs-root /
        ln -s /squashfs-root/AppRun /usr/bin/nvim || sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
        nvim --version
    fi
    if ! (check_conda_is_installed); then
        prompt_to_install_conda
        echo "Please rerun the installation script after first running . ${HOME}/.bashrc to see if the base conda env is activated"
        rm ./Miniconda*.sh && exit 1
    else
        set +e
        echo "* Conda installation found"
        environment_location="$(find / -mindepth 1 -maxdepth 3 -type d -iname "miniconda*" 2>/dev/null | head -n1)"
        grep "name:" ./pynvim-env.yaml | awk '{print $2}'
        if [ -d "${environment_location}/$(grep "name:" ./pynvim-env.yaml | awk '{print $2}')" ]; then
            echo "Found conda environment location: ${environment_location}";
        else
            create_pynvim_conda_env $REINSTALL_CONDA
        fi
        set -e
    fi
    echo "* Installing dependencies for Neovim configuration."
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
    nvim --headless -c 'LspInstall awk_ls bashls dockerls pyright grammarly' -c 'quitall'
    echo
    for file in ./*.zip*; do
        if [ -f "$file" ]; then
            rm -v ./*.zip*
        fi
    done
    if [ -f ./nvim.appimage ]; then
        rm -v ./nvim.appimage
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
