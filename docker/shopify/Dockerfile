FROM ruby:3.0

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#RUN curl -s https://api.github.com/repos/Shopify/shopify-cli/releases/latest \
#  | grep browser_download_url \
#  | grep shopify-cli \
#  | grep .deb \
#  | cut -d '"' -f 4 \
#  | wget -O shopify-cli.deb -qi -

#RUN apt install shopify-cli.deb

#RUN wget -O ruby-gem.tar.gz https://rubygems.org/rubygems/rubygems-3.2.31.tgz && \
#    tar -xzf ruby-gem.tar.gz && \
#    cd rubygems* && \
#    ruby setup.rb

RUN gem install shopify-cli

RUN shopify version

# Arguments defined in docker-compose.yml
ARG USER_ID
ARG GROUP_ID

# Create system user to run Composer and Artisan Commands
RUN if getent group app ; then groupdel app; fi &&\
    groupadd -g ${GROUP_ID} app &&\
    useradd -l -u ${USER_ID} -g app app &&\
    install -d -m 0755 -o app -g app /home/app &&\
    chown --changes --silent --no-dereference --recursive \
        ${USER_ID}:${GROUP_ID} \
        /home/app 

USER app

#ENTRYPOINT /usr/local/bundle/bin/shopify

EXPOSE 9292
EXPOSE 3456