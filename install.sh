#!/bin/bash

if [[ "$USER" != "root" ]]; then
	echo "Usage: sudo ./install.sh"
	exit
fi

# Setup Dependencies

apt-get update

echo "[*] Installing fail2ban"
apt-get install fail2ban -y

echo "[*] Install docker, docker-compose"

which docker >/dev/null
if [ $? -ne 0 ]; then
    curl -fsSL https://get.docker.com | sh
fi

which docker-compose >/dev/null
if [ $? -ne 0 ]; then
    curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

echo "[*] Clearing previous docker instances, volumes"
docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker volume ls -qf dangling=true | xargs -r docker volume rm

${PWD}/generate_cmf_conf.py -o cms.conf

cp ${PWD}/cms-docker/host_scripts/* /usr/local/bin/

# Run docker
docker-compose build cms
docker-compose up -d
