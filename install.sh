#!/bin/bash

echo -e "#1: apt update\n"
apt update
echo -e "\n#2: apt upgrade -y\n"
apt upgrade -y

# Add Git
echo -e "\n#3: apt install -y git\n"
apt install -y git

# Add Docker and Docker Compose (Ubuntu based)
# Uninstall old versions
echo -e "\n#4: install docker and docker compose\n"
echo -e "#4.1: remove old installations\n"
apt remove docker docker-engine docker.io containerd runc
# Install using the repository
echo -e "\n#4.2: install deps\n"
apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
echo -e "\n#4.3: add gpt key\n"
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo -e "\n#4.4: setup repository\n"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
# Install Docker Engine
echo -e "\n#4.5: install\n"
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
# Manage Docker as a non-root user
echo -e "\n#4.6: setup non-root user\n"
groupadd docker
usermod -aG docker $USER
# newgrp docker
# Configure Docker to start on boot with systemd
echo -e "\n#4.7: enable services\n"
systemctl enable docker.service
systemctl enable containerd.service

# Add Visual Studio Code
echo -e "\n#5: install vscode\n"
apt install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
apt install -y apt-transport-https
apt update
apt install -y code # or code-insiders

