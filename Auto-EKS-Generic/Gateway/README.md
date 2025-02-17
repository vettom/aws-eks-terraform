<a href="https://vettom.github.io/"><img src="https://vettom.github.io/img/vettom-banner.jpg" alt="vettom.github.io" ></a>

# Installing Envoy Gateway Fabric
Gateway API specification is part of Kubernetes, however requires provider software to implement the solution. In this example I am using Envoy Gateway Fabric to implement Gateway API

## Gateway API resources

- GatewayClass : Defines type of Gateway (internal/external), custom setting specific to Cloud provider and implementation software
- Gateway : Enables creation of Loadbalncer and listener creation. Each gateway creates a new Loadbalancer.
- HTTPRoute : Defines rules for routing traffic like backend, redirects, canary, traffic mirroring etc.

## Envoy Proxy
Envoy gateway provisions Envoy Proxy per gateway. In order to customise your gateway, you can define `EnvoyProxy` config to manage behaviour of your Envoy gateway proxies provisioned

## Install Envoy Gateway
```bash
# Install Envoy Gateway and Gateway API CRD's
helm install gateway oci://docker.io/envoyproxy/gateway-helm --version v1.0.2 -n gateway --create-namespace
# Verify Gateway API CRD's are installed and Pods are running
kubectl api-resources --api-group gateway.networking.k8s.io
# Apply Envoy proxy configuration and create Gateway
kubectl apply -f external-gateway.yaml
# Verify Gateway is created and Loadbalancer allocated
kubectl get gateway -n gateway
```