# Do MEGA Backup
Docker image to snapshot MEGA folders in local

## What's this?
It's just a Docker image used to connect to MEGA and create periodic snapshot of the entire remote folder.

## What's with the name?
You have alternatives to interpret the string "domegabackup"
1. "Do MEGA Backup": self explanatory
2. "D.O. MEGA Backup": Docker Operator MEGA Backup
3. dOmegaBackup: docker Omega Backup, just because greek letters are cool in names

## Can it be of use for others?
I hope so, but I don't expect it to be that useful.

---

# How to build

## Requirements
1. You have a MEGA account
2. You have 2FA in such account with TOTP (e.g. google authenticator)
3. You have Docker installed
4. You can run bash scripts
5. You know how to run Docker from CLI

## What to do
1. run `./build.sh`
2. insert mail
3. insert password
4. insert 2FA TOTP
5. decide a zip password and use it as `ZIP_PASSWORD` env var
6. decide a maximum number of snapshots you want to store and use it as `MAX_BACKUPS` env var 
7. either create a docker-compose like the one in this repo or:
    ```bash
    docker run \
        --rm \
        -e ZIP_PASSWORD=password \
        -e MAX_BACKUPS=1 \
        --name domegabackup \
        -v "$(pwd)/backups":/backups:z \
        domegabackup-logged:1.0.0
    ```
   even better:
    ```bash
    docker run \
        --rm \
        --env-file <yourFileWithTheEnvVars> \
        --name domegabackup \
        -v "$(pwd)/backups":/backups:z \
        domegabackup-logged:1.0.0
    ```
