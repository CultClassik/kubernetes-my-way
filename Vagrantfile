NETIFACE = "enp3s0"
IP_NET = "192.168.1."
INT_NET = "192.168.5."
IP_START = 100
MYBOX = "ubuntu/bionic64"
CONT_CPU = 2
CONT_RAM = 3000
NODE_CPU = 2
NODE_RAM = 2000

vms = {
  :controllers => {
    :hosts    => [ "kc1", "kc2", "kc3" ],
    :cpu      => CONT_CPU,
    :ram      => CONT_RAM
  },
  :nodes => {
    :hosts    => [ "kn1", "kn2", "kn3" ],
    :cpu      => NODE_CPU,
    :ram      => NODE_RAM
  }
}

# Create VMs for Kubernetes controllers/etcd
Vagrant.configure(2) do |config|
  vms[:controllers][:hosts].each_with_index do |hostname, index|
    config.vm.define hostname do |node|
      node.vm.box = MYBOX
      node.vm.hostname = hostname
      node.vm.network "public_network", ip: IP_NET + (IP_START + index + 1).to_s, bridge: NETIFACE
      node.vm.network "private_network", ip: INT_NET + (IP_START + index + 1).to_s
      node.vm.provider "virtualbox" do |vb|
        vb.linked_clone = true
        vb.name = node.vm.hostname
        vb.customize ["modifyvm", :id, "--memory", vms[:controllers][:ram]]
        vb.customize ["modifyvm", :id, "--cpus", vms[:controllers][:cpu]]
      end
    end
  end
end

# Create VMs for Kubernetes worker nodes
Vagrant.configure(2) do |config|
  vms[:nodes][:hosts].each_with_index do |hostname, index|
    config.vm.define hostname do |node|
      node.vm.box = MYBOX
      node.vm.hostname = hostname
      node.vm.network "public_network", ip: IP_NET + (IP_START + 10 + index).to_s, bridge: NETIFACE
      node.vm.network "private_network", ip: INT_NET + (IP_START + 10 + index).to_s
      node.vm.provider "virtualbox" do |vb|
        vb.linked_clone = true
        vb.name = node.vm.hostname
        vb.customize ["modifyvm", :id, "--memory", vms[:nodes][:ram]]
        vb.customize ["modifyvm", :id, "--cpus", vms[:nodes][:cpu]]
      end
      if index == (vms[:nodes][:hosts].length())
        runansible()
      end
    end
  end
end

def runansible()
  # Run Ansible playbook to configure all VMs
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "vagrant.yml"
    #ansible.galaxy_role_file = "ansible/requirements.yml"
    ansible.groups = {
      "k8s_etcd"       => vms[:controllers][:hosts], # all controllers will be etcd hosts also
      "k8s_controller" => vms[:controllers][:hosts],
      "k8s_node"     => vms[:nodes][:hosts],
      "all:vars"       => {
          "k8s_interface" => "enp0s9",
          "k8s_version" => "1.18.0",
          "kubectl_download_filetype" => "archive",
          "kubectl_checksum_archive" => "sha512:594ca3eadc7974ec4d9e4168453e36ca434812167ef8359086cd64d048df525b7bd46424e7cc9c41e65c72bda3117326ba1662d1c9d739567f10f5684fd85bee",
          "private_if" => "enp0s9",
          "public_if" => "enp0s8",
          "local_id" => "chris",
          "user_id" => "vagrant",
          "kube_conf_dir" => "/home/vagrant/k8s",
          "k8s_conf_files_dir" => "/home/{{ local_id }}/k8s-conf",
          "cluster_cidr" => "176.16.13.0/24",
          "pod_cidr" => "192.168.10.0/24"
        }
      }
  end
end