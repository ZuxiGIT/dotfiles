#! /bin/bash

set -euo pipefail

TEMP_DIRS=()
TMP_SH=''

cleanup() {
    if [ -n "$TMP_SH" ] && [ -f "$TMP_SH" ]; then
        rm -f -- "$TMP_SH"
    fi

    for temp_dir in "${TEMP_DIRS[@]}"; do
        if [ -d "$temp_dir" ]; then
            rm -rf -- "$temp_dir"
        fi
    done
}

trap cleanup EXIT

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
BLOCK_BEGIN='# >>> dotfiles install >>>'
BLOCK_END='# <<< dotfiles install <<<'
SOURCES=()

# Ask which files should be sourced
echo "Do you want $SH to source: "
for file in shell/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        if ask "${filename}?"; then
            SOURCES+=("$(realpath "$file")")
        fi
    fi
done

TMP_SH=$(mktemp)
if [ -f "$SH" ]; then
    awk -v begin="$BLOCK_BEGIN" -v end="$BLOCK_END" '
        $0 == begin { in_block = 1; next }
        $0 == end { in_block = 0; next }
        !in_block { print }
    ' "$SH" > "$TMP_SH"
fi

{
    echo
    echo "$BLOCK_BEGIN"
    for source_file in "${SOURCES[@]}"; do
        echo "source $source_file"
    done
    echo "$BLOCK_END"
} >> "$TMP_SH"

mv "$TMP_SH" "$SH"
TMP_SH=''

if ask 'Install config files?'; then
    if [ -z "$(command -v stow &> /dev/null)" ]; then
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
    TEMP_DIRS+=("$TMP_DIR")
    git clone -b 'v0.11.5' https://github.com/neovim/neovim "$TMP_DIR"
    pushd "$TMP_DIR" || exit 1
    make CMAKE_BUILD_TYPE=Release -j
    sudo make install -j
    popd || exit 1
fi

# Install tmux
if ask 'Install tmux?'; then
    sudo apt install tmux
    TPM_DIR="$HOME/.tmux/plugins/tpm"
    if [ -d "$TPM_DIR/.git" ]; then
        git -C "$TPM_DIR" pull --ff-only
    elif [ -e "$TPM_DIR" ]; then
        echo "TPM path exists but is not a Git checkout: $TPM_DIR"
        exit 1
    else
        mkdir -p "$(dirname "$TPM_DIR")"
        git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    fi
    echo 'Do not forget to install tmux plugins!'
fi

# Install tig
if ask 'Install tig?'; then
    TMP_DIR=$(mktemp -d)
    TEMP_DIRS+=("$TMP_DIR")
    # Install tmux plugin manager
    git clone https://github.com/jonas/tig "$TMP_DIR"
    pushd "$TMP_DIR" || exit 1
    make prefix=/usr/local -j
    sudo make install prefix=/usr/local -j
    popd || exit 1
fi
