VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.ssh.private_key_path = "~/.ssh/id_rsa_vagrant.pem"

    # Disable default synced folder
    config.vm.synced_folder '.', '/vagrant', disabled: true
    config.vm.synced_folder "~/vagrant-syncd-vol", "/srv/vagrant", create: true

    config.vm.provider "virtualbox" do |virtualbox|
        virtualbox.memory = 2048
        virtualbox.name = "DevVMJessie"
    end

    # set vagrant vm name
    config.vm.define "DevVMJessie"
end
