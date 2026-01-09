[<img src="https://vettom-images.s3.eu-west-1.amazonaws.com/logo/vettom-banner.jpg">](https://vettom.pages.dev/)

# EKS Auto Bootstrap
 Fully Automated EKS cluster bootstrap using Terraform and Helm. Core-apps are stored in (vettom/eks-bootstrap-argocd)[https://github.com/vettom/eks-bootstrap-argocd.git] Githubrepo. Terraform will create VPC, EKS cluster and install core-apps using helm. 

 ## Prerequisites
 Necessary DNS zone is configured in Route53. In this example I have used vettom.io domain hosted in eu-west-1 region.

# Core Apps list
- core-apps
    - Argocd
    - External DNS
    - cert-manager
    - External Gateway (Envoy)
    - metrics-server
- core-apps-resources
    - Cert manager cluster issuer
    - Envoy Proxy and external Gateway called external-gateway

# Customize for environment
Inputs are passed as variables to the helm chart. Create independent values file for each environment and update `bootstrap.tf` file to point to the values file.

# Usage
```bash
cd EKS-auto-1.34-Bootstrap
terraform init
terraform apply
```
    