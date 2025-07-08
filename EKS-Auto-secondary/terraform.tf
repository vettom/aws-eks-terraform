terraform {
  required_version = ">= 1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.84.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.35.1"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "labs" # Configure profile or authentication as required.
}

# Disabling as it cannot work during EKS provisioning.
#provider "kubernetes" {
#  host                   = aws_eks_cluster.eks-auto-demo.endpoint
#  cluster_ca_certificate = base64decode(aws_eks_cluster.eks-auto-demo.certificate_authority.0.data)
#  exec {
#    api_version = "client.authentication.k8s.io/v1beta1"
#    args        = ["eks", "--profile", "labs", "get-token", "--cluster-name", aws_eks_cluster.eks-auto-demo.name]
#    command     = "aws"
#  }
#}



