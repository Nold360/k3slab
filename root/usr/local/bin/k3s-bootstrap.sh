#!/bin/bash
# Start K3S Master if /boot/master exists
# else run as worker & try to find "master" via DNS forever
export PATH=$PATH:/usr/local/bin
source /boot/k3s.config
K3S_MODE=${K3S_MODE:-agent}

# force k3s upgrade
if [ ! -f /usr/local/bin/k3s ] || [ "$UPDATE" != "false" ]; then
	wget -O /usr/local/bin/k3s "$K3S_URL"
	chmod +x /usr/local/bin/k3s
	rm -f /boot/update
fi

# run as master, if K3S_MODE in /boot/k3s.config is "master"
# Default: agent/worker-node
#
echo " => K3S Running in ${K3S_MODE} mode"
if ! grep -q ${K3S_MODE} /etc/hostname ; then
	# Generate random 4-char name for worker nodes
	suffix="-$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | \
			grep -o '[a-zA-Z0-9]' | tr -d '\n' | cut -c1-4)"
		
	[ "${K3S_MODE}" == "master" ] && suffix=""
	echo ${K3S_MODE}${suffix} > /etc/hostname
	reboot
fi

if [ "${K3S_MODE}" == "master" ] ; then
	export K3S_NODE_NAME=$K3S_MODE
	k3s server --tls-san "master"
else
	export K3S_NODE_NAME=$(cat /etc/hostname)
	k3s agent --server https://master:6443 --token $K3S_CLUSTER_SECRET
fi
exit 0
