# arch version is latest, unless you want to run a certain version.
ARG arch_version=latest
FROM archlinux:${arch_version}

LABEL maintainer="Dean <dean@rickles.co.uk>"
