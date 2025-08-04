
locals {
  azs                  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  vpc_cidr             = "10.0.0.0/24"
  private_subnets      = ["10.0.0.0/27", "10.0.0.32/27", "10.0.0.64/27"]
  public_subnets       = ["10.0.0.128/27", "10.0.0.160/27", "10.0.0.192/27"]
  secondary_cidr_block = "100.0.0.0/16"
  pod_subnets          = ["100.0.0.0/19", "100.0.32.0/19", "100.0.64.0/19"]
}
