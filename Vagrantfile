# -*- mode: ruby -*-
# vi: set ft=ruby :

# Load servers definition
require 'yaml'
servers = YAML.load_file('servers.yml').each.with_index do |server, index|
  server['name'] ||= "server-#{index}"
  server['ip']   ||= "192.168.50.#{20 + index}"
  server['ports']  = { '80': (8000 + index) }.merge(server['ports'] || {})
end

# Vagrant configuration
Vagrant.configure(2) do |config|

  # Common configuration
  config.vm.box = "debian/contrib-jessie64"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "256"
  end

  # Servers
  servers.each do |server|
    config.vm.define server['name'] do |m|
      m.vm.hostname = server['name']
      m.vm.network "private_network", ip: server['ip']

      server['ports'].each do |guest, host|
        m.vm.network "forwarded_port", guest: guest.to_s.to_i, host: host.to_s.to_i
      end
    end
  end
  
  # Management node
  config.vm.define :manager do |m|
    m.vm.hostname = "manager"
    m.vm.network "private_network", ip: "192.168.50.10"

    m.vm.synced_folder "ansible/",  "/home/vagrant/ansible"
    
    
    m.vm.provision :shell, name: "install-ansible", path: "install-ansible.sh"
    
    m.vm.provision :shell do |p|
      p.name   = "configure-hosts"
      p.inline = <<-PROVISION.gsub(/^[ \t]{8}/, '')
        cat >> /etc/hosts <<-EOL
          
          # Vagrant nodes
          192.168.50.10  manager
          #{servers.collect{ |s| "#{s['ip']}  #{s['name']}" }.join("\n")}
          
        EOL
      PROVISION
    end
    
    m.vm.provision :shell do |p|
      p.name   = "configure-ssh"
      p.inline = <<-PROVISION.gsub(/^[ \t]{8}/, '')
        ssh-keyscan #{servers.collect{ |s| [ s['ip'], s['name'] ] }.flatten.join(' ')} >> /home/vagrant/.ssh/known_hosts 2>/dev/null
        ssh-keygen -t rsa -b 2048 -f /home/vagrant/.ssh/id_rsa -q -P ""
        cat >> /home/vagrant/.ssh/config <<-EOL
          #{servers.collect{ |s| (s['ssh'] || '') }.join("\n")}
        EOL
        chown -R vagrant:vagrant /home/vagrant/.ssh/*
        chmod -R 600 /home/vagrant/.ssh/*
      PROVISION
    end
  end
end
