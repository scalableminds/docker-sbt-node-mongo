#!/usr/bin/env bash
set -e

if [ "$1" = 'sbt' ] || [ "$1" = 'bash' ] || [ "$1" = 'sh' ]; then
    exec "$@"
fi

exec "sbt $@"
