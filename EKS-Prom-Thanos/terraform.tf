terraform {
  required_version = ">= 1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.84.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "labs" # Configure profile or authentication as required.
  default_tags {
    tags = {
      "Purpose" = "EKS features investigation and demo"
      "Owner"   = "Denny Vettom"
      "Env"     = "Dev"

    }
  }
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "--profile=labs", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}
