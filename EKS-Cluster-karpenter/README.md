<img src="https://avatars.githubusercontent.com/u/20859413?v=4" style="float:right;width:42px;height:42px;">

For details visit [vettom.github.io](https://vettom.github.io/)

> :warning: This configuration uses AWS Access Entries, not aws_auth configMap

# Eks cluster and Karpenter
Contains everything required to configure Karpent autoscaling
Steps
- Apply terraform
- Configure kubeconfig and retrieve Endpoint URL
- Update EndPointURL in karpeneter-values.yaml
- Install Karpenter controller
- Apply karpenter-nodepool

## Steps
```bash
# Execute following commands from  aws-eks-terraform/EKS-Cluster-karpenter folder
terrafor init -upgrade ; terraform apply
# Configure local kubeconfig
aws eks --profile labs  --region eu-west-1 update-kubeconfig --name eks-demo
# Verify cluster access
kubectl cluster-info
# Update cluster endpoint in Karpenter-app/karpenter-values.yaml file
"clusterEndpoint: https://11111111111.gr7.eu-west-1.eks.amazonaws.com"
# Install Karpenter controller
helm install karpenter -n karpenter --create-namespace oci://public.ecr.aws/karpenter/karpenter \
 --version 0.36.2 -f Karpenter-app/karpenter-values.yaml
# Once karpenter pods are up and running, create nodepoo and node class
kubectl apply -f Karpenter-app/karpenter-nodepool.yaml
# Verify resources are created
kubectl get ec2nc,nodepool
```

# Testing Karpenter
Karpenter will provision new nodes when ever pod deployment is pending due to resource constraints. Here is sample app that you can use for test, adjust number of replicas as required.

```bash
kubectl apply -f Sample-App/karpenter-scale.yaml
# Notice pods are pending and if you describe, it will report insufficient CPU. 
# Check Karpenter logs for errors, also notice it provision new node
kubectl logs -f -n karpenter -l app.kubernetes.io/name=karpenter
# Allow a minute and check pods status as well as nodes. 
kubectl get nodes # Should see new node being provisioned.
# Check and ensure all pods are now deployed
kubectl get po -n karpenter-testing
```