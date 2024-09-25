#/bin/bash


#function definitions
append_alias() {
    local shell_file="$1"
    local alias_command="$2"

    # Check if the alias already exists in the file
    if grep -qF "$alias_command" "$shell_file"; then
        echo "Alias already exists in $shell_file."
    else
        echo "$alias_command" >> "$shell_file"
        echo "Alias added to $shell_file."
    fi
}

### Install basics
echo "Install basic Packages"

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



### Install Chrome -- not needed now

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

sudo dpkg -i google-chrome-stable_current_amd64.deb

rm google-chrome-stable_current_amd64.deb



### Install Sublime
echo "Installing Sublime"

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update 

sudo apt-get install -y sublime-text

### Install VSCode
echo "Installing vscode"

wget -O vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868
sudo dpkg -i vscode.deb
sudo apt-get install -f
rm vscode.deb


### Install Typora
echo "Installing Typora"

wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
sudo add-apt-repository 'deb https://typora.io/linux ./'  
sudo apt-get update 

sudo apt-get install -y typora



##### Docker
echo "Install Docker"


#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#sudo add-apt-repository \
#   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) \
#   stable" 

sudo apt-get update 

sudo apt-get install -y docker.io


if [ ! $(getent group docker) ]; then
  sudo groupadd docker
fi

sudo usermod -aG docker $USER


sudo tee /etc/docker/daemon.json > /dev/null <<EOT 
{
  "default-address-pools":
  [
    {"base":"10.244.0.0/16","size":24}
  ]
}

EOT


### Docker Compose
echo "Installing docker compose"


dcRelease="1.29.2"
sudo curl -L "https://github.com/docker/compose/releases/download/$dcRelease/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo curl -L "https://raw.githubusercontent.com/docker/compose/$dcRelease/contrib/completion/bash/docker-compose" -o /etc/bash_completion.d/docker-compose

#docker login https://hub.docker.com


### Nginx
#echo "Installing nginx"

#sudo add-apt-repository -y ppa:ondrej/nginx 
#sudo apt-get update 
#sudo apt-get install -y nginx


### PHP
echo "Installing php"

sudo add-apt-repository -y ppa:ondrej/php 

versions="8.1"
extensions="bcmath bz2 cli common curl dev fpm gd intl ldap mbstring mysql odbc opcache pgsql readline snmp soap sqlite3 xml xsl zip"

phpPackages=""
for version in $versions;do
    phpPackages="$phpPackages php${version}"
    for extension in $extensions;do
      phpPackages="$phpPackages php${version}-${extension}"
    done
done

sudo apt-get install -y $phpPackages 

sudo update-alternatives --set php /usr/bin/php8.0

### Install Composer

EXPECTED_CHECKSUM=$(wget -q -O - https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM=$(php -r "echo hash_file('sha384', 'composer-setup.php');")

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

sudo php composer-setup.php --quiet --install-dir=/usr/local/bin --filename=composer
RESULT=$?
rm composer-setup.php


### Install Node
echo "Installing Node"

curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

### Install n
sudo npm install -g n


### Install insomnia

curl -1sLf \
  'https://packages.konghq.com/public/insomnia/setup.deb.sh' \
  | sudo -E distro=ubuntu codename=focal bash

# Refresh repository sources and install Insomnia
sudo apt-get update 
sudo apt-get install -y insomnia


### set devhome
echo "now you have to tell me where your dev-home is located at, so I can set a short for you...\n"

# Prompt user for devhome directory
read -p "Enter the devhome directory: " devhome

# Validate the input
if [[ ! -d "$devhome" ]]; then
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
# Notify user
echo "Please restart your shell to apply changes.\n"


echo "Then, install the following one by hand: \nJetbrains toolbox https://www.jetbrains.com/toolbox-app/ https://www.microsoft.com/de-at/microsoft-teams/download-app"
