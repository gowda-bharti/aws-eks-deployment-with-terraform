# Creating IAM role for EKS nodes to work with other AWS Services. 
resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.worker_node.arn
  subnet_ids      = aws_subnet.device_api[*].id
  instance_types  = [var.instance_type]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.desired_size
    min_size     = 1
  }


  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    "Environment" = var.environment,
    "Cluster"     = var.cluster_name,
    "NodeGroup"   = "${var.cluster_name}-default-node-group",
  }
}
