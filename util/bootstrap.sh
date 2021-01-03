#!/bin/bash
cd..
ansible-galaxy collection install -r ./ansible/requirements.yml
ansible-galaxy install -r ./ansible/requirements.yml
vagrant up
ansible-playbook -i ./.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory ./ansible/main.yml
