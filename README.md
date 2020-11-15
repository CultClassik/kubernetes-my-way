# Kubernetes the "hard" way with Vagrant and Ansible

## Requirements
Just an Ubuntu Linux system with enough CPU, RAM and disk to host the desired number of VMs in your Kubernetes cluster.

Old folders from original method that used Bash and Puppet instead of Ansible left for reference
* puppet
* shell

## Setup (from root of this repo, on the vbox host)
1. Set variables in vagrant.yml as needed
* local_user: chris
* github_userid: cultclassik
* user_id: vagrant
2. run `vagrant up` 
* Will generate an Ansible inventory file at `./.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory`
3. Run `ansible-playbook -i ./.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory ./ansible/main.yml`
* Generates all TLS certificates
* Distributes TLS certs and kube conf files
* Installs and configures kubectl on all systems
* Installs etcd, controller and node components
* Creates haproxy container on the vbox host to serve as the k8s API proxy

## Vagrantfile
* Will create as many controllers and nodes as defined
* VMs will be created as linked clones to conserve disk space
* Will run the Ansible provisioner on all VMs after the last VM has been provisioned

## Individual plays
All plays in the "plays" folder will perform the actions for individual components i.e. vbox host, etcd hosts, nodes, controllers.

------

## TODO
Health checks need to be setup with the API server at https://127.0.0.1:6443/healthz
Ensure shell commands include a "creates" when possible
