VAGRANTFILE_API_VERSION = "2"

vm_login_user           = "docker"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.ssh.shell = "sh"
    config.ssh.username = "docker"
    config.ssh.insert_key = false
    config.ssh.private_key_path = "~/.ssh/id_rsa_vagrant.pem"
    config.ssh.forward_agent = true

    # disable default synced folder
    config.vm.synced_folder '.', '/vagrant', disabled: true
    config.vm.synced_folder '~/vagrant-syncd-vol', '/srv/vagrant', create: true, owner: vm_login_user

    # sync default configs
    config.vm.provision 'file', source: '~/.Xdefaults', destination: '${HOME}/.Xdefaults'
    config.vm.provision 'file', source: '~/.bash_aliases', destination: '${HOME}/.bash_aliases'
    config.vm.provision 'file', source: '~/.bash_profile', destination: '${HOME}/.bash_profile'
    config.vm.provision 'file', source: '~/.config/bashrc', destination: '${HOME}/.bashrc'
    config.vm.provision 'file', source: '~/.gitconfig', destination: '${HOME}/.gitconfig'
    config.vm.provision 'file', source: '~/.tmux.conf', destination: '${HOME}/.tmux.conf'
    config.vm.synced_folder '~/.aws', '/home/' + vm_login_user + '/.aws', create: true, owner: vm_login_user
    config.vm.synced_folder '~/.emacs.d', '/home/' + vm_login_user + '/.emacs.d', create: true, owner: vm_login_user
    config.vm.synced_folder '~/.config/hist_backup', '/home/' + vm_login_user + '/.config/hist_backup/', create: true, owner: vm_login_user
    config.vm.synced_folder '~/.ssh', '/home/' + vm_login_user + '/.ssh', create: true, owner: vm_login_user
    config.vm.synced_folder '~/Downloads', '/home/' + vm_login_user + '/Downloads', create: true, owner: vm_login_user

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
