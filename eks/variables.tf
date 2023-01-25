### Define AWS variables and EKS Cluster settings

# AWS 

variable "state_bucket"{
    default = "cley-eks-tfstate-bucket"
}

variable "state_key"{
    default = "cley-eks-cluster.tfstate"
}

variable "state_region"{
    default = "eu-west-3"
}

# MASTER NAME
variable "MASTER_NAME" {
	default		= "cley"
	description	= "Master Name to name Cluster, VPC, SG...."
}

variable "K8s_VERSION" {
	default		= "1.23"
	description	= "Kubernetes version deployed"
}

variable "INSTANCE_TYPE" {
	default		= "m1.small"
	description	= "Size of the instance deployed for worker nodes"
}

variable "MIN_WORKER_NODE" {
	default		= "1"
	description	= "Minimum worker node(s) created"
}

variable "MAX_WORKER_NODE" {
        default         = "1"
        description     = "Maximum worker node(s) created"
}

variable "DESIRED_WORKER_NODE" {
        default         = "1"
        description     = "Desired worker node(s) created"
}

