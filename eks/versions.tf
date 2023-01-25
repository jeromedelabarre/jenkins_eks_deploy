terraform {
  required_version = ">= 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.72"
    }

    tls = {
      source = "hashicorp/tls"
      version = "3.4.0"
    }
  }

  required_version = "~> 0.14"
}

