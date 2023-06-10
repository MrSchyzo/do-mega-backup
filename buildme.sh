#!/bin/bash

docker build . \
    -f base-image/Dockerfile \
    -t domegabackup:latest \
    && read -p "Enter mega email: " user \
    && read -s -p "Enter Mega password: " pass \
    && echo \
    && read -s -p "Enter Mega 2FA code: " code \
    && docker build .  \
        --build-arg='user='"${user}" \
        --build-arg='pass='"${pass}" \
        --build-arg='code='"${code}" \
        -f logged-image/Dockerfile \
        -t domegabackup-logged:1.0.0 \
    && echo "🎉 Now try to run 'docker run --rm -it --name domegabackup domegabackup-logged:1.0.0'"
