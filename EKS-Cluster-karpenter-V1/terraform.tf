terraform {
  required_version = ">= 1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.73.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "labs" # Configure profile or authentication as required.
}