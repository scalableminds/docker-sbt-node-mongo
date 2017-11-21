#!/usr/bin/env bash
set -e

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-$USER_UID}
USER_NAME=${USER_NAME:-sbt}

if [[ -d "/home/${USER_NAME}" ]]; then
  chown ${USER_UID}:${USER_GID} "/home/${USER_NAME}"
  # copy user files from /etc/skel
  install -g ${USER_GID} -o ${USER_UID} /etc/skel/* "/home/${USER_NAME}"
fi

# create group with USER_GID
if ! getent group "${USER_NAME}" >/dev/null; then
  groupadd -f -g ${USER_GID} "${USER_NAME}" 2> /dev/null
fi

# create user with USER_UID
if ! getent passwd "${USER_NAME}" >/dev/null; then
  adduser --disabled-login --uid ${USER_UID} --gid ${USER_GID} \
    --gecos "${USER_NAME}" "${USER_NAME}"
fi

if [ "$1" = 'sbt' ] || [ "$1" = 'bash' ] || [ "$1" = 'sh' ]; then
    cd $(eval echo "~${USER_NAME}")
    exec sudo -HEu "${USER_NAME}" $@
else
    su ${USER_NAME}" << EOF
    exec sbt $@
EOF
fi
