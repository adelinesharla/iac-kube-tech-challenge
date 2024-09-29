kubectl rollout status deployment/tech-challenge-phase-1-approvider "aws" {
  region = var.aws_region 
}

terraform {
  backend "s3" {}
}

# Definição do cluster EKS
resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = var.aws_iam_role
  vpc_config {
    subnet_ids         = var.aws_subnets
    endpoint_private_access = true
    endpoint_public_access = true
  }
}

# Definição do Node Group
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "my-nodes"
  node_role_arn   = var.aws_iam_role
  subnet_ids      = var.aws_subnets

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }

  instance_types = ["t3.nano"]

  depends_on = [aws_eks_cluster.cluster]
}