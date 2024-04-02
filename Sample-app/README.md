# Sample app Echo server.
App will be deployed to `echoserver` namespace and ingress will be created with ALB

## Applying and testing app
```bash
kubectl apply -f echoserver.yaml
kubectl get po -n echo server 
kubectl get ing -n nameserver # Make note of ALB DNS name

# If no ALB provisioned, check Ingress for possible errors
kubectl describe ing  echoserver -n echoserver

# Verifying the app
curl -H "HOST:echo.vettom.github.io" <address>.elb.amazonaws.com

```