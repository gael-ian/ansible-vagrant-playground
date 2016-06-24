# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # Common configuration
  config.vm.box = "debian/contrib-jessie64"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "256"
  end

  # Servers
  [ :ruby,  :php ].each.with_index do |name, index|
    config.vm.define name do |m|
      m.vm.hostname = name
      m.vm.network "private_network", ip: "192.168.50.#{20+index}"
      m.vm.network "forwarded_port", guest: 80, host: (8000 + index)
    end
  end
  
  # Management node
  config.vm.define :manager do |m|
    m.vm.hostname = "manager"
    m.vm.network "private_network", ip: "192.168.50.10"
    
    m.vm.synced_folder "ansible/",        "/home/vagrant/ansible"
    m.vm.synced_folder "../../projects/", "/home/vagrant/projects"
    
    m.vm.provision :shell, path: "bootstrap-manager.sh"
  end

end

