#! /bin/bash

# Ask Y/n
function ask() {
    read -r -p "$1 (Y/n): " resp
    if [ -z "$resp" ]; then
        response_lc="y" # empty is Yes
    else
        response_lc=$(echo "$resp" | tr '[:upper:]' '[:lower:]') # case insensitive
    fi

    [ "$response_lc" = "y" ]
}

# Check what shell is being used
SH="${HOME}/.bashrc"

echo >> "$SH"
echo "# -------------- automatically added: dotfiles install ---------------" >> "$SH"

# Ask which files should be sourced
echo "Do you want $SH to source: "
for file in shell/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        if ask "${filename}?"; then
            echo "source $(realpath "$file")" >> "$SH"
        fi
    fi
done

if ask 'Install config files?'; then
    if [ -z $(command -v stow &> /dev/null) ]; then
        echo 'Stow is not installed'
	if ask 'Install stow?'; then
	    sudo apt install stow
	fi
    fi
    mkdir -p "$HOME/.config"
    stow  -t "$HOME" "."
fi

# Install neovim v0.11.5
if ask 'Install neovim?'; then
    sudo apt install cmake make build-essential
    TMP_DIR=$(mktemp -d)
    git clone -b 'v0.11.5' https://github.com/neovim/neovim $TMP_DIR
    pushd $TMP_DIR
    make CMAKE_BUILD_TYPE=Release -j
    sudo make install -j
    popd
fi

# Install tmux
if ask 'Install tmux?'; then
    sudo apt install tmux
    # Install tmux plugin manager
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo 'Do not forget to install tmux plugins!'
fi

# Install tig
if ask 'Install tig?'; then
    TMP_DIR=$(mktemp -d)
    # Install tmux plugin manager
    git clone https://github.com/jonas/tig $TMP_DIR
    pushd $TMP_DIR
    make prefix=/usr/local -j
    sudo make install prefix=/usr/local -j
    popd
fi
