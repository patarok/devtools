# Peters Devtools

> “Laziness is the key to efficiency.”

― Marcel

## Installation

`cd ~ && mkdir lib && cd lib && git clone git@github.com:patarok/devtools.git && cd devtools && ./install.sh`


## Usage


### Commands

All Commands detect project setup and act accordingly.

you will find out more about what each command does in the description

|Command|Description|
|---|---|
| start | Starts current project |
| stop | Stops current project |
| restart | Stops then starts current project |
| down | Stops current project && Removes cached data |
| build | Builds current project |
| start | Run command in current project |
| status | Shows status information about current project |
| shell | Opens a shell or runs command in a shell for current project |
| logs | Shows logs for current project |
| dep | Deploys current project |
| artisan | shortcut for `shell app php artisan` | 
| laravel | Runs laravel commands (actually only "new" and "routes") |
| ssh-keygen-ed25519 | Generates ssh-key with ed24419 cypher |
| ssh-keygen-remote [ssh_server] | Generates ssh-key on remote host and echos public key (very nice for git deploys) |
| sendertest | Tests smtp credentials on smtp2go (senterdest [username] [password] [toMail - optional]) |
| remote-to-remote | Copies files from source to target via rsync see command description |
| devtools-update | Updates this devtools |
| z | See https://github.com/rupa/z |
| ngrok | See https://ngrok.com/ |
| shopify | Implementation der shopify-cli https://shopify.dev/themes/tools/cli |
| ssh-audit | SSH Audit für Zieldomain ssh-audit 192.168.1.2 https://github.com/jtesta/ssh-audit |
| ngrok-dev | Use ngrok predefined setup |
| svelte-icon | Generates A Svelte icon from Streamline icons light. run svelte-icon --help |
| svelte-icon-duo | Generates A Svelte icon from Streamline icons core duo. run svelte-icon-duo --help |
| composer-download | downloads current version of composer.phar into current directory |
| mkcert | Local development certificates https://github.com/FiloSottile/mkcert |

### Aliases

| Alias          | Command                                                 |
| -------------- | ------------------------------------------------------- |
| gs             | git status -sb                                          |
| gl             | git log ......                                          |
| ga             | git add -A .                                            |
| gcm            | git commit -am                                          |
| gco            | git chekout                                             |
| gp             | git push                                                |
| gpp            | git pull && git push                                    |
| dps            | docker-compose ps                                       |
| docker-compose | uid=$(id -u) gid=$(id -g) /usr/local/bin/docker-compose |
| clone          | rsync -rltpzv                                           |





## Available Project Types

### Docker Compose

> if folder contains `docker-compose.yml`

#### start

Starts containers defined in docker-compose.yml.

Runs `docker-compose up -d [container] `

e.g.

```
start # starts all containers
start app # starts container called 'app'
```

#### stop

Stops all containers defined in docker-compose.yml.

Runs `docker-compose stop [args**]`

e.g.

```
stop # stopps all containers
stop app # stopss app container
```



#### down

Shuts down containers defined in docker-compose.yml.

Runs `docker-compose down [args**]`

e.g.

```
down # stops all containers and removes them
down -v # stops all containers and volumes and removes them
```

#### build

Builds images defined in docker-compose.yml.

Runs `docker-compose build [args**]` 

e.g.

```
build # builds all images
build app # builds image for container called 'app'
```

#### run

Runs command in images defined in docker-compose.yml.

Runs `docker-compose run [args**]` 

e.g.

```
run app npm install # runns npm instann in new container instance of app
```



#### status

Shows container status

Runs `docker-compose ps`

e.g.

```
status # shows all containers
```

#### shell

Gets into a container or runs command inside container. You have to start them first.

If no args are given it uses the container called 'app' and runs '/bin/bash'

Runs `docker-compose exec [container <app>][args**  </bin/bash>]`

e.g.

```
shell # a new '/bin/bash' shell is opend inside the 'app' container
shell app php artisan test # runs the command `php artisan test` inside the app container
shell runner sh # runs the sh command (opens shell) inside the 'runner' container
```

#### logs

Shows logs for containers.

Shows logs for 'app' container per default. Default to  `--tail=100` (last 100 rows) and `-f` (follow) 

Runs `docker-compose logs [args** <--tail=100 -f>] [container <app>]`

e.g.

```
logs # shows last 100 logs for app container and follows
logs db # shows last 100 logs for db container and follows
logs db --tail=1000 # shows last 1000 logs for db container
```

#### laravel new

Create new Laravel Project

e.g.

```
laravel new blog # creates a new laravel project in directory blog
```

#### laravel routes

List Laravel routes with search

e.g.

```
laravel routes # list all routes
```

```
laravel routes user # lists all routes with user in name
```

#### remote-to-remote

Usage: remote-to-remote --source <user@host> --target <user@host> [-h]

Sends files from source ispconfig web folter to target ispconfig web folder.

Requires ispconfig users on both ispconfigs without jailkit.


### Deployer

> if folder contains deployer.php

Runs deployer in a docker container (no local deployer needed) see: https://deployer.org/. Uses your local configured ssh-agent instance.


Runs `docker run --rm -it -v "$(pwd)":/project -v "${HOME}/.ssh":/home/deployer/.ssh deployer /usr/local/bin/deployer $command`

e.g.

```
dep # deploys to staging (runs task deploy staging from deployer.php)
dep deploy:unlock production # unlocks deployments for production (runs task deploy:unlock production)
```

# devtools
