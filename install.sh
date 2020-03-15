#!/bin/bash

CLEAR_VOLUMES="false"
RUN="true"

function usage()
{
    echo -e "Usage: sudo ./intall.sh"
    echo ""
    echo -e "  -h --help"
    echo -e "  --clear-volumes  Clear volumes(log, db) that were previously used"
    echo -e "  --no-run  Do not start docker, just install"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --clear-volumes)
            CLEAR_VOLUMES="true"
            ;;
        --no-run)
            RUN="false"
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done


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

echo "[*] Clearing previous CMS docker instances"
docker ps | grep cms | awk '{print $1}' | xargs -r -I{} docker kill {}
docker ps -a | grep cms | awk '{print $1}' | xargs -r -I{} docker rm {}

if [[ "${CLEAR_VOLUMES}" == "true" ]]; then
    echo "[*] Clearing previous CMS volumes"
    docker volume ls -qf dangling=true | xargs -r docker volume rm
fi

${PWD}/generate_cms_conf.py -o cms.conf

cp ${PWD}/cms-docker/host_scripts/* /usr/local/bin/

# Run docker
docker-compose build cms
if [[ "${RUN}" == "true" ]]; then
    docker-compose up -d
fi
