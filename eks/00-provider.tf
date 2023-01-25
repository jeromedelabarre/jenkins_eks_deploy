# Configure the AWS Provider
provider "aws" {
  region = ${var.state_region}
}

data "terraform_remote_state" "network_state" {
  backend = "s3"
  config= {
    bucket = "${var.state_bucket}"
    region = "${var.state_region}"
    key    = "${var.state_key}"
  }
}