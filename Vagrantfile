VBOX_HOST_USERID   = "chris"
GITHUB_USER_ID     = "cultclassik"
HOST_PUB_IFACE     = "enp4s0"
VM_PUB_NET         = "10.0.2."
VM_PUB_NETMASK     = "24"
VM_INT_NET         = "192.168.56."
IP_START           = 100
VM_INT_IFACE       = "enp0s9"
VM_PUB_IFACE       = "enp0s8"
MYBOX              = "ubuntu/bionic64" # various issues with focal, going back to bionic
K8S_VERSION        = "1.21.12"
CLUSTER_CIDR       = "10.200.0.0/16"
SERVICE_CLUSTER_IP_RANGE = "10.32.0.0/24"
CLUSTER_DNS              = "10.32.0.10"
K8S_POD_CIDR_BASE        = "10.200."
K8S_POD_CIDR_MASK        = "/24"
VM_USERID                = "vagrant"
COREDNS_FORWARDS         = "#{VM_PUB_NET}1:53"
K8S_API_IP               = "#{VM_PUB_NET}11"
TLS_ORG_NAME             = "Kubernetes the Diehlabs Way"
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

# Build list of unique pod cidrs to add to the ansible vars for each worker node
$nodelist = {}
$cidr_base_subnet = IP_START + 1
VMS[:controllers][:hosts].each_with_index do |hostname, index|
  $nodelist[hostname] = { "pod_cidr" => K8S_POD_CIDR_BASE + ( $cidr_base_subnet ).to_s + ".0" + K8S_POD_CIDR_MASK }
  $cidr_base_subnet += 1
end
VMS[:nodes][:hosts].each_with_index do |hostname, index|
  $nodelist[hostname] = { "pod_cidr" => K8S_POD_CIDR_BASE + ( $cidr_base_subnet ).to_s + ".0" + K8S_POD_CIDR_MASK }
  $cidr_base_subnet += 1
end

# Run Ansible playbook to configure all VMs
def runansible(node)
  node.vm.provision "ansible" do |ansible|
    ansible.limit = "all"
    ansible.playbook = "vagrant.yml"
    #ansible.galaxy_role_file = "ansible/requirements.yml"
    ansible.host_vars = $nodelist
    ansible.groups = {
      "k8s_etcd"       => VMS[:controllers][:hosts], # all controllers will be etcd hosts also
      "k8s_controller" => VMS[:controllers][:hosts],
      "k8s_node"     => VMS[:nodes][:hosts],
      "all:vars"       => {
          "k8s_version" => K8S_VERSION,
          "private_if" => VM_INT_IFACE,
          "public_if" => VM_PUB_IFACE,
          "local_id" => VBOX_HOST_USERID,
          "github_userid" => GITHUB_USER_ID,
          "user_id" => VM_USERID,
          "kube_conf_dir" => "/home/{{ user_id }}/k8s",
          "k8s_conf_files_dir" => "/home/{{ local_id }}/k8s-conf",
          "k8s_cluster_cidr" => CLUSTER_CIDR,
          "k8s_service_cluster_ip_range" => SERVICE_CLUSTER_IP_RANGE,
          "cluster_dns" => CLUSTER_DNS,
          "coredns_forwards" => COREDNS_FORWARDS,
          "oci_image_regstry_address" => K8S_API_IP,
          "vm_pub_net_cidr" => "#{VM_PUB_NET}0/#{VM_PUB_NETMASK}"
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