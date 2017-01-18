#!/bin/bash
# Instructions to run this script. PLEASE READ!
# 1. Update USERNAME, PASSWORD - only if RHEL control node is used
# 2. Update RHEL_MAJOR_VERSION - as per the instructions below:
#    - RHEL6: 6, RHEL7: 7, Fedora: just comment or remove the corresponding line
# 3. Make sure to run this script as root, in this project's root folder

export USERNAME="changeme"
export PASSWORD="changeme"
export RHEL_MAJOR_VERSION="0"

if [[ "$USERNAME" = "changeme" && "$PASSWORD" = "changeme" ]]; then
  echo "Please update the variables in the script before running it."
  exit 1
fi
if [ "$RHEL_MAJOR_VERSION" == "0" ]; then
  echo "Please update the variables in the script before running it."
  exit 1
fi

if [ -z "$RHEL_MAJOR_VERSION" ]; then
  dnf install -y ansible
else
  # Register and subscribe
  echo "Register and subscribe the node. This is done to install few packages."
  subscription-manager register --username="$USERNAME" --password="$PASSWORD" --autosubscribe

  set -x
  # Enable epel repo and install Ansible
  yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-"$RHEL_MAJOR_VERSION".noarch.rpm
  yum clean all
  yum install -y ansible
  yum install -y yum-utils # yum-utils not installed by default on rhel7
  # Disable all repos and re-enable only rhel6 or rhel7 server rpms
  yum-config-manager --disable \*  &> /dev/null
  yum-config-manager --enable rhel-"$RHEL_MAJOR_VERSION"-server-rpms
fi

# Install rsync for using the `synchronize` Ansible module
yum install -y rsync
