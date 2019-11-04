#!/bin/bash 

export TF_VERSION="1.14.0-gpu-py3"

docker run --runtime=nvidia --rm \
        -p8888:8888 \
	-e HOME=${HOME} \
        -w ${HOME} \
	-u $(id -u):$(id -g) \
	-v /etc/passwd:/etc/passwd:ro \
        -v ${HOME}:${HOME} \
        --name dl-${TF_VERSION} \
	-e "VIRTUAL_HOST=dl.do.qpqp01.pl" -e "LETSENCRYPT_HOST=dl.do.qpqp01.pl" -e "LETSENCRYPT_EMAIL=emsi@qpqp01.pl" -e "VIRTUAL_PORT=8888" \
        emsi/deep-learning:${TF_VERSION} jupyter-lab --ip=0.0.0.0 
