# arch version is latest, unless you want to run a certain version.
ARG arch_version=latest
FROM archlinux:${arch_version}


LABEL maintainer="Dean <dean@rickles.co.uk>"

RUN \
    echo "**** Pacman:: CA certificates  ****" \
    && pacman -Syyu --noconfirm  \
        ca-certificates  \
    && pacman -Scc --noconfirm \
    && \
    echo
# Total Download Size:   18.26 MiB
# Total Installed Size:  66.67 MiB
# Net Upgrade Size:      -0.72 MiB

## use to add any other packages on the fly through a build.
ARG pacman_packages
RUN \
    echo "**** Pacman:: Python + pacman_packages ****" \
    && pacman -S --noconfirm  \
        python \
        python-numpy \
        $pacman_packages \
    && pacman -Scc --noconfirm \
    && \
    echo
# Total Download Size:   19.76 MiB
# Total Installed Size:  95.15 MiB

RUN \
    echo "**** Pacman:: X11  ****" \
    && pacman -S --noconfirm  \
        supervisor \
        x11vnc \
        xorg \
        xorg-server-xvfb \
        xorg-xinit \
    && pacman -Scc --noconfirm \
    && \
    echo
# Total Download Size:   101.13 MiB
# Total Installed Size:  361.59 MiB


# selecting required packages.
RUN \
    echo "**** Pacman:: KDE Plasma  ****" \
    && pacman -S --noconfirm  \
    # KDE Plasma Desktop
        plasma-desktop \
    && pacman -Scc --noconfirm \
    && \
    echo
# Total Download Size:    332.98 MiB
# Total Installed Size:  1366.11 MiB


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
        tar xzC /opt/novnc --strip-components=1 \
        # Removes excess files not required.
        --exclude='tests' --exclude='docs' --exclude='debian' --exclude='README.md' \
    && \
    echo
# 956K    /tmp/novnc/

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
# 564K    /tmp/websockify

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
# Generate cert and key for websockify ssl
# possibly add option to skip section if cert&key is changed.
RUN \
    echo "**** SelfSign Cert & key ****" \
    && mkdir /opt/ssl && cd /opt/ssl \
    && openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365 -nodes -batch \
    && cd / \
    && \
    echo

# screen size
ENV \
    DESKTOP_SESSION=plasma \
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