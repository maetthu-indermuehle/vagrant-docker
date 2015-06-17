#!/usr/bin/env bash
#
# This bootstraps Puppet on Ubuntu
# source: https://github.com/hashicorp/puppet-bootstrap
#
set -e

# Load up the release information
. /etc/lsb-release

#--------------------------------------------------------------------
# NO TUNABLES BELOW THIS POINT
#--------------------------------------------------------------------
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

#if which puppet > /dev/null 2>&1 -a apt-cache policy | grep --quiet apt.puppetlabs.com; then
if which docker  > /dev/null 2>&1; then
  echo "[INFO] docker is already installed"
  exit 0
fi

# change sources.list to ch mirror
echo "[INFO] Change sources.list to use ch mirror..."
sed -i 's/us.archive/ch.archive/g' /etc/apt/sources.list

# Add the repository to your APT sources
echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list

# Do the initial apt-get update
echo "[INFO] Initial apt-get update..."
apt-get update >/dev/null

# Then import the repository key
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

# Install docker
apt-get update
apt-get install -y lxc-docker
# Install the PuppetLabs repo

echo "[INFO] Docker installed"

echo "[INFO] Shell provisioner finished..."
