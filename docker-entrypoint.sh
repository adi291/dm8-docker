#!/bin/sh
set -e

DEFAULT_DB_NAME=${DATABASE_NAME:-DAMENG}
INSTANCE_NAME=${INSTANCE_NAME:-DMSERVER}
CASE_SENSITIVE=${CASE_SENSITIVE:-Y}
SYSDBA_PWD=${SYSDBA_PWD:-DMdba_123}
SYSAUDITOR_PWD=${SYSAUDITOR_PWD:-DMauditor_123}

check_init_status() {
  declare -g DM_INITIALIZED
  if [ -n "$(find ${DM_DATA_DIR} -maxdepth 1 -type d)" ]; then
    DM_INITIALIZED='true'
  fi
}

generate_init_ini() {
  cat > ${DM_INSTALL_DIR}/default_db_init.ini <<EOF
[$DEFAULT_DB_NAME]
system_path=$DM_DATA_DIR
instance_name=$INSTANCE_NAME
port_num=5236
page_size=16
time_zone=+08:00
charset=1
sysdba_pwd=$SYSDBA_PWD
sysauditor_pwd=$SYSAUDITOR_PWD
EOF
}

default_db_init() {
  generate_init_ini()
  ${DM_INSTALL_DIR}/bin/dminit CONTROL=${DM_INSTALL_DIR}/default_db_init.ini
}

check_init_status
if [ -z "${DM_INITIALIZED}" ];then
  default_db_init
fi

if [ $# -eq 0 ]; then
    exec ${DM_INSTALL_DIR}/bin/dmserver", "${DM_DATA_DIR}/${DEFAULT_DB_NAME}/dm.ini
else
    exec "$@"
fi
