## (in development)

# Ansible Kubernetes Playbook for vSphere

## Environment Setup

**Generate SSH Keys for Remote Hosts**

```bash
# use ssh keygen script
./ssh_key_gen.sh

# or copy existing id_rsa and id_rsa.pub to .ssh folder of this repository
```

**Initialize Configuration File**

The configuration file found in `config.ini_sample` should be copied to
`config.ini` and then updated to match your environment.

_**Note:** The VMWare network that is chosen must have access to the internet._

## Playbook Execution

To run the playbook, Ansible must be installed on your admin workstation. If
you not have Ansible installed, but have docker running locally, see my
[ansible-docker](https://github.com/nmarus/ansible-docker) repository for a
quick way to get up and running.

When your Ansible environment is ready, run the following to initiate the
playbook:

```bash
# Prepare Base Image used to create Machines on vSphere
ansible-playbook provision-image.yml

# Prepare Virtual Machines on vSphere
ansible-playbook provision-vmw.yml

# Suggested to snapshot environment before continuing
ansible-playbook provision-vmw.yml --tags vmw-snapshot-create

# Install k8s environment
ansible-playbook provision-k8s.yml
```

### Optional Playbooks

#### Ingresses:

_**Note:** Only deploy one of the ingresses below._

```bash
# haproxy layer7 ingress and ssl offload
# listens on port 80 (redirect) and 443 of all nodes (host networking)
# deployed as DaemonSet
ansible-playbook provision-k8s.yml --tags k8s-ingress-haproxy

# nginx layer7 ingress and ssl offload
# listens on port 80 (redirect) and 443 of all nodes (host networking)
# deployed as DaemonSet
ansible-playbook provision-k8s.yml --tags k8s-ingress-nginx

# traefik layer7 ingress and ssl offload (traefik.example.com)
# listens on port 80 (redirect) and 443 of virtual ip
# deployed as Service/Deployment with Horizontal Pod Autoscaling
# does NOT currently support Service Topology routing
ansible-playbook provision-k8s.yml --tags k8s-ingress-traefik
```

#### Others:

```bash
# descheduler cronjob
ansible-playbook provision-k8s.yml --tags k8s-descheduler

# quotas for default namespace
ansible-playbook provision-k8s.yml --tags k8s-quotalimit

# install docker registry (registry.example.com)
ansible-playbook provision-k8s.yml --tags k8s-registry

# install k8s web dashboard (dashboard.example.com)
ansible-playbook provision-k8s.yml --tags k8s-dashboard

# install portainer web dashboard for k8s (portainer.example.com)
ansible-playbook provision-k8s.yml --tags k8s-portainer
```

## Admin Setup

**Install kubectl for your local Linux Distribution**

```bash
# apt based systems
apt-get install -yq kubectl

# homebrew based systems (OSX)
homebrew install kubectl
```

**Create kube Config to Connect to Cluster**

```bash
# create $HOME/.kube configuration for provisioned setup
ansible-playbook provision-k8s.yml --tags local-kube-config

# or
scp -r ubuntu@10.100.100.31:/home/ubuntu/.kube ~/
```

## License

The MIT License (MIT)

Copyright (c) 2020

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
