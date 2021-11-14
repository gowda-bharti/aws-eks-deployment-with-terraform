#!/usr/bin/env bash

# End the script immediately if any command or pipe exits with a non-zero status.
set -eox pipefail

GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT/deploy/backend/device-api

# set variables for terraform.
source .envrc

terraform init;
terraform plan \
  -out out.tfplan;
terraform apply -auto-approve out.tfplan;


# set ~/.kube/config to connect and manages k8s cluster with kubectl.
./set-kubeconfig.sh

# if namespace already exists then ignore to avoid pipeline to be failed.
kubectl create namespace mvs --dry-run=client -o yaml | kubectl apply -f -

# make api-deployment to cluster.
kubectl apply -f api-deployment.yml

# create a load balancer ingress with a load balancer service
kubectl apply -f service-elb.yml
