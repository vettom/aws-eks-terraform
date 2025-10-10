terraform init -upgrade
terraform apply --auto-approve

aws eks --profile labs  --region eu-west-1 update-kubeconfig --name eks-auto-demo
# Apply custom Nodepool to to make use of secondary IP range for pods.
kubectl apply -f Bootstrap/cni-nodepool.yaml
