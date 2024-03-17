terraform {
  required_version = ">= 1.5"
  backend "s3" {
    bucket  = "eks-automation"
    key     = "dv-experiment/vpc/terraform.tfstate"
    region  = "eu-west-1"
    profile = "cadm-dev"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.36.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "cadm-dev"
}