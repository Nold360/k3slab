#!/bin/bash
# Quick and dirty script to patch files into a raspi-img
set -e
set -u

# config
IMG_FILE=$1
ROOT_MNT=./mnt
mkdir -p $ROOT_MNT

# cleanup on exit
trap clean_exit 0 1 2 3 15
function clean_exit {
	set +e
	set +u
	echo "Exit. Cleaning up..."
	sync
	umount -q $ROOT_MNT/boot
	umount -q $ROOT_MNT
	[ ! -z "$loopdev" ] && losetup -d $loopdev
}

# create loopdev from image and mount it
echo "Creating and mounting loop device..."
loopdev=$(losetup --partscan --show --find "$IMG_FILE")
mount "${loopdev}p2" $ROOT_MNT
mkdir -p $ROOT_MNT/boot $ROOT_MNT/etc/systemd/system/multi-user.target.wants/

# preseed k3s
echo "Downloading k3s-binary..."
source root/boot/k3s.config
wget -O $ROOT_MNT/usr/local/bin/k3s "$K3S_URL"
chmod +x $ROOT_MNT/usr/local/bin/k3s

# copy files
echo "Copying files to image filesystem..."
mount "${loopdev}p1" $ROOT_MNT/boot
cp -arv root/* $ROOT_MNT/ || true

# Other patches
# enable k3s service on bootup e.g. `systemctl enable k3s`
ln -s /etc/systemd/system/k3s.service $ROOT_MNT/etc/systemd/system/multi-user.target.wants/k3s.service || true

echo "Image '$IMG_FILE' successfully patched!"
exit 0
