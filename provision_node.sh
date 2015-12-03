#!/bin/bash
export DEBIAN_FRONTEND=noninteractive 

# add docker key
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
echo "deb https://get.docker.io/ubuntu docker main" | sudo tee /etc/apt/sources.list.d/docker.list

# add clusterhq deb details
add-apt-repository -y "deb https://clusterhq-archive.s3.amazonaws.com/ubuntu/$(lsb_release --release --short)/\$(ARCH) /"

apt-get update
apt-get -y --force-yes install apt-transport-https software-properties-common lxc-docker clusterhq-flocker-node clusterhq-flocker-docker-plugin

mkdir /etc/flocker
chmod 0700 /etc/flocker

cp /vagrant/cert-store/cluster.crt /etc/flocker
cp /vagrant/cert-store/c51305eb-e69f-47a8-a93c-83d432032758.crt /etc/flocker/node.crt
cp /vagrant/cert-store/c51305eb-e69f-47a8-a93c-83d432032758.key /etc/flocker/node.key
cp /vagrant/cert-store/plugin.crt /etc/flocker
cp /vagrant/cert-store/plugin.key /etc/flocker
chmod 0600 /etc/flocker/node.key
chmod 0600 /etc/flocker/plugin.key

cat <<'EOF' > /etc/flocker/agent.yml
"version": 1
"control-service":
   "hostname": "flocker-control-node"
   "port": 4524
"dataset":
   "backend": "loopback"
   "root_path": "/vagrant/datasets"
EOF

service flocker-dataset-agent start
service flocker-container-agent start
service flocker-docker-plugin restart