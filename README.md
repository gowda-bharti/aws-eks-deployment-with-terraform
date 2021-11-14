## Making deployment to AWS EKS with terraform

This repo illustrates how to make a deployment to AWS EKS (Elastic Kubernetes Service) with using terraform.   

* [Set variables for terraform](#set-variables)
* [Deploy](#deploy)
* [Terraform Plan](#terraform-plan-to-be-applied)
* [Destroy](#destroy)
* [Test deployment](#test-deployment)

## Set Variables
- You can set all variables in _".envrc"_ file before executing the deployment script.
- Since terraform uses env variables in TF_VAR_name format you should follow this convention. (ref: https://www.terraform.io/docs/cli/config/environment-variables.html#tf_var_name)

## Deploy
After all variables are set then we are ready to go and complete deployment by provisioning all resources
such as network, load balancing, cluster, iam roles for nodes...
- VPC resources including:
  - VPC
  - Subnets
  - Internet Gateway
  - Route Table
- iam roles and policies for worker nodes and cluster to work with other AWS services.
- AWS EKS Cluster
- namespace and will do api and service deployments under this namespace.
  This helps to manage deployments separately from the others in the same cluster.
- loadbalancer service to ingress from inbound network.
```shell
./deploy.sh
```

## Terraform Plan to be applied
``` terraform
data.aws_region.current: Refreshing state...
data.aws_availability_zones.available: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_eks_cluster.cluster will be created
  + resource "aws_eks_cluster" "cluster" {
      + arn                   = (known after apply)
      + certificate_authority = (known after apply)
      + created_at            = (known after apply)
      + endpoint              = (known after apply)
      + id                    = (known after apply)
      + identity              = (known after apply)
      + name                  = "device-api-cluster"
      + platform_version      = (known after apply)
      + role_arn              = (known after apply)
      + status                = (known after apply)
      + tags                  = {
          + "Cluster"     = "device-api-cluster"
          + "Environment" = "staging"
        }
      + tags_all              = {
          + "Cluster"     = "device-api-cluster"
          + "Environment" = "staging"
        }
      + version               = (known after apply)

      + kubernetes_network_config {
          + service_ipv4_cidr = (known after apply)
        }

      + vpc_config {
          + cluster_security_group_id = (known after apply)
          + endpoint_private_access   = false
          + endpoint_public_access    = true
          + public_access_cidrs       = (known after apply)
          + security_group_ids        = (known after apply)
          + subnet_ids                = (known after apply)
          + vpc_id                    = (known after apply)
        }
    }

  # aws_eks_node_group.node will be created
  + resource "aws_eks_node_group" "node" {
      + ami_type               = (known after apply)
      + arn                    = (known after apply)
      + capacity_type          = (known after apply)
      + cluster_name           = "device-api-cluster"
      + disk_size              = (known after apply)
      + id                     = (known after apply)
      + instance_types         = [
          + "t2.small",
        ]
      + node_group_name        = "device-api-cluster-node-group"
      + node_group_name_prefix = (known after apply)
      + node_role_arn          = (known after apply)
      + release_version        = (known after apply)
      + resources              = (known after apply)
      + status                 = (known after apply)
      + subnet_ids             = (known after apply)
      + tags                   = {
          + "Cluster"     = "device-api-cluster"
          + "Environment" = "staging"
          + "NodeGroup"   = "device-api-cluster-default-node-group"
        }
      + tags_all               = {
          + "Cluster"     = "device-api-cluster"
          + "Environment" = "staging"
          + "NodeGroup"   = "device-api-cluster-default-node-group"
        }
      + version                = (known after apply)

      + scaling_config {
          + desired_size = 2
          + max_size     = 2
          + min_size     = 1
        }

      + update_config {
          + max_unavailable            = (known after apply)
          + max_unavailable_percentage = (known after apply)
        }
    }

  # aws_iam_role.device_api will be created
  + resource "aws_iam_role" "device_api" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "eks.amazonaws.com"
                        }
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "device-api-cluster-iam-role"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags                  = {
          + "Cluster"     = "device-api-cluster"
          + "Environment" = "staging"
        }
      + tags_all              = {
          + "Cluster"     = "device-api-cluster"
          + "Environment" = "staging"
        }
      + unique_id             = (known after apply)

      + inline_policy {
          + name   = (known after apply)
          + policy = (known after apply)
        }
    }

  # aws_iam_role.worker_node will be created
  + resource "aws_iam_role" "worker_node" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "ec2.amazonaws.com"
                        }
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "device-api-cluster-worker-node-iam-role"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags                  = {
          + "Cluster"     = "device-api-cluster"
          + "Environment" = "staging"
        }
      + tags_all              = {
          + "Cluster"     = "device-api-cluster"
          + "Environment" = "staging"
        }
      + unique_id             = (known after apply)

      + inline_policy {
          + name   = (known after apply)
          + policy = (known after apply)
        }
    }

  # aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly will be created
  + resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      + role       = "device-api-cluster-worker-node-iam-role"
    }

  # aws_iam_role_policy_attachment.AmazonEKSClusterPolicy will be created
  + resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
      + role       = "device-api-cluster-iam-role"
    }

  # aws_iam_role_policy_attachment.AmazonEKSServicePolicy will be created
  + resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
      + role       = "device-api-cluster-iam-role"
    }

  # aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy will be created
  + resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
      + role       = "device-api-cluster-worker-node-iam-role"
    }

  # aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy will be created
  + resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      + role       = "device-api-cluster-worker-node-iam-role"
    }

  # aws_internet_gateway.device_api will be created
  + resource "aws_internet_gateway" "device_api" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags     = {
          + "Cluster"     = "device-api-cluster"
          + "Environment" = "staging"
        }
      + tags_all = {
          + "Cluster"     = "device-api-cluster"
          + "Environment" = "staging"
        }
      + vpc_id   = (known after apply)
    }

  # aws_route_table.device_api will be created
  + resource "aws_route_table" "device_api" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + carrier_gateway_id         = ""
              + cidr_block                 = "0.0.0.0/0"
              + destination_prefix_list_id = ""
              + egress_only_gateway_id     = ""
              + gateway_id                 = (known after apply)
              + instance_id                = ""
              + ipv6_cidr_block            = ""
              + local_gateway_id           = ""
              + nat_gateway_id             = ""
              + network_interface_id       = ""
              + transit_gateway_id         = ""
              + vpc_endpoint_id            = ""
              + vpc_peering_connection_id  = ""
            },
        ]
      + tags             = {
          + "Cluster"     = "device-api-cluster"
          + "Environment" = "staging"
        }
      + tags_all         = {
          + "Cluster"     = "device-api-cluster"
          + "Environment" = "staging"
        }
      + vpc_id           = (known after apply)
    }

  # aws_route_table_association.device_api[0] will be created
  + resource "aws_route_table_association" "device_api" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # aws_route_table_association.device_api[1] will be created
  + resource "aws_route_table_association" "device_api" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # aws_route_table_association.device_api[2] will be created
  + resource "aws_route_table_association" "device_api" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # aws_security_group.sg will be created
  + resource "aws_security_group" "sg" {
      + arn                    = (known after apply)
      + description            = "Cluster communication with worker nodes"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "HTTP from VPC"
              + from_port        = 8080
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8080
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "TLS from VPC"
              + from_port        = 443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 443
            },
        ]
      + name                   = "terraform-eks-admin_backend"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Cluster"     = "device-api-cluster"
          + "Environment" = "staging"
        }
      + tags_all               = {
          + "Cluster"     = "device-api-cluster"
          + "Environment" = "staging"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_subnet.device_api[0] will be created
  + resource "aws_subnet" "device_api" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-west-2a"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "10.0.0.0/24"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = true
      + owner_id                        = (known after apply)
      + tags                            = {
          + "Cluster"                                  = "device-api-cluster"
          + "Environment"                              = "staging"
          + "kubernetes.io/cluster/device-api-cluster" = "shared"
        }
      + tags_all                        = {
          + "Cluster"                                  = "device-api-cluster"
          + "Environment"                              = "staging"
          + "kubernetes.io/cluster/device-api-cluster" = "shared"
        }
      + vpc_id                          = (known after apply)
    }

  # aws_subnet.device_api[1] will be created
  + resource "aws_subnet" "device_api" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-west-2b"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "10.0.1.0/24"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = true
      + owner_id                        = (known after apply)
      + tags                            = {
          + "Cluster"                                  = "device-api-cluster"
          + "Environment"                              = "staging"
          + "kubernetes.io/cluster/device-api-cluster" = "shared"
        }
      + tags_all                        = {
          + "Cluster"                                  = "device-api-cluster"
          + "Environment"                              = "staging"
          + "kubernetes.io/cluster/device-api-cluster" = "shared"
        }
      + vpc_id                          = (known after apply)
    }

  # aws_subnet.device_api[2] will be created
  + resource "aws_subnet" "device_api" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-west-2c"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "10.0.2.0/24"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = true
      + owner_id                        = (known after apply)
      + tags                            = {
          + "Cluster"                                  = "device-api-cluster"
          + "Environment"                              = "staging"
          + "kubernetes.io/cluster/device-api-cluster" = "shared"
        }
      + tags_all                        = {
          + "Cluster"                                  = "device-api-cluster"
          + "Environment"                              = "staging"
          + "kubernetes.io/cluster/device-api-cluster" = "shared"
        }
      + vpc_id                          = (known after apply)
    }

  # aws_vpc.device_api will be created
  + resource "aws_vpc" "device_api" {
      + arn                              = (known after apply)
      + assign_generated_ipv6_cidr_block = false
      + cidr_block                       = "10.0.0.0/16"
      + default_network_acl_id           = (known after apply)
      + default_route_table_id           = (known after apply)
      + default_security_group_id        = (known after apply)
      + dhcp_options_id                  = (known after apply)
      + enable_classiclink               = (known after apply)
      + enable_classiclink_dns_support   = (known after apply)
      + enable_dns_hostnames             = (known after apply)
      + enable_dns_support               = true
      + id                               = (known after apply)
      + instance_tenancy                 = "default"
      + ipv6_association_id              = (known after apply)
      + ipv6_cidr_block                  = (known after apply)
      + main_route_table_id              = (known after apply)
      + owner_id                         = (known after apply)
      + tags                             = {
          + "Cluster"                                  = "device-api-cluster"
          + "Environment"                              = "staging"
          + "kubernetes.io/cluster/device-api-cluster" = "shared"
        }
      + tags_all                         = {
          + "Cluster"                                  = "device-api-cluster"
          + "Environment"                              = "staging"
          + "kubernetes.io/cluster/device-api-cluster" = "shared"
        }
    }

Plan: 19 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

This plan was saved to: out.tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "out.tfplan"
```

## Destroy
Destroy script basically destroys all resources managed in this terraform configuration. <br>
**NOTE** We need to remove load balancer service at first otherwise AWS will not let us remove VPC resources.
```shell
./destroy.sh
```

## Test deployment
- At first, we need to get AWS ELB address to access containers running in pods.
- Let's have a look at the "backend-api-service" service under mvs namespace:

```shell
kubectl describe service backend-api-service -n mvs

Name:                     backend-api-service
...
LoadBalancer Ingress:     a17da47d5075e4b62809ac95b2e56b14-353037627.eu-west-2.elb.amazonaws.com
Port:                     <unset>  80/TCP
TargetPort:               8080/TCP
```

### Request example
```shell
curl --location --request POST 'http://a17da47d5075e4b62809ac95b2e56b14-353037627.eu-west-2.elb.amazonaws.com/api/v1/device' \
--header 'Content-Type: application/json' \
--data-raw '{
   "name" : "Iphone",
    "brand": "Apple",
    "model": "13 Pro Max"
}'
```

### Response
```shell
{
    "id": "7dff9b80-1884-476a-bf01-1fbdcc6fcccf",
    "name": "Iphone",
    "brand": "Apple",
    "model": "13 Pro Max"
}
```