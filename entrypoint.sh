#!/usr/bin/env bash
set -e

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}
SBT_USER=${SBT_USER:-sbt}

if [[ -d "/home/${SBT_USER}" ]]; then
  chown ${USER_UID}:${USER_GID} "/home/${SBT_USER}"
  # copy user files from /etc/skel
  install -g ${USER_GID} -o ${USER_UID} /etc/skel/* "/home/${SBT_USER}"
fi

# create group with USER_GID
if ! getent group "${SBT_USER}" >/dev/null; then
  groupadd -f -g ${USER_GID} "${SBT_USER}" 2> /dev/null
fi

# create user with USER_UID
if ! getent passwd "${SBT_USER}" >/dev/null; then
  adduser --disabled-login --uid ${USER_UID} --gid ${USER_GID} \
    --gecos "${SBT_USER}" "${SBT_USER}"
fi

if [ "$1" = 'sbt' ] || [ "$1" = 'bash' ] || [ "$1" = 'sh' ]; then
    cd "/home/${SBT_USER}"
    exec sudo -HEu "${SBT_USER}" $@
else
    su ${SBT_USER}" << EOF
    exec sbt $@
EOF
fi
