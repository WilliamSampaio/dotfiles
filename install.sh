#!/bin/bash
# Distro Ubuntu 22.0

sudo apt update
sudo apt upgrade -y

# Add Git
sudo apt install -y git

# Add Docker and Docker Compose (Ubuntu based)
# Uninstall old versions
sudo apt remove docker docker-engine docker.io containerd runc
# Install using the repository
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Install Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
# Manage Docker as a non-root user
sudo groupadd docker
sudo usermod -aG docker $USER
# newgrp docker
# Configure Docker to start on boot with systemd
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Add Visual Studio Code
sudo apt install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y code # or code-insiders

# Add Vim and Neovim
sudo apt install -y python3 python3-pip
pip install pynvim
# Install NodeJS
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.bashrc
nvm install node
# Install Vim and Neovim
sudo apt install -y vim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install -y neovim

# Download and install Nerd Fonts
mkdir -p ~/.fonts
curl -fLo ~/.fonts/UbuntuMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.1/UbuntuMono.zip
unzip ~/.fonts/UbuntuMono.zip -d ~/.fonts/

# Install zsh
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Dbeaver
curl -fLo ~/dbeaver-ce_latest_amd64.deb https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
sudo dpkg -i ~/dbeaver-ce_latest_amd64.deb
rm ~/dbeaver-ce_latest_amd64.deb

# Install pyenv
curl https://pyenv.run | bash

# End os Setup
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cp -r "$SCRIPT_DIR"/dotfiles/. ~/
sudo apt update
sudo apt full-upgrade -y
sudo apt autoremove --purge -y
reboot