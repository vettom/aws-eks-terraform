locals {
  az        = [for k, v in aws_subnet.podnet : v.availability_zone]
  subnet_id = [for k, v in aws_subnet.podnet : v.id]
}

resource "helm_release" "vpc-cni" {
  name       = "aws-vpc-cni"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-vpc-cni"
  version    = "1.19.6"
  values = [
    <<-EOT
    env:
        AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG: "true"
        ENABLE_POD_ENI: "true"
        ENABLE_PREFIX_DELEGATION: "true"
        ENABLE_SUBNET_DISCOVERY: "true"  
    eniConfig:
        # Specifies whether ENIConfigs should be created
        create: true
        region: "${data.aws_region.current.region}"
        subnets:
            "${local.az[0]}":
                id: "${local.subnet_id[0]}"
                securityGroups:
                    - "${module.eks.node_security_group_id}"
            "${local.az[1]}":
                id: "${local.subnet_id[1]}"
                securityGroups:
                    - "${module.eks.node_security_group_id}"
            "${local.az[2]}":
                id: "${local.subnet_id[2]}"
                securityGroups:
                    - "${module.eks.node_security_group_id}"                                        
    EOT
  ]
}
