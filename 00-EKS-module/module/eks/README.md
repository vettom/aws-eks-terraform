# EKS Module

Terraform module that provisions an EKS cluster with managed node groups (Bottlerocket SPOT), VPC-CNI configured for secondary CIDR pod networking with ENIConfig, and core addons (vpc-cni, kube-proxy, coredns, eks-pod-identity-agent).

## Features

- EKS managed node group using Bottlerocket AMI with SPOT instances
- VPC-CNI configured for custom networking (`CUSTOM_NETWORK_CFG`) with prefix delegation and ENIConfig per AZ
- Auto Mode IAM resources pre-provisioned (`create_auto_mode_iam_resources = true`) for future use with custom Karpenter NodePools
- Karpenter subnet discovery tags applied per-cluster to support multi-cluster VPC sharing
- SSM access enabled on nodes via `AmazonSSMManagedInstanceCore`
- EKS Pod Identity agent addon installed

## Usage

```hcl
module "eks" {
  source = "./module/eks"

  vpc_name           = "my-vpc"
  cluster_name       = "eks-demo"
  kubernetes_version = "1.35"

  kms_key_administrators = ["arn:aws:iam::123456789012:role/Admin"]

  vpc_cni_version    = "v1.19.3-eksbuild.1"
  kube_proxy_version = "v1.35.3-eksbuild.13"
  coredns_version    = "v1.14.3-eksbuild.3"
}
```

## Variables

### Required

| Name | Type | Description |
|------|------|-------------|
| `vpc_name` | `string` | Name of the VPC (matched via the `Name` tag) |
| `cluster_name` | `string` | Name of the EKS cluster |
| `kubernetes_version` | `string` | Kubernetes version (e.g. `"1.35"`) |
| `kms_key_administrators` | `list(string)` | IAM ARNs granted KMS key administrator permissions |
| `vpc_cni_version` | `string` | AWS VPC CNI addon version (e.g. `"v1.19.3-eksbuild.1"`) |
| `kube_proxy_version` | `string` | kube-proxy addon version (e.g. `"v1.35.3-eksbuild.13"`) |
| `coredns_version` | `string` | CoreDNS addon version (e.g. `"v1.14.3-eksbuild.3"`) |

### Optional

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `private_subnet_tags` | `list(string)` | `["<vpc_name>-private-*"]` | Name tag filter for private (node) subnets |
| `pod_subnet_tags` | `list(string)` | `["<vpc_name>-podsubnet-*"]` | Name tag filter for secondary CIDR pod subnets |
| `enable_cluster_creator_admin_permissions` | `bool` | `false` | Grant the Terraform caller cluster-admin access via an EKS access entry |
| `enable_endpoint_public_access` | `bool` | `false` | Expose the Kubernetes API server endpoint publicly |
| `endpoint_public_access_cidrs` | `list(string)` | `["0.0.0.0/0"]` | CIDRs permitted when public endpoint access is enabled |
| `cloudwatch_enabled_log_types` | `list(string)` | `[]` | Control plane log types to send to CloudWatch (`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`) |
| `cloudwatch_log_group_retention_in_days` | `number` | `7` | Retention period in days for CloudWatch log groups |
| `create_eniconfig` | `bool` | `true` | Create ENIConfig resources for VPC-CNI custom networking |
| `eks_pod_identity_agent_addon_version` | `string` | `"v1.3.10-eksbuild.3"` | EKS Pod Identity Agent addon version |
| `node_instance_type` | `list(string)` | `["m7i.large", "m6i.large", "m5.large"]` | Instance types for the managed node group |
| `node_capacity_type` | `string` | `"SPOT"` | Node capacity type — `SPOT` or `ON_DEMAND` |
| `node_min_size` | `number` | `2` | Minimum number of nodes |
| `node_max_size` | `number` | `3` | Maximum number of nodes |
| `node_desired_size` | `number` | `2` | Desired number of nodes |
| `node_volume_size` | `number` | `50` | Data volume size (GiB) attached to each node (`/dev/xvdb`) |

## Notes

- The VPC and pod subnets must already exist before applying this module. Use the name-tag filters (`private_subnet_tags` / `pod_subnet_tags`) to match your VPC module's naming convention.
- Pod subnets should reside in a secondary CIDR block (e.g. `100.0.0.0/16`) and exist in every AZ used by the cluster. The module builds ENIConfig entries automatically from the discovered subnets.
- Authentication mode is fixed to `API` (access entries only — no `aws-auth` ConfigMap).
