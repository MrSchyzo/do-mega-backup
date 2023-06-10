#!/bin/bash

mega-dl() {
    until mega-get  $@ ; do echo "❌ cannot execute mega-get $@, retrying in 15s..." ; sleep 15 ; done
}

[ -z "$ZIP_PASSWORD" ] && echo '❌ need ZIP_PASSWORD env var to work!' && exit 
[ -z "$MAX_BACKUPS" ] && echo '❌ need MAX_BACKUPS env var to work!' && exit 

pushd /backups
until mega-ls; do >&2 echo "⧗ waiting for mega to login..." ; sleep 10 ; done

while true; do
    folder="$(date +Mega_%Y%m%d)"
    if [ -d "$folder.7z" ] ; then
        >&2 echo "⚠️ $folder.7z already exists - waiting for 10mins"
        sleep 60000
    fi

    >&2 echo "⬇️ download whole MEGA dir into an encrypted $folder.7z"
    mkdir -p "$folder" && mega-dl . "$folder" && 7z a -P"${ZIP_PASSWORD}" "$folder"
    rm -r "$folder/"
    >&2 echo "✅ $folder.7z has been created"
    
    extra_backups="$(( $(ls -t *.7z | wc -l) - $MAX_BACKUPS ))"
    if (($extra_backups > 0)) ; then
        >&2 echo "🧹 cleaning up oldest following $extra_backups backup(s)"
        for old in $(ls -t *.7z | tail -n "$extra_backups") ; do
            >&2 echo "🗑️ removing $old"
            rm -f "$old"
        done
    fi
done
popd