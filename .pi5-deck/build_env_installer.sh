#!/usr/bin/env bash
set -euo pipefail

echo "== Pi5-Deck Build Environment Installer =="

# ---------------------------------------------------------
# Detect OS
# ---------------------------------------------------------
OS="unknown"
if grep -qi "raspbian" /etc/os-release; then
  OS="raspbian"
elif grep -qi "ubuntu" /etc/os-release; then
  OS="ubuntu"
elif grep -qi "debian" /etc/os-release; then
  OS="debian"
fi

echo "[*] Detected OS: $OS"

# ---------------------------------------------------------
# Update package lists
# ---------------------------------------------------------
echo "[*] Updating package lists..."
sudo apt update

# ---------------------------------------------------------
# Install core build tools
# ---------------------------------------------------------
echo "[*] Installing core build tools..."
sudo apt install -y \
  build-essential \
  cmake \
  make \
  ninja-build \
  pkg-config \
  git \
  git-lfs \
  curl \
  wget \
  unzip \
  zip \
  tar \
  rsync \
  jq

# ---------------------------------------------------------
# Install firmware + Pi tools
# ---------------------------------------------------------
echo "[*] Installing firmware tools..."
sudo apt install -y \
  device-tree-compiler \
  rpi-eeprom \
  libraspberrypi-bin || true

# ---------------------------------------------------------
# Install Python environment
# ---------------------------------------------------------
echo "[*] Installing Python + pip..."
sudo apt install -y python3 python3-pip python3-venv

echo "[*] Creating Python virtual environment..."
mkdir -p env
python3 -m venv env
source env/bin/activate
pip install --upgrade pip setuptools wheel

# ---------------------------------------------------------
# Install optional CAD/EDA tools (commented out)
# ---------------------------------------------------------
# echo "[*] Installing KiCad (optional)..."
# sudo apt install -y kicad

# echo "[*] Installing FreeCAD (optional)..."
# sudo apt install -y freecad

# echo "[*] Installing OpenSCAD (optional)..."
# sudo apt install -y openscad

# ---------------------------------------------------------
# Create build-tools directory
# ---------------------------------------------------------
mkdir -p build-tools

cat << 'TOOLS_EOF' > build-tools/README.md
# Pi5-Deck Build Tools

This directory contains helper tools, scripts, and binaries used during
the build, packaging, or deployment process.

Populate this directory with:
- custom compilers
- helper scripts
- CAD/EDA automation tools
- firmware utilities
TOOLS_EOF

# ---------------------------------------------------------
# System summary
# ---------------------------------------------------------
echo "[*] Writing system summary..."

cat << SYS_EOF > build-tools/system-info.txt
Pi5-Deck Build Environment Summary
==================================

Date: $(date)
OS: $OS
Kernel: $(uname -a)

Installed Tools:
- build-essential
- cmake
- ninja
- pkg-config
- git + git-lfs
- Python3 + pip + venv
- dtc (Device Tree Compiler)
- rpi-eeprom
- libraspberrypi-bin

Virtual Environment:
env/

SYS_EOF

echo "== Build environment installation complete =="
