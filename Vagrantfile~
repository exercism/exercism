Vagrant.configure('2') do |config|

  # Configure the box to use
    config.vm.box='ubuntu/trusty64'
      config.vm.define "jens_virtualmachine" do |foohost|
      end
      config.vm.provider :virtualbox do |vb|
        vb.name = "exercism_virtualbox"
      end
  # If you can only use a 32-bit operating system, Comment line 3 and uncomment lines 5
    # config.vm.box='ubuntu/trusty32'

  # Configure the network interfaces
    config.vm.network :private_network, ip:    "33.33.33.33"

    web: rackup -s puma -p 3000 -o 0.0.0.0

  # default rails server port
    config.vm.network :forwarded_port,  guest: 3000,  host: 3000

  # Default postgresql port
    config.vm.network :forwarded_port,  guest: 5432,  host: 5432

  # Configure shared folders
    config.vm.synced_folder ".",  "/vagrant", id: "vagrant-root", :nfs => true
    config.vm.synced_folder "./application", "/var/www", id: "application",  :nfs => true

  # Configure VirtualBox environment
    config.vm.provider :virtualbox do |v|

  # If you get issues running the logged in commands, uncomment the following line:
    # v.gui = true
        v.name = (0...8).map { (65 + rand(26)).chr }.join
        v.customize [ "modifyvm", :id, "--memory", 2048 ]
      end

  # Provision the box
    config.vm.provision :ansible do |ansible|
      ansible.playbook = "ansible/site.yml"
    end
end
