module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${local.EKS_CLUSTER_NAME}-${random_id.suffix.hex}"
  cluster_version = local.K8s_VERSION
  

  tags = {
    Environment = var.MASTER_NAME
  }

  vpc_id          = module.vpc.vpc_id
  subnets_ids     = module.vpc.private_subnets_ids
  worker_groups = [
    {
      name                          = "${local.EKS_CLUSTER_NAME}-worker-group-1"
      instance_type                 = var.INSTANCE_TYPE
      asg_min_size		              = var.MIN_WORKER_NODE
      asg_max_size		              = var.MAX_WORKER_NODE
      asg_desired_capacity          = var.DESIRED_WORKER_NODE
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
