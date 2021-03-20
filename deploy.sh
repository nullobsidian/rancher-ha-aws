#!/bin/bash
set -e

echo -e "localhost ansible_connection=\"local\"\n" > /etc/ansible/hosts

ansible-playbook ansible/terraform.yml

# ansible-playbook ansible/rke.yml

# ansible-playbook ansible/rancher.yml