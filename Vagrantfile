Vagrant.configure("2") do |config|
    config.vm.box = "puphpet/debian75-x64"
    
    config.vm.synced_folder "project", "/var/www/project"
    
    config.vm.network 'private_network', ip: '10.50.0.14'

    config.vm.provision :shell, :inline => "sudo apt-get update && sudo apt-get install puppet -y"
    
    config.vm.provision :shell, path: "bootstrap.sh"
    
    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppets/manifests"
        puppet.module_path    = "puppets/modules"
        puppet.manifest_file  = 'init.pp'
    end

end