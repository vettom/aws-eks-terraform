# Complete EKS cluster
This terraform code is all you need to spin up a new EKS cluster, ready to deploy and expose application with Loadbalancer controller.

Following resources are created by this code
- VPC with 2 public and 2 private subnet
- ELS cluster
	- Node group with single SPOT instance
	- VPC CNI Plugin
	- AWS Loablanacer Controller.