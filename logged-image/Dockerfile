FROM --platform=amd64 domegabackup:latest

ARG user
ARG pass
ARG code

RUN mega-login "${user}" "${pass}" --auth-code="${code}"

COPY scripts /workdir/scripts

RUN sleep 10 && mega-ls

ENTRYPOINT [ "/workdir/scripts/mega-snapshot.sh" ]