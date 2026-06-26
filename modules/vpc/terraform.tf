terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.51.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "labs" # Configure profile or authentication as required.
}


