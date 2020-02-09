#!/bin/bash

if [ "$EUID" -ne 0 ]; then 
	echo "Please run as root"
	exit
fi

apt-get update
apt-get -y upgrade

cp /etc/fstab ~/fstab.bak
cat <<EOF >> /etc/fstab
# add mount point for backup
# TODO: change nas, user and password
# Do not change mount point or change it alos in backup.sh
//??nas??/home /mnt/backup cifs  username=?????,password=?????  0  0
EOF

mkdir -p /mnt/backup
mount -a

cat > /usr/local/bin/backup.sh <<EOF
#!/bin/bash

if [ "$EUID" -ne 0 ]; then 
	echo "Please run as root"
	exit
fi

# ------------------
BACKUP_PATH="/mnt/backup"
BACKUP_COUNT="5"
BACKUP_NAME="????-Backup"
# ------------------

dd if=/dev/mmcblk0 of=${BACKUP_PATH}/${BACKUP_NAME}-$(date +%Y%m%d-%H%M%S).img bs=1MB status=progress
pushd ${BACKUP_PATH}; ls -tr ${BACKUP_PATH}/${BACKUP_NAME}* | head -n -${BACKUP_COUNT} | xargs rm; popd

EOF

vim /usr/local/bin/backup.sh
chmod a+x /usr/local/bin/backup.sh