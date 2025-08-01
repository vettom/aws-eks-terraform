
locals {
  azs                  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  vpc_cidr             = "10.0.0.0/24"
  private_subnets      = ["10.0.0.0/27", "10.0.0.32/27", "10.0.0.64/27"]
  public_subnets       = ["10.0.0.128/27", "10.0.0.160/27", "10.0.0.192/27"]
  secondary_cidr_block = "100.0.0.0/16"
  pod_subnets          = ["100.0.0.0/19", "100.0.32.0/19", "100.0.64.0/19"]
}


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
