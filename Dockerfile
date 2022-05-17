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

RUN \
    echo "**** websockify install ****" \
    && cd /opt/novnc/utils/websockify \
    && python3 setup.py install \
    && cd / \
    && \
    echo


# certificate location
ENV \
    SSL_CERT="/opt/ssl/cert.pem" \
    SSL_KEY="/opt/ssl/key.pem"

# Generate cert and key for wildcard
# possibly add option to skip section if cert&key is changed.
RUN \
    echo "**** SelfSign Cert & key ****" \
    && mkdir /opt/ssl && cd /opt/ssl \
    && openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365 -nodes -batch \
    && cd / \
    && \
    echo

# need to change conf.d file for websockify to include ENV

# Usual way of starting. unable to sue as not sharing with system.
# systemctl enable sddn.service
# system enable network manager.service

# screen size
ENV \
    DESKTOP_SESSION=plasma
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768

# copy over the supervisord config files.
COPY conf.d /opt/conf.d

COPY supervisord.conf /opt/

# novnc port for testing.
EXPOSE 5959

# Copy and run the enterypoint script.
COPY --chmod=755 entrypoint.sh /opt/
ENTRYPOINT ["/bin/sh"]
CMD ["/opt/entrypoint.sh"]