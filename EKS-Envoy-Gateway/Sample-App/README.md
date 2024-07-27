<img src="https://avatars.githubusercontent.com/u/20859413?v=4" style="float:right;width:42px;height:42px;">

# Simple app for testing.
Apps deployed is configured with gateway to make it availabel externally.

### Install and test with echo app (yaml)
```bash
kubectl apply -f echoserver.yaml
kubectl get po -n echoserver 
kubectl get httproute -n echoserver 
kubectl get gateway -n gateway external-gateway # Make note of NLB DNS name


# Verifying the app
NLB_URL=" "
curl -H "HOST:dvdemo.vettom.github.io" $NLB_URL
# run in loop to validate loadbalancing.
while true
do
curl -s -H "HOST:dvdemo.vettom.github.io" $NLB_URL | grep Hostname
sleep 1
done
```
