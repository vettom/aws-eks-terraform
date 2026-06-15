module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.5"
  name    = "eks-demo-vpc"
  cidr    = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true
  azs                  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets      = ["10.0.0.0/22", "10.0.4.0/22", "10.0.8.0/22"]
  public_subnets       = ["10.0.128.0/22", "10.0.132.0/22", "10.0.136.0/22"]
  enable_nat_gateway   = true # Required as k8s hosts will be in private_subnet
  enable_vpn_gateway   = false
  single_nat_gateway   = true # NAT GW is required as nodes will be provisioned in private subnet

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1" # Tag for external LoadBalancer
    "subnet_type"            = "public"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1" # Tag for internal LoadBalancer
    "subnet_type"                     = "private"
    "karpenter.sh/discovery"          = "eks-demo"
  }
}
