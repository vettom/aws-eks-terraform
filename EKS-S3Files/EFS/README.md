# EFS CSI installation

```bash
helm repo add efs https://kubernetes-sigs.github.io/aws-efs-csi-driver/
helm repo update efs
helm upgrade --install aws-efs-csi-driver --namespace kube-system efs/aws-efs-csi-driver -f ./values.yaml
```
