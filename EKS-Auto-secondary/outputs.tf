# # output "subnet_ids_and_azs" {
# #   value = {
# #     for az, subnet in aws_subnet.podnet :
# #     az => {
# #       subnet_id = subnet.id
# #       az        = subnet.availability_zone
# #     }
# #   }
# # }



#   "eu-west-1a" = {
#     "arn" = "arn:aws:ec2:eu-west-1:218687456330:subnet/subnet-0a933ebd3467a8418"
#     "assign_ipv6_address_on_creation" = false
#     "availability_zone" = "eu-west-1a"
#     "availability_zone_id" = "euw1-az1"
#     "cidr_block" = "100.0.0.0/19"
#     "customer_owned_ipv4_pool" = ""
#     "enable_dns64" = false
#     "enable_lni_at_device_index" = 0
#     "enable_resource_name_dns_a_record_on_launch" = false
#     "enable_resource_name_dns_aaaa_record_on_launch" = false
#     "id" = "subnet-0a933ebd3467a8418"
#     "ipv6_cidr_block" = ""
#     "ipv6_cidr_block_association_id" = ""
#     "ipv6_native" = false
#     "map_customer_owned_ip_on_launch" = false
#     "map_public_ip_on_launch" = false
#     "outpost_arn" = ""
#     "owner_id" = "218687456330"
#     "private_dns_hostname_type_on_launch" = "ip-name"
#     "region" = "eu-west-1"
#     "tags" = tomap({
#       "Name" = "eks-demo-vpc-pod-subneteu-west-1a"
#       "kubernetes.io/role/cni" = "1"
#       "kubernetes.io/role/internal-elb" = "1"
#       "pod_subnet" = "true"
#     })
#     "tags_all" = tomap({
#       "Name" = "eks-demo-vpc-pod-subneteu-west-1a"
#       "kubernetes.io/role/cni" = "1"
#       "kubernetes.io/role/internal-elb" = "1"
#       "pod_subnet" = "true"
#     })
#     "timeouts" = null /* object */
#     "vpc_id" = "vpc-006a6ed3513999bec"
#   }
#   "eu-west-1b" = {
#     "arn" = "arn:aws:ec2:eu-west-1:218687456330:subnet/subnet-0017952155bc5dfd1"
#     "assign_ipv6_address_on_creation" = false
#     "availability_zone" = "eu-west-1b"
#     "availability_zone_id" = "euw1-az2"
#     "cidr_block" = "100.0.32.0/19"
#     "customer_owned_ipv4_pool" = ""
#     "enable_dns64" = false
#     "enable_lni_at_device_index" = 0
#     "enable_resource_name_dns_a_record_on_launch" = false
#     "enable_resource_name_dns_aaaa_record_on_launch" = false
#     "id" = "subnet-0017952155bc5dfd1"
#     "ipv6_cidr_block" = ""
#     "ipv6_cidr_block_association_id" = ""
#     "ipv6_native" = false
#     "map_customer_owned_ip_on_launch" = false
#     "map_public_ip_on_launch" = false
#     "outpost_arn" = ""
#     "owner_id" = "218687456330"
#     "private_dns_hostname_type_on_launch" = "ip-name"
#     "region" = "eu-west-1"
#     "tags" = tomap({
#       "Name" = "eks-demo-vpc-pod-subneteu-west-1b"
#       "kubernetes.io/role/cni" = "1"
#       "kubernetes.io/role/internal-elb" = "1"
#       "pod_subnet" = "true"
#     })
#     "tags_all" = tomap({
#       "Name" = "eks-demo-vpc-pod-subneteu-west-1b"
#       "kubernetes.io/role/cni" = "1"
#       "kubernetes.io/role/internal-elb" = "1"
#       "pod_subnet" = "true"
#     })
#     "timeouts" = null /* object */
#     "vpc_id" = "vpc-006a6ed3513999bec"
#   }
#   "eu-west-1c" = {
#     "arn" = "arn:aws:ec2:eu-west-1:218687456330:subnet/subnet-09bac4cb8ebc3ae38"
#     "assign_ipv6_address_on_creation" = false
#     "availability_zone" = "eu-west-1c"
#     "availability_zone_id" = "euw1-az3"
#     "cidr_block" = "100.0.64.0/19"
#     "customer_owned_ipv4_pool" = ""
#     "enable_dns64" = false
#     "enable_lni_at_device_index" = 0
#     "enable_resource_name_dns_a_record_on_launch" = false
#     "enable_resource_name_dns_aaaa_record_on_launch" = false
#     "id" = "subnet-09bac4cb8ebc3ae38"
#     "ipv6_cidr_block" = ""
#     "ipv6_cidr_block_association_id" = ""
#     "ipv6_native" = false
#     "map_customer_owned_ip_on_launch" = false
#     "map_public_ip_on_launch" = false
#     "outpost_arn" = ""
#     "owner_id" = "218687456330"
#     "private_dns_hostname_type_on_launch" = "ip-name"
#     "region" = "eu-west-1"
#     "tags" = tomap({
#       "Name" = "eks-demo-vpc-pod-subneteu-west-1c"
#       "kubernetes.io/role/cni" = "1"
#       "kubernetes.io/role/internal-elb" = "1"
#       "pod_subnet" = "true"
#     })
#     "tags_all" = tomap({
#       "Name" = "eks-demo-vpc-pod-subneteu-west-1c"
#       "kubernetes.io/role/cni" = "1"
#       "kubernetes.io/role/internal-elb" = "1"
#       "pod_subnet" = "true"
#     })
#     "timeouts" = null /* object */
#     "vpc_id" = "vpc-006a6ed3513999bec"
#   }
