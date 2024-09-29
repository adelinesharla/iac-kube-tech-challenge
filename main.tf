provider "aws" {
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

# Grupo de Segurança para os Nodes
resource "aws_security_group" "eks_nodes_sg" {
  name        = "${var.cluster_name}-nodes-sg"
  description = "Grupo de segurança para os nodes do cluster EKS"
  vpc_id      = var.vpc_id  # Certifique-se de que 'var.vpc_id' esteja definida

  # Regras de entrada
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true  # Permite comunicação entre os nodes do mesmo grupo de segurança
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfego HTTPS de entrada de qualquer lugar (ajuste conforme necessário)
  }

  # Regras de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfego de saída para qualquer lugar (ajuste conforme necessário)
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

  vpc_security_group_ids = [aws_security_group.eks_nodes_sg.id]
  
  depends_on = [aws_eks_cluster.cluster]
}