provider "aws" {
  region = "eu-north-1"
  allowed_account_ids = [
    "665357118005",
  ]
}

# ECR
resource "aws_ecr_repository" "api" {
  name = "api"
  force_delete = true
}

resource "aws_ecr_repository" "app" {
  name = "app"
  force_delete = true
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = "my-vpc-name"
  cidr = "10.0.0.0/16"

  azs             = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    "Terraform" = "true"
    "Environment" = "dev"
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 19.0"
  cluster_name    = "parkbee-cluster-v3"
  cluster_version = "1.28"
  subnet_ids         = module.vpc.private_subnets

  cluster_endpoint_public_access  = true
#  cluster_endpoint_public_access  = false

  tags = {
    Environment = "training"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id

  eks_managed_node_group_defaults = {
      instance_types = ["m5.large", "t3.large"]  # Update to available instance types
  }

  eks_managed_node_groups = {
    blue = {
      min_size     = 1
      max_size     = 10
      desired_size = 2  # Adjusting desired size for initial capacity

      instance_types = ["m5.large", "m5.xlarge"]  # More powerful and diversified
      capacity_type  = "ON_DEMAND"  # Ensuring stable capacity for this critical group
    }

    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      # Diversifying with a range of powerful instance types suitable for Spot usage
      instance_types = ["t3.xlarge", "t3a.xlarge", "m5.large", "m5.xlarge", "m5a.xlarge"]
      capacity_type  = "SPOT"
    }
  }
}

# EC2 bastion host

#resource "tls_private_key" "bastion_key" {
#  algorithm = "RSA"
#}
#
#resource "aws_key_pair" "bastion_key" {
#  key_name   = "bastion-key"  # Specify the key pair name
#  public_key = tls_private_key.bastion_key.public_key_openssh
#}
#
#
#resource "aws_instance" "bastion" {
#  ami           = "ami-000e50175c5f86214"  # Sample Amazon Linux 2 AMI ID
#  instance_type = "t2.micro"
#  subnet_id     = module.vpc.public_subnets[0]
#  key_name      = aws_key_pair.bastion_key.key_name
#  associate_public_ip_address = true
#}
