# Complete EKS cluster
This terraform code is all you need to spin up a new EKS cluster, ready to deploy and expose application with Loadbalancer controller.

Following resources are created by this code
- VPC 
	- 2 public and 2 private subnet
	- Single NAT GW
- EKS cluster
	- Node group with single SPOT instance
	- VPC CNI Plugin
	- AWS Loablanacer Controller.

> AWS profile called `labs` used for terraform authentication

## Creating cluster
```bash
terraform init
terraform plan
terraform apply
```

## Configure kubeconfig
```bash
aws eks --profile labs --region eu-west-1 update-kubeconfig --name eks-demo
kubectl cluster-info
k9s
```