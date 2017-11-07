#!/usr/bin/env bash
set -e

if [ "$1" = 'sbt' ] || [ "$1" = 'bash' ] || [ "$1" = 'sh' ]; then
    su "$SBT_USER" -c "exec $@"
else
    su "$SBT_USER" << EOF
    exec sbt $@
EOF
fi
