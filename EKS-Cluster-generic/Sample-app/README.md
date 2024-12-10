<img src="https://avatars.githubusercontent.com/u/20859413?v=4" style="float:right;width:42px;height:42px;">

# Simple EKS cluster and test apps 

## Pod Identity test
Terraform code creates IAM role and Role association for validating Pod Identity. Apps running in `example` namespace with serviceAccount `exampleservieaccount` will have S3 readonly access. To test, apply `pod-id-test-app.yaml`
```bash
kubectl apply -f pod-id-test-app.yaml
kubectl get po -n example
# get shell access to the pod
kubectl exec -n example --stdin --tty <pod name> -- /bin/sh
# Check S3 list

```