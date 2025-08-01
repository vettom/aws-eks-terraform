terraform {
  required_version = ">= 1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.84.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "labs" # Configure profile or authentication as required.
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--profile", "labs", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

# Fetch the current AWS region
data "aws_region" "current" {}
