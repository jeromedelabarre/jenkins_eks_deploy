variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

# S3 bucket for TF
variable "state_bucket"{
    default = "cley-eks-tfstate-bucket"
}

variable "state_key"{
    default = "cley-eks-cluster.tfstate"
}
