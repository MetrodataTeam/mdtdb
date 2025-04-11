#!/usr/bin/env bash
set -Eeo pipefail

# 检查 MDT_CRON 环境变量是否存在
if [ "$(id -u)" -eq 0 ] && [ -n "$MDT_CRON" ]; then
  # 将环境变量写入到 crontab 文件
  echo "$MDT_CRON" > /etc/cron.d/crontab
  # 确保权限设置正确
  chmod 0644 /etc/cron.d/crontab
  crontab /etc/cron.d/crontab

  # 启动 cron 服务
  service cron start
fi

source docker-entrypoint.sh
if [ "$#" -eq 0 ] || [ "$1" != 'postgres' ]; then
  set -- postgres "$@"
fi

docker_setup_env
docker_create_db_directories

if [ "$(id -u)" = '0' ]; then
  # then restart script as postgres user
  if type gosu > /dev/null 2>&1; then
    exec gosu postgres "$BASH_SOURCE" "$@"
  else
    exec su-exec postgres "$BASH_SOURCE" "$@"
  fi
fi

if [ -z "$DATABASE_ALREADY_EXISTS" ]; then
  _main "$@" -c mdt.mdtdb_version=$PG_MAJOR.$MDTDB_VERSION
else
  exec "$@" -c mdt.mdtdb_version=$PG_MAJOR.$MDTDB_VERSION
fi
