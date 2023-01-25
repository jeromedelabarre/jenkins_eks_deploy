# Configure the AWS Provider
provider "aws" {
  region = local.region
}


locals {
  EKS_CLUSTER_NAME	  = "eks-${var.MASTER_NAME}"
  K8s_VERSION         = var.K8s_VERSION
  region              = var.state_region

  tags = {
    Name    = local.name
  }
}

backend "s3" {
    bucket = var.state_bucket
    region = var.state_region
    key    = local.region
}