## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| aws | 6.52.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| eks | terraform-aws-modules/eks/aws | ~> 21.21 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_ec2_tag.subnet_internal_elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_ec2_tag.subnet_karpenter_discovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_eks_addon.coredns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.eks-pod-identity-agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.kube-proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.pod_id_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet.pod_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.pod_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| cluster_name | Name of the EKS cluster | `string` | n/a | yes |
| coredns_version | Version of coredns to use. | `string` | n/a | yes |
| eks_pod_identity_agent_addon_version | Version of EKS Pod Identity Agent to use. | `string` | n/a | yes |
| kms_key_administrators | List of KMS key administrators | `list(string)` | n/a | yes |
| kube_proxy_version | Version of kube-proxy to use. | `string` | n/a | yes |
| kubernetes_version | Version of Kubernetes to use | `string` | n/a | yes |
| vpc_cni_version | Version of AWS VPC CNI to use. | `string` | n/a | yes |
| vpc_name | Name of the VPC  in full | `string` | n/a | yes |
| cloudwatch_enabled_log_types | List of log types to enable. Options are 'api', 'audit', 'authenticator', 'controllerManager', 'scheduler', 'all'. Default is []. | `list(string)` | `[]` | no |
| cloudwatch_log_group_retention_in_days | Number of days to retain the log groups for the EKS cluster. Default is 7. | `number` | `7` | no |
| create_eniconfig | Create ENIConfig for EKS nodes. | `bool` | `true` | no |
| enable_cluster_creator_admin_permissions | Enable cluster creator admin permissions | `bool` | `false` | no |
| enable_endpoint_public_access | Enable public access to the EKS cluster | `bool` | `false` | no |
| endpoint_public_access_cidrs | List of CIDRs to allow public access to the EKS cluster | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| node_capacity_type | Capacity type of the nodes. Options are 'ON_DEMAND', 'SPOT'. Default is SPOT | `string` | `"SPOT"` | no |
| node_desired_size | Desired size of the nodes. | `number` | `2` | no |
| node_instance_type | Instance types to use for the nodes. | `list(string)` | <pre>[<br/>  "m7i.large",<br/>  "m6i.large",<br/>  "m5.large"<br/>]</pre> | no |
| node_max_size | Maximum size of the nodes. | `number` | `3` | no |
| node_min_size | Minimum size of the nodes. | `number` | `2` | no |
| node_volume_size | Size of the EBS volume in GBs for the nodes. Default is 50 | `number` | `50` | no |
| pod_subnet_tags | Wildcard pod subnet name eg [vpc-name-podsubnet-*] | `list(string)` | <pre>[<br/>  "*-podsubnet-*"<br/>]</pre> | no |
| private_subnet_tags | Wildcard private subnet name eg [vpc-name-private-*] | `list(string)` | <pre>[<br/>  "*-private-*"<br/>]</pre> | no |

## Outputs

No outputs.
