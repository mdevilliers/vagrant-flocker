#!/bin/bash
export DEBIAN_FRONTEND=noninteractive 

# add clusterhq deb details
add-apt-repository -y "deb https://clusterhq-archive.s3.amazonaws.com/ubuntu/$(lsb_release --release --short)/\$(ARCH) /"

# install dependancies
apt-get update
apt-get -y --force-yes install apt-transport-https software-properties-common clusterhq-flocker-cli clusterhq-flocker-node 

# configure flocker
mkdir /etc/flocker
chmod 0700 /etc/flocker

cp /vagrant/cert-store/cluster.crt /etc/flocker
cp /vagrant/cert-store/control-flocker-control-node.crt /etc/flocker/control-service.crt
cp /vagrant/cert-store/control-flocker-control-node.key /etc/flocker/control-service.key
chmod 0600 /etc/flocker/control-service.key

cat <<'EOF' > /etc/init/flocker-control.override
start on runlevel [2345]
stop on runlevel [016]
EOF

echo "flocker-control 4523/tcp # Flocker Control API port" >> /etc/services

service flocker-control start