VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.ssh.shell = "sh"
    config.ssh.username = "docker"
    config.ssh.insert_key = false
    config.ssh.private_key_path = "~/.ssh/id_rsa_vagrant.pem"

    # Disable default synced folder
    config.vm.synced_folder '.', '/vagrant', disabled: true
    config.vm.synced_folder "~/vagrant-syncd-vol", "/srv/vagrant", create: true

    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.memory = 2048
        vb.name = "DevVMDocker"
    end

    # Docker port forwards
    config.vm.network "forwarded_port", guest: 2375, host: 2375, host_ip: "127.0.0.1", auto_correct: true, id: "docker"
    config.vm.network "forwarded_port", guest: 2376, host: 2376, host_ip: "127.0.0.1", auto_correct: true, id: "docker-ssl"

    # set vagrant vm name
    config.vm.define "DevVMDocker"
end
