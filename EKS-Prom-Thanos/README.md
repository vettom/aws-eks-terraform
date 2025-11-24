[<img src="https://vettom-images.s3.eu-west-1.amazonaws.com/logo/vettom-banner.jpg">](https://vettom.pages.dev/Monitoring/prometheus-thanos/)
# ECR Cluster
- EKS Auto
- EBS-SCI driver installed
- StorageClass GP3 created

[<img src="https://vettom-images.s3.eu-west-1.amazonaws.com/monitoring/thanos-steps.png">](https://vettom.pages.dev/Monitoring/prometheus-thanos/)

# Installations steps
```bash
cd aws-eks-terraform/EKS-Prom-Thanos/Prom-Thanos
helm upgrade -i kube-prometheus-stack --repo https://prometheus-community.github.io/helm-charts \ 
kube-prometheus-stack  -n monitoring --create-namespace -f prometheus-thanos.yaml
# Add Bitnami repo and install thanos
helm repo add bitnami https://charts.bitnami.com/bitnami ; helm repo update bitnami
helm install thanos bitnami/thanos --version 17.3.1 -f thanos.yaml -n thanos --create-namespace

```

## Architecture
[<img src="https://vettom-images.s3.eu-west-1.amazonaws.com/monitoring/prom-thanos.jpg">](https://vettom.pages.dev/Monitoring/prometheus-thanos/)

## Thanos components summary
| Component                       | Purpose                                                      |
| ------------------------------- | ------------------------------------------------------------ |
| ✅ **Query-Front-end**           | (optional) Adds caching, better UI performance.       |
| ✅ **Query**                     | Aggregates metrics from Prometheus sidecars and StoreGateway |
| ✅ **StoreGateway**              | Reads historical blocks from S3                              |
| ✅ **Compactor**                 | Deduplicates and compacts blocks in S3                       |
| ⚙️ **Optional: Ruler**          | Allows rule evaluation based on S3 data                      |
| ❌ **Bucketweb**                 | Usually not needed in production                             |
