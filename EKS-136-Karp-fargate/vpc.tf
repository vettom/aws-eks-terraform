data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_id]
  }
}

# Get all subnets ID's from VPC
data "aws_subnets" "all" {
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.this.id
    ]
  }
}

# Get private subnets ID's from VPC
data "aws_subnets" "private" {
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.this.id
    ]
  }

  filter {
    name = "tag:Name"
    values = [
      "${var.vpc_id}-private-*"
    ]
  }
}

# Get secondary subnets for EKS to use for pods
data "aws_subnets" "podsubnets" {
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.this.id
    ]
  }

  filter {
    name = "tag:Name"
    values = [
      "${var.vpc_id}-podsubnet-*"
    ]
  }
}

data "aws_subnet" "podsubnet" {
  for_each = toset(data.aws_subnets.podsubnets.ids)
  id       = each.key
}

# Add tags for EKS, Karpenter, SG etc to identify correct subnets

resource "aws_ec2_tag" "subnet_internal_elb" {
  for_each = toset(data.aws_subnets.private.ids)

  resource_id = each.key

  key   = "kubernetes.io/role/internal-elb"
  value = "1"
}

# Make Karpenter Discovery key unique for each cluster. This will allow multiple clusters to use the same subnets without impacting.
resource "aws_ec2_tag" "subnet_karpenter_discovery" {
  for_each = toset(data.aws_subnets.private.ids)

  resource_id = each.key

  key   = "karpenter.sh/discovery/${module.eks.cluster_name}"
  value = "true"
}

resource "aws_ec2_tag" "subnet_karpenter_discovery_name" {
  for_each = toset(data.aws_subnets.private.ids)

  resource_id = each.key

  key   = "karpenter.sh/discovery"
  value = module.eks.cluster_name
}

