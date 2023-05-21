#!/bin/bash

# Determine the operating system
OS=$(uname -s)

# Install dependencies based on the operating system
if [[ "$OS" == "Darwin" ]]; then
  # macOS dependencies
  echo "Installing macOS dependencies..."
  if [[ -x "$(command -v brew)" ]]; then
    brew install git zip
  else
    echo "Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install git zip
  fi

elif [[ "$OS" == "Linux" ]]; then
  # Linux dependencies
  echo "Installing Linux dependencies..."
  if [[ -x "$(command -v apt-get)" ]]; then
    # Debian-based Linux (e.g., Ubuntu)
    sudo apt-get update
    sudo apt-get install -y git zip
  elif [[ -x "$(command -v yum)" ]]; then
    # Red Hat-based Linux (e.g., CentOS, Fedora)
    sudo yum install -y git zip
  elif [[ -x "$(command -v pacman)" ]]; then
    # Arch Linux
    sudo pacman -Syu --noconfirm git zip
  elif [[ -x "$(command -v zypper)" ]]; then
    # openSUSE-based Linux (e.g., openSUSE Leap)
    sudo zypper install -y git zip
  else
    # Detect other Linux distributions
    if [[ -x "$(command -v apk)" ]]; then
      # Alpine Linux
      sudo apk update
      sudo apk add git zip
    elif [[ -x "$(command -v dnf)" ]]; then
      # Fedora (dnf package manager)
      sudo dnf install -y git zip
    elif [[ -x "$(command -v emerge)" ]]; then
      # Gentoo Linux
      sudo emerge -av dev-vcs/git app-arch/zip
    elif [[ -x "$(command -v xbps-install)" ]]; then
      # Void Linux
      sudo xbps-install -Sy git zip
    elif [[ -x "$(command -v pkg)" ]]; then
      # FreeBSD
      sudo pkg install -y git zip
    elif [[ -x "$(command -v pkg_add)" ]]; then
      # OpenBSD
      sudo pkg_add -v git zip
    else
      echo "Unsupported Linux distribution. Please install 'git' and 'zip' manually."
      exit 1
    fi
  fi

elif [[ "$OS" == "MINGW"* ]]; then
  # Windows (Git Bash)
  echo "Installing Windows dependencies..."
  if [[ -x "$(command -v choco)" ]]; then
    choco install git zip
  else
    echo "Chocolatey is not installed. Installing Chocolatey..."
    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    choco install git zip
  fi

else
  echo "Unsupported operating system. Please install 'git' and 'zip' manually."
  exit 1
fi

# Clone or download the Quantum Ad List repository
git clone https://gitlab.com/The_Quantum_Alpha/the-quantum-ad-list.git

# Create the adblocker directory structure
mkdir -p adblocker

# Copy the manifest JSON file
cat > adblocker/manifest.json <<EOF
{
  "manifest_version": 3,
  "name": "Quantum AdBlocker",
  "version": "1.0",
  "description": "Adblocker extension based on the Quantum Ad List",
  "action": {
    "default_popup": "popup.html"
  },
  "icons": [
    {
      "src": "icons/icon48.png",
      "sizes": "48x48",
      "type": "image/png"
    },
    {
      "src": "icons/icon128.png",
      "sizes": "128x128",
      "type": "image/png"
    }
  ]
}
EOF

# Copy the popup HTML file
cat > adblocker/popup.html <<EOF
<!DOCTYPE html>
<html>
<head>
  <title>Quantum AdBlocker</title>
  <link rel="stylesheet" type="text/css" href="popup.css">
  <script type="module" src="popup.js"></script>
</head>
<body>
  <h1>Quantum AdBlocker</h1>
  <p>Ad blocking is active.</p>
</body>
</html>
EOF

# Copy the popup CSS file
cat > adblocker/popup.css <<EOF
/* Add your custom styles here */
EOF

# Create the icons directory and copy the icon files
mkdir -p adblocker/icons
cp the-quantum-ad-list/src/icons/*.png adblocker/icons

# Clean up the temporary Quantum Ad List directory
rm -rf the-quantum-ad-list

# Create the adblocker ZIP file
zip -r adblocker.zip adblocker

echo "Chromium adblocker extension build completed."

# Open a terminal and set the executable permission
if [[ "$OS" == "Darwin" ]]; then
  open -a Terminal.app
  echo "Please run 'chmod +x build-adblocker.sh' in the opened terminal."
elif [[ "$OS" == "Linux" ]]; then
  x-terminal-emulator -e "chmod +x build-adblocker.sh"
elif [[ "$OS" == "MINGW"* ]]; then
  echo "Please open a Command Prompt and run 'chmod +x build-adblocker.sh'."
else
  echo "Executable permission should be set manually. Please run 'chmod +x build-adblocker.sh'."
fi
