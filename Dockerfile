ARG PY_VERSION
FROM python:${PY_VERSION}

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
	universal-ctags \
	&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

COPY requirements.txt /requirements.txt
RUN pip3 install --upgrade pip
RUN pip3 --no-cache-dir install -r requirements.txt
RUN pip3 freeze > requirements.txt

RUN mkdir -p /notebooks/
ENV HOME /notebooks
WORKDIR /notebooks

# add ~/.local/bin to path for locally installed stuff
RUN echo 'export PATH="${HOME}/.local/bin:${PATH}"'> /etc/profile.d/99-local-path.sh 

# enable sshd
RUN mkdir /var/run/sshd

# Set shell to bash
ENV SHELL /bin/bash

# Set locale
ENV LANG "C.UTF-8"
ENV LC_COLLATE "C.UTF-8"

CMD ["jupyter", "notebook", "--no-browser", "--allow-root", "--ip=0.0.0.0"]
