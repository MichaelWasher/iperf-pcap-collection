# iPerf inter-Node test - Must-Gather image

This repository is used to build an image for use with the OpenShift Must-Gather tool.
The image will deploy a numbr of DaemonSets and other objects within the cluster to perform an iPerf test between appropriately tagged Nodes. A tcpdump instance is also started on these Nodes to collect a packet capture of the iPerf traffic.

# How to Use
iPerf inter-Node test tool is split into two parts, deploying and collecting. Running the deployment script (discussed below) will configure the iPerf server, initiate the packet collection and start a Pod for the iPerf client to run in. 

**NOTE** that this will NOT start the iPerf test automatically as this is left as an exercise for the administrator.

The iPerf Server and Client Pods are running in the host network namesapce and all communication is expected to be performed over port `30995`. 

**NOTE** this is NOT the default iPerf3 port and will need to be accounted for when triggering the iPerf client with the `-p 30995` option.

## Deploying

Before deploying the iPerf test, 2 Nodes must be chosen and labeled for this test.

NOTE: THIS DOES NOT SUPPORT ARBIRTRARY NUMBERS OF NODES IN A MESH. THERE CAN ONLY BE ONE SERVER AND ONE CLIENT.

Adding the `iperf-server=""` label to the desired Node will deploy an iPerf3 server on this Node in the host network-namespace.
Adding the `iperf-client=""` label to the desired Node will deploy an iPerf3 client on this Node in the host network-namespace and initiate a test with the Server.

```
$ oc label nodes/worker-0.mwasherovn.lab.upshift.rdu2.redhat.com iperf-server=""
$ oc label nodes/master-0.mwasherovn.lab.upshift.rdu2.redhat.com iperf-client=""
```

To start an iPerf server and deploy the matching client Pod, the 'deploy' option is used when running the image as below:
```bash
⇒ oc adm must-gather --image=quay.io/mwasher/must-gather-iperf-pcap -- deploy
```
**NOTE: This will not start the iPerf test. The client is configured to sleep waiting for instructions so the administrator can choose the appropriate type of test to run in iPerf.**

To run a test, use the `oc rsh` command to access the client Pod and trigger a test:
```bash
⇒ oc get pods  -o wide
NAME                 READY   STATUS    RESTARTS   AGE     IP            NODE                                                       NOMINATED NODE   READINESS GATES
iperf-client-lmdwt   1/1     Running   0          2m23s   10.0.92.95    worker-0.sharedocp4upi412ovn.lab.upshift.rdu2.redhat.com   <none>           <none>
iperf-server-vjj2b   1/1     Running   0          2m23s   10.0.94.152   master-0.sharedocp4upi412ovn.lab.upshift.rdu2.redhat.com   <none>           <none>

⇒ oc rsh iperf-client-lmdwt 
sh-5.0# iperf3 -p 30995 -u -c 10.0.94.152
Connecting to host 10.0.94.152, port 30995
[  5] local 10.0.92.95 port 48261 connected to 10.0.94.152 port 30995
[ ID] Interval           Transfer     Bitrate         Total Datagrams
[  5]   0.00-1.00   sec   129 KBytes  1.05 Mbits/sec  91
[  5]   1.00-2.00   sec   127 KBytes  1.04 Mbits/sec  90
[  5]   2.00-3.00   sec   129 KBytes  1.05 Mbits/sec  91
[  5]   3.00-4.00   sec   127 KBytes  1.04 Mbits/sec  90
[  5]   4.00-5.00   sec   129 KBytes  1.05 Mbits/sec  91
[  5]   5.00-6.00   sec   129 KBytes  1.05 Mbits/sec  91
[  5]   6.00-7.00   sec   127 KBytes  1.04 Mbits/sec  90
[  5]   7.00-8.00   sec   129 KBytes  1.05 Mbits/sec  91
[  5]   8.00-9.00   sec   127 KBytes  1.04 Mbits/sec  90
[  5]   9.00-10.00  sec   129 KBytes  1.05 Mbits/sec  91
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[  5]   0.00-10.00  sec  1.25 MBytes  1.05 Mbits/sec  0.000 ms  0/906 (0%)  sender
[  5]   0.00-10.04  sec  1.25 MBytes  1.05 Mbits/sec  0.513 ms  0/906 (0%)  receiver

iperf Done.
```

## Collecting the iPerf and PCAP results
To bundle and download the iPerf and PCAP results, the 'collect' option can be used:
```bash 
⇒ oc adm must-gather --image=quay.io/mwasher/must-gather-iperf-pcap -- collect
```

# Uninstall
To remove the pcap collectors and iPerf instances, the 'destroy' option should be used:
```bash 
⇒ oc adm must-gather --image=quay.io/mwasher/must-gather-iperf-pcap -- destroy
```
