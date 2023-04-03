ARG CUDA_VERSION
FROM nvidia/cuda:${CUDA_VERSION}

ARG TF_VERSION
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
	nodejs \
	libgl1 \
	git \
	wget \
	vim \
	inetutils-ping \
	openssh-server \
	sudo \
	net-tools \
	iproute2 \
    python3-venv \
    python3-pip \
    python3-jupyterlab-server \
    build-essential \
    python3-dev \
	&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

COPY requirements.txt /requirements.txt
RUN pip3 --no-cache-dir install tensorflow==${TF_VERSION} -r requirements.txt
RUN pip3 freeze > requirements.txt

RUN mkdir -p /notebooks/
ENV HOME /notebooks
WORKDIR /notebooks

# Set shell to bash
ENV SHELL /bin/bash

# Set locale
ENV LANG "C.UTF-8"
ENV LC_COLLATE "C.UTF-8"

CMD ["jupyter", "notebook", "--no-browser", "--allow-root", "--ip=0.0.0.0"]
