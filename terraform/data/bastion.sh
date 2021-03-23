#!/bin/bash -x

# K8s
mkdir -p /home/ubuntu/.kube && chown -R ubuntu:ubuntu /home/ubuntu/.kube
curl -LO https://storage.googleapis.com/kubernetes-release/release/${k8s_version}/bin/linux/amd64/kubectl
mv kubectl /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

# Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
chmod 1777 -R /tmp/

# Python3
apt update && apt install python3-pip -y && pip3 install openshift

su - ubuntu
helm plugin install https://github.com/databus23/helm-diff
echo "export PATH=\"~/.local/bin:$PATH\"" > ~/.profile
echo -e "Host *\n  StrictHostKeyChecking no" > ~/.ssh/config && chmod 600 ~/.ssh/config
echo "${node_key}" > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa
