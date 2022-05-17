#!/bin/bash
set -ex

echo "**** Starting Container: Entrypoint ****"
exec supervisord -c /opt/supervisord.conf
