#!/usr/bin/env bash

# This script is used for getting k8s cluster info such as endpoint, credentials and dumps to kube config file that is
# populated configuration in terraform kubeconfig output.

mkdir -p ~/.kube/
terraform init
terraform output kubeconfig > ~/.kube/config
