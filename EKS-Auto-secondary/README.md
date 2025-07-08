[<img src="https://vettom-images.s3.eu-west-1.amazonaws.com/logo/vettom-banner.jpg">](https://vettom.pages.dev/)

# EKS-Auto with pod subnets

## Incomplete, work in progress


## Applying changes
```bash
terraform init; terraform plan
terraform apply --auto-approve
```
This will create VPC with 2 subnets, install EKS Auto and configured `ClusterAdmin` access to the identity creating cluster.

## Bootstrap the cluster
<!-- Subnet and Securitygroup Hardcoded, please update first -->
```bash
# Update kubeconfig to execurecommands
aws eks --profile labs  --region eu-west-1 update-kubeconfig --name eks-auto-demo
helm upgrade --install aws-vpc-cni --namespace kube-system eks/aws-vpc-cni -f ENI/eni-values.yaml
kubectl get eniconfigs
# Optional Apply custom Nodepool to spin up SPOT instance to keep cost down.
kubectl apply -f Bootstrap/primary-nodepool.yaml
```

## Install Envoy Gateway
```bash
# Install Envoy Gateway and Gateway API CRD's
helm install gateway oci://docker.io/envoyproxy/gateway-helm --version v0.0.0-latest -n gateway --create-namespace
# Verify Gateway API CRD's are installed and Pods are running
kubectl api-resources --api-group gateway.networking.k8s.io
# Apply Envoy proxy configuration and create Gateway
kubectl apply -f Gateway/external-gateway.yaml
# Verify Gateway is created and Loadbalancer allocated
kubectl get gateway -n gateway
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


## Nodeclass
https://docs.aws.amazon.com/eks/latest/userguide/create-node-class.html