#!/bin/bash
set -e

echo "Installing APT repository GPG keys..."

echo "Installing KeePassXC key..."
gpg --keyserver keyserver.ubuntu.com --no-default-keyring --keyring gnupg-ring:/tmp/keepassxc-keyring.gpg --recv-keys 61922AB60068FCD6
sudo mv /tmp/keepassxc-keyring.gpg /usr/share/keyrings/keepassxc-archive-keyring.gpg
sudo chmod 644 /usr/share/keyrings/keepassxc-archive-keyring.gpg

echo "Installing Signal key..."
wget -O - https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

echo "Installing Dropbox key..."
gpg --keyserver keyserver.ubuntu.com --no-default-keyring --keyring gnupg-ring:/tmp/dropbox-keyring.gpg --recv-keys FC918B335044912E
sudo mv /tmp/dropbox-keyring.gpg /usr/share/keyrings/dropbox-archive-keyring.gpg
sudo chmod 644 /usr/share/keyrings/dropbox-archive-keyring.gpg

echo "All keys installed successfully"
