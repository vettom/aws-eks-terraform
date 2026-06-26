variable "vpc_name" {
  type        = string
  description = "Name of the VPC  in full"
}

variable "private_subnet_tags" {
  type        = list(string)
  description = "Wildcard private subnet name eg [vpc-name-private-*]"
  default     = ["*-private-*"]
}

variable "pod_subnet_tags" {
  type        = list(string)
  description = "Wildcard pod subnet name eg [vpc-name-podsubnet-*]"
  default     = ["*-podsubnet-*"]
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "kubernetes_version" {
  type        = string
  description = "Version of Kubernetes to use"
}

# variable "kms_key_administrators" {
#   type        = list(string)
#   description = "List of KMS key administrators"
#   default     = [""]
# }

variable "enable_cluster_creator_admin_permissions" {
  type        = bool
  description = "Enable cluster creator admin permissions"
  default     = false
}

variable "enable_endpoint_public_access" {
  type        = bool
  description = "Enable public access to the EKS cluster"
  default     = false
}

variable "endpoint_public_access_cidrs" {
  type        = list(string)
  description = "List of CIDRs to allow public access to the EKS cluster"
  default     = ["0.0.0.0/0"]
}

variable "cloudwatch_enabled_log_types" {
  type        = list(string)
  description = "List of log types to enable. Options are 'api', 'audit', 'authenticator', 'controllerManager', 'scheduler', 'all'. Default is []."
  default     = []
}

variable "cloudwatch_log_group_retention_in_days" {
  type        = number
  description = "Number of days to retain the log groups for the EKS cluster. Default is 7."
  default     = 7
}

variable "vpc_cni_version" {
  type        = string
  description = "Version of AWS VPC CNI to use."
}

variable "create_eniconfig" {
  type        = bool
  description = "Create ENIConfig for EKS nodes."
  default     = true
}

variable "eks_pod_identity_agent_addon_version" {
  type        = string
  description = "Version of EKS Pod Identity Agent to use."
}

variable "kube_proxy_version" {
  type        = string
  description = "Version of kube-proxy to use."
}

variable "coredns_version" {
  type        = string
  description = "Version of coredns to use."
}

variable "node_instance_type" {
  type        = list(string)
  description = "Instance types to use for the nodes."
  default     = ["m7i.large", "m6i.large", "m5.large"]
}

variable "node_capacity_type" {
  type        = string
  description = "Capacity type of the nodes. Options are 'ON_DEMAND', 'SPOT'. Default is SPOT"
  default     = "SPOT"
}

variable "node_min_size" {
  type        = number
  description = "Minimum size of the nodes."
  default     = 2
}

variable "node_max_size" {
  type        = number
  description = "Maximum size of the nodes."
  default     = 3
}

variable "node_desired_size" {
  type        = number
  description = "Desired size of the nodes."
  default     = 2
}

variable "node_volume_size" {
  type        = number
  description = "Size of the EBS volume in GBs for the nodes. Default is 50"
  default     = 50
}

