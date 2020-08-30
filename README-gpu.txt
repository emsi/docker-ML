For the docker-compose with GPU you need:
* No need for nvidia-docker any more. Just install
  https://github.com/NVIDIA/nvidia-container-runtime.
  (chances are you have it already)
  The thing is that container does NOT need nvidia drivers
  inside any more. You can use it with any container like:
  `docker run -it --rm --gpus all python:3.8 nvidia-smi`
  and python:3.8 container has `nvidia-smi`  and stuff 
  available from host.

* Unfortunately 2.4 version of compose file is required!
  (3.* won't work yet, see this issue:
  https://github.com/docker/compose/issues/6691).

* preferably use `--gpus all` syntax or attached
  docker-compose.yml which define:
  ```
  runtime: nvidia
  ...
  environment:
    - NVIDIA_VISIBLE_DEVICES=all
  ```
  Both are necessairy!
