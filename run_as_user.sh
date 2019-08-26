docker run --runtime=nvidia --rm \
        -p8888:8888 \
	-e HOME=${HOME} \
        -w ${HOME} \
	-u $(id -u):$(id -g) \
	-v /etc/passwd:/etc/passwd:ro \
        -v ${HOME}:${HOME} \
        --name dl-1.14 \
        emsi/deep-learning:1.14.0-gpu-py3 jupyter-lab --ip=0.0.0.0 
