[<img src="https://vettom-images.s3.eu-west-1.amazonaws.com/logo/vettom-banner.jpg">](https://vettom.pages.dev/)

## Work in progress

# Crossplane install

```bash
helm repo add crossplane-stable https://charts.crossplane.io/stable; helm repo update
helm install crossplane \
--namespace crossplane-system \
--create-namespace crossplane-stable/crossplane

# Install a provider, this seems to install provider family and s3 provider.
k apply -f Crossplane/aws-provider.yaml

```
