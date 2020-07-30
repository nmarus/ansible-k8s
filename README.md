## (in development)

# Ansible Kubernetes Playbook (with optional vSphere Deployment)

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
# Prepare Virtual Machines on vSphere (optional)
ansible-playbook provision-vmw.yml

# Suggested to snapshot environment before continuing
ansible-playbook provision-vmw.yml --tags vmw-snapshot-create

# Install k8s environment
#(requires hosts and ssh setup to be complete if not using provision-vmw)
ansible-playbook provision-k8s.yml
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
