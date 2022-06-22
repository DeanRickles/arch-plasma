# VERSION HISTORY.
    v0.4.0
    * Removed adding audio to noVNC to it's own minor version.
    * Added pulseaudio.
    * Added enviroment port for noVNC at run.
    v0.3.6
    * Removed folders not required for websockify.
    * Added variable to set root password.
    * Added command to set root password based on root password in entrypoint.sh.
    * Added variable to set novnc password.
    * Added command to set novnc password based on novnc password in entrypoint.sh.
    v0.3.5
    * Removed test files from import of noVNC
    * Temporary added notes for each KDE Plasma packages. Looking to how to reduce size.
    v0.3.4
    * Added dockerfile inspection for github workflow.
    * Added code inspection for github workflow.
    v0.3.3 - 26/05/2022
    * Removed un-required plasma packages to minumise build size.
    v0.3.2 - 26/05/2022
    * Added logging to supervisord files.
    * moved ca-certificates into Pacman section.
    * Added pacman package refresh to Pacman section.
    * Enabled kde-applications-meta to pacman section.
    * Added xorg-xinit.
    * Added altered conf.d file for KDE-plasma and dbus.
    v0.3.1 - 17/05/2022
    * Fixed a missing slash.
    v0.3.0 - 17/05/2022
    * Removed adding language for now.
    * Enabled supervisor.
    * novnc now running.
    * Added SSL to websockify by default.
    v0.2.2 - 16/05/2022
    * Added xvfb for virtual screen config
    v0.2.1 - 13/05/2022
    * NoVNC & websockify release downloaded into /opt/
    * Started adding supervisor conf/d
    * Started groundwork for plasma.
    v0.1.0 - 12/05/2022
    * Added pacman and pacman_arg
    v0.0.0 - 12/05/2022
    * Created folder structure and planned out guidelines.