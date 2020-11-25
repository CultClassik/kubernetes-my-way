#!/bin/bash
vagrant up
ansible-galaxy install -r ./ansible/requirements.yml
ansible-playbook -i ./.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory ./ansible/main.yml
