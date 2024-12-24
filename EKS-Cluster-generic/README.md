<a href="https://vettom.github.io/"><img src="https://vettom.github.io/img/vettom-banner.jpg" alt="vettom.github.io" ></a>

# EKS Cluster with extras
Spin up EKS cluster and configure various IAM Pod Identity for applications.

#Getting started
```bash
# Install Gateway API and Gateway
helm install gateway oci://docker.io/envoyproxy/gateway-helm --version v1.0.2 -n gateway --create-namespace
kubectl apply -f ext-gateway/external-gateway.yaml

# Install External DNS
helm install  external-dns  external-dns -n external-dns \
--create-namespace --repo https://kubernetes-sigs.github.io/external-dns \
--version 1.15.0 -f ext-dns/values.yaml

# Install Cert mgr
helm install  cert-manager cert-manager -n cert-manager  --create-namespace  \
--repo https://charts.jetstack.io/ --version v1.16.2 -f cert-manager/values.yaml
 
 kubectl apply -f cert-manager/cluster-issuer.yaml

```

## Configure kubeconfig
```bash
aws eks --profile labs --region eu-west-1 update-kubeconfig --name eks-demo
kubectl cluster-info
k9s
```