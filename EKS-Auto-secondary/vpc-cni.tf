resource "helm_release" "vpc-cni" {
  name       = "aws-vpc-cni"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-vpc-cni"
  version    = "1.19.6"
  values = [
    yamlencode({
      env = {
        AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG = "true"
        ENABLE_POD_ENI                     = "true"
        ENABLE_PREFIX_DELEGATION           = "true"
        ENABLE_SUBNET_DISCOVERY            = "true"
      }
      eniConfig = {
        create = true
        region = data.aws_region.current.region
        subnets = {
          for az, subnet in aws_subnet.podnet : az => {
            id             = subnet.id
            securityGroups = [module.eks.node_security_group_id]
          }
        }
      }
    })
  ]
}
