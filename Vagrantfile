# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # centos 6.5
  config.vm.box = "bradallenfisher/centos65-x86_64"
  
  # ip address
  config.vm.network "private_network", ip: "192.168.33.99"
  
  # host name
  config.vm.hostname = "local.digital.dev"
  
  # virtual box name
  config.vm.provider "virtualbox" do |v|
    v.name = "digital"
  end
  
  # run script as root
  config.vm.provision "shell",
    path: "nginx-php5/install.sh"
    
  # run script as vagrant user
  config.vm.provision "shell",
    path: "nginx-php5/post-install.sh",
    privileged: FALSE

end
