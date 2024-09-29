# Buscar a AMI mais recente para EKS
data "aws_ami" "eks_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Buscar Configs de rede da VPC
data "aws_vpc" "vpc" {
  cidr_block = "172.31.0.0/16"
}

data "aws_subnets" "subnets"{
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.vpc.id]
    }
}

data "aws_subnet" "subnet" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id       = each.value
}