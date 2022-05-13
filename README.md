# arch-plasma


Create a baseline [Archlinux](https://hub.docker.com/_/archlinux) enviroment using KDE [Plasma](https://kde.org/) with [NoVNC](https://github.com/novnc/noVNC) and [Webockify](https://github.com/novnc/websockify) pre-configured for other to to use for their docker containers.


---

## Planned todo:

Loose guidelines to check i've got everything I need.

    v0.0.0
    - [x] archlinux version at build
        - [x] arg $arch_version
        - [x] Default latest

    v0.1.0
    - [x] pacman
        - [x] ca-certificates
        - [x] general tools (example... curl, wget, less, unzip, rsync, bash, bash-completion)
        - [x] python
        - [x] python-numpy (used for websockify for latancy reduction.)
        - [x] ARG $pacman_packages

    v0.2.0 - removed as user can change language from US when they build.
    - [ ] local Config
        - [ ] LANG = US default
        - [ ] ARG $LANG (to change default language. Need to account for language packs.)

    v0.3.0
    - [ ] NOVNC
        - [ ] Enable
        - [ ] Configuration
        - [ ] Setup with default details but configure (ENV & ARG) for password.
        - [ ] ARG novnc_password.
    - [ ] Websockify
        - [ ] Enable
        - [ ] Configuration
    - [ ] SSL certificate (allow personal re-defined file?)

    v0.4.0
    - [ ] KDE
        - [ ] Enable
        - [ ] Configuration
        - [ ] Remove un-required packages.


---

## Docker Run Example

This section is to be filled in once at Version 1.


---

## Docker Compose

This section is to be filled in once at Version 1.

---

## Docker Build Arguments

Build version of arch linux from the docker repositroy.

> arch_version='base-20220424.0.54084'

Install additional pacman packages to what is already preset.

> pacman_packages='less curl steam'

Get the version of NoVNC by the release version. Excludes any pre-releases.

> novnc_version='1.2'

Get the version of websockify by the release version. Excludes any pre-releases.

> websockify_version='0.8'

