echo "Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#Install Zsh & Oh My Zsh
echo "Installing Oh My ZSH..."
curl -L http://install.ohmyz.sh | sh

echo -e "export PATH=/opt/homebrew/bin:$PATH\n$(cat ~/.zshrc)" >~/.zshrc
echo -e "FPATH=\"$(brew --prefix)/share/zsh/site-functions:${FPATH}\"\n$(cat ~/.zshrc)" >~/.zshrc
echo -e "eval \"$(brew shellenv)\"\n$(cat ~/.zshrc)" >~/.zshrc

# Update homebrew recipes
echo "Updating homebrew..."
brew update

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
