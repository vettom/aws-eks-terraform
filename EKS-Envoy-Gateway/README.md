<img src="https://avatars.githubusercontent.com/u/20859413?v=4" style="float:right;width:42px;height:42px;">
For details visite [https://vettom.github.io/](https://vettom.github.io/)

# :desktop_computer: EKS cluster with Gateway API [Envoy]
 [Kubernetes Gateway API](https://gateway-api.sigs.k8s.io/) is the next generation of Kubernetes Ingress, Load Balancing, and Service Mesh APIs. While Gateway API is part of Kubernetes, you will require a provider software to implement and manage functionalities. There are [multiple providers](https://gateway-api.sigs.k8s.io/implementations/) and in this example I will be using [Envoy Gateway](https://gateway.envoyproxy.io/)

This example covers following
- [x] VPC with 2  privat and 2 public zones
- [x] EKS cluster with Managed NodeGroup (1 Node)
- [x] VPC CNI add-on with prefix delegation
- [x] LB Controller installed (Required to provision NLB with target type IP)
- [x] [Envoy Gateway](https://gateway.envoyproxy.io/)  Gateway API
- [x] Deploy and verify [Gateway API](https://gateway-api.sigs.k8s.io/) using Sample app.

<img src="img/eks-ingress.png" width="600" height="400">

> :information_source: AWS profile called `labs` used for terraform authentication

## Creating cluster
```bash
terraform init; terraform plan
terraform apply
```
## Configure kubeconfig
```bash
aws eks --profile labs --region eu-west-1 update-kubeconfig --name eks-demo
kubectl cluster-info
```
## Insall and configure Envoy Gateway

```bash
# Install Envoy Gateway and Gateway API CRD's
helm install gateway oci://docker.io/envoyproxy/gateway-helm --version v1.0.2 -n gateway --create-namespace
# Verify Gateway API CRD's are installed and Pods are running
kubectl api-resources --api-group gateway.networking.k8s.io
# Apply Envoy proxy configuration and create Gateway
kubectl apply -f Gateway/gateway.yaml
# Verify Gateway is created and Loadbalancer allocated
kubectl get gateway -n gateway
```
Create HTTP route definitions for your application and update DNS entries accordingly.

## Install Sample app and verify
Follow instructions in [Sample App README.md](https://github.com/vettom/aws-eks-terraform/blob/main/EKS-Envoy-Gateway/Sample-App/README.md) to test Gateway


