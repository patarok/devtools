#!/bin/sh

OS="$(uname -s)"

DEV_HOME="$HOME/lib/devtools"

# Initialize PROMPT_COMMAND for bash; won't be used in sh
if [ -n "$BASH_VERSION" ]; then
    PROMPT_COMMAND="history -a"
fi

# Define Docker Compose alias
alias docker-compose="uid=$(id -u) gid=$(id -g) /usr/local/bin/docker-compose"

# Git Aliases
alias gs="git status -sb"
alias gl="git log --all --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias ga="git add -A ."
alias gcm="git commit -am "
alias gco="git checkout "
alias gp="git push"
alias gpp="git pull && git push"
alias dps="docker-compose ps"

# Rsync Aliases
alias clone="rsync -rltpzv"

# Sudo Apt Aliases
if [ "$OS" = "Linux" ]; then
    # Linux-specific installation using apt
    if command -v apt >/dev/null 2>&1; then
        echo "Detected Linux with apt package manager."
        alias sapt="sudo apt"
    else
        echo "apt package manager not found. Please install it or use a different Linux distribution."
    fi
elif [ "$OS" = "Darwin" ]; then
    # macOS-specific installation using Homebrew
    if command -v brew >/dev/null 2>&1; then
        echo "Detected macOS with Homebrew."
        alias sapt="sudo brew"
    else
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        alias sapt="sudo brew"
    fi
else
    echo "Unsupported operating system: $OS"
    exit 1
fi

# Cheat Alias
alias cheat='docker run --rm bannmann/docker-cheat'

# z script installation
if [ ! -e "$DEV_HOME/lib/z.sh" ]; then
    wget https://raw.githubusercontent.com/rupa/z/master/z.sh --quiet -O "$DEV_HOME/lib/z.sh"
fi

# Source z.sh
. "$DEV_HOME/lib/z.sh"

# Add directories to PATH
PATH="$PATH:$DEV_HOME/bin:$DEV_HOME/bin/core"

# Export updated PATH for subshells
export PATH
