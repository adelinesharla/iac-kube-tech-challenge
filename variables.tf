variable "aws_region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "meu-cluster-eks"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}