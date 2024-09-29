variable "aws_region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "meu-cluster-eks"
}

variable "vpc_cidr_block" {
  default = ["172.31.0.0/16"]
}

variable "aws_iam_role" {
  default = "arn:aws:iam::717145188069:role/LabRole"
}

variable "accessConfig" {
  default = "API_AND_CONFIG_MAP"
}

variable "node_name" {
  default = "my-nodes"
}

variable "principalArn" {
  default = "arn:aws:iam::717145188069:role/voclabs"
}

variable "policyArn" {
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}