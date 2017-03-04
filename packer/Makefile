all: boot2docker debian-jessie

install-boxes: boot2docker-box-install debian-jessie-box-install

remove-boxes: boot2docker-box-remove debian-jessie-box-remove

boot2docker:
	time packer build -force boot2docker.json

boot2docker-box-install:
	vagrant box add boot2docker box/virtualbox/boot2docker-v1.13.1.box

boot2docker-box-remove:
	vagrant box remove boot2docker

debian-jessie:
	time packer build -force debian-jessie.json

debian-jessie-box-install:
	vagrant box add debian-jessie box/virtualbox/debian-8.7.1-amd64.box

debian-jessie-box-remove:
	vagrant box remove debian-jessie

.PHONY: all install-boxes remove-boxes \
        boot2docker boot2docker-box-install boot2docker-box-remove \
        debian-jessie debian-jessie-box-install debian-jessie-box-remove
