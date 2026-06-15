terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.47.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "labs" # Configure profile or authentication as required.
}

# Public ECR lives only in us-east-1 — alias is required even if your cluster is elsewhere
provider "aws" {
  alias   = "virginia"
  region  = "us-east-1"
  profile = "labs"
}

data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

provider "helm" {
  registries = [
    {
      url      = "oci://public.ecr.aws"
      username = data.aws_ecrpublic_authorization_token.token.user_name
      password = data.aws_ecrpublic_authorization_token.token.password
    }
  ]
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
