#!/bin/sh
set -e

if [ -n "${OSS_ENDPOINT}" ] && [ -n "${OSS_AK_ID}" ] && [ -n "${OSS_AK_SECRET}" ]; then
  if [ -n "${OSSUTIL_CONFIG_FILE}" ]; then
    cfg_dir=$(dirname "${OSSUTIL_CONFIG_FILE}")
    mkdir -p "$cfg_dir"
    cfg_file="${OSSUTIL_CONFIG_FILE}"
  else
    cfg_file="${HOME}/.ossutilconfig"
  fi

  ossutil config -e "${OSS_ENDPOINT}" -i "${OSS_AK_ID}" -k "${OSS_AK_SECRET}" -c "${cfg_file}"
  echo "configured ossutil to ${cfg_file}"
fi
