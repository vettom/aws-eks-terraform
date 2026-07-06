[<img src="https://vettom-images.s3.eu-west-1.amazonaws.com/logo/vettom-banner.jpg">](https://vettom.pages.dev/Eks/eks-cluster-karpenterV1/)

#Scenario
VPC is created in the modules directory with secondary subnet

# Requirements Terraform/EKS/AWS

[x] - VPC CNI with secondary IP block
[] - Karpenter for node management
[x] - EBS CSI Driver
[x] - EKS podIdentity
[] - AWS Load Balancer Controller
[x] - kube-proxy
[x] - core-dns
[] - DNS domain name internal and external
[] - External DNS for public and private DNS records
[] - Certificate manager
[] - External secrets with access to cluster Path and SSM
[] - EFS file system for persistent storage
[] - security groups for EFS to access from EKS nodes
[] - Mount target in each subnet
[] - EFS Filesyste
[] - EFS SC

## Additional and optional

[] - S3 bucket, s3-filesystem, access point and bucket policy for EFS (optional)
[] - ECR and ECR access (optional)
[] - S3 bucket for Thanos (optional)
)

## Steps

```bash
# Execute following commands from  aws-eks-terraform/EKS-Cluster-karpenter folder
terraform init -upgrade ; terraform apply
# Configure local kubeconfig
aws eks --profile labs  --region eu-west-1 update-kubeconfig --name eks-demo
# Verify cluster access
kubectl cluster-info

# Authenticate with ECR public repo
aws ecr-public get-login-password --region us-east-1 | helm registry login \
     --username AWS --password-stdin public.ecr.aws
```

## EKS Build Notes

### VPC Requirements

- Tags for Private and Public subnets are required
- Enable NAT gateway or transit gateway
