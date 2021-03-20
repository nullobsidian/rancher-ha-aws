FROM alpine:latest

ENV TERRAFORM_VERSION "0.14.3"
ENV RKE_VERSION "1.2.3"
ENV RANCHER_VERSION "2.4.10"
ENV K8S_VERSION "1.19.4"

RUN apk add --update \
    git \
    openssh-client openssh-keygen \
    openssl \
    ca-certificates \
    vim \
    wget \
    bash \
    python3 \
    py-pip && \
    apk add --update --virtual build-dependencies \
    python3-dev libffi-dev openssl-dev build-base && \
    pip install cffi --upgrade && \
    pip install awscli --upgrade && \
    wget -P /tmp/ https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
    wget -P /tmp/ https://github.com/rancher/cli/releases/download/v${RANCHER_VERSION}/rancher-linux-amd64-v${RANCHER_VERSION}.tar.gz && \
    tar -xvf /tmp/rancher-linux-amd64-v${RANCHER_VERSION}.tar.gz && mv ./rancher-v${RANCHER_VERSION}/rancher /usr/bin/ && \
    wget -P /tmp/ https://github.com/rancher/rke/releases/download/v${RKE_VERSION}/rke_linux-amd64 && \
    mv /tmp/rke_linux-amd64 /usr/bin/rke && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v${K8S_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl && \
    apk --purge del build-dependencies && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/tmp/*

WORKDIR /root/