#!/bin/bash
set -e

echo "Installing APT repository GPG keys..."

# gpg writes a keybox database, which apt cannot read, so export to a plain
# keyring rather than moving the keyserver output into place directly.
echo "Installing KeePassXC key..."
gpg --keyserver keyserver.ubuntu.com --no-default-keyring --keyring /tmp/kpxc.kbx --recv-keys 61922AB60068FCD6
gpg --no-default-keyring --keyring /tmp/kpxc.kbx --export 61922AB60068FCD6 \
  | sudo tee /usr/share/keyrings/keepassxc-archive-keyring.gpg > /dev/null
sudo chmod 644 /usr/share/keyrings/keepassxc-archive-keyring.gpg
rm -f /tmp/kpxc.kbx

echo "Installing Signal key..."
wget -O - https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

echo "Installing Dropbox key..."
curl -fsSL https://linux.dropbox.com/fedora/rpm-public-key.asc \
  | gpg --dearmor | sudo tee /usr/share/keyrings/dropbox-archive-keyring.gpg > /dev/null
sudo chmod 644 /usr/share/keyrings/dropbox-archive-keyring.gpg

echo "Installing Mullvad key..."
curl -fsSL https://repository.mullvad.net/deb/mullvad-keyring.asc \
  | sudo tee /usr/share/keyrings/mullvad-keyring.asc > /dev/null
sudo chmod 644 /usr/share/keyrings/mullvad-keyring.asc

echo "All keys installed successfully"
