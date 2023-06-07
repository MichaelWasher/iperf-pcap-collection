# Egress IP PCAP Collection - Must-Gather image

This repository is used to build an image for use with the OpenShift Must-Gather tool.
This container image deploys a DaemonSet within the cluster that will collect PCAPs for the EgressIP Healthchecks seen in OVN Kubernetes on all relevant Nodes.

# How to Use
PCAP collection tool is split into two parts, deploying and collecting.

## Deploying
To start collection a packet capture for Nodes within the cluster, the 'deploy' option is used when running the image as below:
```bash 
$ oc adm must-gather --image quay.io/mwasher/egressippcapcollection -- deploy
```

The DaemonSet will automatically be applied to all of the OpenShift Masters and all Nodes with the label `k8s.ovn.org/egress-assignable: ""`

## Collecting the PCAP Files
To bundle and download the pcaps from all labeled Nodes, the 'collect' option should be used as below:
```bash 
$ oc adm must-gather --image quay.io/mwasher/egressippcapcollection -- collect
```

# Uninstall
To remove the pcap collectors the 'destroy' option should be used:
```bash 
$ oc adm must-gather --image quay.io/mwasher/egressippcapcollection -- destroy
```
