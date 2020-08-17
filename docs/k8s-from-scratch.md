# K8s From Scratch

## Provision Machines

### Machine Assignment

* 3 GlusterFS Nodes (Distributed File Store)
* 3 ETCD Nodes (kubelet managed)
* 3 K8s Master Nodes
* 3 K8s Worker Nodes
* 1 K8s Control Plane Proxy

### OS Setup

* Ubuntu 18.04
* Configure User
* Generate and Install SSH Key
* Configure sudo
* Configure Network
* Apply OS customizations
  * Remove Floppy
  * Setup Swap
  * Setup IP Tables
  * Setup VM Tools
  * Setup Tmp

### Secondary Disk Setup

* Add secondary Disks (GlusterFS Nodes)

## Software Installations

### Package Installs (all hosts)

* Package Install
  * git
  * curl
  * wget
  * vim
  * jq
  * apt-transport-https
  * ca-certificates
  * curl
  * gnupg-agent
  * software-properties-common

### Docker (all hosts)

* Install Python libraries
  * docker
  * jsondiff
  * PyYAML
* Docker docker-compose install
* Docker Install

### K8s Base (all hosts)

* Update IP Tables
* K8s Repo
* Docker Daemon Customizations
* Install kubelet, kubeadm, kubectl
* Lock installed versions of kubelet, kubeadm, kubectl

### GlusterFS (glusterfs nodes)

* Package Install
  * xfsprogs
  * attr
  * glusterfs-server
  * glusterfs-common
  * glusterfs-client
  * nfs-common
  * thin-provisioning-tools
* Create symlink for LVM
* Enable/start Gluster service

### Heketi (glusterfs nodes)

* Install Heketi CLI
* Create XFS File System on Disk 1
* Create Gluster Volume for Heketi Database
* Secure Gluster Volume
* Mount Gluster Volume
* Create SSH Keys for Heketi POD to access Gluster via SSH

### HAProxy (Control Plane Proxy)

* Install HAProxy
* Create or Assign Certs
* Create HAProxy config file
* Enable/start HAProxy service

### ETCD (ETCD Nodes)

* Create systemd service for ETCD kublet
* Generate ETC certs on Primary Node
* Copy ETCD certs to all ETCD Secondary nodes
* Create pod manifest named kubeadmcfg.yaml for each ETCD node
* Init ETCD via pod manifest through kubeadm on each ETCD node
* Run tests for ETCD cluster

### Initialize K8s Masters and Workers

* Get ETCD certs and copy to Node
* Create pod manifest named kubeadmcfg.yaml on first master node
* Initialize Control Plane via pod manifest through kubeadm on first master node
* Configure Cluster Networking with Calico on first master node
* Set Default Network Policy on first master node
* Generate discovery.yaml on first master node
* Copy discovery.yaml to all remaining master and all worker nodes
* Create pod manifest named kubeadmcfg.yaml on all remaining master nodes
* Join node as Master via pod manifest through kubeadm on all remaining master nodes
* Create pod manifest named kubeadmcfg.yaml on all worker nodes
* Join node as Worker via pod manifest through kubeadm on all worker nodes
* Install Calicoctl on all Master and Worker nodes
* Update Local User ~/.kube config on all Master and Worker nodes

## Networking and External Access

### Setup Ingres Controller

## Storage

### Setup Default Storage Class

## Policies

### Setup Network Default Policy

### Setup Quotas and Limits

### Setup Descheduler

## Utilities

### Web Dashboard

### Docker Secure Registry

## Testing K8s

* Create Simple Service
* Verify POD
* Verify Service
* Verify PV and PVC
* Verify Gluster
* Verify Internal Access
* Verify External Access (via NodePort)
* Verify External Access (via IP Route)
* Verify External Access (via L7 Route)
