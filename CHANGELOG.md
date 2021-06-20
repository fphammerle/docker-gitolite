# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Fixed
- `sshd_config`: added redundant settings blocking unused features
- `docker-compose`: increased memory limit to support large repos and `git-remote-gcrypt`

## [0.1.0] - 2021-03-20
### Added
- openssh server listening on tcp port `2200`
- gitolite command filter with support for `git-annex`
- entrypoint generating basic gitolite setup based on environment variables
  `GITOLITE_INITIAL_ADMIN_NAME` and `GITOLITE_USER_PUBLIC_KEY_[USER]`

[Unreleased]: https://github.com/fphammerle/docker-gitolite/compare/v0.1.0...master
[0.1.0]: https://github.com/fphammerle/docker-gitolite/tree/v0.1.0
