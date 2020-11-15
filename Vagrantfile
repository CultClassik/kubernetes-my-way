HOST_PUB_IFACE   = "enp3s0"
VM_PUB_NET       = "192.168.1."
VM_INT_NET       = "192.168.5."
IP_START         = 100
K8S_IFACE        = "enp0s9"
VM_INT_IFACE     = "enp0s9"
VM_PUB_IFACE     = "enp0s8"
MYBOX            = "ubuntu/bionic64"
K8S_VERSION      = "1.18.0"
K8S_CLUSTER_CIDR = "176.16.13.0/24"
K8S_POD_CIDR     = "192.168.10.0/24"
VBOX_HOST_USERID = "chris"
VM_USERID        = "vagrant"
VMS = {
  :controllers => {
    :hosts    => [ "kc1", "kc2", "kc3" ],
    :cpu      => 2,
    :ram      => 3000
  },
  :nodes => {
    :hosts    => [ "kn1", "kn2", "kn3" ],
    :cpu      => 2,
    :ram      => 2000
  }
}

# Run Ansible playbook to configure all VMs
def runansible(node)
  node.vm.provision "ansible" do |ansible|
    ansible.limit = "all"
    ansible.playbook = "vagrant.yml"
    #ansible.galaxy_role_file = "ansible/requirements.yml"
    ansible.groups = {
      "k8s_etcd"       => VMS[:controllers][:hosts], # all controllers will be etcd hosts also
      "k8s_controller" => VMS[:controllers][:hosts],
      "k8s_node"     => VMS[:nodes][:hosts],
      "all:vars"       => {
          "k8s_interface" => K8S_IFACE,
          "k8s_version" => K8S_VERSION,
          "kubectl_download_filetype" => "archive",
          "kubectl_checksum_archive" => "sha512:594ca3eadc7974ec4d9e4168453e36ca434812167ef8359086cd64d048df525b7bd46424e7cc9c41e65c72bda3117326ba1662d1c9d739567f10f5684fd85bee",
          "private_if" => VM_INT_IFACE,
          "public_if" => VM_PUB_FACE,
          "local_id" => VBOX_HOST_USERID,
          "user_id" => VM_USERID,
          "kube_conf_dir" => "/home/{{ user_id }}/k8s",
          "k8s_conf_files_dir" => "/home/{{ local_id }}/k8s-conf",
          "cluster_cidr" => K8S_CLUSTER_CIDR,
          "pod_cidr" => K8S_POD_CIDR
        }
      }
  end
end

# Create VMs for Kubernetes controllers/etcd
Vagrant.configure(2) do |config|
  VMS[:controllers][:hosts].each_with_index do |hostname, index|
    config.vm.define hostname do |node|
      node.vm.box = MYBOX
      node.vm.hostname = hostname
      node.vm.network "public_network", ip: VM_PUB_NET + (IP_START + index + 1).to_s, bridge: HOST_PUB_IFACE
      node.vm.network "private_network", ip: VM_INT_NET + (IP_START + index + 1).to_s
      node.vm.provider "virtualbox" do |vb|
        vb.linked_clone = true
        vb.name = node.vm.hostname
        vb.customize ["modifyvm", :id, "--memory", VMS[:controllers][:ram]]
        vb.customize ["modifyvm", :id, "--cpus", VMS[:controllers][:cpu]]
      end
    end
  end
end

# Create VMs for Kubernetes worker nodes
Vagrant.configure(2) do |config|
  VMS[:nodes][:hosts].each_with_index do |hostname, index|
    config.vm.define hostname do |node|
      node.vm.box = MYBOX
      node.vm.hostname = hostname
      node.vm.network "public_network", ip: VM_PUB_NET + (IP_START + 10 + index).to_s, bridge: HOST_PUB_IFACE
      node.vm.network "private_network", ip: VM_INT_NET + (IP_START + 10 + index).to_s
      node.vm.provider "virtualbox" do |vb|
        vb.linked_clone = true
        vb.name = node.vm.hostname
        vb.customize ["modifyvm", :id, "--memory", VMS[:nodes][:ram]]
        vb.customize ["modifyvm", :id, "--cpus", VMS[:nodes][:cpu]]
      end
      # run the ansible provisioner function against all vms if this is the last vm to be created
      if index == (VMS[:nodes][:hosts].length()-1)
        runansible(node)
      end
    end
  end
end

# config.trigger.after :destroy do |trigger|
#   ...
# end