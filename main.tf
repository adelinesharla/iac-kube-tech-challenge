provider "aws" {
  region = var.aws_region 
}

resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id
}

resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = var.aws_iam_role
  vpc_config {
    subnet_ids         = var.aws_subnets
    endpoint_private_access = true
    endpoint_public_access = true
  }
}