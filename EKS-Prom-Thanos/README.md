[<img src="https://vettom-images.s3.eu-west-1.amazonaws.com/logo/vettom-banner.jpg">](https://vettom.pages.dev/)

# ECR Cluster
- EKS Auto
- EBS-SCI driver installed
- StorageClass GP3 created

# Installations steps
```bash
cd aws-eks-terraform/EKS-Prom-Thanos/Prom-Thanos
helm upgrade -i kube-prometheus-stack --repo https://prometheus-community.github.io/helm-charts kube-prometheus-stack  -n monitoring --create-namespace -f prometheus-thanos.yaml
# Add Bitnami repo and install thanos
helm repo add bitnami https://charts.bitnami.com/bitnami ; helm repo update bitnami
helm upgrade -i thanos --repo https://charts.bitnami.com/bitnami thanos  -n thanos --create-namespace -f thanos.yaml --version 17.3.1

```
