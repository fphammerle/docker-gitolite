# docker: gitolite 💾 🐳 🐙

[OpenSSH server](https://www.openssh.com/)
with [Gitolite](https://gitolite.com/gitolite/) command filter
including support for [git-annex](https://git-annex.branchable.com/)

```sh
$ sudo docker run --name gitolite \
    -v gitolite_ssh_host_keys:/etc/ssh/host_keys \
    -v gitolite_data:/var/lib/gitolite \
    -p 2200:2200 \
    -e GITOLITE_INITIAL_ADMIN_NAME=someone \
    -e GITOLITE_USER_PUBLIC_KEY_someone="$(cat ~/.ssh/id_*.pub)" \
    --read-only --cap-drop=ALL --security-opt=no-new-privileges \
    docker.io/fphammerle/gitolite

$ ssh -p 2200 -T git@localhost
hello someone, this is git@hostname running gitolite3 3.6.11-2 (Debian) on git 2.20.1

 R W	gitolite-admin
 R W	testing

$ git clone ssh://git@localhost:2200/gitolite-admin.git

$ git clone ssh://git@localhost:2200/testing.git
```

`sudo docker` may be replaced with `podman`.

Pre-built docker images are available at https://hub.docker.com/r/fphammerle/gitolite/tags
(mirror: https://quay.io/repository/fphammerle/gitolite?tab=tags)

Annotation of signed git tags `docker/*` contains docker image digests: https://github.com/fphammerle/docker-gitolite/tags

Detached signatures of images are available at https://github.com/fphammerle/container-image-sigstore
(exluding automatically built `latest` tag).

### Docker Compose 🐙

1. `git clone https://github.com/fphammerle/docker-gitolite`
2. Adapt `GITOLITE_INITIAL_ADMIN_NAME` and `GITOLITE_USER_PUBLIC_KEY_*` in [docker-compose.yml](docker-compose.yml)
3. `docker-compose up --build`
