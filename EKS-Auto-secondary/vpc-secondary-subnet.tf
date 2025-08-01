
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
    "Name"                            = "${module.vpc.name}-pod-subnet${each.key}"
    "kubernetes.io/role/internal-elb" = "1" # Tag for internal LoadBalancer
    "kubernetes.io/role/cni"          = "1"
    "pod_subnet"                      = "true"
    "subnet_purpose"                  = "EKS_Cluster"
  }
  depends_on = [aws_vpc_ipv4_cidr_block_association.secondary_cidr] # Ensure VPC CIDR is created before subnets
}


resource "aws_route_table_association" "podnet-association" {
  for_each       = aws_subnet.podnet
  subnet_id      = each.value.id
  route_table_id = module.vpc.private_route_table_ids.0
}
