FROM ubuntu

RUN apt-get update && apt-get install -y software-properties-common && \
apt-add-repository ppa:ansible/ansible && apt-get update && apt-get install -y ansible curl

CMD /bin/bash
