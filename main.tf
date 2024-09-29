provider "aws" {
  region = var.aws_region 
}

terraform {
  backend "s3" {}
}

# Grupo de Segurança
resource "aws_security_group" "eks_sg" {
  name        = "${var.cluster_name}-sg"
  vpc_id      = var.vpc_id

  # Regras de entrada
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regras de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Definição do cluster EKS
resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = var.aws_iam_role
  vpc_config {
    subnet_ids         = var.aws_subnets
    security_group_ids = [aws_security_group.eks_sg.id]
  }
}

# Definição do Node Group
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "my-nodes"
  node_role_arn   = var.aws_iam_role
  subnet_ids      = var.aws_subnets
  disk_size       = 50

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }

  depends_on = [aws_eks_cluster.cluster]

  launch_template {
    id      = aws_launch_template.eks_nodes_lt.id 
    version = aws_launch_template.eks_nodes_lt.latest_version
  }
}

# Launch Template para os Nodes
resource "aws_launch_template" "eks_nodes_lt" {
  name_prefix   = "${var.cluster_name}-node-group-lt-"
  image_id      = data.aws_ami.eks_ami.id # Certifique-se de ter essa AMI definida
  instance_type = "t3.nano"

  network_interfaces {
    security_groups = [aws_security_group.eks_sg.id]
  }
}

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