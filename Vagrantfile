# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

# Load servers definition
servers_definition = [ '../servers.yml', '../ansible/servers.yml' ].
                       map{ |p| File.expand_path(p, __FILE__) }.
                       select{ |p| File.exists?(p) }.
                       first

servers = YAML.load_file(servers_definition).each.with_index do |server, index|
  server['name']  ||= "server-#{index}"
  server['ip']    ||= "192.168.50.#{20 + index}"
  server['ports']   = { '80': (8000 + index) }.merge(server['ports'] || {})
  server['folders'] = (server['folders'] || {})
end

# Vagrant configuration
Vagrant.configure(2) do |config|

  # Common configuration
  config.vm.box = "bento/debian-8.5"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "512"
  end

  # Servers
  servers.each do |server|
    config.vm.define server['name'] do |m|
      m.vm.hostname = server['name']
      m.vm.network "private_network", ip: server['ip']

      server['ports'].each do |guest, host|
        m.vm.network "forwarded_port", guest: guest.to_s.to_i, host: host.to_s.to_i
      end

      server['folders'].each do |guest_bind_path, options|
        guest_mount_path = "/vagrant-#{guest_bind_path.gsub('/', '-')}"
        synced_options   = (options['synced'] || {}).reduce({}) do |opts, (name, value)|
                             opts[name] = value == 'nil' ? nil : value.to_s
                             opts
                           end
        bindfs_options   = (options['bindfs'] || {}).reduce({}) do |opts, (name, value)|
                             opts[name] = value == 'nil' ? nil : value.to_s
                             opts
                           end

        m.vm.synced_folder options['source'], guest_mount_path, synced_options
        m.bindfs.bind_folder guest_mount_path, guest_bind_path, bindfs_options
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
      ssh_keyscan = servers.collect{ |s| [ s['ip'], s['name'] ] }.flatten.join(' ')
      ssh_configs = servers.collect{ |s| (s['ssh'] || '') }.join("\n")
      
      p.name   = "configure-ssh"
      p.inline = <<-PROVISION.gsub(/^[ \t]{8}/, '')
        ssh-keyscan #{ssh_keyscan} >> /home/vagrant/.ssh/known_hosts 2>/dev/null
        ssh-keygen -t rsa -b 2048 -f /home/vagrant/.ssh/id_rsa -q -P ""
        cat >> /home/vagrant/.ssh/config <<-EOL
        #{ssh_configs}
        EOL
        chown -R vagrant:vagrant /home/vagrant/.ssh/*
        chmod -R 600 /home/vagrant/.ssh/*
      PROVISION
    end
  end
end
