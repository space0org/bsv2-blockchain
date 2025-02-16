terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC and Networking
resource "aws_vpc" "bsv2_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "bsv2-vpc"
  }
}

resource "aws_subnet" "bsv2_subnet" {
  vpc_id     = aws_vpc.bsv2_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "bsv2-subnet"
  }
}

# Security Group
resource "aws_security_group" "bsv2_nodes" {
  name        = "bsv2-nodes"
  description = "Security group for BSV2 blockchain nodes"
  vpc_id      = aws_vpc.bsv2_vpc.id

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 18443
    to_port     = 18443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 18543
    to_port     = 18543
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bsv2-nodes-sg"
  }
}

# EC2 Instances
resource "aws_instance" "bsv2_node" {
  count         = 3
  ami           = var.ami_id
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.bsv2_subnet.id

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }

  vpc_security_group_ids = [aws_security_group.bsv2_nodes.id]

  tags = {
    Name = "bsv2-node-${count.index + 1}"
  }
}

# Elastic IPs
resource "aws_eip" "bsv2_eip" {
  count    = 3
  instance = aws_instance.bsv2_node[count.index].id
  vpc      = true

  tags = {
    Name = "bsv2-eip-${count.index + 1}"
  }
}
