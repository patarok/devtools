FROM php:8.0-cli-alpine

LABEL maintainer="Peter Patoschka <patoschkapeter@gmail.com>"


# Arguments defined in docker-compose.yml
ARG USER_ID
ARG GROUP_ID

RUN apk add openssh
RUN apk add sshpass
RUN apk add rsync

# Create system user to run Composer and Artisan Commands
RUN addgroup -g ${GROUP_ID} deployer &&\
    adduser --uid ${USER_ID} --ingroup deployer --disabled-password deployer


ENV DEPLOYER_VERSION=6.9.0

        
RUN curl -L https://deployer.org/releases/v$DEPLOYER_VERSION/deployer.phar > /usr/local/bin/deployer \
    && chmod +x /usr/local/bin/deployer

USER deployer

VOLUME ["/project", "$HOME/.ssh"]
WORKDIR /project