#!/bin/sh

# Determine the directory of the script
DIR="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"

# Define the source command
source_cmd="source \"$DIR/loader.sh\""

# Initialize the file variable based on the current shell
file=""
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
