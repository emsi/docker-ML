#!/bin/bash

set -Eeuo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

cat > "${script_dir}/.env" << EOF
PY_VERSION="3.10"
TF_VERSION="2.10"

COMPOSE_USER_ID=$(id -u)
COMPOSE_GROUP_ID=$(id -g)
COMPOSE_PROJECT_NAME="$(whoami)-ml"
EOF

cat > "${script_dir}/sudoers.sh" << EOF
#!/bin/bash

echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudoers
chown 0:0 /etc/sudoers.d/sudoers
EOF
chmod +x sudoers.sh


if [ `which dokcer-compose` ]; then
	compose='docker-compose'
else
	compose='docker compose'
fi

$compose up -d

$compose logs -f
