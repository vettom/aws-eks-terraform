output "subnet_ids_and_azs" {
  value = {
    for az, subnet in aws_subnet.podnet :
    az => {
      subnet_id = subnet.id
      az        = subnet.availability_zone
    }
  }
}
