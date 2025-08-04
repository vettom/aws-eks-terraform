[<img src="https://vettom-images.s3.eu-west-1.amazonaws.com/logo/vettom-banner.jpg">](https://vettom.pages.dev/)

# EKS-Auto and Karpenter with VPC secondary IP
AWS VPC secondary IP range enables you have have smaller IP range for your nodes, while pods can make use of seconday IP range. This provides improved security as well as does not use up IP pools available for nodes.

### Tasks
[x] Create VPC and define secondary IP range
[x] Configure VPC-CNI and EniConfig for each secondary subnet
[x] Configure Karpenter to provision nodes that support secondary IP for pods

[<img src="https://vettom-images.s3.eu-west-1.amazonaws.com/aws/vpc-secondary-ip.jpg">](https://vettom.pages.dev/)

## Applying changes
```bash
terraform init; terraform plan
terraform apply --auto-approve
```

## Bootstrap the cluster
```bash
# Update kubeconfig to execurecommands
aws eks --profile labs  --region eu-west-1 update-kubeconfig --name eks-auto-demo
# Apply custom Nodepool to to make use of secondary IP range for pods.
kubectl apply -f Bootstrap/primary-nodepool.yaml
```
## Testing
Deploy a pod and verify that pods IP addresses is allocated from secondary CIDR range
`kubectl run nginx --image=nginx `
This will trigger Karpenter to spin up a node and provision pod.

## Nodeclass specification
https://docs.aws.amazon.com/eks/latest/userguide/create-node-class.html#auto-node-class-spec
