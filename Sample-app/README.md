<img src="https://avatars.githubusercontent.com/u/20859413?v=4" style="float:right;width:42px;height:42px;">

# Simple app for testing.
Apps deployed is configured with ingress to make it availabel externally if configured with Ingress controller names 'alb'

### Install and test with echo app (yaml)
```bash
kubectl apply -f echoserver.yaml
kubectl get po -n echo server 
kubectl get ing -n nameserver # Make note of ALB DNS name

# If no ALB provisioned, check Ingress for possible errors
kubectl describe ing  echoserver -n echoserver

# Verifying the app
ALB_URL=" "
curl -H "HOST:echo.vettom.github.io" $ALB_URL
# run in loop to validate loadbalancing.
while true
do
curl -s -H "HOST:echo.vettom.github.io" $ALB_URL | grep Hostname
sleep 1
done
```

### Install and test with demo app (HELM)
```bash
helm install dv-demo-app dv-demo-app -n dvdemo --version 3.0.0 --create-namespace --repo  https://vettom.github.io/demohelmrepo/
kubectl get ing -n dvdemo  # Make note of ALB DNS name

# If no ALB provisioned, check Ingress for possible errors
kubectl describe ing  dv-demo-app -n dvdemo

# Verifying the app
ALB_URL=" "
curl -H "HOST:dvdemo.vettom.github.io" $ALB_URL

# run in loop to validate loadbalancing.
while true
do
curl -s -H "HOST:dvdemo.vettom.github.io" $ALB_URL | grep Hostname
sleep 1
done

```
