variable "aws_region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "meu-cluster-eks"
}

variable "vpc_cidr_block" {
  default = ["172.31.0.0/16"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_id" {
  default = "vpc-003fdd4eb65bd0b81"
}

variable "aws_iam_role" {
  default = "arn:aws:iam::717145188069:role/LabRole"
}

variable "aws_subnets" {
  default = ["subnet-0d1e9a9d216eb7f65", "subnet-06535282ea2be01c9", "subnet-05d6d1c8f40bec41f"]