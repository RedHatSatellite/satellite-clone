#!/bin/bash
# Instructions to run this script. PLEASE READ!
# 1. Update RHEL_MAJOR_VERSION - as per the instructions below:
#    - RHEL6: 6, RHEL7: 7, Fedora: just comment or remove the corresponding line
# 2. Make sure to run this script as root, in this project's root folder

export RHEL_MAJOR_VERSION="0"

if [ "$RHEL_MAJOR_VERSION" == "0" ]; then
  echo "Please update the variables in the script before running it."
  exit 1
fi

set -x
if [ -z "$RHEL_MAJOR_VERSION" ]; then
  dnf install -y ansible
else
  # Enable epel repo for RHEL6 and RHEL7
  yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-"$RHEL_MAJOR_VERSION".noarch.rpm
  yum clean all
  yum install -y ansible
  # Disable epel as this conflicts with satellite installer
  yum remove -y epel-release
  yum repolist
fi
