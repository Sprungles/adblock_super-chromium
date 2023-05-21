#!/bin/bash

# Determine the operating system
OS=$(uname -s)

# Define the extension file path
EXTENSION_FILE="adblocker.zip"

# Function to install the Chromium extension on Windows
install_extension_windows() {
  echo "Installing Chromium extension on Windows..."

  if [[ -x "$(command -v choco)" ]]; then
    # Using Chocolatey package manager
    choco install chromium -y
  else
    echo "Chocolatey is not installed. Please install Chromium manually."
    exit 1
  fi

  # Find the Chromium executable path
  CHROMIUM_PATH="$(where chromium)"

  # Install the extension
  "$CHROMIUM_PATH" --load-extension="$EXTENSION_FILE"
}

# Function to install the Chromium extension on macOS
install_extension_macos() {
  echo "Installing Chromium extension on macOS..."

  if [[ -x "$(command -v brew)" ]]; then
    # Using Homebrew package manager
    brew install chromium
  else
    echo "Homebrew is not installed. Please install Chromium manually."
    exit 1
  fi

  # Find the Chromium executable path
  CHROMIUM_PATH="$(brew --prefix)/opt/chromium/bin/chromium"

  # Install the extension
  "$CHROMIUM_PATH" --load-extension="$EXTENSION_FILE"
}

# Function to install the Chromium extension on Linux
install_extension_linux() {
  echo "Installing Chromium extension on Linux..."

  if [[ -x "$(command -v chromium)" ]]; then
    # Using system-installed Chromium
    CHROMIUM_PATH="$(which chromium)"
  elif [[ -x "$(command -v chromium-browser)" ]]; then
    # Using system-installed Chromium (alternative name)
    CHROMIUM_PATH="$(which chromium-browser)"
  else
    echo "Chromium is not installed. Please install Chromium manually."
    exit 1
  fi

  # Install the extension
  "$CHROMIUM_PATH" --load-extension="$EXTENSION_FILE"
}

# Function to install the Chromium extension on BSD
install_extension_bsd() {
  echo "Installing Chromium extension on BSD..."

  if [[ -x "$(command -v chromium)" ]]; then
    # Using system-installed Chromium
    CHROMIUM_PATH="$(which chromium)"
  else
    echo "Chromium is not installed. Please install Chromium manually."
    exit 1
  fi

  # Install the extension
  "$CHROMIUM_PATH" --load-extension="$EXTENSION_FILE"
}

# Install the Chromium extension based on the operating system
if [[ "$OS" == "Darwin" ]]; then
  install_extension_macos
elif [[ "$OS" == "Linux" ]]; then
  install_extension_linux
elif [[ "$OS" == "FreeBSD" ]] || [[ "$OS" == "OpenBSD" ]] || [[ "$OS" == "NetBSD" ]]; then
  install_extension_bsd
elif [[ "$OS" == "MINGW"* ]]; then
  install_extension_windows
else
  echo "Unsupported operating system. Please install Chromium and load the extension manually."
  exit 1
fi
