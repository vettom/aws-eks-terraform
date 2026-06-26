data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
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
    name   = "tag:Name"
    values = var.private_subnet_tags
  }
}

# Get secondary subnets for EKS to use for pods
data "aws_subnets" "pod_subnets" {
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.this.id
    ]
  }

  filter {
    name   = "tag:Name"
    values = var.pod_subnet_tags
  }
}

data "aws_subnet" "pod_subnet" {
  for_each = toset(data.aws_subnets.pod_subnets.ids)
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
