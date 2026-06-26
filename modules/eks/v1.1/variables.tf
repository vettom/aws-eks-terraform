variable "cluster_name" {
  type        = string
  description = "Name for Eks cluster"
}

variable "environment" {
  type        = string
  description = "Environment variale [dev,ppd,prd]"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes cluster version"
}

variable "vpc_id" {
  type        = string
  description = "ID of VPC where cluster will be deployed"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets for EKS cluster deployment"
}

variable "node_instance_type" {
  type        = list(string)
  description = "List of instance types associated with the EKS Node Group."
}

variable "node_capacity_type" {
  type        = string
  description = "Node capacity type (ON_DEMAND, SPOT)"
}

variable "nodegroup_min_size" {
  type        = number
  description = "Minimum number of nodes to provision"
  default     = 1
}

variable "nodegroup_max_size" {
  type        = number
  description = "Maximum number of nodes to provision"
}

variable "nodegroup_desired_size" {
  type        = number
  description = "Desired number of nodes to provision"
}

variable "nodegroup_volume_size" {
  type        = number
  description = "Volume size for the data disk on provisioned nodes"
  default     = 50
}

variable "buildversion" {
  type        = string
  description = "Used to trigger tf build no other use" #
  default     = "1.0.0"
}

variable "cni_addon_version" {
  type        = string
  description = "VPC CLI Driver version to install"
}

variable "pod_identity_addon_version" {
  type        = string
  description = "Pod Identity addon version"
}

variable "kube_proxy_addon_version" {
  type        = string
  description = "Kube proxy addon version"
}

variable "coredns_addon_version" {
  type        = string
  description = "CoreDNS addon version"
}

variable "sso_role_prefix" {
  type        = string
  description = "Name of SSO role (name upto _ ) used by SRE DevOps."
  default     = "AWSReservedSSO_BauerRadioDevOps"
}

variable "enable_cluster_admin" {
  type        = bool
  default     = false
  description = "If true devops role will get admin privilege on EKS cluster"
}
