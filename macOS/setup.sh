#!/bin/bash

if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

#Install Zsh & Oh My Zsh
echo "Installing Oh My ZSH..."
curl -L http://install.ohmyz.sh | sh

# Apps
apps=(
    google-chrome
    docker
    visual-studio-code
    kubectl
    git
    kitty
    btop
    unnaturalscrollwheels
    doll
    iriunwebcam
    gpg2
    gnupg
    pinentry-mac
    jq
    vim
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps with Cask..."
brew cask install --no-quarantine --appdir="/Applications" ${apps[@]}

brew cask cleanup
brew cleanup

killall Finder

echo "Done!"
