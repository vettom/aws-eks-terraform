locals {
  azs                  = ["eu-west-1a", "eu-west-1b"]
  vpc_cidr             = "10.64.0.0/24"
  private_subnets      = ["10.64.0.0/26", "10.64.0.64/26"]
  public_subnets       = ["10.64.0.128/26", "10.64.0.192/26"]
  secondary_cidr_block = "10.100.0.0/16"
  pod_subnets          = ["10.100.0.0/19", "10.100.32.0/19"]
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
  }
}

# Create secondary CIDR once VPC is created
resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = module.vpc.vpc_id
  cidr_block = local.secondary_cidr_block
}


resource "aws_subnet" "podnet" {
  for_each = {
    for idx, az in local.azs :
    az => {
      cidr_block = local.pod_subnets[idx]
    }
  }
  vpc_id            = module.vpc.vpc_id
  availability_zone = each.key
  cidr_block        = each.value.cidr_block

  tags = {
    "Name"                            = "${module.vpc.name}-pod-subnet-${each.key}"
    "kubernetes.io/role/internal-elb" = "1" # Tag for internal LoadBalancer
    "kubernetes.io/role/cni"          = "1"
    "pod_subnet"                      = "true"
  }
  depends_on = [aws_vpc_ipv4_cidr_block_association.secondary_cidr] # Ensure VPC CIDR is created before subnets
}


resource "aws_route_table_association" "podnet-association" {
  for_each       = aws_subnet.podnet
  subnet_id      = each.value.id
  route_table_id = module.vpc.private_route_table_ids.0
}

