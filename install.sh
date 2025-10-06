#!/bin/bash
# ===== BANAPHAR Terminal Installer =====
# Created by Vivek Banaphar ⚔️

echo "🔹 Updating packages..."
pkg update -y && pkg upgrade -y
pkg install ncurses-utils -y
echo "🔹 Installing required packages..."
pkg install -y bash nano figlet toilet ruby coreutils

echo "🔹 Installing lolcat..."
gem install lolcat

echo "🔹 Setting up nano softwrap..."
mkdir -p ~/.config/nano
echo "set softwrap" > ~/.config/nano/nanorc

echo "🔹 Installing BANAPHAR Terminal..."
cp .bashrc ~/.bashrc

echo "✅ Installation complete!"
echo "Restart Termux to see the BANAPHAR Galaxy Terminal."
