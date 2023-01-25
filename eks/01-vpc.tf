# Generate Random String
resource "random_id" "suffix" {
  byte_length = 5
}

data "aws_availability_zones" "available" {}

locals {
  EKS_CLUSTER_NAME	= "eks-${var.MASTER_NAME}"
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.66.0"

  name                 = "vpc-${var.MASTER_NAME}-${random_id.suffix.hex}"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.EKS_CLUSTER_NAME}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.EKS_CLUSTER_NAME}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.EKS_CLUSTER_NAME}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
