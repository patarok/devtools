#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source="source \"$DIR/loader.sh\""
file=""
if [[ "$SHELL" == '/bin/bash' ]]; then
  file="$HOME/.bashrc"  
fi

if [[ "$SHELL" == '/bin/zsh' ]]; then
  file="$HOME/.zshrc"
fi

if [[ "$SHELL" == '/usr/bin/zsh' ]]; then
  file="$HOME/.zshrc"
fi

if [[ "$file" == "" ]]; then
  echo "Unknown shell. Please report an issue!"
  exit 1
fi

case `grep "$source" "$file" > /dev/null; echo $?` in
  0)
    echo "Loader already registered."
    ;;
  1)
    echo "Registering loader in $file"
    echo "$source" >> "$file"
    ;;
  *)
    echo "Unknown error occoured. Please report an issue!"
    exit 1
    ;;
esac


if [[ "$1" == "--setup" ]]; then
  echo "Running setup script..."
  $SHELL "$DIR/setup.sh"
fi
