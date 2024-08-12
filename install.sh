#!/bin/bash

# Determine the directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Define the source command
source_cmd="source \"$DIR/loader.sh\""

# Initialize the file variable based on the current shell
file=""
case "$SHELL" in
  /bin/bash)
    file="$HOME/.bashrc"
    ;;
  /bin/zsh | /usr/bin/zsh)
    file="$HOME/.zshrc"
    ;;
  *)
    echo "Unknown shell. Please report an issue!"
    exit 1
    ;;
esac

# Check if the source command is already in the file
if grep -qF "$source_cmd" "$file"; then
  echo "Loader already registered."
else
  echo "Registering loader in $file"
  echo "$source_cmd" >> "$file"
fi

# Run the setup script if --setup argument is passed
if [[ "$1" == "--setup" ]]; then
  echo "Running setup script..."
  bash "$DIR/setup.sh"  # Always use bash to run the setup script
fi
