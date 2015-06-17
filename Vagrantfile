# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|

  fqdn = 'vagrant.maetthu.dev'

  config.hostmanager.enabled = false
  config.hostmanager.manage_host = false
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true


  # define a puppet agent VM
  config.vm.define :dev1 do |vm_config|

    # some variables for easier configuration
    vm_name     = 'docker'
    vm_cores    = 2
    vm_memory   = 4096
    vm_hostname = "#{vm_name}.#{fqdn}"
    vm_ip       = '192.168.215.13'
    vb_name     = "maetthu Vagrant Test - #{vm_name}"
    box         = 'puppetlabs/ubuntu-14.04-64-nocm'

    # basic parameters
    vm_config.vm.hostname = vm_hostname
    vm_config.vm.box = box
    vm_config.ssh.forward_agent = true

    # host-only network
    vm_config.vm.network :private_network, ip: vm_ip
    vm_config.vm.network :forwarded_port, guest: 80, host: 8888, auto_correct: true
    vm_config.vm.network :forwarded_port, guest: 443, host: 8448, auto_correct: true

    ########## provisioning ####################################################
    vm_config.vm.provision :shell, :path => 'install_docker.sh'
    ############################################################################

    # configure virtualbox VM
    vm_config.vm.provider :virtualbox do |vb|
      vb.gui  = false
      vb.name = vb_name
      vb.customize ['modifyvm', :id, '--memory', vm_memory]
      vb.customize ['modifyvm', :id, '--ioapic', 'on']
      vb.customize ['modifyvm', :id, '--cpus', vm_cores]
    end
  end
end

