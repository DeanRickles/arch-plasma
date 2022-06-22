# arch-plasma


Create a baseline [Archlinux](https://hub.docker.com/_/archlinux) enviroment using KDE [Plasma](https://kde.org/) with [NoVNC](https://github.com/novnc/noVNC) and [Webockify](https://github.com/novnc/websockify) pre-configured for other to to use for their docker containers.


How it works:

    1) XVFB - X11 in a virtual framebuffer.
    2) X11vnc - A VNC server that scrapes the above X11 server.
    3) noVNC & websockify - A HTML5 canvas vnc viewer.
    4) Dbus + KDE Plamsa - starts the desktop enviroment.

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

V0.2.0
- [x] xvfb

v0.3.0
- [x] NOVNC
    - [x] Downladed
    - [x] Installed
    - [x] Configuration
    - [x] Setup with default details but configure (ENV & ARG) for password.
    - [x] ARG novnc_passwd.
- [x] Websockify
    - [x] Downloaded
    - [x] Installed
    - [x] Configuration
- [x] SSL certificate (allow personal re-defined file?)
    - [x] ENV Cert
    - [x] ENV Key

v0.4.0
- [ ] KDE
    - [x] Enable
    - [ ] Configuration
    - [x] Remove un-required packages.

v0.5.0
- [ ] Container size reduction.
    - [x] xorg
    - [x] novnc
    - [x] websockify
    - [ ] KDE-Plasma. Struggling to reduce size of package.

v0.6.0
- [ ] Entrypoint additions
    - [ ] Enable / Disable desktop config
    - [ ] enable to use GIT themes?

v1.2.0
- [ ] noVNC add audio passthrough.

Removed as user can change language from US when they build.
- [ ] local Config
    - [ ] LANG = US default
    - [ ] ARG $LANG (to change default language. Need to account for language packs.)


---

## Docker Run Example

This section is to be filled in once at Version 1.


---

## Docker-Compose

This section is to be filled in once at Version 1.

---
## Enviroment aguments

Password:

    root_passwd='root'
    novnc_passwd='P@ssw0rd'

expose port:

    novnc_port=5900

Display Settings:

    DISPLAY=:0.0
    DISPLAY_WIDTH=1024
    DISPLAY_HEIGHT=768

Websockify SSL:

    SSL_CERT="/opt/ssl/cert.pem"
    SSL_KEY="/opt/ssl/key.pem"


---
## Build Arguments

Build version of arch linux from the docker repositroy.

> arch_version='base-20220424.0.54084'

Install additional pacman packages to what is already preset.

> pacman_packages='less curl steam'

Get the version of NoVNC by the release version. Excludes any pre-releases.

> novnc_version='1.2'

Get the version of websockify by the release version. Excludes any pre-releases.

> websockify_version='0.8'

