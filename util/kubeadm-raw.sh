#!/bin/bash
apt-get update && apt-get upgrade -y
apt-get install -y \
  docker.io \
   software-properties-common
# modprobe overlay
# modprobe br_netfilter
# cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
# net.bridge.bridge-nf-call-iptables = 1
# net.ipv4.ip_forward = 1
# net.bridge.bridge-nf-call-ip6tables = 1
# EOF
# sysctl --system
# add-apt-repository ppa:projectatomic/ppa && apt-get update
# which common - now update /etc/crio/crio.conf
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list
curl -s \
  https://packages.cloud.google.com/apt/doc/apt-key.gpg \
  | apt-key add
apt-get update
apt-get install -y \
  kubeadm=1.18.1-00 kubelet=1.18.1-00 kubectl=1.18.1-00
wget https://docs.projectcalico.org/manifests/calico.yaml