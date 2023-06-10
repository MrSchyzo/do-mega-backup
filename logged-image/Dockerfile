FROM --platform=amd64 domegabackup:latest

ARG user
ARG pass
ARG code

RUN mega-login "${user}" "${pass}" --auth-code="${code}" && \
    sleep 10 && \
    mega-ls