# Apps being installed

```bash
helm install envoy-gateway oci://docker.io/envoyproxy/gateway-helm --version v1.9.3 -n envoy-gateway-system --create-namespace
k apply -f default-gateway.yaml
```
