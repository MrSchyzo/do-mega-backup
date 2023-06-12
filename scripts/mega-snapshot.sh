#!/bin/bash

log() {
    COLOR="${1:-0}"
    START="\e[${COLOR}m"
    END="\e[0m"
    >&2 echo -e "${START}[$(date +"%Y-%m-%dT%H:%M:%S%z")]${END} ${@:2}"
}

err() {
    log 31 $@
}

warn() {
    log 33 $@
}

succ() {
    log 32 $@
}

info() {
    log 0 $@
}

debug() {
    log 34 $@
}

mega-dl() {
    until mega-get  $@ ; do err "❌ cannot execute mega-get $@, retrying in 15s..." ; sleep 15 ; done
}

password="${ZIP_PASSWORD}"
if [ -z "$password" ] ; then
    err '❌ need ZIP_PASSWORD env var to work!'
    exit
fi

max_backups="${MAX_BACKUPS:-7}"
if ! [ "$max_backups" -eq "$max_backups" ] ; then
    err '❌ need numeric MAX_BACKUPS env var to work!'
    exit
fi

polling=${POLLING_SECONDS:-600}
if ! [ "$polling" -eq "$polling" ] ; then
    err '❌ need numeric POLLING_SECONDS env var to work!'
    exit
fi

pushd /backups
until mega-ls; do info "⧗ waiting for mega to login..." ; sleep 10 ; done

while true; do
    folder="$(date +Mega_%Y%m%d)"
    while [ -f "$folder.7z" ] ; do
        warn "❕ $folder.7z already exists - retrying in $polling seconds"
        sleep "$polling"
        folder="$(date +Mega_%Y%m%d)"
    done

    mkdir -p "$folder" \
        && info "⬇️ downloading whole MEGA dir into (encrypted) $folder.7z" \
        && mega-dl . "$folder" \
        && info "🗜️ compressing $folder into $folder.7z" \
        && 7z a -P"${password}" "$folder" ./"$folder"/* \
        && succ "✅ $folder.7z has been created"

    info "🧹 cleaning up folder $folder" && rm -r "$folder/"
    
    extra_backups="$(( $(ls -t *.7z | wc -l) - $max_backups ))"
    if (($extra_backups > 0)) ; then
        info "🧹 cleaning up following $extra_backups backup(s)"
        for old in $(ls -t *.7z | tail -n "$extra_backups") ; do
            info "🗑️ removing $old"
            rm -f "$old"
        done
    fi
done
popd