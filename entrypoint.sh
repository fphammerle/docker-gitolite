#!/bin/sh

set -eu

if [ ! -f "$SSHD_HOST_KEYS_DIR/rsa" ]; then
    ssh-keygen -t rsa -b 4096 -N '' -f "$SSHD_HOST_KEYS_DIR/rsa"
fi
if [ ! -f "$SSHD_HOST_KEYS_DIR/ed25519" ]; then
    ssh-keygen -t ed25519 -N '' -f "$SSHD_HOST_KEYS_DIR/ed25519"
fi

if [ ! -d "$HOME/.gitolite" ]; then
    # > First run: either the pubkey or the admin name is *required*, [...]
    (set -x; gitolite setup --admin "$GITOLITE_INITIAL_ADMIN_NAME")
fi
unset GITOLITE_INITIAL_ADMIN_NAME

printenv | cut -d = -f 1 | while IFS= read -r var_name; do
    if [ "$(echo "$var_name" | cut -d _ -f -4)" = "GITOLITE_USER_PUBLIC_KEY" ]; then
        user="$(echo "$var_name" | cut -d _ -f 5-)"
        key_path="$HOME/container-entrypoint-user-public-keys/${user}.pub"
        mkdir --parents "$(dirname "$key_path")"
        printenv "$var_name" > "$key_path"
        (set -x; gitolite setup --pubkey "$key_path")
    fi
done

set -x

exec "$@"
