#!/bin/sh

# Function to append an alias to the shell configuration file
append_alias() {
    shell_file="$1"
    alias_command="$2"

    # Check if the alias already exists in the file
    if grep -qF "$alias_command" "$shell_file"; then
        echo "Alias already exists in $shell_file."
    else
        echo "$alias_command" >> "$shell_file"
        echo "Alias added to $shell_file."
    fi
}

# Detect the operating system
OS="$(uname -s)"

### Install basics
echo "Installing basic packages"

if [ "$OS" = "Linux" ]; then
    sudo apt-get update 
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common \
        wget \
        git \
        remmina remmina-plugin-rdp \
        jq \
        neovim \
        libnss3-tools

elif [ "$OS" = "Darwin" ]; then
    # Update brew and install packages
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
fi

### Install Sublime
echo "Installing Sublime Text"
if [ "$OS" = "Linux" ]; then
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update 
    sudo apt-get install -y sublime-text

elif [ "$OS" = "Darwin" ]; then
    brew install --cask sublime-text
fi

### Install VSCode
echo "Installing VSCode"
if [ "$OS" = "Linux" ]; then
    wget -O vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868
    sudo dpkg -i vscode.deb
    sudo apt-get install -f -y
    rm vscode.deb

elif [ "$OS" = "Darwin" ]; then
    brew install --cask visual-studio-code
fi

### Install Typora
echo "Installing Typora"
if [ "$OS" = "Linux" ]; then
    wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
    sudo add-apt-repository 'deb https://typora.io/linux ./'  
    sudo apt-get update 
    sudo apt-get install -y typora

elif [ "$OS" = "Darwin" ]; then
    brew install --cask typora
fi

### Docker Installation
echo "Installing Docker"
if [ "$OS" = "Linux" ]; then
    sudo apt-get update 
    sudo apt-get install -y docker.io

elif [ "$OS" = "Darwin" ]; then
    brew install --cask docker
fi

# Docker usermod setup
if [ "$OS" = "Linux" ]; then
    if ! getent group docker >/dev/null; then
        sudo groupadd docker
    fi
    sudo usermod -aG docker "$USER"
    sudo tee /etc/docker/daemon.json > /dev/null <<EOT
{
  "default-address-pools": [
    {"base":"10.244.0.0/16","size":24}
  ]
}
EOT
fi

### Docker Compose
echo "Installing Docker Compose"
dcRelease="1.29.2"
sudo curl -L "https://github.com/docker/compose/releases/download/$dcRelease/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

### PHP Installation
echo "Installing PHP"
if [ "$OS" = "Linux" ]; then
    sudo add-apt-repository -y ppa:ondrej/php 
    versions="8.1"
    extensions="bcmath bz2 cli common curl dev fpm gd intl ldap mbstring mysql odbc opcache pgsql readline snmp soap sqlite3 xml xsl zip"
    phpPackages=""
    for version in $versions; do
        phpPackages="$phpPackages php${version}"
        for extension in $extensions; do
            phpPackages="$phpPackages php${version}-${extension}"
        done
    done
    sudo apt-get install -y $phpPackages

elif [ "$OS" = "Darwin" ]; then
    brew install php
fi

### Install Composer
echo "Installing Composer"
EXPECTED_CHECKSUM=$(wget -q -O - https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM=$(php -r "echo hash_file('sha384', 'composer-setup.php');")
if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi
sudo php composer-setup.php --quiet --install-dir=/usr/local/bin --filename=composer
rm composer-setup.php

### Node Installation
echo "Installing Node.js"
if [ "$OS" = "Linux" ]; then
    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo apt-get install -y nodejs

elif [ "$OS" = "Darwin" ]; then
    brew install node
fi

# Install `n` for Node version management
sudo npm install -g n

### Install Insomnia
echo "Installing Insomnia"
if [ "$OS" = "Linux" ]; then
    curl -1sLf 'https://packages.konghq.com/public/insomnia/setup.deb.sh' | sudo -E distro=ubuntu codename=focal bash
    sudo apt-get update 
    sudo apt-get install -y insomnia

elif [ "$OS" = "Darwin" ]; then
    brew install --cask insomnia
fi

### Set devhome alias
echo "Setting up devhome alias"

# Prompt user for devhome directory
read -p "Enter the devhome directory: " devhome

# Validate the input
if [ ! -d "$devhome" ]; then
    echo "Invalid directory: $devhome"
    exit 1
fi

# Construct the alias command
alias_command="alias devhome='cd $devhome'"

# Determine the shell and file to modify
case "$SHELL" in
    */bash)
        shell_file="$HOME/.bashrc"
        ;;
    */zsh)
        shell_file="$HOME/.zshrc"
        ;;
    *)
        echo "Unsupported shell: $SHELL"
        exit 1
        ;;
esac

# Append the alias to the appropriate file
append_alias "$shell_file" "$alias_command"

### Goodbye
echo "Please restart your shell to apply changes."

echo "Then, install the following manually:"
echo "Jetbrains Toolbox: https://www.jetbrains.com/toolbox-app/"
echo "Microsoft Teams: https://www.microsoft.com/de-at/microsoft-teams/download-app"
