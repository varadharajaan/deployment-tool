#!/usr/bin/env bash

sudo apt-get update

if [ -s package_install/install.txt ]; then
  declare -a package_install_list
  while IFS='\n' read -r value; do
    package_install_list+=( "${value}" )
  done < "package_install/install.txt"

  for in_pkg in "${package_install_list[@]}"
  do
    if ! dpkg -l | grep "${in_pkg}"; then
      sudo apt-get install -y "${in_pkg}"
    fi
  done
fi


if [ -f "/var/www/html/index.html" ]; then
  sudo rm /var/www/html/index.html
  touch /var/www/html/index.php
fi


if [ -s rbac.txt ]; then
  declare -A rbac
  while IFS== read -r key value; do
    rbac[$key]=$value
  done < "rbac.txt"
  sudo chmod "${rbac[permissions]}" "${rbac[file]}"
  sudo chown "${rbac[owner]}" "${rbac[file]}"
  sudo chgrp "${rbac[group]}" "${rbac[file]}"
  sudo echo "${rbac[content]}" > "${rbac[file]}"
fi

needrestart
