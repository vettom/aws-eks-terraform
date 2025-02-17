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
kubectl apply -f myapp-route.yaml
```

## Routes example
```yaml
  rules:
  - backendRefs:
    - name: myapp-v1-bluegreen
      port: 8080
      weight: 80
      - name: myapp-v2-bluegreen
        port: 8080
        weight: 20
    - backendRefs:
      - name: myapp-v3-bluegreen
        port: 8080
        weight: 1
      matches:
      - headers:
        - name: traffic
          type: Exact
          value: test
```