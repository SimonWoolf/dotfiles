#!/bin/bash
set -e

APT_PACKAGES=(
  amqp-tools awscli build-essential brightnessctl ca-certificates chromium-browser curl
  dh-autoreconf dos2unix git gpa gpg grim htop inetutils-traceroute iotop jq libffi-dev
  libreadline-dev libtool libyaml-dev mise mupdf net-tools network-manager-applet parallel
  playerctl protobuf-compiler pulseaudio-utils pydf python3-setuptools redshift ripgrep rofi
  socat tree upower vlc wbritish-insane whois wireshark wl-clipboard zlib1g-dev
)

GITHUB_DEB_REPOS=(
  dandavison/delta
)

echo "Installing apt packages..."
sudo apt-get update
sudo apt-get install -y "${APT_PACKAGES[@]}"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

for repo in "${GITHUB_DEB_REPOS[@]}"; do
  echo "Installing latest release of $repo..."
  # Skip musl variants, which some projects publish alongside the glibc build.
  url=$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" \
    | jq -r '.assets[].browser_download_url | select(endswith("_amd64.deb")) | select(contains("musl") | not)' \
    | head -n1)
  if [ -z "$url" ]; then
    echo "No _amd64.deb asset found for $repo" >&2
    exit 1
  fi
  curl -fsSL -o "$tmpdir/${url##*/}" "$url"
  sudo dpkg -i "$tmpdir/${url##*/}"
done

echo "All packages installed successfully"
