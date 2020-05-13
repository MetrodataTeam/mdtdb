#!/bin/sh
set -e

if ! [[ -z "${LIMITS_NOFILE_SOFT}" ]]; then
  echo "postgres soft nofile ${LIMITS_NOFILE_SOFT}" >> /etc/security/limits.d/postgres.conf
fi
if ! [[ -z "${LIMITS_NOFILE_HARD}" ]]; then
  echo "postgres hard nofile ${LIMITS_NOFILE_HARD}" >> /etc/security/limits.d/postgres.conf
fi
