#!/bin/bash
set -e

if [[ "$USER" != "root" ]]; then
	echo "Usage: sudo ./run.sh"
	exit
fi

# 0. Setup Dependencies

apt-get update

echo "[*] Installing fail2ban"
apt-get install fail2ban -y

echo "[*] Install docker, docker-compose"
curl -fsSL https://get.docker.com | sh -c
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# 1. Download CMS

CMS_DIR = cms
CMS_TAR = ${CMD_DIR}.tar.gz
rm -rf $CMS_DIR
rm -f $CMS_TAR 
wget https://github.com/cms-dev/cms/releases/download/v1.4.rc1/v1.4.rc1.tar.gz -O $CMS_TAR
tar -xvf $CMS_TAR

cd cms