# Vagrantfile

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  config.vm.hostname = "devops-vm"

  # Port forwarding Windows -> VM
  config.vm.network "forwarded_port", guest: 3000, host: 3001  # Flask app
  config.vm.network "forwarded_port", guest: 4646, host: 4646  # Nomad UI
  config.vm.network "forwarded_port", guest: 3100, host: 3100  # Loki

  config.vm.network "private_network", ip: "192.168.56.10"
  config.vm.network "public_network"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.name = "devops-vm"
    vb.memory = 4096
    vb.cpus = 2
    

 end

  config.vm.boot_timeout = 200  # Giảm xuống 5 phút

  config.vm.provision "shell", path: "scripts/sysinfo.sh"
  config.vm.provision "shell", path: "scripts/provision.sh"
end