
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"
  name    = "eks-demo-vpc"
  cidr    = local.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true
  azs                  = local.azs
  private_subnets      = local.private_subnets
  public_subnets       = local.public_subnets
  enable_nat_gateway   = true # Required as k8s hosts will be in private_subnet
  enable_vpn_gateway   = false
  single_nat_gateway   = true # NAT GW is required as nodes will be provisioned in private subnet


  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1" # Tag for external LoadBalancer
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1" # Tag for internal LoadBalancer
    "subnet_type"                     = "private"
    "subnet_purpose"                  = "EKS_Cluster"
  }
}
