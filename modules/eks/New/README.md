[<img src="https://vettom-images.s3.eu-west-1.amazonaws.com/logo/vettom-banner.jpg">](https://vettom.pages.dev/Eks/eks-cluster-karpenterV1/)

# Eks cluster and Karpenter V1

Contains everything required to configure Karpenter autoscaling
Steps

- Apply terraform
- Configure kubeconfig and retrieve Endpoint URL
- Install Karpenter controller
- Apply karpenter-nodepool

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

## EFS configuration

Requires

- IAM role with AmazonEFSCSIDriverPolicy and AmazonElasticFileSystemsUtils policies
- Security groups for EFS and EC2
- EFS mount target per subnet
- Output EFS file-system ID for storage class creation.
-
