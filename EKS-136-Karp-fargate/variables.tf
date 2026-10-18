variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-demo"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.36"
}

variable "vpc_id" {
  description = "Name tag of the VPC to search for"
  type        = string
  default     = "eks-demo-vpc"
}

variable "karpenter_version" {
  description = "Version of Karpenter to deploy"
  type        = string
  default     = "1.9.2"
}
