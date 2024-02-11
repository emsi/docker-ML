#!/bin/bash

set -Eeuo pipefail

if [ "$(which docker-compose)" ]; then
	compose='docker-compose'
else
	compose='docker compose'
fi

$compose exec --user 0  -d dl mkdir -p /run/sshd
$compose exec --user 0  -d dl nohup /usr/sbin/sshd
