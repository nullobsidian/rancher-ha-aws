#!/bin/bash
set -e

echo -e "localhost ansible_connection=\"local\"\n" > .hosts

ansible-playbook -vvvvvvvvv -i.hosts ansible/infrastructure.yml

# ansible-playbook -i .hosts ansible/rke.yml

rm .hosts