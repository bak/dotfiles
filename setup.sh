#!/bin/sh

echo "👉 Sourcing dotfiles/.envrc"
source .envrc

echo "👉 Checking for brew command"
if ! type brew >/dev/null 2>&1; then
  echo "✋ Brew not found, installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
echo "👉 Updating brew"
brew update

echo "👉 Checking for stow"
if ! type stow >/dev/null 2>&1; then
  echo "✋ Stow not found, installing..."
  brew install stow
fi

echo "👉 Stowing files under dev/"
stow dev

echo "👉 symlinking .zshrc to .zshenv for vim"
ln -s ~/.zshrc ~/.zshenv

echo "👉 Signing in to MAS"
brew install mas
mas signin --dialog $EMAIL

echo "👉 Installing all Homebrew recipes (relies on Brewfile being stowed)"
brew tap Homebrew/bundle
brew bundle --global

echo "👉 Setting Homebrew's zsh"
sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh

echo "👉 Installing FZF auto-completion and key bindings"
$(brew --prefix)/opt/fzf/install

echo "👉 Symlinking vim to nvim"
ln -s /usr/local/bin/nvim /usr/local/bin/vim

echo "👉 installing terminal color schemes"
open shared/wwdc16-*.itermcolors

echo "🙌 All done!"
echo "- Be sure to create an ssh keypair if this is a new machine"
echo "- Be sure to install GPG key data (gpg --import /Path/To/File.asc)"
echo "- Please restart the computer for everything to work right"
