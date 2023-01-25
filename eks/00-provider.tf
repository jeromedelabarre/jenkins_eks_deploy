# Configure the AWS Provider
provider "aws" {
  region = local.region
}


locals {
  EKS_CLUSTER_NAME	  = "eks-${var.MASTER_NAME}"
  local.K8s_VERSION   = var.K8s_VERSION
  region              = "eu-west-3"

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