ARG PY_VERSION
FROM python:${PY_VERSION}

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
	universal-ctags \
	&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Configure optional ssh access
RUN sed -i -e 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' \
	-e 's/UsePAM yes/UsePAM no/' \
	/etc/ssh/sshd_config && \
	mkdir /root/.ssh && chmod 700 /root/.ssh && mkdir /var/run/sshd && \
	curl https://github.com/emsi.keys | tee -a /root/.ssh/authorized_keys && \
	/bin/true > /etc/bash.bashrc && \
	echo "export LANG=C.UTF-8" >> /etc/profile &&\
	echo "export LC_COLLATE=C.UTF-8" >> /etc/profile && \
	true

COPY requirements.txt /requirements.txt
RUN pip3 --no-cache-dir install tensorflow==${TF_VERSION} -r requirements.txt
RUN pip3 freeze > requirements.txt

# Installing nodejs with npm
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash && \
	apt-get install -y nodejs && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN jupyter labextension install @jupyterlab/toc \
	@aquirdturtle/collapsible_headings \
	@ryantam626/jupyterlab_code_formatter \
	@jupyter-widgets/jupyterlab-manager \
	@krassowski/jupyterlab-lsp \
		&& \
	jupyter serverextension enable --py jupyterlab_code_formatter 


#RUN jupyter lab build

# add CUDA toolkit
RUN curl -sL https://developer.download.nvidia.com/compute/cuda/11.4.0/local_installers/cuda_11.4.0_470.42.01_linux.run -o cuda_linux.run
RUN sh ./cuda_linux.run --silent --toolkit && rm ./cuda_linux.run

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/libcudnn8_8.2.2.26-1+cuda11.4_amd64.deb
RUN dpkg -i ./libcudnn8_8.2.2.26-1+cuda11.4_amd64.deb && rm libcudnn8_8.2.2.26-1+cuda11.4_amd64.deb

ENV PATH="${PATH}:/usr/local/cuda/bin"

RUN mkdir -p /notebooks/
COPY nbconfig /notebooks/.jupyter/
ENV HOME /notebooks
WORKDIR /notebooks

# Set shell to bash
ENV SHELL /bin/bash

# Set locale
ENV LANG "C.UTF-8"
ENV LC_COLLATE "C.UTF-8"


#CMD ["/run_jupyter.sh"]
