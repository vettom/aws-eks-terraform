# Blue-Green or Canary deployment with Gateway API

### Pre-requisite
- EKS cluster installed and configured
- Gateway API implemented
- Gateway called `external-gateway` created

# Installing 3 versions of apps
```bash
helm install myapp-v1 bluegreen --repo=https://vettom.github.io/demohelmrepo/ --version 1.0.0
helm install myapp-v2 bluegreen --repo=https://vettom.github.io/demohelmrepo/ --version 2.0.0
helm install myapp-v3 bluegreen --repo=https://vettom.github.io/demohelmrepo/ --version 3.0.0
```
# Expose App 
```bash
helm upgrade --install myapp-route route-bluegreen --repo=https://vettom.github.io/demohelmrepo/  -f route-value.yaml