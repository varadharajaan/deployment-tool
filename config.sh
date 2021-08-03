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
