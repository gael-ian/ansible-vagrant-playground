# ansible-vagrant-playground

[Vagrant](https://vagrantup.com) configurations and provisionning scripts to build an [Ansible](https://www.ansible.com/) playground in minutes.

Sets up:

* A `manager` VM to run Ansible from 
* A set of managed servers to test your configurations


## Prerequisites

You must have [Vagrant](https://vagrantup.com) installed on your machine.


## Usage

1. Copy `servers.yml.sample` to `servers.yml` and edit it  
   Define as many managed servers as you need in this file. See comments on top of the sample file for details.
2. Put your Ansible configuration in the `ansible` directory  
   It will be mounted in the `manager` VM at `/home/vagrant/ansible`.
3. Build VMs with `vagrant up`  
   And go grab some coffee :o)
4. Connect to the `manager` VM with `vagrant ssh manager`  
   Enter the `ansible` directory and start managing your servers. 

You can find a sample Ansible configuration in [my `ansible-config-webservers` 
repository](https://github.com/gael-ian/ansible-config-webservers).

## Inspirations

These settings were inspired by this sysadmincast.com serie :

1. [19 minutes with Ansible](https://sysadmincasts.com/episodes/43-19-minutes-with-ansible-part-1-4)
2. [Learning Ansible with Vagrant](https://sysadmincasts.com/episodes/45-learning-ansible-with-vagrant-part-2-4)
3. [Configuration management with Ansible](https://sysadmincasts.com/episodes/46-configuration-management-with-ansible-part-3-4)
4. [Zero-downtime deployments with Ansible](https://sysadmincasts.com/episodes/47-zero-downtime-deployments-with-ansible-part-4-4)

I encourage you to watch at least the first 3 episodes for an intelligible presentation of Ansible.

