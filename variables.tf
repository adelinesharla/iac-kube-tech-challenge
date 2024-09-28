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
