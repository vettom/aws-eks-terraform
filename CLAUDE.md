# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a collection of independent Terraform configurations for building and experimenting with AWS EKS clusters. Each top-level directory is a self-contained Terraform project targeting a specific EKS scenario or feature.

**AWS profile:** `labs` | **Default region:** `eu-west-1`

## Common Workflow

Every directory follows the same pattern:

```bash
# Initialize and apply
terraform init -upgrade
terraform plan
terraform apply --auto-approve

# Configure kubeconfig after cluster is ready
aws eks --profile labs --region eu-west-1 update-kubeconfig --name <cluster-name>
kubectl cluster-info
```

Most cluster directories include a `run.sh` that does `terraform init -upgrade && terraform apply --auto-approve && aws eks update-kubeconfig ...` in one shot.

## Provider Requirements

- Terraform >= 1.8 (some modules require >= 1.9)
- AWS provider `hashicorp/aws` ~> 6.x (pinned per directory in `terraform.tf`)
- Helm provider required in bootstrap/full-stack directories
- All providers use `profile = "labs"` for AWS auth

## Directory Map

| Directory | Purpose |
|---|---|
| `00-eks-1.35/` | EKS 1.35 managed nodes (Bottlerocket SPOT) + Karpenter IRSA IAM + EFS CSI via Pod Identity; `create_auto_mode_iam_resources = true` pre-provisions Auto Mode IAM even though Auto Mode is off |
| `01-eks-auto/` | EKS Auto Mode baseline — AWS manages addons and Karpenter |
| `EKS-auto-1.35-Bootstrap/` | Full bootstrap: Auto Mode + ArgoCD + core-apps via Helm |
| `Auto-EKS-Generic/` | Auto Mode with custom SPOT NodePool (weight 50 overrides default pool) |
| `EKS-Auto-secondary/` | Auto Mode + VPC secondary CIDR (`100.0.0.0/16`) for pod IPs via VPC-CNI ENIConfig |
| `EKS-Cluster-ALB/` | Managed node group cluster + ALB Ingress Controller |
| `EKS-Cluster-generic/` | Managed nodes + LB controller + IAM Pod Identity examples (cert-manager, ext-dns, ESO) |
| `EKS-Cluster-ingress/` | Managed nodes + nginx ingress + LB controller |
| `EKS-Cluster-karpenter/` | Managed nodes + Karpenter v1 autoscaler (IRSA auth) |
| `EKS-Cluster-karpenter-V1/` | Karpenter with AWS API auth (newer pattern) |
| `EKS-Cluster-podIdentity/` | EKS Pod Identity agent demo |
| `EKS-Prom-Thanos/` | Auto Mode + EBS CSI + GP3 StorageClass; installs kube-prometheus-stack + Thanos via Helm |
| `EKS-AUTO-Mode/` | Minimal Auto Mode reference with access entries |
| `EKS-Auto-ACK/` | Auto Mode + ACK IAM and EKS controllers via Pod Identity |
| `EKS-Auto-ACK-Adv/` | ACK with additional EKS Pod Identity role |
| `EKS-Crossplane/` | Auto Mode + Crossplane bootstrap (WIP) |
| `EKS-Envoy-Gateway/` | Managed nodes + Envoy Gateway (Gateway API) |
| `EKS-SecondaryIP/` | Managed nodes + VPC secondary CIDR for pods |
| `Blue-green-gatewayApi/` | Gateway API blue/green routing YAML examples (no Terraform) |
| `Karpenter/` | Karpenter NodePool/NodeClass YAML manifests |

## Architecture Patterns

### EKS Auto Mode vs Managed Node Groups
- **Auto Mode** (`compute_config.enabled = true`): AWS manages Karpenter, addons, and node lifecycle. Fewer Terraform resources needed. Most newer directories use this.
- **Managed node groups** (`eks_managed_node_groups`): Traditional model. Requires explicit addon management and Karpenter IAM setup in separate `.tf` files.

### IAM Auth Patterns
- **IRSA (older):** `aws_iam_role` with `AssumeRoleWithWebIdentity` condition on OIDC provider — used for Karpenter in `EKS-Cluster-karpenter/` and `00-eks-1.35/`.
- **EKS Pod Identity (newer):** `aws_eks_pod_identity_association` with `pods.eks.amazonaws.com` principal — used in `EKS-Auto-ACK/`, `EKS-Cluster-generic/`, `EKS-Prom-Thanos/`, and for EFS CSI in `00-eks-1.35/`. The assume-role policy document is usually shared in `data.tf` as `pod_id_assume_role`.

### File Conventions per Directory
- `terraform.tf` — provider versions and AWS profile
- `vpc.tf` — VPC module (`terraform-aws-modules/vpc/aws` ~> 6.x)
- `eks.tf` or `eks-auto.tf` — EKS module (`terraform-aws-modules/eks/aws` ~> 21.x)
- `iam-*.tf` — IAM roles/policies for specific controllers (cert-manager, ext-dns, karpenter, etc.)
- `bootstrap.tf` — Helm releases for cluster bootstrapping (ArgoCD, core-apps)
- `data.tf` — `aws_caller_identity`, `aws_region` data sources

### Cluster Names
Most clusters are named `eks-demo` or `eks-auto-demo`. Check the `name` field in the relevant `eks.tf` / `eks-auto.tf` before running `update-kubeconfig`.

### VPC Design
All VPCs use `terraform-aws-modules/vpc/aws` with:
- Private subnets for nodes (tagged `kubernetes.io/role/internal-elb` and `karpenter.sh/discovery`)
- Public subnets for NAT GW / ELB (tagged `kubernetes.io/role/elb`)
- `single_nat_gateway = true` to reduce cost (not HA)

### Secondary CIDR (EKS-Auto-secondary, EKS-SecondaryIP)
Pod IPs come from `100.0.0.0/16` secondary CIDR. Requires:
1. `vpc-secondary-subnet.tf` — associates secondary CIDR and creates pod subnets per AZ
2. `vpc-cni.tf` — deploys `aws-vpc-cni` Helm chart with `CUSTOM_NETWORK_CFG`, `ENABLE_POD_ENI`, `ENABLE_PREFIX_DELEGATION`, and ENIConfigs mapping each AZ to its pod subnet
3. Bootstrap NodePool manifest references pod subnet tag `pod_subnet: "true"`

## ECR Public Auth (required for Karpenter Helm installs)

Newer directories (e.g. `00-eks-1.35/`) handle this automatically in `terraform.tf` via a `virginia` provider alias and `data.aws_ecrpublic_authorization_token` injected into the Helm provider registry block — no manual step needed.

For directories without that pattern, run manually before `helm install`:

```bash
aws ecr-public get-login-password --region us-east-1 | \
  helm registry login --username AWS --password-stdin public.ecr.aws
```

## State Files

Each directory has its own `terraform.tfstate` stored locally (no remote backend). Do not mix state between directories.
