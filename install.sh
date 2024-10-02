#!/bin/sh

# Detect the operating system
OS="$(uname -s)"

# Determine the directory of the script
DIR="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"

# Define the source command
source_cmd="source \"$DIR/loader.sh\""

# Define Google Chrome alias for mac
alias_google_chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'


# Initialize the file variable based on the current shell
file=""


if [ "$OS" = "Darwin" ]; then
    # Check for Homebrew
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew update
    brew install \
        ca-certificates \
        curl \
        gnupg \
        wget \
        git \
        jq \
        neovim \
        nss

    file="$HOME/.zprofile"
else
  case "$SHELL" in
    *bash)
      file="$HOME/.bashrc"
      ;;
    *zsh)
      file="$HOME/.zshrc"
      ;;
    *)
      echo "Unknown shell. Please report an issue!"
      exit 1
      ;;
  esac
fi


# Check if the shell configuration file exists
if [ ! -f "$file" ]; then
  echo "Shell configuration file $file does not exist. Creating it."
  touch "$file"
fi

# Check if the source command is already in the file
if grep -qF "$source_cmd" "$file"; then
  echo "Loader already registered."
else
  echo "Registering loader in $file"
  echo "$source_cmd" >> "$file"
fi

if [ "$OS" = "Darwin" ]; then
  if grep -qF "$alias_google_chrome" "$file"; then
    echo "Alias already set."
  else
    echo "Setting alias for Google-Chrome Mac App to chrome binary in $file"
    echo "$alias_google_chrome" >> "$file"
  fi
else
  echo "not a mac. not setting an alias to App package"
fi

# Run the setup script if --setup argument is passed
if [ "$1" = "--setup" ]; then
  echo "Running setup script..."
  # Use the appropriate shell to run the setup script
  if [ -f "$DIR/setup.sh" ]; then
    . "$DIR/setup.sh"  # Use dot (.) to source the script
  else
    echo "Setup script not found."
    exit 1
  fi
fi
