#!/bin/sh

# Perform system update
sudo yum -y install vim 
sudo yum -y update

# Set up repos and install dependencies for kubernetes
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Install Docker pre-reqs
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum -y install docker-ce docker-ce-selinux

mkdir -p /etc/docker
cat <<EOF > /etc/docker/daemon.json
{
  "storage-driver": "overlay2"
}
EOF

systemctl start docker
systemctl enable docker

# Kubelet installation
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

# Configure SELinux contexts in order to resolve https://github.com/kubernetes/kubeadm/issues/1654

mkdir -p /var/lib/etcd/
mkdir -p /etc/kubernetes/pki/
chcon -R -t svirt_sandbox_file_t /var/lib/etcd
chcon -R -t svirt_sandbox_file_t /etc/kubernetes/

systemctl enable --now kubelet

cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# Custom personal options
echo "set -o vi" >> /etc/bashrc