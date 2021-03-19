#!/bin/bash

set -eu

if [ ! -f "$SSHD_HOST_KEYS_DIR/rsa" ]; then
    ssh-keygen -t rsa -b 4096 -N '' -f "$SSHD_HOST_KEYS_DIR/rsa"
fi
if [ ! -f "$SSHD_HOST_KEYS_DIR/ed25519" ]; then
    ssh-keygen -t ed25519 -N '' -f "$SSHD_HOST_KEYS_DIR/ed25519"
fi
unset SSHD_HOST_KEYS_DIR

if [ ! -d "$HOME/.gitolite" ]; then
    # > First run: either the pubkey or the admin name is *required*, [...]
    (set -x; gitolite setup --admin "$GITOLITE_INITIAL_ADMIN_NAME")
fi
unset GITOLITE_INITIAL_ADMIN_NAME

key_dir_path="$HOME/.container-entrypoint/users/public-keys"
mkdir --parents "$key_dir_path"
for var_name in $(compgen -e); do
    if [[ $var_name =~ ^GITOLITE_USER_PUBLIC_KEY_ ]]; then
        user="${var_name#GITOLITE_USER_PUBLIC_KEY_}"
        # https://github.com/sitaramc/gitolite/blob/v3.6.11/src/lib/Gitolite/Setup.pm#L93
        key_path="${key_dir_path}/${user}.pub"
        printenv "$var_name" > "$key_path"
        (set -x; gitolite setup --pubkey "$key_path")
        unset "$var_name"
    fi
done

set -x

exec "$@"
