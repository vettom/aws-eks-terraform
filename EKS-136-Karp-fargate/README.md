# EKS 1.36 with Karpenter on Fargate (Nodeless Bootstrap)

This configuration provisions an Amazon EKS **1.36** cluster (`terraform-aws-modules/eks/aws ~> 21.21`) with **no managed node groups**. The cluster compute lifecycle is fully managed by **Karpenter (`v1.9.2`)**:

- **Karpenter Controller**: Runs on **AWS Fargate** in the `karpenter` namespace.
- **Worker Nodes**: Dynamically provisioned by Karpenter using **Bottlerocket** AMIs across `spot` and `on-demand` capacity (`arm64` / `amd64`, `c`/`m`/`r` families, `generation >= 5`, `CPU >= 2`, `memory > 2048 MiB`).
- **VPC CNI Custom Networking**: Configured with Prefix Delegation, Pod ENI, and per-AZ `ENIConfig` using dedicated pod subnets (`*-podsubnet-*`).
- **CoreDNS & Add-ons**: Run on worker nodes spun up by Karpenter, not on Fargate.

## Architecture Highlights

1. **Fargate Profile for Karpenter Only** (`eks.tf`):
   - The Fargate profile targets only the `karpenter` namespace in private subnets.
   - CoreDNS, VPC CNI, Kube-proxy, and EKS Pod Identity Agent run on worker nodes provisioned by Karpenter.

2. **IRSA for Karpenter Controller** (`karpenter.tf`):
   - Because AWS Fargate does not support DaemonSets (preventing the `eks-pod-identity-agent` from running on Fargate compute), the Karpenter controller uses **IAM Roles for Service Accounts (IRSA)** (`create_pod_identity_association = false`) to authenticate with AWS APIs.
   - Native Spot interruption handling (`enable_spot_termination = true`) via SQS and EventBridge is enabled, and `AmazonSSMManagedInstanceCore` is attached to the Karpenter node role.

3. **DNS Resolution on Fargate (`dnsPolicy: Default`)** (`karpenter.tf`):
   - CoreDNS pods do not run on Fargate and await worker node provisioning.
   - The Karpenter controller (`replicas: 1`, `300m` CPU / `512Mi` memory) is configured with `dnsPolicy: Default` so it uses VPC DNS directly to reach AWS STS and EC2 endpoints at startup without a circular dependency on CoreDNS.

4. **VPC Discovery & CNI Custom Networking** (`vpc.tf`, `eks.tf`):
   - Discovers an existing VPC (`var.vpc_id`, default `eks-demo-vpc`), private subnets (`*-private-*`), and secondary pod subnets (`*-podsubnet-*`), and tags private subnets for internal ELB and Karpenter discovery.
   - `vpc-cni` (`before_compute = true`, dynamically pinned to the latest version for `var.cluster_version`) enables Custom Networking (`AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG = "true"`), Pod ENI, Prefix Delegation, and automatically creates AZ-scoped `ENIConfig` resources (`ENI_CONFIG_LABEL_DEF = "topology.kubernetes.io/zone"`).

5. **Karpenter CRDs, NodePool & EC2NodeClass** (`karpenter.tf`, `helm/nodepool/`):
   - Deploys `karpenter-crd` and `karpenter` (`v1.9.2`) from `oci://public.ecr.aws/karpenter` (authenticated via a `us-east-1` AWS provider alias).
   - Deploys a local Helm chart (`./helm/nodepool`) creating the `default` `NodePool` and `EC2NodeClass`:
     - **AMI**: `Bottlerocket` (`bottlerocket@latest`).
     - **Instance Requirements**: `arm64`/`amd64`, `spot`/`on-demand`, categories `c`/`m`/`r`, `instance-generation >= 5`, `instance-cpu >= 2`, `instance-memory > 2048`.
     - **Limits & Disruption**: `50` CPU / `128Gi` memory limits; `WhenEmptyOrUnderutilized` consolidation after `1m`.

6. **EKS Add-ons with Dynamic Versioning** (`eks-addons.tf`, `eks.tf`):
   - All EKS add-ons (`vpc-cni`, `eks-pod-identity-agent`, `kube-proxy`, and `coredns`) use `aws_eks_addon_version` data sources (`most_recent = true`) tied to `var.cluster_version`, automatically selecting the latest compatible add-on version whenever the Kubernetes cluster version changes.
   - `coredns` (`replicaCount = 1`) explicitly depends on both `helm_release.karpenter` and `helm_release.karpenter_nodepool` so worker nodes are provisioned before the add-on readiness check completes.

## Project Structure

| File / Path | Description |
| :--- | :--- |
| `terraform.tf` | Terraform (`>= 1.9`), AWS (`>= 6.59.0`, `eu-west-1` + `us-east-1` alias for Public ECR), and Helm (`>= 2.14`) providers |
| `variables.tf` | Input variables (`cluster_name`, `cluster_version`, `vpc_id`, `karpenter_version`) |
| `data.tf` | Caller identity, region, and shared Pod Identity assume-role policy document |
| `vpc.tf` | VPC, private subnet, and pod subnet lookups plus EC2 tags for ELB and Karpenter discovery |
| `eks.tf` | EKS cluster module, `vpc-cni` custom networking (`ENIConfig`), and `karpenter` Fargate profile |
| `karpenter.tf` | Karpenter module, IRSA trust policy, and Helm releases (`karpenter-crd`, `karpenter`, `karpenter-nodepool`) |
| `helm/nodepool/` | Local Helm chart defining the default `NodePool` and Bottlerocket `EC2NodeClass` |
| `eks-addons.tf` | `eks-pod-identity-agent`, `kube-proxy`, and `coredns` EKS add-ons |
| `outputs.tf` | Cluster name, endpoint, version, and Karpenter IAM role / SQS queue outputs |
| `run.sh` | Helper script to initialize, apply, and configure local `kubeconfig` |

## Deployment Steps

You can deploy using the helper script:

```bash
./run.sh
```

Or run the steps manually:

```bash
# 1. Initialize and upgrade Terraform
terraform init -upgrade

# 2. Plan and apply
terraform plan
terraform apply --auto-approve

# 3. Configure local kubeconfig
aws eks --profile labs --region eu-west-1 update-kubeconfig --name eks-demo --alias eks-demo

# 4. Verify cluster and nodes
kubectl get nodes
kubectl get pods -A
kubectl get nodepool,ec2nodeclass
```

