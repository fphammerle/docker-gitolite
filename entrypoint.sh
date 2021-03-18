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

set -x

exec "$@"
