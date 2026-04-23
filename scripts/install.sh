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
  MINGW*|MSYS*|CYGWIN*) OS="Windows" ;;
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

# Map to YOUR release names
if [ "$OS" = "Linux" ]; then
  TAG="Linux"
elif [ "$OS" = "Darwin" ] && [ "$ARCH" = "arm64" ]; then
  TAG="Apple-silicon"
elif [ "$OS" = "Darwin" ] && [ "$ARCH" = "amd64" ]; then
  TAG="Apple-intel"
elif [ "$OS" = "Windows" ]; then
  TAG="Windows"
else
  echo "No matching release for $OS $ARCH"
  exit 1
fi

echo "Using release tag: $TAG"

URL="https://github.com/$REPO/releases/latest/download/boltx"

TMP="/tmp/boltx"

echo "Downloading from: $URL"

if ! curl -L "$URL" -o "$TMP"; then
  echo "Download failed."
  exit 1
fi

chmod +x "$TMP"

# Install location
if [ "$OS" = "Windows" ]; then
  INSTALL_DIR="$HOME/bin"
  mkdir -p "$INSTALL_DIR"
  mv "$TMP" "$INSTALL_DIR/boltx.exe"

  echo ""
  echo "Add this to PATH if needed:"
  echo 'export PATH="$HOME/bin:$PATH"'
else
  INSTALL_DIR="/usr/local/bin"
  sudo mv "$TMP" "$INSTALL_DIR/$BIN_NAME"
fi

echo ""
echo "BoltX installed successfully!"
echo "Run: boltx search hello"