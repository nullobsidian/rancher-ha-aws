FROM alpine:latest

ENV TERRAFORM_VERSION "0.14.8"
ENV RKE_VERSION "1.2.6"
ENV ANSIBLE_VERSION "3.1.0"

RUN apk add --update \
    git \
    openssh-client openssh-keygen \
    openssl \
    ca-certificates \
    vim \
    wget \
    curl \
    bash \
    python3 \
    py3-pip && \
    apk add --update --virtual build-dependencies \
    gcc musl-dev python3-dev libffi-dev openssl-dev cargo && \
    pip3 install --no-cache wheel && \
    pip3 install --no-cache ansible==${ANSIBLE_VERSION} && \
    mkdir -p /etc/ansible && echo -e "[local]\nlocalhost ansible_connection=\"local\"\n" > /etc/ansible/hosts && \
    wget -P /tmp/ https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip  &> /dev/null && \
    unzip /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
    wget -P /tmp/ https://github.com/rancher/rke/releases/download/v${RKE_VERSION}/rke_linux-amd64  &> /dev/null && \
    mv /tmp/rke_linux-amd64 /usr/bin/rke && \
    apk --purge del build-dependencies && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/tmp/*

WORKDIR /root/
