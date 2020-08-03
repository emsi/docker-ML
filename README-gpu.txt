For the docker-compose with GPU you need:
* 2.4 version of compose file (3.* won't work yet, see this issue:
  https://github.com/docker/compose/issues/6691).
* nvidia-docker2 installed:
  ```
  sudo apt-get update
  sudo apt-get --only-upgrade install docker-ce nvidia-docker2
  sudo systemctl restart docker
  ```
* Use --runtime nvidia (rather than --gpus all) syntax or attached
  docker-compose.yml
