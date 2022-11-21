#!/bin/bash

set -Eeuo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

cat > "${script_dir}/.env" << EOF
PY_VERSION="3.10"
TF_VERSION="2.10"

COMPOSE_USER_ID=$(id -u)
COMPOSE_GROUP_ID=$(id -g)
EOF


if [ `which dokcer-compose` ]; then
	compose='docker-compose'
else
	compose='docker compose'
fi

$compose up -d

$compose logs -f


#docker run --runtime=nvidia --rm \
#        -p8888:8888 \
#	-e HOME=${HOME} \
#        -w ${HOME} \
#	-u $(id -u):$(id -g) \
#	-v /etc/passwd:/etc/passwd:ro \
#        -v ${HOME}:${HOME} \
#        --name dl-${TF_VERSION} \
#	-e "VIRTUAL_HOST=dl.do.qpqp01.pl" -e "LETSENCRYPT_HOST=dl.do.qpqp01.pl" -e "LETSENCRYPT_EMAIL=emsi@qpqp01.pl" -e "VIRTUAL_PORT=8888" \
#        emsi/deep-learning:${TF_VERSION} jupyter-lab --ip=0.0.0.0 
