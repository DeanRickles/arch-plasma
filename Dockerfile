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

#RUN \
#    echo "**** Pacman:: KDE Plasma  ****" \
#    && pacman -S --noconfirm  \
#        plasma-meta \
#        #kde-applications-meta \ # removed while testing to see if needed.
#        #Plasma-nm \  plasma network manager - Proberly not needed.
#    && pacman -Scc --noconfirm \
#    && \
#    echo

# selecting required packages.
RUN \
    echo "**** Pacman:: KDE Plasma  ****" \
    && pacman -S --noconfirm  \
        discover \
        plasma-workspace \
        drkonqi  \
        konsole \
        #khotkeys  \
        #kinfocenter \
        #kscreen \
        #ksshaskpass \
        #kwallet-pam \
        #kwayland-integration \
        #kwrited \
        #plasma-browser-integration \
        plasma-desktop \
        #plasma-disks \
        #plasma-firewall \
        #plasma-nm \
        plasma-pa \
        #plasma-systemmonitor \
        #plasma-thunderbolt \
        #plasma-vault \
        #plasma-workspace-wallpapers \
        #powerdevil \
        #sddm-kcm \
        #xdg-desktop-portal-kde \
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