#!/bin/sh
set -e

if [ -n "${LIMITS_NOFILE_SOFT}" ]; then
  # this is actually not working right now
  # postgres entrypoint sources this file with non-super user and unable to swith using `gosu`
  # https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#entrypoint
  # TODO: find an alternative
  {
    echo "postgres soft nofile ${LIMITS_NOFILE_SOFT}" >> /etc/security/limits.d/postgres.conf
  } || echo "failed to set LIMITS_NOFILE_SOFT"
fi

if [ -n "${LIMITS_NOFILE_HARD}" ]; then
  {
    echo "postgres hard nofile ${LIMITS_NOFILE_HARD}" >> /etc/security/limits.d/postgres.conf
  } || echo "failed to set LIMITS_NOFILE_HARD"
fi
