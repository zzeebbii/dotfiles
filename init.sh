#!/bin/bash

abort() {
    printf "%s\n" "$@" >&2
    exit 1
}

if ! [ -x "$(command -v zsh)" ]; then
    abort 'Error: "zsh" is not installed. Please install "zsh" first'
fi

IS_MAC=false

# First check OS.
OS="$(uname)"
if [[ "${OS}" == "Linux" ]]; then
    BREW_PREFIX="/home/linuxbrew/.linuxbrew"
elif [[ "${OS}" == "Darwin" ]]; then
    BREW_PREFIX="/opt/homebrew"
    IS_MAC=1
else
    abort "This script is only supported on macOS and Linux."
fi

install_brew() {
    echo "1. Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo "2. Adding brew to the PATH..."

    echo '# Set PATH, MANPATH, etc., for Homebrew.' >>~/.zprofile
    printf 'eval "$(%s/bin/brew shellenv)"\n' $BREW_PREFIX >>~/.zprofile
    eval "$($BREW_PREFIX/bin/brew shellenv)"
}

install_iterm2() {
    if [[ IS_MAC == 1 ]]; then
        echo "2. Installing iTerm2"
        brew install --cask iterm2
    else
        echo "Not MacOS. Skipping iTerm installation"
    fi
}

install_git() {
    echo "3. Installing/Updating Git"
    brew install git
}

install_omz() {
    if [[ ! -d ~/.oh-my-zsh ]]; then
        echo "4. Installing oh-my-zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo '"oh-my-zsh" is already installed. Skipping...'
    fi
}

install_powerlevel_10k() {
    if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k ]]; then
        echo "5. Installing PowerLevle10k theme"
        git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
    else
        echo '"powerlevel10k" theme already installed. Skipping...'
    fi

}

install_zsh_plugins() {
    if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
        echo "6. Installing zsh-autosuggestions"
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    else
        echo '"zsh-autosuggesstions" theme already installed. Skipping...'
    fi

    if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]]; then
        echo "6. Installing zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    else
        echo '"zsh-syntax-highlighting" theme already installed. Skipping...'
    fi

}

main() {
    echo "Starting the setup..."

    install_brew
    install_iterm2
    install_git
    install_omz
    install_powerlevel_10k
    install_zsh_plugins
}

main
