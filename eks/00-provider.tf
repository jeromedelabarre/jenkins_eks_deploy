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


data "terraform_remote_state" "network_state" {
  backend = "s3"
  config= {
    bucket = "${var.state_bucket}"
    region = "${var.state_region}"
    key    = "${var.state_key}"
  }
}