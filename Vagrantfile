# -*- mode: ruby -*-
# vi: set ft=ruby :

# Defining Oracle Proxy / Use Case Flags
load './vagrant-addons/ProxyConfigfile'

# Display Message so users know how to access the demo.
$msg = <<MSG_EOF
------------------------------------------------------
Sample Sandbox Mgmt, accessible at localhost (127.0.0.1)

Access:
- C:\> vagrant ssh
- C:\> vagrant ssh-config

- python2
- ruby
- java

- atom
- git

- chefdk
- jenkins
- terraform
- terraform-provider-oci

Port Forwards:
  SSH - Port 2222
  Jenkins - http://127.0.0.1:8080
  VNC Server - localhost:5901
------------------------------------------------------
MSG_EOF

##############################################################################
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  # This demo will use Oracle Linux 7.3 mini server image.
  # You can search for boxes at https://vagrantcloud.com/search.
  config.vm.box = "oravirt/ol73"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:2280" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 80, auto_correct: true
  config.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true
  config.vm.network "forwarded_port", guest: 443, host: 443, auto_correct: true
  # vnc server port forwarding
  for i in 5901..5905
    config.vm.network "forwarded_port", guest: i, host: i
  end

  # Share an additional folder to the guest VM, default is "share" in the current directory.
  config.vm.synced_folder "vagrant-share", "/vagrant_share"

  # Use Berkshelf for automatically resolving Chef dependencies
  config.berkshelf.enabled = false
  #config.berkshelf.enabled = true
  # Enable provisioning of the client with chef-solo
  #config.vm.provision :chef_solo do |chef|
  #  chef.cookbooks_path = ['cookbooks','./vagrant-cookbooks']
  #  chef.add_recipe "main::default"
  #end

  config.vm.provision "shell", path: "./vagrant-shell/provision.sh"
  config.vm.provision "shell", path: "./vagrant-shell/training-client-install.sh"


  config.vm.post_up_message = $msg
end
