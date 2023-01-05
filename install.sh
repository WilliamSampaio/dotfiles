#!/bin/bash

echo -e "#1: apt-get update\n"
apt-get update
echo -e "\n#2: apt-get upgrade -y\n"
apt-get upgrade -y

# Add Git
echo -e "\n#3: apt-get install -y git\n"
apt-get install -y git

# Add Docker and Docker Compose (Ubuntu based)
# Uninstall old versions
echo -e "\n#4: install docker and docker compose\n"
echo -e "\n#4.1: remove old installations\n"
apt-get remove docker docker-engine docker.io containerd runc
# Install using the repository
echo -e "\n#4.2: install deps\n"
apt-get install -y \
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
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
# Manage Docker as a non-root user
echo -e "\n#4.6: setup non-root user\n"
groupadd docker
usermod -aG docker $USER
# newgrp docker
# Configure Docker to start on boot with systemd
echo -e "\n#4.7: enable services\n"
systemctl enable docker.service
systemctl enable containerd.service

