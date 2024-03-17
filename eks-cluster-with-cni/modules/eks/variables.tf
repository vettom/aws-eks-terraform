variable "cluster_name" {
  type        = string
  description = "Name for Eks cluster"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes cluster version"
}

variable "region" {
  type        = string
  description = "Region in which cluster is deployed"
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

variable "shared_account_id" {
  type        = string
  description = "AWS account ID for shared services"
}
