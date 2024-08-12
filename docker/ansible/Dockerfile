FROM ubuntu:20.04

WORKDIR /ansible

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    software-properties-common \
    openssh-client \
    && add-apt-repository --yes --update ppa:ansible/ansible \
    && apt-get install -y --no-install-recommends ansible \
    && apt-get clean && rm -rf /var/lib/apt/lists/*




# Arguments defined in docker-compose.yml
ARG USER_ID
ARG GROUP_ID

# Create system user to run Composer and Artisan Commands
RUN if getent group ansible ; then groupdel ansible; fi &&\
    groupadd -g ${GROUP_ID} ansible &&\
    useradd -l -u ${USER_ID} -g ansible ansible &&\
    install -d -m 0755 -o ansible -g ansible /home/ansible &&\
    chown --changes --silent --no-dereference --recursive \
        ${USER_ID}:${GROUP_ID} \
        /home/ansible 

USER ansible

RUN printf "[defaults]\ninventory = {{CWD}}/hosts" > /home/ansible/.ansible.cfg

ENV ANSIBLE_ROLES_PATH /ansible/roles

#RUN python -m pip install --user ansible

#ENTRYPOINT /usr/local/bundle/bin/shopify

EXPOSE 9292
EXPOSE 3456