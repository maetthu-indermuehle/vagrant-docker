#!/usr/bin/env bash
#
# This bootstraps Puppet on Ubuntu
# source: https://github.com/hashicorp/puppet-bootstrap
#
set -e

# Load up the release information
. /etc/lsb-release

REPO_DEB_URL="http://apt.puppetlabs.com/puppetlabs-release-${DISTRIB_CODENAME}.deb"

#--------------------------------------------------------------------
# NO TUNABLES BELOW THIS POINT
#--------------------------------------------------------------------
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

#if which puppet > /dev/null 2>&1 -a apt-cache policy | grep --quiet apt.puppetlabs.com; then
if which puppet > /dev/null 2>&1; then
  echo "[INFO] Puppet is already installed"
  exit 0
fi

# change sources.list to ch mirror
echo "[INFO] Change sources.list to use ch mirror..."
sed -i 's/us.archive/ch.archive/g' /etc/apt/sources.list

# Do the initial apt-get update
echo "[INFO] Initial apt-get update..."
apt-get update >/dev/null

# Install wget if we have to (some older Ubuntu versions)
echo "[INFO] Installing wget..."
apt-get install -y wget >/dev/null

# Install the PuppetLabs repo
echo "[INFO] Configuring PuppetLabs repo..."
repo_deb_path=$(mktemp)
wget --output-document="${repo_deb_path}" "${REPO_DEB_URL}" 2>/dev/null
dpkg -i "${repo_deb_path}" >/dev/null
apt-get update >/dev/null

# Install Puppet
echo "[INFO] Installing Puppet..."
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install puppet >/dev/null
# remove deprecated config
sed -i '/templatedir/d' /etc/puppet/puppet.conf

echo "[INFO] Puppet installed"

# Install RubyGems for the provider
echo "[INFO] Installing RubyGems..."
if [ $DISTRIB_CODENAME != "trusty" ]; then
  apt-get install -y rubygems >/dev/null
fi
gem install --no-ri --no-rdoc rubygems-update
update_rubygems >/dev/null

# echo "[INFO] Set Additional IP Adresses..."
# 
# cat << DONE > /etc/network/interfaces
# iface eth0:0 inet static
# name Ethernet alias LAN card
# address 10.0.2.150
# netmask 255.255.255.0
# broadcast 10.0.2.255
# network 10.0.2.1
# 
# iface eth0:1 inet static
# name Ethernet alias LAN card
# address 10.0.2.151
# netmask 255.255.255.0
# broadcast 10.0.2.255
# network 10.0.2.1
# DONE
# 
# /sbin/ifconfig eth0:1 10.0.2.150 up
# /sbin/ifconfig eth0:1 10.0.2.151 up
# 
# 
# echo "[INFO] Additional IPs Set"

echo "[INFO] Shell provisioner finished..."
