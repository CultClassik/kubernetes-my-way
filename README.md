# Kubernetes the hard way with Vagrant and Ansible

Old folders from original method that used Bash and Puppet instead of Ansible left for reference
* puppet
* shell

# Setup (from root of this repo, on the vbox host)
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

# Individual plays
All plays in the "plays" folder will perform the actions for individual components i.e. vbox host, etcd hosts, nodes, controllers.

------

Health checks need to be setup with the API server at https://127.0.0.1:6443/healthz
