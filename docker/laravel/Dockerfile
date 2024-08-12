FROM php:8.3.10-cli-alpine

LABEL maintainer="Peter Patoschka <patoschkapeter@gmail.com>"


# Arguments defined in docker-compose.yml
ARG USER_ID
ARG GROUP_ID

# Create system user to run Composer and Artisan Commands
RUN addgroup -g ${GROUP_ID} laravel &&\
    adduser --uid ${USER_ID} --ingroup laravel --disabled-password laravel


ENV COMPOSER_VERSION=2.0.7

        
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION}

USER laravel

VOLUME ["/project", "$HOME/.ssh"]
WORKDIR /project