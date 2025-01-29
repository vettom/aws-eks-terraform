<a href="https://vettom.pages.dev/"><img src="![vettom.pages.dev banner](https://vettom-images.s3.eu-west-1.amazonaws.com/logo/vettom-banner.jpg)" alt="vettom.pages.dev" ></a>

# EKS Cluster Auto mode

Terraform code to spin up an EKS cluster in Auto mode. In Auto mode, AWS manages Addons and Karpenter autoscaler, making it easier to manage cluster. Includes following

- VPC CNI
- Loadbalancer controller
- Pod Identity Agent
- EBS CSI driver
- Karpenter Autoscaler
- Ingress Controller

## Applying changes
```bash
terraform init; terraform plan
terraform apply --auto-approve
```
This will create VPC with 2 subnets, install EKS Auto and configured `ClusterAdmin` access to the identity creating cluster.