#!/bin/bash

LXC_PROFILE="k3s"
LXC_CONTAINER_MEMORY="2GB"
LXC_CONTAINER_CPU="2"

if [ -f ~/.k3s_lxd ]
  then exit 0
fi

lxc profile copy default ${LXC_PROFILE}
lxc profile set ${LXC_PROFILE} security.privileged true
lxc profile set ${LXC_PROFILE} security.nesting true
lxc profile set ${LXC_PROFILE} limits.memory.swap false
lxc profile set ${LXC_PROFILE} limits.memory ${LXC_CONTAINER_MEMORY:-2GB}
lxc profile set ${LXC_PROFILE} limits.cpu ${LXC_CONTAINER_CPU:-2}
lxc profile set ${LXC_PROFILE} linux.kernel_modules overlay,nf_nat,ip_tables,ip6_tables,netlink_diag,br_netfilter,xt_conntrack,nf_conntrack,ip_vs,vxlan

cat <<EOT | lxc profile set ${LXC_PROFILE} raw.lxc -
lxc.apparmor.profile = unconfined
lxc.cgroup.devices.allow = a
lxc.mount.auto=proc:rw sys:rw
lxc.cap.drop =
EOT

touch ~/.k3s_lxd

lxc profile show ${LXC_PROFILE}
