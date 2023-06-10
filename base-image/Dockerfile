FROM --platform=amd64 ubuntu:23.04

RUN mkdir -p /workdir && mkdir -p /backups
WORKDIR /workdir

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y curl p7zip-full

RUN curl https://mega.nz/linux/repo/xUbuntu_23.04/amd64/megacmd-xUbuntu_23.04_amd64.deb -o mega.install.deb && \
    dpkg -i mega.install.deb || apt -y -f install && \
    dpkg -i mega.install.deb && \
    rm mega.install.deb && \
    apt autoremove -y && \
    apt purge -y