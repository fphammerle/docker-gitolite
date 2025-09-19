FROM docker.io/debian:13.1-slim

ARG GITOLITE_PACKAGE_VERSION=3.6.12-1
# https://git-annex.branchable.com/news/
# https://git.joeyh.name/index.cgi/git-annex.git/refs/
# https://salsa.debian.org/haskell-team/git-annex/-/blob/master/CHANGELOG
# https://salsa.debian.org/haskell-team/git-annex/-/blob/master/debian/changelog
ARG GIT_ANNEX_PACKAGE_VERSION=10.20230126-3
# https://github.com/git/git/tree/master/Documentation/RelNotes
ARG GIT_PACKAGE_VERSION=1:2.39.5-0+deb12u2
# https://www.openssh.com/releasenotes.html
# https://salsa.debian.org/ssh-team/openssh/-/blob/master/debian/changelog
ARG OPENSSH_SERVER_PACKAGE_VERSION=1:9.2p1-2+deb12u7
# https://salsa.debian.org/debian/tini/-/blob/debian/latest/debian/changelog?ref_type=heads
ARG TINI_PACKAGE_VERSION=0.19.0-1+b3
ARG USER=git
ARG GITOLITE_HOME_PATH=/var/lib/gitolite
ENV SSHD_HOST_KEYS_DIR=/etc/ssh/host_keys
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
        git-annex=$GIT_ANNEX_PACKAGE_VERSION \
        git=$GIT_PACKAGE_VERSION \
        gitolite3=$GITOLITE_PACKAGE_VERSION \
        openssh-server=$OPENSSH_SERVER_PACKAGE_VERSION \
        tini=$TINI_PACKAGE_VERSION \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/ssh/ssh_host_*_key* \
    && useradd --home-dir "$GITOLITE_HOME_PATH" --create-home "$USER" \
    && getent passwd "$USER" \
    && if grep --extended-regex --invert-match '^[a-z0-9_-]+:[\*!]:' /etc/shadow; then exit 1; fi \
    && mkdir "$SSHD_HOST_KEYS_DIR" \
    && chown -c "$USER" "$SSHD_HOST_KEYS_DIR"
# TODO merge up
RUN sed --in-place '/ENABLE => \[/a \\n            '"'git-annex-shell ua'," \
        /usr/share/gitolite3/lib/Gitolite/Rc.pm
VOLUME $GITOLITE_HOME_PATH
VOLUME $SSHD_HOST_KEYS_DIR

COPY sshd_config /etc/ssh/sshd_config
EXPOSE 2200/tcp

ENV GITOLITE_INITIAL_ADMIN_NAME=admin
COPY entrypoint.sh /
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]

USER $USER
CMD ["/usr/sbin/sshd", "-D", "-e"]

# https://github.com/opencontainers/image-spec/blob/v1.0.1/annotations.md
ARG REVISION=
LABEL org.opencontainers.image.title="gitolite with support for git-annex" \
    org.opencontainers.image.source="https://github.com/fphammerle/docker-gitolite" \
    org.opencontainers.image.revision="$REVISION"
