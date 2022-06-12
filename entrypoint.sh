#!/bin/bash

# set the root password.
echo "root:${root_passwd}" | chpasswd

# set novnc password if variable is set to the null (empty) string.
if [ "$novnc_passwd" != "" ]
then
    # Create vnc password file.
    x11vnc -storepasswd $novnc_passwd /opt/vnc_passwd &>/dev/null

    # append x11vnc .conf to include password aurgument.
    sed -i "s|-nopw|-usepw -rfbauth /opt/vnc_passwd|g" /opt/conf.d/novnc.conf
fi

# Exit if any bash script command fail and print command into output.
set -ex

# starting container scripts.
echo "**** Starting Container: Entrypoint ****"
exec supervisord -c /opt/supervisord.conf