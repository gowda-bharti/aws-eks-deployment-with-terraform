#!/usr/bin/env bash

## This script is used to drop all resources created by api deployment.

set -e

GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT/deploy/backend/device-api

# set variables for terraform.
source .envrc

# we need to remove elb to delete all vpc resources afterwards.
./set-kubeconfig.sh
kubectl delete -f service-elb.yml

terraform init;
terraform destroy -auto-approve;
