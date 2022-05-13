#!/bin/bash
set -ex

echo "**** Entrypoint ****"
exec supervisord -c /opt/supervisord.conf
