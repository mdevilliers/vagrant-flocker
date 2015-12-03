# -*- mode: ruby -*-
# vi: set ft=ruby :

# install required plugins
required_plugins = %w(vagrant-hostmanager)

required_plugins.each do |plugin|
  need_restart = false
  unless Vagrant.has_plugin? plugin
    system "vagrant plugin install #{plugin}"
    need_restart = true
  end
  exec "vagrant #{ARGV.join(' ')}" if need_restart
end


VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # setup hostmanager config to update the host files
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  config.vm.provision :hostmanager

  config.vm.define "flocker-control-node" do |node_config|

    node_config.vm.hostname = "flocker-control-node"
    node_config.vm.box = "ubuntu/trusty64"

    node_config.hostmanager.aliases = "flocker-control-node"
    node_config.vm.network :private_network, ip: "192.168.0.55"

    node_config.vm.provider :virtualbox do |v, override|
     
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--cpus", 1]
        
    end
    node_config.vm.provision 'shell', path: 'provision_control_node.sh'
  end

  config.vm.define "flocker-agent-node-1" do |node_config|

    node_config.vm.hostname = "flocker-agent-node-1"
    node_config.vm.box = "ubuntu/trusty64"

    node_config.hostmanager.aliases = "flocker-agent-node-1"
    
    node_config.vm.network :private_network, ip: "192.168.0.65"

    node_config.vm.provider :virtualbox do |v, override|
     
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--cpus", 1]
        
    end
    node_config.vm.provision 'shell', path: 'provision_node.sh'
  end

end
