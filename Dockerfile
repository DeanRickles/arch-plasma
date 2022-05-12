# arch version is latest, unless you want to run a certain version.
ARG arch_version=latest
FROM archlinux:${arch_version}

LABEL maintainer="Dean <dean@rickles.co.uk>"


# add Certifcate authority certs.
RUN \
    echo "**** Pacman  ****" \
    && pacman -Syyu --noconfirm \
        ca-certificates \
    && pacman -Scc --noconfirm \
    && \
    echo

ARG pacman_packages

# add Pacman utility packages (excluded bash, less, curl as already installed.)
RUN \
    echo "**** Pacman  ****" \
    && pacman -S --noconfirm  \
        wget \
        git \
        rsync \
        unzip \
        python \
        python-numpy \
        $pacman_packages \
    && pacman -Scc --noconfirm \
    && \
    echo
