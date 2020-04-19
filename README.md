# k3s-on-lxd
K3S on LXD  [wip]

## Usage

Deploy a master:

```
$ ./deploy master --name k3s-master
...
[INFO]  systemd: Starting k3s
writing config to /home/user/kubeconfig
```

Deploy 2 agents:

```
$ ./deploy agent --name k3s-node-1
$ ./deploy agent --name k3s-node-2
```

View the nodes using kubectl:

```
$ docker run -it -v $PWD/kubeconfig:/root/.kube/config ruanbekker/kubectl kubectl get nodes
NAME         STATUS   ROLES    AGE     VERSION
k3s-master   Ready    master   5m17s   v1.17.4+k3s1
k3s-node-1   Ready    <none>   3m29s   v1.17.4+k3s1
k3s-node-2   Ready    <none>   2m33s   v1.17.4+k3s1
```
