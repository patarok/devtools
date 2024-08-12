DEV_HOME="$HOME/lib/devtools"

PROMPT_COMMAND="history -a"

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

# Sudo Aliases
alias sapt="sudo apt"

# Cheat Alias
alias cheat='docker run --rm bannmann/docker-cheat'

# z
if [[ ! -e "$DEV_HOME/lib/z.sh" ]]; then
	wget https://raw.githubusercontent.com/rupa/z/master/z.sh --quiet -O "$DEV_HOME/lib/z.sh"
fi

. "$DEV_HOME/lib/z.sh"

PATH="$PATH:$DEV_HOME/bin:$DEV_HOME/bin/core"
