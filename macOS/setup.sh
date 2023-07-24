#!/bin/bash

if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "export PATH=/opt/homebrew/bin:$PATH" >>~/.zshrc
    echo "FPATH=\"$(brew --prefix)/share/zsh/site-functions:${FPATH}\"" >>~/.zshrc
    echo "eval \"$(/opt/homebrew/bin/brew shellenv)\"" >>~/.zshrc
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

#Install Zsh & Oh My Zsh
echo "Installing Oh My ZSH..."
curl -L http://install.ohmyz.sh | sh

# Apps
apps=(
    docker
    kubernetes-cli
    git
    btop
    gnupg
    pinentry-mac
    jq
    vim
)

casks=(
    google-chrome
    visual-studio-code
    kitty
    unnaturalscrollwheels
    doll
    iriunwebcam
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
brew install --no-quarantine --appdir="/Applications" ${apps[@]}

echo "installing apps with Cask..."
brew install --cask --no-quarantine --appdir="/Applications" ${casks[@]}

brew cleanup

killall Finder

echo "Done!"
