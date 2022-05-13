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

# add Pacman utility packages
# xorg = display service
# plasma = desktop env
# plasma-wayland-session = same as x11
#kde-application = misc desktop apps.
RUN \
    echo "**** Pacman  ****" \
    && pacman -S --noconfirm  \
        supervisor \
        xorg-server-xvfb \
        x11vnc \
        python \
        python-numpy \
        xorg \
        plasma-meta \
        #kde-applications \
        $pacman_packages \
    && pacman -Scc --noconfirm \
    && \
    echo


# noVNC version. wildcard the version. Example 1.2.0
ARG novnc_version


# download NoVNC
RUN \
    echo "**** NoVNC Install & Setup ****" \
    && mkdir /opt/novnc \
    && curl -s https://api.github.com/repos/novnc/novnc/releases |  \
    grep tarball_url | grep -v "-" | grep ${novnc_version:-''} | \
    head -n 1 | cut -d '"' -f 4 | \
    xargs -I % curl -L % | \
    tar xzC /opt/novnc --strip-components=1\
    && \
    echo

# websockify version. wildcard the version. Example 1.2.0
ARG websockify_version

# need to look at what to exclude from extration to reduce size.
# download websockify
RUN \
    echo "**** websockify download ****" \
    && mkdir /opt/novnc/utils/websockify \
    && curl -s https://api.github.com/repos/novnc/websockify/releases |  \
    grep tarball_url | grep -v "-" | grep ${websockify_version:-''} | \
    head -n 1 | cut -d '"' -f 4 | \
    xargs -I % curl -L % | \
    tar xzC /opt/novnc/utils/websockify  --strip-components=1 \
    && \
    echo


# Usual way of starting. unable to sue as not sharing with system.
# systemctl enable sddn.service
# system enable network manager.service

# screen size
ENV \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768

# Copy over the supervisord config files.
copy conf.d /opt/conf.d

COPY supervisord.conf /opt/

# websockify port
EXPOSE 8888

 Copy and run the enterypoint script.
COPY --chmod=755 entrypoint.sh /opt/
ENTRYPOINT ["/bin/sh"]
#CMD ["/opt/entrypoint.sh"]