#!/bin/bash

container_name=$1
K3S_MASTER_NAME="k3s-master"
K3S_MASTER_IP=$(lxc list $K3S_MASTER_NAME | grep eth0| head -1 | awk '{print $4}')
K3S_TOKEN_VALUE=$(lxc exec $K3S_MASTER_NAME -- bash -c "cat /var/lib/rancher/k3s/server/node-token")

lxc init images:ubuntu/bionic/amd64 --profile privileged $container_name
lxc config device add "${container_name}" "kmsg" unix-char source="/dev/kmsg" path="/dev/kmsg"

cat > install_k3s.sh << EOF
apt update && apt install openssl curl -y
curl -sfL https://get.k3s.io | K3S_URL=https://$K3S_MASTER_IP:6443 K3S_TOKEN=$K3S_TOKEN_VALUE sh -
sleep 20
EOF

lxc start $container_name
sleep 5

lxc file push install_k3s.sh $container_name/install_k3s.sh
lxc exec $container_name -- bash /install_k3s.sh

rm -rf install_k3s.sh
