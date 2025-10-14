[<img src="https://vettom-images.s3.eu-west-1.amazonaws.com/logo/vettom-banner.jpg">](https://vettom.pages.dev/)

# Aws Controller for Kubernetes (ACK)
Terraform code to provision EKS-Auto cluster with custom Nodepool that will provision SPOT instances. It also creates IAM policy and pod identity to provision `ack-iam-char` and `ack-eks-controller`

## Apply terraform code and configure EKS cluster
```bash
terraform init -upgrade
terraform apply --auto-approve
sleep 10
aws eks --profile labs  --region eu-west-1 update-kubeconfig --name eks-auto-demo
```

## Provision IAM controller
```bash
export SERVICE=iam
export RELEASE_VERSION=$(curl -sL https://api.github.com/repos/aws-controllers-k8s/${SERVICE}-controller/releases/latest | jq -r '.tag_name | ltrimstr("v")')
export ACK_SYSTEM_NAMESPACE=ack-system
export AWS_REGION=eu-west-1

aws ecr-public get-login-password --region us-east-1 | helm registry login --username AWS --password-stdin public.ecr.aws
helm install --create-namespace -n $ACK_SYSTEM_NAMESPACE ack-$SERVICE-controller \
  oci://public.ecr.aws/aws-controllers-k8s/$SERVICE-chart --version=$RELEASE_VERSION --set=aws.region=$AWS_REGION
```
