#!/usr/bin/env bash
set -Eeuo pipefail

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-$USER_UID}
USER_NAME=${USER_NAME:-sbt-user}

# create group with USER_GID
if ! getent group ${USER_GID} >/dev/null && ! getent group ${USER_NAME} >/dev/null; then
  groupadd -f -g ${USER_GID} ${USER_NAME} > /dev/null 2>&1
fi

# create user with USER_UID
if ! getent passwd ${USER_UID} >/dev/null && ! getent passwd ${USER_NAME} >/dev/null; then
  adduser --disabled-login --uid ${USER_UID} --gid ${USER_GID} \
    --gecos ${USER_NAME} ${USER_NAME} > /dev/null 2>&1
fi

USER_HOME=$(gosu ${USER_NAME} bash -c "echo ~")
if [ "$(pwd)" == "/" ]; then
  cd $USER_HOME
fi
chown $USER_UID:$USER_GID $USER_HOME
exec gosu ${USER_NAME} "$@"
