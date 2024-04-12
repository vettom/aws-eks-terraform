# Complete EKS cluster
<img src="https://avatars.githubusercontent.com/u/20859413?v=4" style="float:right;width:42px;height:42px;">
Terraform code to provision complete EKS cluster.

- [ ] VPC with 2 zones
- [ ] EKS cluster with Managed NodeGroup
- [ ] VPC CLI plugin
- [ ] AWS Loadbalancer controller

<img src="img/eks-design.png" width="600" height="400">



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

|Resource|Components|
|--------------------------|--------------------------|
|VPC| 2 public and 2 private subnets and Single NAT GW|
|EKS Cluster|Node group with single SPOT instance, VPC CNI Plugin,AWS Loablanacer Controller |
------------------
