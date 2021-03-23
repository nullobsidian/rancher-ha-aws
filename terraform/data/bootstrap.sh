#!/bin/bash -x

# Install Docker
export DEBIAN_FRONTEND=noninteractive
curl https://releases.rancher.com/install-docker/${docker_version}.sh | sh
sudo usermod -aG docker ubuntu
sudo -s

# Allow TCP Forwardsing - SSH
echo -e "\nAllowTcpForwarding yes" >> /etc/ssh/sshd_config

# Mounting and auto-start EBS
mkdir -p /var/lib/etcd/data && sudo mkdir -p /var/lib/etcd/wal
mkfs -t ext4 /dev/nvme1n1 && sudo mkfs -t ext4 /dev/nvme2n1
mount /dev/nvme1n1 /var/lib/etcd/data && mount /dev/nvme2n1 /var/lib/etcd/wal
echo '/dev/nvme1n1 /var/lib/etcd/data  ext4   defaults,nofail         0 2' >> /etc/fstab
echo '/dev/nvme2n1 /var/lib/etcd/wal   ext4   defaults,nofail         0 2' >> /etc/fstab

