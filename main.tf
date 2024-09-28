provider "aws" {
  region = var.aws_region 
}

resource "aws_vpc" "main" {
  id = var.vpc_id
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "public" {
  count             = length(var.availability_zones)
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone = var.availability_zones[count.index]
}

resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id
}

resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = var.aws_iam_role
  vpc_config {
    subnet_ids         = [for subnet in aws_subnet.public : subnet.id]
    endpoint_private_access = true
    endpoint_public_access = true
  }
}