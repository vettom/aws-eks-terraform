# Core-apps
Core-apps helm chart contains all necessary apps to get started with a EKS cluster. This Helm chart is to bootstrap core-apps and core-apps-resources (vettom/eks-bootstrap-argocd)[https://github.com/vettom/eks-bootstrap-argocd.git] Githubrepo

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
Inputs are passed as variables to the helm chart. Create independent values file for each environment. 
