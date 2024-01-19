Vagrant.configure("2") do |config|
  #Ordenes obligatoria
  config.vm.box = "debian/bullseye64"

  #Ordenes generales para todas las MVs
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "256" # RAM
    vb.linked_clone = true
  end

  #Solo para una VM que vamos a llamar DEBIAN
  config.vm.define "tierra" do |debian|
    debian.vm.hostname = "tierra"
    debian.vm.network :private_network, ip: "192.168.57.103"
    debian.vm.provision "shell", path: "provision.sh"
  end

  config.vm.define "venus" do |debian|
    debian.vm.hostname = "venus"
    debian.vm.network :private_network, ip: "192.168.57.102"
    debian.vm.provision "shell", path: "provision.sh"
  end

end