locals {
  cluster_name                             = "eks-demo"
  kubernetes_version                       = "1.35"
  vpc_name                                 = "eks-demo-vpc"
  private_subnet_tags                      = ["${local.vpc_name}-private-*"]
  pod_subnet_tags                          = ["${local.vpc_name}-podsubnet-*"]
  enable_cluster_creator_admin_permissions = true
  enable_endpoint_public_access            = true
  endpoint_public_access_cidrs             = ["0.0.0.0/0"]
  vpc_cni_version                          = "v1.22.2-eksbuild.1"
  eks_pod_identity_agent_addon_version     = "v1.3.10-eksbuild.3"
  kube_proxy_version                       = "v1.35.3-eksbuild.13"
  coredns_version                          = "v1.14.3-eksbuild.3"
}

module "eks" {
  source                                   = "./module/eks"
  cluster_name                             = local.cluster_name
  kubernetes_version                       = local.kubernetes_version
  vpc_name                                 = local.vpc_name
  private_subnet_tags                      = local.private_subnet_tags
  pod_subnet_tags                          = local.pod_subnet_tags
  enable_cluster_creator_admin_permissions = local.enable_cluster_creator_admin_permissions
  enable_endpoint_public_access            = local.enable_endpoint_public_access
  endpoint_public_access_cidrs             = local.endpoint_public_access_cidrs
  vpc_cni_version                          = local.vpc_cni_version
  eks_pod_identity_agent_addon_version     = local.eks_pod_identity_agent_addon_version
  kube_proxy_version                       = local.kube_proxy_version
  coredns_version                          = local.coredns_version
}
