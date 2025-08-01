module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.0.6"

  name               = "eks-auto-demo"
  kubernetes_version = "1.33"

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = {
    Environment = "dev"
    Terraform   = "true"
    Owner       = "D Vettom"
  }
}
