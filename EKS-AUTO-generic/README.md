[<img src="https://vettom-images.s3.eu-west-1.amazonaws.com/logo/vettom-banner.jpg">](https://vettom.pages.dev/)

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

## Update kubeconfig to access cluster
```bash
aws eks --profile labs  --region eu-west-1 update-kubeconfig --name eks-auto-demo
```

## Testing App with Curl
```bash
ALB_URL=" "
curl -H "HOST:echo.vettom.pages.dev" $ALB_URL
# run in loop to validate loadbalancing.
while true
do
curl -s -H "HOST:echo.vettom.pages.dev" $ALB_URL | grep Hostname
sleep 1
done
```