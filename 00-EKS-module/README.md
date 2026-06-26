[<img src="https://vettom-images.s3.eu-west-1.amazonaws.com/logo/vettom-banner.jpg">](https://vettom.pages.dev/Eks/eks-cluster-karpenterV1/)

#Scenario
VPC is created in the modules directory with secondary subnet

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
