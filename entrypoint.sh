#!/bin/sh

set -eu

if [ ! -f "$SSHD_HOST_KEYS_DIR/rsa" ]; then
    ssh-keygen -t rsa -b 4096 -N '' -f "$SSHD_HOST_KEYS_DIR/rsa"
fi
if [ ! -f "$SSHD_HOST_KEYS_DIR/ed25519" ]; then
    ssh-keygen -t ed25519 -N '' -f "$SSHD_HOST_KEYS_DIR/ed25519"
fi

set -x

exec "$@"
