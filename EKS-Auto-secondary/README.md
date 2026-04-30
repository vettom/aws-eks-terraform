[<img src="https://vettom-images.s3.eu-west-1.amazonaws.com/logo/vettom-banner.jpg">](https://vettom.pages.dev/Eks/eks-auto-second-cidr/)

# EKS-Auto and Karpenter with VPC secondary IP
AWS VPC secondary IP range enables you have have smaller IP range for your nodes, while pods can make use of seconday IP range. This provides improved security as well as does not use up IP pools available for nodes.

### Tasks
- [x] Create VPC and define secondary IP range
- [x] Configure VPC-CNI and EniConfig for each secondary subnet
- [x] Configure Karpenter to provision nodes that support secondary IP for pods

[<img src="https://vettom-images.s3.eu-west-1.amazonaws.com/aws/vpc-secondary-ip.jpg">](https://vettom.pages.dev/Eks/eks-auto-second-cidr/)

## Deployment Workflow

```bash
# 1. Provision infrastructure
terraform init -upgrade
terraform plan
terraform apply --auto-approve

# 2. Bootstrap the cluster after apply
aws eks --profile labs --region eu-west-1 update-kubeconfig --name eks-auto-demo
kubectl apply -f Bootstrap/cni-nodepool.yaml
```

## Testing
Deploy a pod and verify that pods IP addresses is allocated from secondary CIDR range
```bash
kubectl run nginx --image=nginx 
```
This will trigger Karpenter to spin up a node and provision pod.

## Nodeclass specification
https://docs.aws.amazon.com/eks/latest/userguide/create-node-class.html#auto-node-class-spec

## Purpose

This Terraform project provisions an EKS Auto cluster (`eks-auto-demo`) in `eu-west-1` with VPC secondary IP support, so that pods receive IPs from a separate `100.0.0.0/16` CIDR block rather than consuming the node CIDR (`10.0.0.0/24`). The AWS profile used throughout is `labs`.


### IP Address Design
- **Node subnets (private):** `10.0.0.0/27`, `10.0.0.32/27`, `10.0.0.64/27` — nodes live here
- **Node subnets (public):** `10.0.0.128/27`–`10.0.0.192/27` — for NAT GW / ELB
- **Pod subnets (secondary CIDR):** `100.0.0.0/19`, `100.0.32.0/19`, `100.0.64.0/19` per AZ — pods get IPs from here

### Key Terraform Files
| File | Purpose |
|---|---|
| `vpc.tf` | Primary VPC (`10.0.0.0/24`) with private/public subnets and single NAT GW |
| `vpc-secondary-subnet.tf` | Associates `100.0.0.0/16` secondary CIDR to the VPC; creates `aws_subnet.podnet` per AZ; routes through the private route table |
| `vpc-cni.tf` | Deploys `aws-vpc-cni` Helm chart; enables `CUSTOM_NETWORK_CFG`, `ENABLE_POD_ENI`, and `ENABLE_PREFIX_DELEGATION`; creates ENIConfigs mapping each AZ to its pod subnet |
| `eks-auto.tf` | EKS cluster using `terraform-aws-modules/eks/aws` v21, EKS Auto mode with `general-purpose` node pool |
| `IAM.tf` | `AmazonEKSAutoNodeRole` with minimal node policies; EKS access entry wired to `AmazonEKSAutoNodePolicy` |
| `pods-sg.tf` | Security group for pods on secondary IPs; allows HTTP/HTTPS from anywhere, ephemeral ports and DNS from RFC-1918 + `100.0.0.0/8` |
| `locals.tf` | Central place for AZ list, CIDR blocks, and subnet lists |

### Bootstrap Manifests (`Bootstrap/`)
- `cni-nodepool.yaml` — combined `NodeClass` + `NodePool` (Karpenter v1) that selects pod subnets via `pod_subnet: "true"` tag and uses the `AmazonEKSAutoNodeRole`; `weight: 20` over the default pool

### Optional: Envoy Gateway (`Gateway/`)
Install separately with Helm after cluster is up. See `Gateway/README.md` for commands. Manifests: `external-gateway.yaml`, `internal-gateway.yaml`, `advanced-envoy-proxy-config.yaml`.

## Important Constraints

- **Order dependency:** `aws_subnet.podnet` depends on `aws_vpc_ipv4_cidr_block_association.secondary_cidr` — do not remove that `depends_on`.
- **ENIConfig ↔ subnet tag coupling:** The VPC-CNI ENIConfigs reference the pod subnet IDs directly from `aws_subnet.podnet` via `local.az` / `local.subnet_id` locals defined in `vpc-cni.tf`. Changing subnet tags or the for-each key (AZ) will break this mapping.
- **Node role name is hardcoded:** `AmazonEKSAutoNodeRole` is referenced by name in `Bootstrap/cni-nodepool.yaml`; renaming in `IAM.tf` requires updating the manifest.
- **Single NAT GW:** `single_nat_gateway = true` — all private subnets share one NAT GW to keep costs low; not HA.
