#!/usr/bin/env bash

set -e

MOUNT_POINT=/mnt/data
B2D_PERSISTENT_DIR=${MOUNT_POINT}/var/lib/boot2docker
TMP_USERDATA_DIR=/tmp/userdata
HDD_DEV=/dev/sda
B2D_DATA_DEV="${HDD_DEV}2"

# Format globally $HDD_DEV for cleaning eventually old partition table
echo "== Dumping boot2docker.iso to ${HDD_DEV} :"
dd if=/tmp/boot2docker.iso of=${HDD_DEV}

# Creating one partition and formating to ext4
# See https://github.com/boot2docker/boot2docker/issues/531#issuecomment-61740859
echo "== Creating a second partition"
echo "n
p
2


w
"| /sbin/fdisk ${HDD_DEV}
echo "== Formating the partition in ext4 with the boot2docker-data label"
/sbin/mkfs.ext4 -L boot2docker-data ${B2D_DATA_DEV}

echo "p" | /sbin/fdisk ${HDD_DEV}

# Mounting the freshly formatted volume to copy persisted content
echo "== Mounting new partition to customize"
mkdir -p ${MOUNT_POINT}
mount ${HDD_DEV}2 ${MOUNT_POINT}

echo "== Inserting vagrant key in the userdata.tar which should be deployed when boot2docker boot"
mkdir -p ${B2D_PERSISTENT_DIR} ${TMP_USERDATA_DIR}/.ssh
cat <<KEY >${TMP_USERDATA_DIR}/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHb62X+gfIlkdZ7OhyPfpYkIkoF84fcIW+PmvglvXTeeDgWR8y8YLbqLDG5BW/GHBFjniMj66fVjbPzCvwGffuWBDhuA9Jz/d4NbrrudzGP0lYq6cYmrIbV95PurS8/sZ8i9BqlPJCDfv21U/WPSVjZU9x8y6RJbvaHuAT6zGwyYwHPRcyLDicTNtkBFvT9AGCftTligM9CrHOd7VspOjzZRfcHXVBvUla4IzEXca09joHf3fUgIwTfPeR/vFM+YDADq1A1ev2FRg/Cua30owCD0OD8DQY8LQ1yFUBxXZ6q5YgD88Qp/ofwsykpMYWZbtzJbR+e4tmnTrsjoqqe6np
KEY
chmod 0600 ${TMP_USERDATA_DIR}/.ssh/authorized_keys

echo "== Compress and copy userdata"
cd ${TMP_USERDATA_DIR}
tar cf ${B2D_PERSISTENT_DIR}/userdata.tar ./.ssh

echo "== Customize docker daemon"
cat <<EOF >${B2D_PERSISTENT_DIR}/profile
# Insert custom Docker daemon settings here
EOF
