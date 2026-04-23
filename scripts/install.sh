#!/usr/bin/env bash
set -e

REPO="Tomdabom27/BoltX"
BIN_NAME="boltx"

OS="$(uname -s)"
ARCH="$(uname -m)"

echo "Detecting system..."
echo "OS: $OS"
echo "ARCH: $ARCH"

# Normalize OS
case "$OS" in
  Linux*) OS="Linux" ;;
  Darwin*) OS="Darwin" ;;
  MINGW*|MSYS*|CYGWIN*)
    echo "Windows is not supported in this installer."
    echo "Use the PowerShell installer instead:"
    echo "irm https://raw.githubusercontent.com/Tomdabom27/BoltX/main/scripts/install.ps1 | iex"
    exit 1
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

# Normalize ARCH
case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# Build URL based on YOUR release structure
if [ "$OS" = "Linux" ]; then
  URL="https://github.com/$REPO/releases/download/Linux/boltx"
  INSTALL_DIR="/usr/local/bin"

elif [ "$OS" = "Darwin" ] && [ "$ARCH" = "arm64" ]; then
  URL="https://github.com/$REPO/releases/download/Apple-silicon/boltx"
  INSTALL_DIR="/usr/local/bin"

elif [ "$OS" = "Darwin" ] && [ "$ARCH" = "amd64" ]; then
  URL="https://github.com/$REPO/releases/download/Apple-intel/boltx"
  INSTALL_DIR="/usr/local/bin"

else
  echo "No matching release for $OS $ARCH"
  exit 1
fi

echo "Downloading from:"
echo "$URL"

TMP="$(mktemp -t boltx.XXXXXX)"

if ! curl -L "$URL" -o "$TMP"; then
  echo "Download failed."
  exit 1
fi

chmod +x "$TMP"

echo "Installing to: $INSTALL_DIR"
sudo mv "$TMP" "$INSTALL_DIR/$BIN_NAME"

echo ""
echo "BoltX installed successfully!"
echo "Run: boltx search hello"