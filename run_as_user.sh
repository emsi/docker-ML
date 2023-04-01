#!/bin/bash

set -Eeuo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

# source existing env values
. "${script_dir}"/.env

# set default values
PY_VERSION="${PY_VERSION:-"3.10"}"
TF_VERSION="${TF_VERSION:-"2.10"}"

# refresh repo
echo "$(cd "${script_dir}"; git pull)" >> /dev/null

# set variables for  uid/gid and prefix project name with username
cat > "${script_dir}/.env" << EOF
PY_VERSION="${PY_VERSION}"
TF_VERSION="${TF_VERSION}"

COMPOSE_USER_ID=$(id -u)
COMPOSE_GROUP_ID=$(id -g)
COMPOSE_PROJECT_NAME="$(whoami)-ml"
EOF

# create appropriate sudoers.sh script
cat > "${script_dir}/sudoers.sh" << EOF
#!/bin/bash

echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudoers
chown 0:0 /etc/sudoers.d/sudoers
EOF
chmod +x sudoers.sh


if [ "$(which docker-compose)" ]; then
	compose='docker-compose'
else
	compose='docker compose'
fi

$compose up -d

$compose logs -f
