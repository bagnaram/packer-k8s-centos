# packer-k8s-centos

Creation of Kubernetes base infrastructure image.

The goal of this page is to create a base image that may be used to bootstrap a Kubernetes cluster based on Centos.

## Prerequisites

* Access to AWS
  * Access to source Centos AMI
* Linux Machine:
  * `packer` https://www.packer.io/

## Install Packer
Packer provides a templated ability to produce reproducable machine images. 

Download the Packer binary from Hashicorp.

## AWS
###  Prepare infrastructure for AWS

The `centos_build.json` file contains a defination of what the Amazon AMI should be. There are a number of parameters which need to be modified to match your build enviornment.

1. `region`: The AWS region containing the source AMI
2. `source_ami`: The source AMI ID which will be used as a base.
3. `instance_type`: The Amazon instance type.

### Begin Packer Build

Source the AWS credentials that you obtain from the console:
```
export AWS_SESSION_TOKEN=
export AWS_SECRET_ACCESS_KEY=
export AWS_ACCESS_KEY_ID=
```

Simply initiate the Packer build below:
```
packer build -only=amazon-ebs centos_build.json
```

###  Prepare infrastructure for VSphere

The `centos_build.json` file contains a defination of what the source ISO should be. There are a number of parameters which need to be modified to match your build enviornment.
1. `vcenter_server`: the IP of the vcenter server
2. `username`: VSphere credentials
3. `password`: VSphere credentials
4. `datacenter`: VSphere DC
5. `host`: ESX host
6. `cluster`: VSphere cluster name 
7. `datastore` 
8. `network`: Defaults to "VM Network"
9. `network_card`: Leave as vmxnet3
### Begin Packer Build

Simply initiate the Packer build below:
```
packer build -only=vsphere-iso centos_build.json
```