#!/bin/bash
 ansible-playbook -i localhost ./vagrant-the-hard-way/ansible/vbox_host.yml
 cd vagrant-the-hard-way
 vagrant up